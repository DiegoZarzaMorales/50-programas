/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Establecer, borrar y alternar bits específicos en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int numero = 73;        // 1001001 en binario
        int posicion = 3;
        
        // Establecer bit
        int setBit = numero | (1 << posicion);
        
        // Borrar bit
        int clearBit = numero & ~(1 << posicion);
        
        // Alternar bit
        int toggleBit = numero ^ (1 << posicion);
        
        Console.WriteLine($"Número original: {numero} (binario: {Convert.ToString(numero, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Después de establecer bit {posicion}: {setBit} (binario: {Convert.ToString(setBit, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Después de borrar bit {posicion}: {clearBit} (binario: {Convert.ToString(clearBit, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Después de alternar bit {posicion}: {toggleBit} (binario: {Convert.ToString(toggleBit, 2).PadLeft(8, '0')})");
    }
}
*/

.data
    numero:         .word   73
    posicion:       .word   3
    msg_orig:       .string "Número original: %d (binario: %s)\n"
    msg_set:        .string "Después de establecer bit %d: %d (binario: %s)\n"
    msg_clear:      .string "Después de borrar bit %d: %d (binario: %s)\n"
    msg_toggle:     .string "Después de alternar bit %d: %d (binario: %s)\n"
    bin_buffer:     .skip   33

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar número y posición
    adr     x19, numero
    ldr     w19, [x19]       // w19 = número
    adr     x20, posicion
    ldr     w20, [x20]       // w20 = posición

    // Mostrar número original
    mov     w0, w19
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_orig
    mov     w1, w19
    adr     x2, bin_buffer
    bl      printf

    // Establecer bit
    mov     w21, #1
    lsl     w21, w21, w20    // w21 = 1 << posición
    orr     w22, w19, w21    // w22 = número | (1 << posición)
    
    mov     w0, w22
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_set
    mov     w1, w20          // posición
    mov     w2, w22          // resultado
    adr     x3, bin_buffer
    bl      printf

    // Borrar bit
    mov     w21, #1
    lsl     w21, w21, w20    // w21 = 1 << posición
    mvn     w21, w21         // w21 = ~(1 << posición)
    and     w22, w19, w21    // w22 = número & ~(1 << posición)
    
    mov     w0, w22
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_clear
    mov     w1, w20
    mov     w2, w22
    adr     x3, bin_buffer
    bl      printf

    // Alternar bit
    mov     w21, #1
    lsl     w21, w21, w20    // w21 = 1 << posición
    eor     w22, w19, w21    // w22 = número ^ (1 << posición)
    
    mov     w0, w22
    adr     x1, bin_buffer
    bl      to_binary
    adr     x0, msg_toggle
    mov     w1, w20
    mov     w2, w22
    adr     x3, bin_buffer
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

// Función to_binary (igual que en programas anteriores)
to_binary:
    mov     w3, #32
    mov     w4, #0
binary_loop:
    sub     w3, w3, #1
    lsr     w5, w0, w3
    and     w5, w5, #1
    add     w5, w5, #48
    strb    w5, [x1, x4]
    add     w4, w4, #1
    cmp     w3, #0
    bne     binary_loop
    mov     w5, #0
    strb    w5, [x1, x4]
    ret
