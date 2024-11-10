/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir una cadena ASCII a número entero en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string numero = "12345";
        int resultado = 0;
        
        foreach(char c in numero)
        {
            resultado = resultado * 10 + (c - '0');
        }
        
        Console.WriteLine($"Cadena ASCII: {numero}");
        Console.WriteLine($"Número: {resultado}");
    }
}
*/

.data
    cadena:     .string "12345"
    msg_str:    .string "Cadena ASCII: %s\n"
    msg_num:    .string "Número: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir cadena original
    adr     x0, msg_str
    adr     x1, cadena
    bl      printf

    // Inicializar variables
    mov     w19, #0          // w19 = resultado
    adr     x20, cadena      // x20 = dirección cadena
    mov     w21, #0          // w21 = índice

convert_loop:
    ldrb    w22, [x20, w21]  // Cargar byte
    cbz     w22, print_result // Si es 0, terminar

    // resultado = resultado * 10 + (carácter - '0')
    mov     w23, #10
    mul     w19, w19, w23     // resultado * 10
    sub     w22, w22, #48     // carácter - '0'
    add     w19, w19, w22     // + dígito

    add     w21, w21, #1      // Siguiente carácter
    b       convert_loop

print_result:
    // Imprimir resultado
    adr     x0, msg_num
    mov     w1, w19
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
