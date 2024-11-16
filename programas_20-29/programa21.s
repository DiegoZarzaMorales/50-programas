/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Realizar la transposición de una matriz en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[,] matriz = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        int[,] transpuesta = new int[3,3];
        
        for(int i = 0; i < 3; i++)
            for(int j = 0; j < 3; j++)
                transpuesta[i,j] = matriz[j,i];
                
        Console.WriteLine("Matriz original:");
        for(int i = 0; i < 3; i++)
        {
            for(int j = 0; j < 3; j++)
                Console.Write($"{matriz[i,j]} ");
            Console.WriteLine();
        }
        
        Console.WriteLine("\nMatriz transpuesta:");
        for(int i = 0; i < 3; i++)
        {
            for(int j = 0; j < 3; j++)
                Console.Write($"{transpuesta[i,j]} ");
            Console.WriteLine();
        }
    }
}
*/

.data
    matriz:     .word   1, 2, 3, 4, 5, 6, 7, 8, 9
    resultado:  .skip   36          // 9 elementos * 4 bytes
    size:       .word   3           // Tamaño de la matriz (3x3)
    msg_orig:   .string "Matriz original:\n"
    msg_trans:  .string "\nMatriz transpuesta:\n"
    msg_num:    .string "%3d "
    msg_nl:     .string "\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje matriz original
    adr     x0, msg_orig
    bl      printf

    // Mostrar matriz original
    adr     x19, matriz      // x19 = dirección matriz
    bl      print_matrix

    // Realizar transposición
    adr     x20, resultado   // x20 = dirección resultado
    adr     x21, size
    ldr     w21, [x21]       // w21 = tamaño
    mov     w22, #0          // w22 = i

outer_loop:
    cmp     w22, w21
    bge     print_result
    mov     w23, #0          // w23 = j

inner_loop:
    cmp     w23, w21
    bge     outer_next

    // Calcular índices
    mul     w24, w22, w21    // i * size
    add     w24, w24, w23    // + j
    mul     w25, w23, w21    // j * size
    add     w25, w25, w22    // + i

    // Transponer elemento
    lsl     x24, x24, #2     // * 4 bytes
    lsl     x25, x25, #2     // * 4 bytes
    ldr     w26, [x19, x24]  // Cargar elemento original
    str     w26, [x20, x25]  // Guardar en nueva posición

    add     w23, w23, #1     // j++
    b       inner_loop

outer_next:
    add     w22, w22, #1     // i++
    b       outer_loop

print_result:
    // Imprimir mensaje matriz transpuesta
    adr     x0, msg_trans
    bl      printf

    // Mostrar matriz transpuesta
    mov     x19, x20         // x19 = dirección matriz transpuesta
    bl      print_matrix

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

print_matrix:
    stp     x29, x30, [sp, #-16]!
    mov     w24, #0          // i = 0

print_outer:
    cmp     w24, w21
    bge     print_done
    mov     w25, #0          // j = 0

print_inner:
    cmp     w25, w21
    bge     print_newline

    // Imprimir elemento
    mul     w26, w24, w21
    add     w26, w26, w25
    lsl     x26, x26, #2
    ldr     w1, [x19, x26]
    adr     x0, msg_num
    bl      printf

    add     w25, w25, #1     // j++
    b       print_inner

print_newline:
    adr     x0, msg_nl
    bl      printf
    add     w24, w24, #1     // i++
    b       print_outer

print_done:
    ldp     x29, x30, [sp], #16
    ret
