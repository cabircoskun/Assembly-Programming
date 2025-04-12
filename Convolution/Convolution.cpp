﻿#define _CRT_SECURE_NO_DEPRECATE
#include <stdio.h>
#include <stdlib.h>

// Function to print a matrix stored in a 1D array
void print_matrix(unsigned* matrix, unsigned rows, unsigned cols, FILE* file);
// Function to read matrix from a file
void read_matrix(const char* filename, unsigned** matrix, unsigned* rows, unsigned* cols);
// Function to read kernel from a file
void read_kernel(const char* filename, unsigned** kernel, unsigned* k);
// Function to write output matrix to a file
void write_output(const char* filename, unsigned* output, unsigned rows, unsigned cols);
// Initialize output as zeros.
void initialize_output(unsigned*, unsigned, unsigned);

int main() {

    unsigned n, m, k;  // n = rows of matrix, m = cols of matrix, k = kernel size
    // Dynamically allocate memory for matrix, kernel, and output
    unsigned* matrix = NULL;  // Input matrix
    unsigned* kernel = NULL;  // Kernel size 3x3
    unsigned* output = NULL;  // Max size of output matrix

    char matrix_filename[30];
    char kernel_filename[30];

    // Read the file names
    printf("Enter matrix filename: ");
    scanf("%s", matrix_filename);
    printf("Enter kernel filename: ");
    scanf("%s", kernel_filename);


    // Read matrix and kernel from files
    read_matrix(matrix_filename, &matrix, &n, &m);  // Read matrix from file
    read_kernel(kernel_filename, &kernel, &k);      // Read kernel from file

    // For simplicity we say: padding = 0, stride = 1
    // With this setting we can calculate the output size
    unsigned output_rows = n - k + 1;
    unsigned output_cols = m - k + 1;
    output = (unsigned*)malloc(output_rows * output_cols * sizeof(unsigned));
    initialize_output(output, output_rows, output_cols);

    // Print the input matrix and kernel
    printf("Input Matrix: ");
    print_matrix(matrix, n, m, stdout);

    printf("\nKernel: ");
    print_matrix(kernel, k, k, stdout);

    /******************* KODUN BU KISMINDAN SONRASINDA DEĞİŞİKLİK YAPABİLİRSİNİZ - ÖNCEKİ KISIMLARI DEĞİŞTİRMEYİN *******************/

    // Assembly kod bloğu içinde kullanacağınız değişkenleri burada tanımlayabilirsiniz. ---------------------->
    // Aşağıdaki değişkenleri kullanmak zorunda değilsiniz. İsterseniz değişiklik yapabilirsiniz.
    unsigned matrix_value, kernel_value;    // Konvolüsyon için gerekli 1 matrix ve 1 kernel değişkenleri saklanabilir.
    unsigned sum;                           // Konvolüsyon toplamını saklayabilirsiniz.
    unsigned matrix_offset;                 // Input matrisi üzerinde gezme işleminde sınırları ayarlamak için kullanılabilir.
    unsigned tmp_si, tmp_di;                // ESI ve EDI döngü değişkenlerini saklamak için kullanılabilir.
    unsigned output_index =0;
    unsigned i=0, j=0;
    matrix_offset = 0; // 
    sum = 0;
    unsigned output_size = output_cols * output_rows; 
    unsigned max_offset = (n-k+1)*m; //matrix_offset için maks değer.
    
    // Assembly dilinde 2d konvolüsyon işlemini aşağıdaki blokta yazınız ----->
    __asm {
        // Aşağıdaki kodu silerek başlayabilirsiniz ->
        XOR ESI, ESI
        XOR EDI, EDI
        XOR EBX, EBX
        
        MOV ESI, matrix
        MOV EDI, kernel


    L1: 
    L2: 
        XOR ECX,ECX
        MOV i,ECX  
        MOV sum,ECX 
        L_in1:  
                XOR ECX,ECX
                MOV j,ECX 
        L_in2:
                MOV ESI,matrix
                MOV EAX,i
                MOV ECX,m
                MUL ECX
                ADD EAX,j
                
                ADD EAX,matrix_offset //ana matris indisi axde şuan -- matris[4*(matrix_offset+(i*m+j))]
                    MOV EBX, 4
                    MUL EBX
                ADD ESI,EAX // ESI ana matrix indisi
                
                MOV EDI, kernel
                MOV EAX, i
                MOV ECX,k
                MUL ECX
                ADD EAX, j
                MOV EBX,4
                MUL EBX   
                ADD EDI,EAX //EDI da kernel indisi var -- kernel[4*(i*m+j)]
                
                MOV EAX,[ESI]
                MOV EBX,[EDI]
                MUL EBX   //axde çarpım degeri var suma eklemeliyiz.
                
                ADD sum,EAX
                
                MOV ECX,j
                INC ECX
                MOV j,ECX
                MOV EBX,k
                CMP ECX,EBX 
                JB  L_in2
                
                MOV ECX,i
                INC ECX
                MOV i,ECX
                MOV EBX,k
                CMP ECX,EBX 
                JB L_in1
        
        MOV ECX,matrix_offset
        INC ECX
        MOV matrix_offset,ECX

        MOV EBX, output
        MOV EAX,output_index
        MOV ECX,4
        MUL ECX
        ADD EBX,EAX
        
        MOV EDX,   sum
        MOV [EBX], EDX
        
        MOV EDX,output_index
        INC EDX
        MOV output_index,EDX
        
        
        MOV EAX,matrix_offset
                    //mod alma
                    XOR EDX,EDX
                    MOV ECX,m
                    DIV ECX


        
        MOV ECX,output_cols
        CMP EDX,ECX
        JNE L2
        MOV EAX, matrix_offset
        ADD EAX,k 
        DEC EAX
        MOV matrix_offset,EAX
        MOV EBX,max_offset
        
        CMP EAX, EBX 
        JB L1


    }

    /******************* KODUN BU KISMINDAN ÖNCESİNDE DEĞİŞİKLİK YAPABİLİRSİNİZ - SONRAKİ KISIMLARI DEĞİŞTİRMEYİN *******************/


    // Write result to output file
    write_output("./output.txt", output, output_rows, output_cols);

    // Print result
    printf("\nOutput matrix after convolution: ");
    print_matrix(output, output_rows, output_cols, stdout);

    // Free allocated memory
    free(matrix);
    free(kernel);
    free(output);

    return 0;
}

