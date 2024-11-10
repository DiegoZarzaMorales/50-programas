/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar ordenamiento por selección en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {64, 25, 12, 22, 11};
        int n = arr.Length;
        
        for(int i = 0; i < n-1; i++)
        {
            int min_idx = i;
            for(int j = i+1; j < n; j++)
                if(arr[j] < arr[min_idx])
                    min_idx = j;
                    
            int temp = arr[min_idx];
            arr[min_idx] = arr[i];
            arr[i] = temp;
        }
        
        Console.WriteLine("Arreglo ordenado:");
        foreach(int num in arr)
            Console.Write($"{num} ");
    }
}
*/

.data
    array:      .word   64, 25, 12, 22, 11
    size:       .word   5
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

    // Ordenamiento por selección
    mov     w21, #0          // i = 0

outer_loop:
    sub     w22, w20, #1     // n-1
    cmp     w21, w22
    bge     print_sorted

    mov     w23, w21         // min_idx = i
    add     w24, w21, #1     // j = i + 1

inner_loop:
    cmp     w24, w20
    bge     do_swap

    // Comparar elementos
    ldr     w25, [x19, w24, SXTW 2]    // arr[j]
    ldr     w26, [x19, w23, SXTW 2]    // arr[min_idx]
    cmp     w25, w26
    bge     inner_continue
    
    mov     w23, w24         // Actualizar min_idx

inner_continue:
    add     w24, w24, #1     // j++
    b       inner_loop

do_swap:
    // Realizar swap si es necesario
    cmp     w23, w21
    beq     outer_continue

    // Swap
    ldr     w25, [x19, w21, SXTW 2]    // temp = arr[i]
    ldr     w26, [x19, w23, SXTW 2]    // arr[min_idx]
    str     w26, [x19, w21, SXTW 2]    // arr[i] = arr[min_idx]
    str     w25, [x19, w23, SXTW 2]    // arr[min_idx] = temp

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
