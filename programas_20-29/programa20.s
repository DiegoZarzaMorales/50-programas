/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Realizar multiplicación de dos matrices en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[,] matriz1 = {{1, 2}, {3, 4}};
        int[,] matriz2 = {{5, 6}, {7, 8}};
        int[,] resultado = new int[2,2];
        
        for(int i = 0; i < 2; i++)
            for(int j = 0; j < 2; j++)
            {
                resultado[i,j] = 0;
                for(int k = 0; k < 2; k++)
                    resultado[i,j] += matriz1[i,k] * matriz2[k,j];
            }
            
        Console.WriteLine("Matriz resultante:");
        for(int i = 0; i < 2; i++)
        {
            for(int j = 0; j < 2; j++)
                Console.Write($"{resultado[i,j]} ");
            Console.WriteLine();
        }
    }
}
*/

.data
    // Matrices 2x2
    matriz1:    .word   1, 2, 3, 4
    matriz2:    .word   5, 6, 7, 8
    resultado:  .skip   16              // 4 elementos * 4 bytes
    size:       .word   2               // Tamaño de la matriz (2x2)
    msg_m1:     .string "Matriz 1:\n"
    msg_m2:     .string "Matriz 2:\n"
    msg_res:    .string "Matriz resultante:\n"
    msg_num:    .string "%4d "          // Formato alineado
    msg_nl:     .string "\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir matriz1
    adr     x0, msg_m1
    bl      printf
    adr     x19, matriz1
    bl      print_matrix

    // Imprimir matriz2
    adr     x0, msg_m2
    bl      printf
    adr     x19, matriz2
    bl      print_matrix

    // Multiplicar matrices
    adr     x19, matriz1     // x19 = dirección matriz1
    adr     x20, matriz2     // x20 = dirección matriz2
    adr     x21, resultado   // x21 = dirección resultado
    adr     x22, size
    ldr     w22, [x22]       // w22 = tamaño
    mov     w23, #0          // w23 = i

outer_loop:
    cmp     w23, w22
    bge     print_result
    mov     w24, #0          // w24 = j

middle_loop:
    cmp     w24, w22
    bge     outer_next

    mov     w25, #0          // w25 = suma acumulada
    mov     w26, #0          // w26 = k

inner_loop:
    cmp     w26, w22
    bge     store_result

    // Calcular índices
    mul     w27, w23, w22    // i * size
    add     w27, w27, w26    // + k
    lsl     w27, w27, #2     // * 4

    mul     w28, w26, w22    // k * size
    add     w28, w28, w24    // + j
    lsl     w28, w28, #2     // * 4

    // Multiplicar elementos
    ldr     w29, [x19, w27]  // matriz1[i][k]
    ldr     w30, [x20, w28]  // matriz2[k][j]
    mul     w29, w29, w30    // producto
    add     w25, w25, w29    // suma += producto

    add     w26, w26, #1     // k++
    b       inner_loop

store_result:
    // Guardar resultado
    mul     w27, w23, w22    // i * size
    add     w27, w27, w24    // + j
    lsl     w27, w27, #2     // * 4
    str     w25, [x21, w27]  // resultado[i][j] = suma

    add     w24, w24, #1     // j++
    b       middle_loop

outer_next:
    add     w23, w23, #1     // i++
    b       outer_loop

print_result:
    // Imprimir mensaje resultado
    adr     x0, msg_res
    bl      printf

    // Imprimir matriz resultado
    adr     x19, resultado
    bl      print_matrix

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

// Subrutina para imprimir matriz
print_matrix:
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x20, x19         // Guardar dirección matriz
    adr     x19, size
    ldr     w19, [x19]       // w19 = tamaño
    mov     w21, #0          // w21 = i

print_outer:
    cmp     w21, w19
    bge     print_done
    mov     w22, #0          // w22 = j

print_inner:
    cmp     w22, w19
    bge     print_nl_cont

    // Imprimir elemento
    mul     w23, w21, w19
    add     w23, w23, w22
    lsl     w23, w23, #2
    ldr     w1, [x20, w23]
    adr     x0, msg_num
    bl      printf

    add     w22, w22, #1
    b       print_inner

print_nl_cont:
    adr     x0, msg_nl
    bl      printf
    add     w21, w21, #1
    b       print_outer

print_done:
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret
