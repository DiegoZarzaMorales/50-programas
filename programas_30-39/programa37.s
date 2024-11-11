/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar una pila (stack) usando un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static int[] stack = new int[5];
    static int top = -1;
    
    static void Push(int valor)
    {
        if(top >= 4)
            Console.WriteLine("Error: Pila llena");
        else
            stack[++top] = valor;
    }
    
    static int Pop()
    {
        if(top < 0)
        {
            Console.WriteLine("Error: Pila vacía");
            return -1;
        }
        return stack[top--];
    }
    
    static void Main()
    {
        Console.WriteLine("Push: 10");
        Push(10);
        Console.WriteLine("Push: 20");
        Push(20);
        Console.WriteLine("Pop: " + Pop());
        Console.WriteLine("Push: 30");
        Push(30);
        while(top >= 0)
            Console.WriteLine("Pop: " + Pop());
    }
}
*/

.data
    stack:          .skip   20          // Espacio para 5 enteros
    top:           .word   -1
    size:          .word   5
    msg_push:      .string "Push: %d\n"
    msg_pop:       .string "Pop: %d\n"
    msg_full:      .string "Error: Pila llena\n"
    msg_empty:     .string "Error: Pila vacía\n"

.text
.global main

// Función push (x0 = valor a insertar)
push:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Verificar si la pila está llena
    adr     x1, top
    ldr     w2, [x1]                 // w2 = top
    adr     x3, size
    ldr     w3, [x3]
    sub     w3, w3, #1               // w3 = size - 1
    
    cmp     w2, w3
    bge     stack_full
    
    // Incrementar top y guardar valor
    add     w2, w2, #1               // top++
    str     w2, [x1]                 // Actualizar top
    
    // Guardar valor en stack
    adr     x1, stack
    str     w0, [x1, w2, SXTW 2]
    
    // Imprimir mensaje
    adr     x0, msg_push
    mov     w1, w0
    bl      printf
    
    mov     w0, #1                   // Retorno exitoso
    b       push_end

stack_full:
    adr     x0, msg_full
    bl      printf
    mov     w0, #0                   // Retorno fallido

push_end:
    ldp     x29, x30, [sp], #16
    ret

// Función pop
pop:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Verificar si la pila está vacía
    adr     x1, top
    ldr     w2, [x1]                 // w2 = top
    
    cmp     w2, #0
    blt     stack_empty
    
    // Obtener valor y decrementar top
    adr     x3, stack
    ldr     w0, [x3, w2, SXTW 2]    // w0 = valor
    sub     w2, w2, #1               // top--
    str     w2, [x1]                 // Actualizar top
    
    // Imprimir mensaje
    mov     w1, w0
    adr     x0, msg_pop
    bl      printf
    
    b       pop_end

stack_empty:
    adr     x0, msg_empty
    bl      printf
    mov     w0, #-1                  // Retorno error

pop_end:
    ldp     x29, x30, [sp], #16
    ret

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Push 10
    mov     w0, #10
    bl      push

    // Push 20
    mov     w0, #20
    bl      push

    // Pop
    bl      pop

    // Push 30
    mov     w0, #30
    bl      push

    // Pop todo
pop_loop:
    adr     x0, top
    ldr     w0, [x0]
    cmp     w0, #0
    blt     done
    bl      pop
    b       pop_loop

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
