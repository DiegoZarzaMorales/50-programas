/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar búsqueda binaria en un arreglo ordenado en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Main()
    {
        int[] arr = {4, 8, 15, 16, 23, 42}; // Arreglo ordenado
        int buscar = 16;
        int inicio = 0;
        int fin = arr.Length - 1;
        int posicion = -1;
        
        while(inicio <= fin)
        {
            int medio = (inicio + fin) / 2;
            if(arr[medio] == buscar)
            {
                posicion = medio;
                break;
            }
            if(arr[medio] < buscar)
                inicio = medio + 1;
            else
                fin = medio - 1;
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
    msg_array:  .string "Arreglo ordenado: "
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
    bge     binary_search

    ldr     w1, [x19, w22, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w22, w22, #1
    b       print_loop

binary_search:
    mov     w22, #0          // inicio = 0
    sub     w23, w20, #1     // fin = tamaño - 1

search_loop:
    cmp     w22, w23
    bgt     not_found

    add     w24, w
// Calcular medio = (inicio + fin) / 2
    add     w24, w22, w23    // w24 = inicio + fin
    lsr     w24, w24, #1     // w24 = (inicio + fin) / 2

    // Cargar elemento del medio
    ldr     w25, [x19, w24, SXTW 2]  // w25 = arr[medio]

    // Comparar con valor buscado
    cmp     w25, w21
    beq     found            // Si son iguales, encontrado
    blt     greater          // Si arr[medio] < buscar, buscar en mitad superior
    
    // Buscar en mitad inferior
    sub     w23, w24, #1     // fin = medio - 1
    b       search_loop

greater:
    add     w22, w24, #1     // inicio = medio + 1
    b       search_loop

found:
    adr     x0, msg_found
    mov     w1, w21          // Valor buscado
    mov     w2, w24          // Posición
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
