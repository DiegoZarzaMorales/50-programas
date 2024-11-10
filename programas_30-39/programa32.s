/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular la potencia de un número (x^n) en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int baseNum = 2;
        int exponente = 5;
        int resultado = 1;
        
        for(int i = 0; i < exponente; i++)
        {
            resultado *= baseNum;
        }
        
        Console.WriteLine($"{baseNum}^{exponente} = {resultado}");
    }
}
*/

.data
    base_num:       .word   2
    exponente:      .word   5
    msg_input:      .string "Calculando %d^%d\n"
    msg_result:     .string "Resultado: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x19, base_num
    ldr     w19, [x19]       // w19 = base
    adr     x20, exponente
    ldr     w20, [x20]       // w20 = exponente

    // Mostrar operación
    adr     x0, msg_input
    mov     w1, w19
    mov     w2, w20
    bl      printf

    // Inicializar resultado
    mov     w21, #1          // w21 = resultado = 1
    mov     w22, #0          // w22 = contador = 0

power_loop:
    cmp     w22, w20         // Comparar contador con exponente
    bge     print_result     // Si contador >= exponente, terminar

    mul     w21, w21, w19    // resultado *= base
    add     w22, w22, #1     // contador++
    b       power_loop

print_result:
    adr     x0, msg_result
    mov     w1, w21
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
