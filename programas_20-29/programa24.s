/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Calcular la longitud de una cadena en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string texto = "Hola Mundo";
        int longitud = texto.Length;
        Console.WriteLine($"Cadena: {texto}");
        Console.WriteLine($"Longitud: {longitud}");
    }
}
*/

.data
    cadena:     .string "Hola Mundo"
    msg_str:    .string "Cadena: %s\n"
    msg_len:    .string "Longitud: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir cadena original
    adr     x0, msg_str
    adr     x1, cadena
    bl      printf

    // Calcular longitud
    adr     x19, cadena      // x19 = dirección cadena
    mov     w20, #0          // w20 = contador

count_loop:
    ldrb    w21, [x19, w20]  // Cargar byte
    cbz     w21, print_result // Si es 0, terminar
    add     w20, w20, #1     // Incrementar contador
    b       count_loop

print_result:
    // Imprimir longitud
    adr     x0, msg_len
    mov     w1, w20
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
