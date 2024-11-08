/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular el factorial de un número en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int n = 5;
        long factorial = 1;
        for(int i = 1; i <= n; i++)
        {
            factorial *= i;
        }
        Console.WriteLine($"El factorial de {n} es: {factorial}");
    }
}
*/

.data
    fmt_str: .string "El factorial de %d es: %ld\n"
    n:       .word 5

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializar variables
    adr     x0, n
    ldr     w19, [x0]        // w19 = n
    mov     x20, #1          // x20 = factorial (64 bits)
    mov     w21, #1          // w21 = i = 1

loop:
    cmp     w21, w19         // Comparar i con n
    bgt     done            // Si i > n, terminar

    mul     x20, x20, x21    // factorial *= i
    add     w21, w21, #1     // i++
    b       loop

done:
    // Imprimir resultado
    adr     x0, fmt_str
    mov     w1, w19          // n
    mov     x2, x20          // factorial
    bl      printf

    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
