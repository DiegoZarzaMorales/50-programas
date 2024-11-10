/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar búsqueda lineal en un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {4, 8, 15, 16, 23, 42};
        int buscar = 16;
        int posicion = -1;
        
        for(int i = 0; i < arr.Length; i++)
        {
            if(arr[i] == buscar)
            {
                posicion = i;
                break;
            }
        }
        
        if(posicion != -1)
            Console.WriteLine($"El elemento {buscar} se encontró en la posición {posicion}");
        else
            Console.WriteLine($"El elemento {buscar} no se encontró en el arreglo");
    }
}
*/

.data
    array:      .word   4, 8, 15, 16, 23, 42
    size:       .word   6
    buscar:     .word   16
    msg_array:  .string "Arreglo: "
    msg_num:    .string "%d "
    msg_found:  .string "\nEl elemento %d se encontró en la posición %d\n"
    msg_not:    .string "\nEl elemento %d no se encontró en el arreglo\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir arreglo
    adr     x0, msg_array
    bl      printf

    // Mostrar elementos
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    adr     x21, buscar
    ldr     w21, [x21]       // w21 = valor a buscar
    mov     w22, #0          // w22 = índice

print_loop:
    cmp     w22, w20
    bge     search

    ldr     w1, [x19, w22, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w22, w22, #1
    b       print_loop

search:
    mov     w22, #0          // Reset índice

search_loop:
    cmp     w22, w20
    bge     not_found

    ldr     w23, [x19, w22, SXTW 2]
    cmp     w23, w21
    beq     found

    add     w22, w22, #1
    b       search_loop

found:
    adr     x0, msg_found
    mov     w1, w21          // Valor buscado
    mov     w2, w22          // Posición
    bl      printf
    b       done

not_found:
    adr     x0, msg_not
    mov     w1, w21          // Valor buscado
    bl      printf

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
