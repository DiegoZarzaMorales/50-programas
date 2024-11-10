/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar ordenamiento burbuja en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {64, 34, 25, 12, 22, 11, 90};
        int n = arr.Length;
        
        for(int i = 0; i < n-1; i++)
            for(int j = 0; j < n-i-1; j++)
                if(arr[j] > arr[j+1])
                {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
                
        Console.WriteLine("Arreglo ordenado:");
        foreach(int num in arr)
            Console.Write($"{num} ");
    }
}
*/

.data
    array:      .word   64, 34, 25, 12, 22, 11, 90
    size:       .word   7
    msg_orig:   .string "Arreglo original: "
    msg_ord:    .string "Arreglo ordenado: "
    msg_num:    .string "%d "
    msg_nl:     .string "\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir arreglo original
    adr     x0, msg_orig
    bl      printf

    // Mostrar elementos originales
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    mov     w21, #0          // w21 = índice

print_orig:
    cmp     w21, w20
    bge     sort_start

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_orig

sort_start:
    // Nueva línea
    adr     x0, msg_nl
    bl      printf

    // Ordenamiento burbuja
    mov     w21, #0          // i = 0

outer_loop:
    sub     w22, w20, #1     // n-1
    cmp     w21, w22
    bge     print_sorted

    mov     w23, #0          // j = 0
    sub     w24, w22, w21    // n-i-1

inner_loop:
    cmp     w23, w24
    bge     outer_continue

    // Cargar elementos adyacentes
    ldr     w25, [x19, w23, SXTW 2]    // arr[j]
    add     w26, w23, #1
    ldr     w27, [x19, w26, SXTW 2]    // arr[j+1]

    // Comparar y swapear si necesario
    cmp     w25, w27
    ble     inner_continue

    // Swap
    str     w27, [x19, w23, SXTW 2]
    str     w25, [x19, w26, SXTW 2]

inner_continue:
    add     w23, w23, #1     // j++
    b       inner_loop

outer_continue:
    add     w21, w21, #1     // i++
    b       outer_loop

print_sorted:
    // Imprimir mensaje
    adr     x0, msg_ord
    bl      printf

    // Mostrar elementos ordenados
    mov     w21, #0          // Reset índice

print_loop:
    cmp     w21, w20
    bge     done

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_loop

done:
    // Nueva línea final
    adr     x0, msg_nl
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
