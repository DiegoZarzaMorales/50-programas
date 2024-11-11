/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Escribir texto en un archivo en ARM64

Código equivalente en C#:
using System;
using System.IO;
class Program
{
    static void Main()
    {
        string fileName = "output.txt";
        string text = "Hola, este es un texto de prueba.\n";
        
        try
        {
            File.WriteAllText(fileName, text);
            Console.WriteLine("Archivo escrito exitosamente.");
            
            string content = File.ReadAllText(fileName);
            Console.WriteLine("Contenido del archivo:");
            Console.WriteLine(content);
        }
        catch(Exception e)
        {
            Console.WriteLine($"Error: {e.Message}");
        }
    }
}
*/

.data
    filename:       .string "output.txt"
    write_mode:     .string "w"
    read_mode:      .string "r"
    content:        .string "Hola, este es un texto de prueba.\n"
    msg_success:    .string "Archivo escrito exitosamente.\n"
    msg_error:      .string "Error al manipular el archivo.\n"
    msg_content:    .string "Contenido del archivo:\n"
    buffer:         .skip 256
    file_handle:    .quad 0

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Abrir archivo para escritura
    adr     x0, filename
    adr     x1, write_mode
    bl      fopen
    adr     x1, file_handle
    str     x0, [x1]          // Guardar handle del archivo

    // Verificar si se abrió correctamente
    cmp     x0, #0
    beq     error

    // Escribir contenido
    adr     x1, content
    adr     x2, file_handle
    ldr     x2, [x2]
    bl      fputs

    // Cerrar archivo
    adr     x0, file_handle
    ldr     x0, [x0]
    bl      fclose

    // Mostrar mensaje de éxito
    adr     x0, msg_success
    bl      printf

    // Abrir archivo para lectura
    adr     x0, filename
    adr     x1, read_mode
    bl      fopen
    adr     x1, file_handle
    str     x0, [x1]

    // Verificar si se abrió correctamente
    cmp     x0, #0
    beq     error

    // Mostrar mensaje
    adr     x0, msg_content
    bl      printf

    // Leer y mostrar contenido
read_loop:
    adr     x0, buffer
    mov     x1, #256
    adr     x2, file_handle
    ldr     x2, [x2]
    bl      fgets
    
    // Si no hay más que leer, terminar
    cmp     x0, #0
    beq     close_file

    // Imprimir línea leída
    adr     x0, buffer
    bl      printf
    b       read_loop

close_file:
    // Cerrar archivo
    adr     x0, file_handle
    ldr     x0, [x0]
    bl      fclose
    b       done

error:
    adr     x0, msg_error
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
