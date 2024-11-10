/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Realizar desplazamientos de bits a la izquierda y derecha en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int numero = 8;    // 1000 en binario
        int izquierda = numero << 2;  // Desplazar 2 bits a la izquierda
        int derecha = numero >> 1;    // Desplazar 1 bit a la derecha
        
        Console.WriteLine($"Número original: {numero} (binario: {Convert.ToString(numero, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Desplazamiento izquierda <<2: {izquierda} (binario: {Convert.ToString(izquierda, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Desplazamiento derecha >>1: {derecha} (binario: {Convert.ToString(derecha, 2).PadLeft(8, '0')})");
    }
}
*/

.data
    numero:         .word   8
    msg_orig:       .string "Número original: %d (binario: %s)\n"
    msg_left:       .string "Desplazamiento izquierda <<2: %d (binario: %s)\n"
    msg_right:      .string "Desplazamiento derecha >>1: %d (binario: %s)\n"
    bin_buffer:     .skip   33              // Buffer para string binario

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar número
    adr     x19, numero
    ldr     w19, [x19]       // w19 = número

    // Mostrar número original
    mov     w0, w19
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_orig
    mov     w1, w19
    adr     x2, bin_buffer
    bl      printf

    // Desplazamiento a la izquierda
    lsl     w20, w19, #2     // w20 = número << 2
    mov     w0, w20
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_left
    mov     w1, w20
    adr     x2, bin_buffer
    bl      printf

    // Desplazamiento a la derecha
    lsr     w20, w19, #1     // w20 = número >> 1
    mov     w0, w20
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_right
    mov     w1, w20
    adr     x2, bin_buffer
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

// Función para convertir número a string binario (igual que en el programa anterior)
to_binary:
    mov     w3, #32
    mov     w4, #0
binary_loop:
    sub     w3, w3, #1
    lsr     w5, w0, w3
    and     w5, w5, #1
    add     w5, w5, #48
    strb    w5, [x1, w4]
    add     w4, w4, #1
    cmp     w3, #0
    bne     binary_loop
    mov     w5, #0
    strb    w5, [x1, w4]
    ret
