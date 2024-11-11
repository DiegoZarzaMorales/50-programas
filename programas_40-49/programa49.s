/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Leer entrada desde el teclado en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        Console.WriteLine("Ingrese su nombre:");
        string nombre = Console.ReadLine();
        
        Console.WriteLine("Ingrese su edad:");
        int edad = int.Parse(Console.ReadLine());
        
        Console.WriteLine($"Hola {nombre}, tienes {edad} años.");
    }
}
*/

.data
    prompt_name:    .string "Ingrese su nombre: "
    prompt_age:     .string "Ingrese su edad: "
    msg_result:     .string "Hola %s, tienes %d años.\n"
    format_str:     .string "%s"
    format_int:     .string "%d"
    buffer:         .skip 100
    age:            .word 0

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Solicitar nombre
    adr     x0, prompt_name
    bl      printf

    // Leer nombre
    adr     x0, format_str
    adr     x1, buffer
    bl      scanf

    // Solicitar edad
    adr     x0, prompt_age
    bl      printf

    // Leer edad
    adr     x0, format_int
    adr     x1, age
    bl      scanf

    // Mostrar resultado
    adr     x0, msg_result
    adr     x1, buffer         // nombre
    adr     x2, age
    ldr     w2, [x2]          // edad
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
