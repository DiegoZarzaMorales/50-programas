/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Invertir una cadena en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string texto = "Hola Mundo";
        char[] caracteres = texto.ToCharArray();
        Array.Reverse(caracteres);
        string textoInvertido = new string(caracteres);
        Console.WriteLine($"Texto original: {texto}");
        Console.WriteLine($"Texto invertido: {textoInvertido}");
    }
}
*/

.data
    cadena:         .string "Hola Mundo"
    buffer:         .skip 256
    fmt_original:   .string "Texto original: %s\n"
    fmt_invertido:  .string "Texto invertido: %s\n"

.text
.global main
.balign 4

main:
    stp     x29, x30, [sp, #-16]!

    // Imprimir cadena original
    adr     x0, fmt_original
    adr     x1, cadena
    bl      printf

    // Calcular longitud de la cadena
    adr     x19, cadena            // x19 = dirección de la cadena
    mov     x20, #0                // x20 = longitud

strlen_loop:
    ldrb    w21, [x19, x20]       // Cargar byte
    cbz     w21, strlen_done       // Si es 0, fin de cadena
    add     x20, x20, #1          // Incrementar longitud
    b       strlen_loop

strlen_done:
    // Copiar e invertir la cadena
    adr     x21, buffer           // x21 = dirección del buffer
    sub     x20, x20, #1          // x20 = longitud - 1

copy_loop:
    ldrb    w22, [x19, x20]       // Cargar byte desde el final
    strb    w22, [x21]            // Guardar byte al inicio del buffer
    add     x21, x21, #1          // Avanzar puntero destino
    subs    x20, x20, #1          // Retroceder en la cadena original
    bpl     copy_loop             // Continuar si no hemos llegado al inicio

    // Agregar null terminator
    mov     w22, #0
    strb    w22, [x21]

    // Imprimir cadena invertida
    adr     x0, fmt_invertido
    adr     x1, buffer
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
