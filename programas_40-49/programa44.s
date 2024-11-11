/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Generar números pseudoaleatorios usando LCG (Linear Congruential Generator) en ARM64

Código equivalente en C#:
using System;
class Program
{
    static uint seed = 12345;
    
    static uint GetRandom()
    {
        // Usando el algoritmo LCG: X(n+1) = (a * X(n) + c) mod m
        seed = seed * 1103515245 + 12345;
        return (seed / 65536) % 32768;
    }
    
    static void Main()
    {
        Console.WriteLine("Generando 5 números aleatorios:");
        for(int i = 0; i < 5; i++)
        {
            Console.WriteLine($"Número {i+1}: {GetRandom()}");
        }
    }
}
*/

.data
    seed:           .word   12345
    msg_start:      .string "Generando 5 números aleatorios:\n"
    msg_num:        .string "Número %d: %u\n"
    const_a:        .word   1103515245
    const_c:        .word   12345

.text
.global main

// Función para generar número aleatorio
get_random:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar seed y constantes
    adr     x0, seed
    ldr     w1, [x0]                // w1 = seed actual
    adr     x2, const_a
    ldr     w2, [x2]                // w2 = a
    adr     x3, const_c
    ldr     w3, [x3]                // w3 = c

    // Calcular siguiente seed
    mul     w1, w1, w2              // seed * a
    add     w1, w1, w3              // + c
    str     w1, [x0]                // Guardar nueva seed

    // Calcular número aleatorio
    lsr     w0, w1, #16             // seed / 65536
    mov     w1, #32768
    udiv    w2, w0, w1              // división
    msub    w0, w2, w1, w0          // módulo 32768

    ldp     x29, x30, [sp], #16
    ret

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_start
    bl      printf

    // Generar 5 números
    mov     w19, #1                 // w19 = contador

generate_loop:
    cmp     w19, #6
    bge     done

    // Guardar contador
    str     w19, [sp, #-16]!

    // Generar número aleatorio
    bl      get_random
    mov     w2, w0                  // w2 = número aleatorio

    // Imprimir resultado
    adr     x0, msg_num
    ldr     w1, [sp], #16           // Recuperar contador
    bl      printf

    add     w19, w19, #1            // Incrementar contador
    b       generate_loop

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
