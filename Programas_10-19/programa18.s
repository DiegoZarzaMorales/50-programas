/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar ordenamiento por mezcla en ARM64

Código equivalente en C#:
using System;
class Program
{
    static void Merge(int[] arr, int l, int m, int r)
    {
        int n1 = m - l + 1;
        int n2 = r - m;
        int[] L = new int[n1];
        int[] R = new int[n2];
        
        // Copiar datos a arrays temporales
        for(int i = 0; i < n1; i++)
            L[i] = arr[l + i];
        for(int j = 0; j < n2; j++)
            R[j] = arr[m + 1 + j];
            
        int i = 0, j = 0, k = l;
        
        while(i < n1 && j < n2)
        {
            if(L[i] <= R[j])
            {
                arr[k] = L[i];
                i++;
            }
            else
            {
                arr[k] = R[j];
                j++;
            }
            k++;
        }
        
        while(i < n1)
        {
            arr[k] = L[i];
            i++;
            k++;
        }
        
        while(j < n2)
        {
            arr[k] = R[j];
            j++;
            k++;
        }
    }
    
    static void MergeSort(int[] arr, int l, int r)
    {
        if(l < r)
        {
            int m = l + (r - l) / 2;
            MergeSort(arr, l, m);
            MergeSort(arr, m + 1, r);
            Merge(arr, l, m, r);
        }
    }
    
    static void Main()
    {
        int[] arr = {12, 11, 13, 5, 6, 7};
        MergeSort(arr, 0, arr.Length - 1);
        
        Console.WriteLine("Arreglo ordenado:");
        foreach(int num in arr)
            Console.Write($"{num} ");
    }
}
*/

.data
    array:      .word   12, 11, 13, 5, 6, 7
    size:       .word   6
    temp:       .skip   1000              // Espacio temporal para merge
    msg_orig:   .string "Arreglo original: "
    msg_ord:    .string "Arreglo ordenado: "
    msg_num:    .string "%d "
    msg_nl:     .string "\n"

.text
.global main

