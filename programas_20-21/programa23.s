/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir un número entero a cadena ASCII en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int numero = 12345;
        string resultado = "";
        int temp = numero;
        
        // Convertir dígitos a ASCII en orden inverso
        do
        {
            resultado = (char)(temp % 10 + '0') + resultado;
            temp /= 10;
        } while(temp > 0);
        
        Console.WriteLine($"Número: {numero}");
        Console.WriteLine($"Cadena ASCII: {resultado}");
    }
}
*/

.data
    numero:     .word   12345
    buffer:     .skip   12          // Buffer para la cadena resultante
    msg_num:    .string "Número: %d\n"
    msg_str:    .string "Cadena ASCII: %s\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir número original
    adr     x0, msg_num
    adr     x1, numero
    ldr     w1, [x1]
    bl      printf

    // Inicializar variables
    adr     x19, buffer      // x19 = dirección buffer
    add     x19, x19, #11    // Apuntar al final del buffer
    mov     w20, #0
    strb    w20, [x19]       // Almacenar null terminator
    sub     x19, x19, #1     // Retroceder una posición
    adr     x20, numero
    ldr     w20, [x20]       // w20 = número a convertir

convert_loop:
    cbz     w20, print_result // Si el número es 0, terminar

    // Obtener último dígito
    mov     w21, #10
    sdiv    w22, w20, w21     // w22 = número / 10
    msub    w23, w22, w21, w20 // w23 = número % 10
    add     w23, w23, #48     // Convertir a ASCII

    // Almacenar dígito
    strb    w23, [x19]        // Guardar en buffer
    sub     x19, x19, #1      // Retroceder una posición

    mov     w20, w22          // número = número / 10
    b       convert_loop

print_result:
    // Imprimir resultado
    adr     x0, msg_str
    add     x1, x19, #1       // Ajustar puntero al inicio de la cadena
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
