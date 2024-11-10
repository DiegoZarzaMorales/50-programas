/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Encontrar el valor máximo en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {4, 8, 15, 16, 23, 42};
        int max = arr[0];
        
        for(int i = 1; i < arr.Length; i++)
        {
            if(arr[i] > max)
                max = arr[i];
        }
        Console.WriteLine($"El valor máximo en el arreglo es: {max}");
    }
}
*/

.data
    array:      .word   4, 8, 15, 16, 23, 42
    size:       .word   6
    msg_array:  .string "Arreglo: "
    msg_num:    .string "%d "
    msg_max:    .string "\nEl valor máximo es: %d\n"

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
    bge     find_max

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_loop

find_max:
    ldr     w22, [x19]       // w22 = máximo inicial
    mov     w21, #1          // Reset índice a 1

max_loop:
    cmp     w21, w20
    bge     print_max

    ldr     w23, [x19, w21, SXTW 2]
    cmp     w23, w22
    ble     continue
    mov     w22, w23         // Actualizar máximo

continue:
    add     w21, w21, #1
    b       max_loop

print_max:
    adr     x0, msg_max
    mov     w1, w22
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
