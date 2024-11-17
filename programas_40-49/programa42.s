/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir un número hexadecimal a decimal en ARM64
Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string hex = "FF";  // 255 en decimal
        int resultado = 0;
        
        foreach(char c in hex)
        {
            resultado *= 16;
            if(char.IsDigit(c))
                resultado += c - '0';
            else
                resultado += 10 + (char.ToUpper(c) - 'A');
        }
        
        Console.WriteLine($"Hexadecimal: {hex}");
        Console.WriteLine($"Decimal: {resultado}");
    }
}
*/
.data
    hex:            .string "FF"
    msg_hex:        .string "Hexadecimal: %s\n"
    msg_decimal:    .string "Decimal: %d\n"
.text
.global main
main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    // Imprimir número hexadecimal
    adr     x0, msg_hex
    adr     x1, hex
    bl      printf
    // Inicializar variables
    mov     w19, #0                  // w19 = resultado
    adr     x20, hex                 // x20 = dirección string hex
convert_loop:
    ldrb    w21, [x20], #1           // Cargar carácter y avanzar puntero
    cbz     w21, print_result        // Si es null, terminar
    // Multiplicar resultado actual por 16
    lsl     w19, w19, #4             // resultado *= 16
    // Convertir carácter a valor
    cmp     w21, #'9'                // Comprobar si es dígito
    bgt     convert_letter
    sub     w21, w21, #'0'           // Convertir dígito
    b       add_value
convert_letter:
    bic     w21, w21, #0x20          // Convertir a mayúsculas (0x20 = 0b00100000)
    sub     w21, w21, #'A'           // Convertir letra
    add     w21, w21, #10            // Agregar 10 (A = 10, B = 11, etc.)
add_value:
    add     w19, w19, w21            // Sumar valor al resultado
    b       convert_loop
print_result:
    // Imprimir resultado decimal
    adr     x0, msg_decimal
    mov     w1, w19
    bl      printf
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
