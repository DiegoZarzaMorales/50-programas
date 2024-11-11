/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Encontrar el prefijo común más largo entre dos cadenas en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string str1 = "flower";
        string str2 = "flow";
        string prefix = "";
        int i = 0;
        
        while(i < str1.Length && i < str2.Length && str1[i] == str2[i])
        {
            prefix += str1[i];
            i++;
        }
        
        Console.WriteLine($"String 1: {str1}");
        Console.WriteLine($"String 2: {str2}");
        Console.WriteLine($"Prefijo común más largo: {prefix}");
    }
}
*/

.data
    str1:           .string "flower"
    str2:           .string "flow"
    prefix:         .skip 100
    msg_str1:       .string "String 1: %s\n"
    msg_str2:       .string "String 2: %s\n"
    msg_prefix:     .string "Prefijo común más largo: %s\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir strings originales
    adr     x0, msg_str1
    adr     x1, str1
    bl      printf

    adr     x0, msg_str2
    adr     x1, str2
    bl      printf

    // Inicializar variables
    adr     x19, str1          // x19 = dirección str1
    adr     x20, str2          // x20 = dirección str2
    adr     x21, prefix        // x21 = dirección prefix
    mov     w22, #0            // w22 = índice

compare_loop:
    // Cargar caracteres
    ldrb    w23, [x19, w22]    // w23 = str1[i]
    ldrb    w24, [x20, w22]    // w24 = str2[i]

    // Si alguno es nulo o son diferentes, terminar
    cbz     w23, end_prefix
    cbz     w24, end_prefix
    cmp     w23, w24
    bne     end_prefix

    // Guardar carácter en prefix
    strb    w23, [x21, w22]

    add     w22, w22, #1       // i++
    b       compare_loop

end_prefix:
    // Agregar null terminator
    mov     w23, #0
    strb    w23, [x21, w22]

    // Imprimir resultado
    adr     x0, msg_prefix
    mov     x1, x21
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
