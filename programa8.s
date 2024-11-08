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
        Console.Write($"Los primeros {n} números de Fibonacci son: ");
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
    msg_start:  .string "Los primeros %d números de Fibonacci son: "
    msg_num:    .string "%d "
    msg_nl:     .string "\n"
    n:          .word 10

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_start
    adr     x1, n
    ldr     w1, [x1]
    bl      printf

    // Inicializar variables
    mov     w19, #0          // w19 = a
    mov     w20, #1          // w20 = b
    mov     w21, #0          // w21 = i
    adr     x22, n
    ldr     w22, [x22]       // w22 = n

loop:
    cmp     w21, w22         // Comparar i con n
    bge     done            // Si i >= n, terminar

    // Imprimir número actual
    adr     x0, msg_num
    mov     w1, w19          // a
    bl      printf

    // Calcular siguiente número
    mov     w23, w19         // temp = a
    mov     w19, w20         // a = b
    add     w20, w23, w20    // b = temp + b

    add     w21, w21, #1     // i++
    b       loop

done:
    // Imprimir nueva línea
    adr     x0, msg_nl
    bl      printf

    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
