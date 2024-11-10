/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Encontrar el valor mínimo en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {42, 23, 16, 15, 8, 4};
        int min = arr[0];
        
        for(int i = 1; i < arr.Length; i++)
        {
            if(arr[i] < min)
                min = arr[i];
        }
        Console.WriteLine($"El valor mínimo en el arreglo es: {min}");
    }
}
*/

.data
    array:      .word   42, 23, 16, 15, 8, 4
    size:       .word   6
    msg_array:  .string "Arreglo: "
    msg_num:    .string "%d "
    msg_min:    .string "\nEl valor mínimo es: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir arreglo
    adr     x0, msg_array
    bl      printf

    // Mostrar elementos
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    mov     w21, #0          // w21 = índice

print_loop:
    cmp     w21, w20
    bge     find_min

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_loop

find_min:
    ldr     w22, [x19]       // w22 = mínimo inicial
    mov     w21, #1          // Reset índice a 1

min_loop:
    cmp     w21, w20
    bge     print_min

    ldr     w23, [x19, w21, SXTW 2]
    cmp     w23, w22
    bge     continue
    mov     w22, w23         // Actualizar mínimo

continue:
    add     w21, w21, #1
    b       min_loop

print_min:
    adr     x0, msg_min
    mov     w1, w22
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
