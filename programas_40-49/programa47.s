/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Detectar desbordamiento en la suma de dos números en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int a = 2147483647;  // Máximo valor para int
        int b = 1;
        
        try
        {
            checked
            {
                int resultado = a + b;
                Console.WriteLine($"Suma exitosa: {resultado}");
            }
        }
        catch(OverflowException)
        {
            Console.WriteLine("¡Se detectó desbordamiento!");
        }
    }
}
*/

.data
    num1:           .word   2147483647    // INT_MAX
    num2:           .word   1
    msg_nums:       .string "Sumando %d + %d\n"
    msg_success:    .string "Suma exitosa: %d\n"
    msg_overflow:   .string "¡Se detectó desbordamiento!\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar números
    adr     x19, num1
    ldr     w19, [x19]         // w19 = num1
    adr     x20, num2
    ldr     w20, [x20]         // w20 = num2

    // Mostrar números a sumar
    adr     x0, msg_nums
    mov     w1, w19
    mov     w2, w20
    bl      printf

    // Realizar suma con detección de desbordamiento
    adds    w21, w19, w20      // Suma y actualiza flags
    b.vs    overflow           // Si hay overflow, saltar

    // Mostrar resultado exitoso
    adr     x0, msg_success
    mov     w1, w21
    bl      printf
    b       done

overflow:
    adr     x0, msg_overflow
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
