/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular la suma de todos los elementos en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] array = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
        int suma = 0;
        
        Console.WriteLine("Elementos del arreglo:");
        foreach(int num in array)
        {
            Console.Write($"{num} ");
            suma += num;
        }
        Console.WriteLine($"\nLa suma de todos los elementos es: {suma}");
    }
}
*/

.data
    array:          .word   1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    size:           .word   10
    msg_array:      .string "Elementos del arreglo:\n"
    msg_num:        .string "%d "
    msg_result:     .string "\nLa suma de todos los elementos es: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_array
    bl      printf

    // Inicializar variables
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    mov     w21, #0          // w21 = suma
    mov     w22, #0          // w22 = índice

print_and_sum:
    cmp     w22, w20         // Comparar índice con tamaño
    bge     print_result     // Si índice >= tamaño, terminar

    // Imprimir número actual
    ldr     w1, [x19, w22, SXTW 2]  // Cargar elemento actual
    adr     x0, msg_num
    bl      printf

    // Sumar al total
    ldr     w23, [x19, w22, SXTW 2]
    add     w21, w21, w23    // suma += elemento

    add     w22, w22, #1     // índice++
    b       print_and_sum

print_result:
    // Imprimir suma total
    adr     x0, msg_result
    mov     w1, w21
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
