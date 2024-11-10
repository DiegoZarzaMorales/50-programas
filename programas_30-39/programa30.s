/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular el Máximo Común Divisor de dos números usando el algoritmo de Euclides en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int a = 48;
        int b = 18;
        
        // Algoritmo de Euclides
        int num1 = a;
        int num2 = b;
        while(num2 != 0)
        {
            int temp = num2;
            num2 = num1 % num2;
            num1 = temp;
        }
        
        Console.WriteLine($"MCD de {a} y {b} es: {num1}");
    }
}
*/

.data
    num1:           .word   48
    num2:           .word   18
    msg_input:      .string "Calculando MCD de %d y %d\n"
    msg_result:     .string "MCD es: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x19, num1
    ldr     w19, [x19]       // w19 = a
    adr     x20, num2
    ldr     w20, [x20]       // w20 = b

    // Mostrar números de entrada
    adr     x0, msg_input
    mov     w1, w19
    mov     w2, w20
    bl      printf

gcd_loop:
    cbz     w20, print_result  // Si b == 0, terminar

    // Algoritmo de Euclides
    mov     w21, w20         // temp = b
    sdiv    w22, w19, w20    // w22 = a / b
    msub    w20, w22, w20, w19  // b = a % b (a - (a/b)*b)
    mov     w19, w21         // a = temp

    b       gcd_loop

print_result:
    adr     x0, msg_result
    mov     w1, w19
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
