/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Verificar si una cadena es palíndromo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string texto = "reconocer";
        bool esPalindromo = true;
        int inicio = 0;
        int fin = texto.Length - 1;
        
        while(inicio < fin)
        {
            if(texto[inicio] != texto[fin])
            {
                esPalindromo = false;
                break;
            }
            inicio++;
            fin--;
        }
        Console.WriteLine($"La palabra '{texto}' {(esPalindromo ? "es" : "no es")} un palíndromo");
    }
}
*/

.data
    texto:          .string "reconocer"
    msg_es:         .string "La palabra '%s' es un palíndromo\n"
    msg_no_es:      .string "La palabra '%s' no es un palíndromo\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Calcular longitud
    adr     x19, texto       // x19 = dirección del texto
    mov     x20, #0          // x20 = longitud

strlen_loop:
    ldrb    w21, [x19, x20]  // Cargar byte
    cbz     w21, check_palin // Si es 0, iniciar verificación
    add     x20, x20, #1     // longitud++
    b       strlen_loop

check_palin:
    mov     x21, #0          // x21 = inicio
    sub     x20, x20, #1     // x20 = fin (longitud - 1)

compare_loop:
    cmp     x21, x20         // Comparar inicio con fin
    bge     es_palindromo    // Si inicio >= fin, es palíndromo

    ldrb    w22, [x19, x21]  // Cargar carácter del inicio
    ldrb    w23, [x19, x20]  // Cargar carácter del fin
    cmp     w22, w23         // Comparar caracteres
    bne     no_palindromo    // Si son diferentes, no es palíndromo

    add     x21, x21, #1     // Incrementar inicio
    sub     x20, x20, #1     // Decrementar fin
    b       compare_loop

es_palindromo:
    adr     x0, msg_es
    mov     x1, x19
    bl      printf
    b       done

no_palindromo:
    adr     x0, msg_no_es
    mov     x1, x19
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
