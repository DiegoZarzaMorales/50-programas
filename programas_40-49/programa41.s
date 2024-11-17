/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir un número decimal a hexadecimal en ARM64
Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int decimal = 255;
        string hex = decimal.ToString("X");
        
        Console.WriteLine($"Decimal: {decimal}");
        Console.WriteLine($"Hexadecimal: {hex}");
    }
}
*/
.data
    numero:         .word   255
    hex_chars:      .string "0123456789ABCDEF"
    buffer:         .skip   9           // 8 dígitos + null terminator
    msg_decimal:    .string "Decimal: %d\n"
    msg_hex:        .string "Hexadecimal: %s\n"
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
    add     x20, x20, #7             // Apuntar al final del buffer
    mov     w21, #0                  // Null terminator
    strb    w21, [x20, #1]           // Agregar null terminator
    adr     x22, hex_chars           // x22 = tabla de caracteres hex
    mov     w23, #0                  // w23 = contador de dígitos
convert_loop:
    cbz     w19, print_result        // Si el número es 0, terminar
    // Obtener último dígito (número % 16)
    and     w21, w19, #15            // w21 = número & 15
    ldrb    w21, [x22, x21]          // Obtener carácter hex
    strb    w21, [x20]               // Guardar dígito
    sub     x20, x20, #1             // Mover puntero
    add     w23, w23, #1             // Incrementar contador
    // número = número / 16
    lsr     w19, w19, #4             // Dividir por 16 (shift derecha 4 bits)
    b       convert_loop
print_result:
    // Si el contador es 0, imprimir "0"
    cbnz    w23, print_hex
    mov     w21, #'0'
    strb    w21, [x20, #1]
print_hex:
    adr     x0, msg_hex
    add     x1, x20, #1              // Apuntar al inicio del número
    bl      printf
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
