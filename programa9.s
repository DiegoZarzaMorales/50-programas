/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Verificar si un número es primo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int n = 17;
        bool esPrimo = true;
        if(n <= 1) esPrimo = false;
        for(int i = 2; i * i <= n; i++)
        {
            if(n % i == 0)
            {
                esPrimo = false;
                break;
            }
        }
        Console.WriteLine($"El número {n} {(esPrimo ? "es" : "no es")} primo");
    }
}
*/

.data
    fmt_es_primo: .string "El número %d es primo\n"
    fmt_no_primo: .string "El número %d no es primo\n"
    num:          .word 17

.text
.global main
.balign 4

main:
    stp     x29, x30, [sp, #-16]!

    // Cargar número
    adr     x0, num
    ldr     w19, [x0]               // w19 = número

    // Verificar si es menor o igual a 1
    cmp     w19, #1
    ble     no_primo

    // Inicializar i = 2
    mov     w20, #2                 // w20 = i = 2

check_loop:
    mul     w21, w20, w20           // w21 = i * i
    cmp     w21, w19                // Comparar i * i con n
    bgt     es_primo                // Si i * i > n, es primo

    // Verificar si es divisible por i
    udiv    w21, w19, w20           // w21 = n / i
    mul     w21, w21, w20           // w21 = (n / i) * i
    cmp     w21, w19                // Comparar con n
    beq     no_primo                // Si son iguales, no es primo

    add     w20, w20, #1            // i++
    b       check_loop

es_primo:
    adr     x0, fmt_es_primo
    mov     w1, w19
    bl      printf
    b       done

no_primo:
    adr     x0, fmt_no_primo
    mov     w1, w19
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
