/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular la suma de los primeros N números naturales en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int n = 10;
        int suma = 0;
        for(int i = 1; i <= n; i++)
        {
            suma += i;
        }
        Console.WriteLine($"La suma de los primeros {n} números naturales es: {suma}");
    }
}
*/

.data
    fmt_str: .string "La suma de los primeros %d números naturales es: %d\n"
    n:       .word 10

.text
.global main
.balign 4

main:
    stp     x29, x30, [sp, #-16]!

    // Inicializar variables
    adr     x0, n
    ldr     w19, [x0]               // w19 = n
    mov     w20, #0                 // w20 = suma
    mov     w21, #1                 // w21 = i = 1

loop:
    cmp     w21, w19                // Comparar i con n
    bgt     done                    // Si i > n, terminar
    
    add     w20, w20, w21           // suma += i
    add     w21, w21, #1            // i++
    b       loop

done:
    // Imprimir resultado
    adr     x0, fmt_str
    mov     w1, w19                 // n
    mov     w2, w20                 // suma
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