// Función merge
merge:
    // x0 = array, w1 = left, w2 = mid, w3 = right
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!
    stp     x21, x22, [sp, #-16]!
    stp     x23, x24, [sp, #-16]!

    mov     x19, x0          // Guardar array
    mov     w20, w1          // Guardar left
    mov     w21, w2          // Guardar mid
    mov     w22, w3          // Guardar right

    // Calcular tamaños
    sub     w23, w21, w20    // n1 = mid - left
    add     w23, w23, #1     // n1 = mid - left + 1
    sub     w24, w22, w21    // n2 = right - mid

    // Copiar a arrays temporales
    mov     w4, #0           // i = 0
copy_left:
    cmp     w4, w23
    bge     copy_right_init
    
    add     w5, w20, w4      // left + i
    ldr     w6, [x19, w5, SXTW 2]  // arr[left + i]
    adr     x7, temp
    str     w6, [x7, w4, SXTW 2]   // L[i] = arr[left + i]
    
    add     w4, w4, #1
    b       copy_left

copy_right_init:
    mov     w4, #0           // j = 0
copy_right:
    cmp     w4, w24
    bge     merge_arrays
    
    add     w5, w21, w4
    add     w5, w5, #1       // mid + 1 + j
    ldr     w6, [x19, w5, SXTW 2]  // arr[mid + 1 + j]
    adr     x7, temp
    add     x7, x7, w23, SXTW 2    // temp + n1
    str     w6, [x7, w4, SXTW 2]   // R[j] = arr[mid + 1 + j]
    
    add     w4, w4, #1
    b       copy_right

merge_arrays:
    mov     w4, #0           // i = 0
    mov     w5, #0           // j = 0
    mov     w6, w20          // k = left

merge_loop:
    cmp     w4, w23          // if i >= n1
    bge     copy_remaining_right
    cmp     w5, w24          // if j >= n2
    bge     copy_remaining_left

    adr     x7, temp
    ldr     w8, [x7, w4, SXTW 2]   // L[i]
    add     x7, x7, w23, SXTW 2
    ldr     w9, [x7, w5, SXTW 2]   // R[j]

    cmp     w8, w9
    bgt     copy_right_element

    str     w8, [x19, w6, SXTW 2]  // arr[k] = L[i]
    add     w4, w4, #1             // i++
    b       next_merge

copy_right_element:
    str     w9, [x19, w6, SXTW 2]  // arr[k] = R[j]
    add     w5, w5, #1             // j++

next_merge:
    add     w6, w6, #1             // k++
    b       merge_loop

copy_remaining_left:
    cmp     w4, w23
    bge     merge_done
    
    adr     x7, temp
    ldr     w8, [x7, w4, SXTW 2]   // L[i]
    str     w8, [x19, w6, SXTW 2]  // arr[k] = L[i]
    
    add     w4, w4, #1             // i++
    add     w6, w6, #1             // k++
    b       copy_remaining_left

copy_remaining_right:
    cmp     w5, w24
    bge     merge_done
    
    adr     x7, temp
    add     x7, x7, w23, SXTW 2
    ldr     w8, [x7, w5, SXTW 2]   // R[j]
    str     w8, [x19, w6, SXTW 2]  // arr[k] = R[j]
    
    add     w5, w5, #1             // j++
    add     w6, w6, #1             // k++
    b       copy_remaining_right

merge_done:
    ldp     x23, x24, [sp], #16
    ldp     x21, x22, [sp], #16
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret

// Función mergeSort
mergesort:
    // x0 = array, w1 = left, w2 = right
    stp     x29, x30, [sp, #-16]!
    stp     x19, x20, [sp, #-16]!

    mov     x19, x0          // Guardar array
    mov     w20, w1          // Guardar left

    cmp     w1, w2           // if left >= right
    bge     mergesort_done

    // Calcular mid = (left + right) / 2
    add     w3, w1, w2
    lsr     w3, w3, #1      // w3 = mid

    // Llamar mergesort para primera mitad
    str     w2, [sp, #-16]!  // Guardar right
    str     w3, [sp, #-16]!  // Guardar mid
    
    mov     w2, w3           // right = mid
    bl      mergesort

    // Restaurar registros
    ldr     w3, [sp], #16    // Restaurar mid
    ldr     w2, [sp], #16    // Restaurar right

    // Llamar mergesort para segunda mitad
    str     w2, [sp, #-16]!  // Guardar right
    str     w3, [sp, #-16]!  // Guardar mid
    
    add     w1, w3, #1       // left = mid + 1
    bl      mergesort

    // Restaurar registros y llamar a merge
    ldr     w3, [sp], #16    // Restaurar mid
    ldr     w2, [sp], #16    // Restaurar right
    mov     w1, w20          // Restaurar left original
    mov     x0, x19          // Restaurar array
    bl      merge

mergesort_done:
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir arreglo original
    adr     x0, msg_orig
    bl      printf

    // Mostrar elementos originales
    adr     x19, array       // x19 = dirección del array
    adr     x20, size
    ldr     w20, [x20]       // w20 = tamaño
    mov     w21, #0          // w21 = índice

print_orig:
    cmp     w21, w20
    bge     sort_start

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf
    add     w21, w21, #1
    b       print_orig

sort_start:
    // Nueva línea
    adr     x0, msg_nl
    bl      printf

    // Llamar a mergeSort
    adr     x0, array        // array
    mov     w1, #0           // left = 0
    sub     w2, w20, #1      // right = size - 1
    bl      mergesort

    // Imprimir mensaje
    adr     x0, msg_ord
    bl      printf

    // Mostrar elementos ordenados
    mov     w21, #0          // Reset índice

print_loop:
    cmp     w21, w20
    bge     done

    ldr     w1, [x19, w21, SXTW 2]
    adr     x0, msg_num
    bl      printf

    add     w21, w21, #1
    b       print_loop

done:
    // Nueva línea final
    adr     x0, msg_nl
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
