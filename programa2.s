/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Sumar dos números enteros en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 10;
        int num2 = 20;
        int suma = num1 + num2;
        Console.WriteLine($"La suma de {num1} y {num2} es: {suma}");
    }
}
*/

.data
    fmt_str:    .string "La suma de %d y %d es: %d\n"
    num1:       .word 10
    num2:       .word 20

.text
.global main
.balign 4

main:
    stp     x29, x30, [sp, #-16]!

    // Cargar números
    adr     x0, num1
    ldr     w1, [x0]
    adr     x0, num2
    ldr     w2, [x0]

    // Realizar suma
    add     w3, w1, w2

    // Imprimir resultado
    adr     x0, fmt_str
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
