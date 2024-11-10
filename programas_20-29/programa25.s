/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Contar vocales y consonantes en una cadena en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string texto = "Hola Mundo";
        int vocales = 0, consonantes = 0;
        string vocs = "aeiouAEIOU";
        
        foreach(char c in texto)
        {
            if(char.IsLetter(c))
            {
                if(vocs.Contains(c))
                    vocales++;
                else
                    consonantes++;
            }
        }
        
        Console.WriteLine($"Texto: {texto}");
        Console.WriteLine($"Vocales: {vocales}");
        Console.WriteLine($"Consonantes: {consonantes}");
    }
}
*/

.data
    texto:      .string "Hola Mundo"
    vocales:    .string "aeiouAEIOU"
    msg_txt:    .string "Texto: %s\n"
    msg_voc:    .string "Vocales: %d\n"
    msg_cons:   .string "Consonantes: %d\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir texto original
    adr     x0, msg_txt
    adr     x1, texto
    bl      printf

    // Inicializar contadores
    mov     w19, #0          // w19 = contador vocales
    mov     w20, #0          // w20 = contador consonantes
    adr     x21, texto       // x21 = dirección texto
    mov     w22, #0          // w22 = índice texto

process_loop:
    ldrb    w23, [x21, w22]  // Cargar carácter
    cbz     w23, print_result // Si es 0, terminar

    // Verificar si es letra
    bl      is_letter
    cbz     w0, next_char

    // Verificar si es vocal
    bl      is_vowel
    cbnz    w0, count_vowel

    // Es consonante
    add     w20, w20, #1
    b       next_char

count_vowel:
    add     w19, w19, #1

next_char:
    add     w22, w22, #1     // Siguiente carácter
    b       process_loop

print_result:
    // Imprimir resultados
    adr     x0, msg_voc
    mov     w1, w19
    bl      printf

    adr     x0, msg_
    // Imprimir consonantes
    adr     x0, msg_cons
    mov     w1, w20
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret

// Función is_letter: verifica si un carácter es letra
is_letter:
    // w23 contiene el carácter
    cmp     w23, #'A'
    blt     not_letter
    cmp     w23, #'Z'
    ble     is_letter_true
    cmp     w23, #'a'
    blt     not_letter
    cmp     w23, #'z'
    bgt     not_letter

is_letter_true:
    mov     w0, #1
    ret

not_letter:
    mov     w0, #0
    ret

// Función is_vowel: verifica si un carácter es vocal
is_vowel:
    // w23 contiene el carácter
    adr     x0, vocales      // x0 = dirección string vocales
    mov     w1, #0           // w1 = índice

check_vowel:
    ldrb    w2, [x0, w1]     // Cargar vocal
    cbz     w2, not_vowel    // Si es 0, no es vocal
    cmp     w2, w23          // Comparar con carácter actual
    beq     is_vowel_true
    add     w1, w1, #1
    b       check_vowel

is_vowel_true:
    mov     w0, #1
    ret

not_vowel:
    mov     w0, #0
    ret
    
