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
        for(int i = 2; i * i <= n && esPrimo; i++)
        {
            if(n % i == 0)
                esPrimo = false;
        }
        
        Console.WriteLine($"El número {n} {(esPrimo ? "es" : "no es")} primo");
    }
}
*/

.data
    num:            .word 17
    msg_es_primo:   .string "El número %d es primo\n"
    msg_no_primo:   .string "El número %d no es primo\n"

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar número
    adr     x0, num
    ldr     w19, [x0]        // w19 = número

    // Verificar si es menor o igual a 1
    cmp     w19, #1
    ble     no_primo

    // Inicializar i = 2
    mov     w20, #2          // w20 = i

loop:
    mul     w21, w20, w20    // w21 = i * i
    cmp     w21, w19         // Comparar i * i con n
    bgt     es_primo         // Si i * i > n, es primo

    // Verificar si es divisible por i
    sdiv    w21, w19, w20    // w21 = n / i
    msub    w21, w21, w20, w19  // w21 = n % i
    cbz     w21, no_primo    // Si residuo es 0, no es primo

    add     w20, w20, #1     // i++
    b       loop

es_primo:
    adr     x0, msg_es_primo
    mov     w1, w19
    bl      printf
    b       done

no_primo:
    adr     x0, msg_no_primo
    mov     w1, w19
    bl      printf

done:
    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
