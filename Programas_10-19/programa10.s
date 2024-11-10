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
    msg_original:   .string "Texto original: %s\n"
    msg_invertido:  .string "Texto invertido: %s\n"

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir cadena original
    adr     x0, msg_original
    adr     x1, cadena
    bl      printf

    // Obtener longitud de la cadena
    adr     x19, cadena      // x19 = dirección de la cadena
    mov     w20, #0          // w20 = longitud

strlen_loop:
    ldrb    w21, [x19, w20]  // Cargar byte
    cbz     w21, invertir    // Si es 0, empezar inversión
    add     w20, w20, #1     // longitud++
    b       strlen_loop

invertir:
    // Preparar buffer para cadena invertida
    adr     x21, buffer      // x21 = dirección del buffer
    sub     w20, w20, #1     // Ajustar longitud (índice máximo)
    mov     w22, #0          // w22 = índice desde el inicio

copy_loop:
    cmp     w20, #0          // Si hemos terminado
    blt     print_result     // Imprimir resultado

    ldrb    w23, [x19, w20]  // Cargar carácter desde el final
    strb    w23, [x21, w22]  // Guardar en buffer desde el inicio
    sub     w20, w20, #1     // Decrementar índice origen
    add     w22, w22, #1     // Incrementar índice destino
    b       copy_loop

print_result:
    // Agregar null terminator
    mov     w23, #0
    strb    w23, [x21, w22]

    // Imprimir resultado
    adr     x0, msg_invertido
    mov     x1, x21
    bl      printf

    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
