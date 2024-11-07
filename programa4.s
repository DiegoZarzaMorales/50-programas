/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Multiplicar dos números enteros en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 5;
        int num2 = 6;
        int multiplicacion = num1 * num2;
        Console.WriteLine($"La multiplicación de {num1} y {num2} es: {multiplicacion}");
    }
}
*/

.data
    fmt_str:    .string "La multiplicación de %d y %d es: %d\n"
    num1:       .word 5
    num2:       .word 6

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

    // Realizar multiplicación
    mul     w3, w1, w2

    // Imprimir resultado
    adr     x0, fmt_str
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
