/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Invertir el orden de los elementos en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] array = {1, 2, 3, 4, 5};
        
        Console.WriteLine("Arreglo original:");
        foreach(int num in array)
            Console.Write($"{num} ");
            
        // Invertir arreglo
        for(int i = 0; i < array.Length/2; i++)
        {
            int temp = array[i];
            array[i] = array[array.Length - 1 - i];
            array[array.Length - 1 - i] = temp;
        }
        
        Console.WriteLine("\nArreglo invertido:");
        foreach(int num in array)
            Console.Write($"{num} ");
    }
}
*/

.data
    array:          .word   1, 2, 3, 4, 5
    size:           .word   5
    msg_orig:       .string "Arreglo original:\n"
    msg_inv:        .string "\nArreglo invertido:\n"
    msg_num:        .string "%d "
    msg_nl:         .string "\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_orig
    bl      printf

    // Mostrar arreglo original
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    mov     w21, #0          // w21 = índice

print_original:
    cmp     w21, w20
    bge     start_reverse

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_original

start_reverse:
    mov     w21, #0          // i = 0
    sub     w22, w20, #1     // j = tamaño - 1

reverse_loop:
    cmp     w21, w22         // Comparar índices
    bge     print_reversed   // Si i >= j, terminar

    // Intercambiar elementos
    ldr     w23, [x19, w21, SXTW 2]   // temp = array[i]
    ldr     w24, [x19, w22, SXTW 2]   // array[j]
    str     w24, [x19, w21, SXTW 2]   // array[i] = array[j]
    str     w23, [x19, w22, SXTW 2]   // array[j] = temp

    add     w21, w21, #1     // i++
    sub     w22, w22, #1     // j--
    b       reverse_loop

print_reversed:
    // Imprimir mensaje
    adr     x0, msg_inv
    bl      printf

    // Mostrar arreglo invertido
    mov     w21, #0          // Reset índice

print_final:
    cmp     w21, w20
    bge     done

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_final

done:
    adr     x0, msg_nl
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
