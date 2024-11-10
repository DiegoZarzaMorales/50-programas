/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Rotar los elementos de un arreglo a la izquierda en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] array = {1, 2, 3, 4, 5};
        int rotaciones = 2;
        
        Console.WriteLine("Arreglo original:");
        foreach(int num in array)
            Console.Write($"{num} ");
            
        // Rotar array
        for(int r = 0; r < rotaciones; r++)
        {
            int temp = array[0];
            for(int i = 0; i < array.Length - 1; i++)
                array[i] = array[i + 1];
            array[array.Length - 1] = temp;
        }
        
        Console.WriteLine($"\nArreglo rotado {rotaciones} posiciones a la izquierda:");
        foreach(int num in array)
            Console.Write($"{num} ");
    }
}
*/

.data
    array:          .word   1, 2, 3, 4, 5
    size:           .word   5
    rotaciones:     .word   2
    msg_orig:       .string "Arreglo original:\n"
    msg_rot:        .string "\nArreglo rotado %d posiciones a la izquierda:\n"
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
    adr     x21, rotaciones
    ldr     w21, [x21]       // w21 = número de rotaciones
    mov     w22, #0          // w22 = índice

print_original:
    cmp     w22, w20
    bge     start_rotation

    ldr     w1, [x19, w22, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w22, w22, #1
    b       print_original

start_rotation:
    mov     w22, #0          // r = 0

rotation_loop:
    cmp     w22, w21         // Comparar con número de rotaciones
    bge     print_rotated

    // Guardar primer elemento
    ldr     w23, [x19]       // temp = array[0]
    mov     w24, #0          // i = 0

shift_loop:
    add     w25, w24, #1     // i + 1
    cmp     w25, w20         // Comparar con tamaño
    bge     store_temp

    // Desplazar elemento
    ldr     w26, [x19, w25, SXTW 2]    // Cargar array[i+1]
    str     w26, [x19, w24, SXTW 2]    // array[i] = array[i+1]

    add     w24, w24, #1     // i++
    b       shift_loop

store_temp:
    sub     w27, w20, #1     // tamaño - 1
    str     w23, [x19, w27, SXTW 2]    // array[size-1] = temp

    add     w22, w22, #1     // r++
    b       rotation_loop

print_rotated:
    // Imprimir mensaje
    adr     x0, msg_rot
    mov     w1, w21          // número de rotaciones
    bl      printf

    // Mostrar arreglo rotado
    mov     w22, #0          // Reset índice

print_final:
    cmp     w22, w20
    bge     done

    ldr     w1, [x19, w22, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w22, w22, #1
    b       print_final

done:
    adr     x0, msg_nl
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
