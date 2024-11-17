/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir un número binario a decimal en ARM64
Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        string binario = "101010"; // 42 en binario
        int decimal = 0;
        int base = 1;
        
        for(int i = binario.Length - 1; i >= 0; i--)
        {
            if(binario[i] == '1')
                decimal += base;
            base *= 2;
        }
        
        Console.WriteLine($"Binario: {binario}");
        Console.WriteLine($"Decimal: {decimal}");
    }
}
*/
.data
    binario:        .string "101010"    // 42 en binario
    msg_binario:    .string "Binario: %s\n"
    msg_decimal:    .string "Decimal: %d\n"
.text
.global main
main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    // Imprimir número binario
    adr     x0, msg_binario
    adr     x1, binario
    bl      printf
    // Inicializar variables
    mov     w19, #0                  // w19 = resultado decimal
    mov     w20, #1                  // w20 = base
    adr     x21, binario             // x21 = dirección string binario
    
    // Obtener longitud del string
    mov     w22, #0                  // w22 = longitud
strlen_loop:
    ldrb    w23, [x21, x22]
    cbz     w23, convert             // Si es 0, empezar conversión
    add     x22, x22, #1
    b       strlen_loop
convert:
    sub     x22, x22, #1             // Empezar desde el último dígito
convert_loop:
    cmp     x22, #0
    blt     print_result             // Si i < 0, terminar
    // Obtener dígito
    ldrb    w23, [x21, x22]          // w23 = binario[i]
    
    // Si es '1', sumar base al resultado
    cmp     w23, #'1'
    bne     next_digit
    add     w19, w19, w20            // resultado += base
next_digit:
    lsl     w20, w20, #1             // base *= 2
    sub     x22, x22, #1             // i--
    b       convert_loop
print_result:
    // Imprimir resultado decimal
    adr     x0, msg_decimal
    mov     w1, w19
    bl      printf
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
