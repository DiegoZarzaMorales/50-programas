/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Realizar operaciones a nivel de bits (AND, OR, XOR) en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int num1 = 60;  // 111100 en binario
        int num2 = 13;  // 001101 en binario
        
        int resultAND = num1 & num2;
        int resultOR = num1 | num2;
        int resultXOR = num1 ^ num2;
        
        Console.WriteLine($"Número 1: {num1} (binario: {Convert.ToString(num1, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Número 2: {num2} (binario: {Convert.ToString(num2, 2).PadLeft(8, '0')})");
        Console.WriteLine($"AND: {resultAND} (binario: {Convert.ToString(resultAND, 2).PadLeft(8, '0')})");
        Console.WriteLine($"OR: {resultOR} (binario: {Convert.ToString(resultOR, 2).PadLeft(8, '0')})");
        Console.WriteLine($"XOR: {resultXOR} (binario: {Convert.ToString(resultXOR, 2).PadLeft(8, '0')})");
    }
}
*/

.data
    num1:        .word   60              // 111100 en binario
    num2:        .word   13              // 001101 en binario
    msg_num1:    .string "Número 1: %d (binario: %s)\n"
    msg_num2:    .string "Número 2: %d (binario: %s)\n"
    msg_and:     .string "AND: %d (binario: %s)\n"
    msg_or:      .string "OR: %d (binario: %s)\n"
    msg_xor:     .string "XOR: %d (binario: %s)\n"
    bin_buffer:  .skip   33              // Buffer para string binario

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

    // Mostrar número 1
    mov     w0, w19          // Número a convertir
    adr     x1, bin_buffer   // Buffer para resultado
    bl      to_binary        // Convertir a binario
    adr     x0, msg_num1
    mov     w1, w19          // Número decimal
    adr     x2, bin_buffer   // String binario
    bl      printf

    // Mostrar número 2
    mov     w0, w20
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_num2
    mov     w1, w20
    adr     x2, bin_buffer
    bl      printf

    // AND
    and     w21, w19, w20    // Realizar AND
    mov     w0, w21
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_and
    mov     w1, w21
    adr     x2, bin_buffer
    bl      printf

    // OR
    orr     w21, w19, w20    // Realizar OR
    mov     w0, w21
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_or
    mov     w1, w21
    adr     x2, bin_buffer
    bl      printf

    // XOR
    eor     w21, w19, w20    // Realizar XOR
    mov     w0, w21
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_xor
    mov     w1, w21
    adr     x2, bin_buffer
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

// Función para convertir número a string binario
// w0 = número a convertir, x1 = buffer para resultado
to_binary:
    mov     w3, #32         // Contador de bits
    mov     w4, #0          // Posición en buffer

binary_loop:
    sub     w3, w3, #1      // Decrementar contador
    lsr     w5, w0, w3      // Desplazar a la derecha
    and     w5, w5, #1      // Obtener último bit
    add     w5, w5, #48     // Convertir a ASCII ('0' o '1')
    strb    w5, [x1, x4]    // Guardar en buffer
    add     w4, w4, #1      // Siguiente posición
    cmp     w3, #0
    bne     binary_loop

    mov     w5, #0          // Null terminator
    strb    w5, [x1, x4]
    ret
