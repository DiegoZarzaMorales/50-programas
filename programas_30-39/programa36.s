/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Encontrar el segundo elemento más grande en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {12, 35, 1, 10, 34, 1};
        int primero = int.MinValue;
        int segundo = int.MinValue;
        
        foreach(int num in arr)
        {
            if(num > primero)
            {
                segundo = primero;
                primero = num;
            }
            else if(num > segundo && num != primero)
            {
                segundo = num;
            }
        }
        
        Console.WriteLine($"El segundo elemento más grande es: {segundo}");
    }
}
*/

.data
    array:          .word   12, 35, 1, 10, 34, 1
    size:           .word   6
    msg_array:      .string "Arreglo: "
    msg_num:        .string "%d "
    msg_result:     .string "\nEl segundo elemento más grande es: %d\n"
    min_value:      .word   0x80000000      // Valor mínimo para enteros con signo

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_array
    bl      printf

    // Inicializar variables
    adr     x19, array                   // x19 = dirección array
    adr     x20, size
    ldr     w20, [x20]                   // w20 = tamaño
    adr     x21, min_value
    ldr     w21, [x21]                   // w21 = primero = MIN_VALUE
    mov     w22, w21                     // w22 = segundo = MIN_VALUE

    // Mostrar elementos
    mov     w23, #0                      // w23 = índice

print_array:
    cmp     w23, w20
    bge     find_second

    ldr     w1, [x19, w23, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w23, w23, #1
    b       print_array

find_second:
    mov     w23, #0                      // Reset índice

process_loop:
    cmp     w23, w20
    bge     print_result

    ldr     w24, [x19, w23, SXTW 2]     // w24 = elemento actual

    // Si elemento > primero
    cmp     w24, w21
    ble     check_second
    mov     w22, w21                     // segundo = primero
    mov     w21, w24                     // primero = elemento
    b       continue

check_second:
    // Si elemento > segundo y elemento != primero
    cmp     w24, w22
    ble     continue
    cmp     w24, w21
    beq     continue
    mov     w22, w24                     // segundo = elemento

continue:
    add     w23, w23, #1
    b       process_loop

print_result:
    adr     x0, msg_result
    mov     w1, w22                      // segundo elemento más grande
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