void print_matrix(unsigned* matrix, unsigned rows, unsigned cols, FILE* file) {
    if (file == stdout) {
        printf("(%ux%u)\n", rows, cols);
    }
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            fprintf(file, "%u ", matrix[i * cols + j]);
        }
        fprintf(file, "\n");
    }
}

void read_matrix(const char* filename, unsigned** matrix, unsigned* rows, unsigned* cols) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("Error opening file %s\n", filename);
        exit(1);
    }

    // Read dimensions
    fscanf(file, "%u %u", rows, cols);
    *matrix = (unsigned*)malloc(((*rows) * (*cols)) * sizeof(unsigned));

    // Read matrix elements
    for (int i = 0; i < (*rows); i++) {
        for (int j = 0; j < (*cols); j++) {
            fscanf(file, "%u", &(*matrix)[i * (*cols) + j]);
        }
    }

    fclose(file);
}

void read_kernel(const char* filename, unsigned** kernel, unsigned* k) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("Error opening file %s\n", filename);
        exit(1);
    }

    // Read kernel size
    fscanf(file, "%u", k);
    *kernel = (unsigned*)malloc((*k) * (*k) * sizeof(unsigned));

    // Read kernel elements
    for (int i = 0; i < (*k); i++) {
        for (int j = 0; j < (*k); j++) {
            fscanf(file, "%u", &(*kernel)[i * (*k) + j]);
        }
    }

    fclose(file);
}

void write_output(const char* filename, unsigned* output, unsigned rows, unsigned cols) {
    FILE* file = fopen(filename, "w");
    if (!file) {
        printf("Error opening file %s\n", filename);
        exit(1);
    }

    // Write dimensions of the output matrix
    fprintf(file, "%u %u\n", rows, cols);

    // Write output matrix elements
    print_matrix(output, rows, cols, file);

    fclose(file);
}

void initialize_output(unsigned* output, unsigned output_rows, unsigned output_cols) {
    int i;
    for (i = 0; i < output_cols * output_rows; i++)
        output[i] = 0;
    
}

