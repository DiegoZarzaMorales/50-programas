/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Restar dos números enteros en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 30;
        int num2 = 15;
        int resta = num1 - num2;
        Console.WriteLine($"La resta de {num1} y {num2} es: {resta}");
    }
}
*/

.data
    fmt_str:    .string "La resta de %d y %d es: %d\n"
    num1:       .word 30
    num2:       .word 15

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x0, num1
    ldr     w1, [x0]
    adr     x0, num2
    ldr     w2, [x0]

    // Realizar resta
    sub     w3, w1, w2

    // Imprimir resultado
    adr     x0, fmt_str
    bl      printf

    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
