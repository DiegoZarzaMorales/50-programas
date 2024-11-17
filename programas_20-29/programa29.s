/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Contar la cantidad de bits activados (1s) en un número en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        uint numero = 195;  // 11000011 en binario
        int contador = 0;
        
        // Método 1: Iterar por cada bit
        uint n = numero;
        while (n > 0)
        {
            contador += (int)(n & 1);
            n >>= 1;
        }
        
        Console.WriteLine($"Número: {numero} (binario: {Convert.ToString(numero, 2).PadLeft(8, '0')})");
        Console.WriteLine($"Cantidad de bits activados: {contador}");
    }
}
*/

.data
    numero:         .word   195
    msg_num:        .string "Número: %d (binario: %s)\n"
    msg_bits:       .string "Cantidad de bits activados: %d\n"
    bin_buffer:     .skip   33

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
    adr     x0, msg_num
    mov     w1, w19
    adr     x2, bin_buffer
    bl      printf

    // Inicializar contador
    mov     w20, #0          // w20 = contador
    mov     w21, w19         // w21 = copia del número

count_loop:
    cbz     w21, print_result  // Si el número es 0, terminar

    // Contar bit menos significativo
    and     w22, w21, #1     // Obtener último bit
    add     w20, w20, w22    // Incrementar contador si el bit es 1
    lsr     w21, w21, #1     // Desplazar número a la derecha
    b       count_loop

print_result:
    adr     x0, msg_bits
    mov     w1, w20          // contador
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
    add     x4, x4, #1
    cmp     w3, #0
    bne     binary_loop
    mov     w5, #0
    strb    w5, [x1, x4]
    ret
