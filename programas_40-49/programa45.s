/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Verificar si un número es Armstrong (suma de sus dígitos elevados al número de dígitos es igual al número) en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num = 153;  // 153 = 1^3 + 5^3 + 3^3
        int original = num;
        int n = 0;
        int temp = num;
        
        // Contar dígitos
        while(temp > 0)
        {
            n++;
            temp /= 10;
        }
        
        // Calcular suma
        temp = num;
        int sum = 0;
        while(temp > 0)
        {
            int digit = temp % 10;
            sum += (int)Math.Pow(digit, n);
            temp /= 10;
        }
        
        Console.WriteLine($"El número {num} {(sum == original ? "es" : "no es")} un número Armstrong");
    }
}
*/

.data
    numero:         .word   153
    msg_es:         .string "El número %d es un número Armstrong\n"
    msg_no_es:      .string "El número %d no es un número Armstrong\n"

.text
.global main

// Función para calcular potencia (base en w0, exponente en w1)
potencia:
    mov     w2, #1              // resultado = 1
pot_loop:
    cbz     w1, pot_done       // Si exponente es 0, terminar
    mul     w2, w2, w0         // resultado *= base
    sub     w1, w1, #1         // exponente--
    b       pot_loop
pot_done:
    mov     w0, w2             // Retornar resultado
    ret

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar número
    adr     x19, numero
    ldr     w19, [x19]         // w19 = número original
    mov     w20, w19           // w20 = temp = número
    mov     w21, #0            // w21 = contador de dígitos

    // Contar dígitos
count_loop:
    cbz     w20, start_sum     // Si temp es 0, empezar suma
    add     w21, w21, #1       // contador++
    mov     w22, #10
    sdiv    w20, w20, w22      // temp /= 10
    b       count_loop

start_sum:
    mov     w20, w19           // Restaurar temp = número original
    mov     w22, #0            // w22 = suma

sum_loop:
    cbz     w20, check_result  // Si temp es 0, verificar resultado

    // Obtener último dígito
    mov     w23, #10
    sdiv    w24, w20, w23      // w24 = temp / 10
    msub    w23, w24, w23, w20 // w23 = dígito = temp % 10

    // Calcular dígito^n
    mov     w0, w23            // base = dígito
    mov     w1, w21            // exponente = n
    bl      potencia           // Calcular potencia
    add     w22, w22, w0       // suma += potencia

    mov     w20, w24           // temp /= 10
    b       sum_loop

check_result:
    cmp     w22, w19           // Comparar suma con número original
    bne     no_armstrong

es_armstrong:
    adr     x0, msg_es
    mov     w1, w19
    bl      printf
    b       done

no_armstrong:
    adr     x0, msg_no_es
    mov     w1, w19
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
