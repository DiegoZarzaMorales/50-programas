/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Generar la serie de Fibonacci hasta el n-ésimo término en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int n = 10;
        int a = 0, b = 1;
        Console.Write($"Serie de Fibonacci hasta el término {n}: ");
        for(int i = 0; i < n; i++)
        {
            Console.Write($"{a} ");
            int temp = a;
            a = b;
            b = temp + b;
        }
    }
}
*/

.data
    fmt_start: .string "Serie de Fibonacci hasta el término %d: "
    fmt_num:   .string "%d "
    fmt_nl:    .string "\n"
    n:         .word 10

.text
.global main
.balign 4

main:
    stp     x29, x30, [sp, #-16]!

    // Imprimir mensaje inicial
    adr     x0, fmt_start
    adr     x1, n
    ldr     w1, [x1]
    bl      printf

    // Inicializar variables
    mov     w19, #0                 // w19 = a = 0
    mov     w20, #1                 // w20 = b = 1
    mov     w21, #0                 // w21 = i = 0
    adr     x0, n
    ldr     w22, [x0]               // w22 = n

loop:
    cmp     w21, w22                // Comparar i con n
    bge     done                    // Si i >= n, terminar
    
    // Imprimir número actual
    adr     x0, fmt_num
    mov     w1, w19
    bl      printf

    // Calcular siguiente número
    mov     w23, w19                // temp = a
    mov     w19, w20                // a = b
    add     w20, w23, w20           // b = temp + b
    
    add     w21, w21, #1            // i++
    b       loop

done:
    // Imprimir nueva línea
    adr     x0, fmt_nl
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
