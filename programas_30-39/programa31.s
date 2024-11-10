/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular el Mínimo Común Múltiplo de dos números en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int a = 12;
        int b = 18;
        int num1 = a, num2 = b;
        
        // Primero calculamos el MCD
        while(b != 0)
        {
            int temp = b;
            b = a % b;
            a = temp;
        }
        // MCM = (num1 * num2) / MCD
        int mcm = (num1 * num2) / a;
        
        Console.WriteLine($"MCM de {num1} y {num2} es: {mcm}");
    }
}
*/

.data
    num1:           .word   12
    num2:           .word   18
    msg_input:      .string "Calculando MCM de %d y %d\n"
    msg_result:     .string "MCM es: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x19, num1
    ldr     w19, [x19]       // w19 = num1
    adr     x20, num2
    ldr     w20, [x20]       // w20 = num2

    // Guardar copias de los números originales
    mov     w21, w19         // w21 = copia de num1
    mov     w22, w20         // w22 = copia de num2

    // Mostrar números de entrada
    adr     x0, msg_input
    mov     w1, w19
    mov     w2, w20
    bl      printf

    // Calcular MCD primero
gcd_loop:
    cbz     w20, calc_lcm    // Si b == 0, calcular MCM

    mov     w23, w20         // temp = b
    sdiv    w24, w19, w20    // w24 = a / b
    msub    w20, w24, w20, w19  // b = a % b (a - (a/b)*b)
    mov     w19, w23         // a = temp
    b       gcd_loop

calc_lcm:
    // MCM = (num1 * num2) / MCD
    mul     w24, w21, w22    // w24 = num1 * num2
    sdiv    w19, w24, w19    // w19 = (num1 * num2) / MCD

print_result:
    adr     x0, msg_result
    mov     w1, w19
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
