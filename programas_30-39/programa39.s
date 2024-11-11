/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir un número decimal a binario en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int decimal = 42;
        string binario = "";
        int temp = decimal;
        
        while(temp > 0)
        {
            binario = (temp % 2) + binario;
            temp /= 2;
        }
        
        Console.WriteLine($"Decimal: {decimal}");
        Console.WriteLine($"Binario: {binario}");
    }
}
*/

.data
    numero:         .word   42
    buffer:         .skip   33          // 32 bits + null terminator
    msg_decimal:    .string "Decimal: %d\n"
    msg_binario:    .string "Binario: %s\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir número decimal
    adr     x0, msg_decimal
    adr     x1, numero
    ldr     w1, [x1]
    bl      printf

    // Preparar para conversión
    adr     x19, numero
    ldr     w19, [x19]               // w19 = número
    adr     x20, buffer              // x20 = buffer
    add     x20, x20, #31            // Apuntar al final del buffer
    mov     w21, #0                  // Null terminator
    strb    w21, [x20, #1]           // Agregar null terminator
    mov     w22, #0                  // w22 = contador de dígitos

convert_loop:
    cbz     w19, print_result        // Si el número es 0, terminar

    // Obtener último bit (número % 2)
    and     w21, w19, #1             // w21 = número & 1
    add     w21, w21, #'0'           // Convertir a ASCII
    strb    w21, [x20]               // Guardar dígito
    sub     x20, x20, #1             // Mover puntero
    add     w22, w22, #1             // Incrementar contador

    // número = número / 2
    lsr     w19, w19, #1             // Dividir por 2 (shift derecha)
    b       convert_loop

print_result:
    // Si el contador es 0, imprimir "0"
    cbnz    w22, print_binary
    mov     w21, #'0'
    strb    w21, [x20, #1]

print_binary:
    adr     x0, msg_binario
    add     x1, x20, #1              // Apuntar al inicio del número
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
