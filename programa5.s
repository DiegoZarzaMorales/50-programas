/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Dividir dos números enteros en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 20;
        int num2 = 3;
        int cociente = num1 / num2;
        int residuo = num1 % num2;
        Console.WriteLine($"La división de {num1} entre {num2} es: {cociente} con residuo {residuo}");
    }
}
*/

.data
    fmt_str:    .string "La división de %d entre %d es: %d con residuo %d\n"
    num1:       .word 20
    num2:       .word 3

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

    // Realizar división
    sdiv    w3, w1, w2      // Cociente
    
    // Calcular residuo
    msub    w4, w3, w2, w1  // residuo = dividendo - (cociente * divisor)

    // Imprimir resultado
    adr     x0, fmt_str
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
