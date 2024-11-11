/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar una calculadora simple con operaciones básicas en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 10;
        int num2 = 5;
        
        Console.WriteLine($"Número 1: {num1}");
        Console.WriteLine($"Número 2: {num2}");
        Console.WriteLine($"Suma: {num1 + num2}");
        Console.WriteLine($"Resta: {num1 - num2}");
        Console.WriteLine($"Multiplicación: {num1 * num2}");
        Console.WriteLine($"División: {num1 / num2}");
    }
}
*/

.data
    num1:           .word   10
    num2:           .word   5
    msg_nums:       .string "Números: %d y %d\n"
    msg_suma:       .string "Suma: %d\n"
    msg_resta:      .string "Resta: %d\n"
    msg_mult:       .string "Multiplicación: %d\n"
    msg_div:        .string "División: %d (Cociente), %d (Residuo)\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x19, num1
    ldr     w19, [x19]              // w19 = num1
    adr     x20, num2
    ldr     w20, [x20]              // w20 = num2

    // Mostrar números
    adr     x0, msg_nums
    mov     w1, w19
    mov     w2, w20
    bl      printf

    // Suma
    add     w21, w19, w20           // w21 = num1 + num2
    adr     x0, msg_suma
    mov     w1, w21
    bl      printf

    // Resta
    sub     w21, w19, w20           // w21 = num1 - num2
    adr     x0, msg_resta
    mov     w1, w21
    bl      printf

    // Multiplicación
    mul     w21, w19, w20           // w21 = num1 * num2
    adr     x0, msg_mult
    mov     w1, w21
    bl      printf

    // División
    sdiv    w21, w19, w20           // w21 = num1 / num2 (cociente)
    msub    w22, w21, w20, w19      // w22 = residuo (num1 - (cociente * num2))
    adr     x0, msg_div
    mov     w1, w21
    mov     w2, w22
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
