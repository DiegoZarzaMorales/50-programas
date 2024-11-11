/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Implementar una cola (queue) usando un arreglo en ARM64

Código equivalente en C#:
using System;
class Program
{
    static int[] queue = new int[5];
    static int front = -1;
    static int rear = -1;
    
    static void Enqueue(int valor)
    {
        if(rear >= 4)
        {
            Console.WriteLine("Error: Cola llena");
            return;
        }
        if(front == -1) front = 0;
        queue[++rear] = valor;
        Console.WriteLine($"Enqueue: {valor}");
    }
    
    static int Dequeue()
    {
        if(front == -1 || front > rear)
        {
            Console.WriteLine("Error: Cola vacía");
            return -1;
        }
        int valor = queue[front++];
        Console.WriteLine($"Dequeue: {valor}");
        if(front > rear)
            front = rear = -1;
        return valor;
    }
    
    static void Main()
    {
        Enqueue(10);
        Enqueue(20);
        Enqueue(30);
        Dequeue();
        Enqueue(40);
        while(front != -1 && front <= rear)
            Dequeue();
    }
}
*/

.data
    queue:          .skip   20          // Espacio para 5 enteros
    front:          .word   -1
    rear:           .word   -1
    size:           .word   5
    msg_enq:        .string "Enqueue: %d\n"
    msg_deq:        .string "Dequeue: %d\n"
    msg_full:       .string "Error: Cola llena\n"
    msg_empty:      .string "Error: Cola vacía\n"

.text
.global main

// Función enqueue (x0 = valor a insertar)
enqueue:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Verificar si la cola está llena
    adr     x1, rear
    ldr     w2, [x1]                 // w2 = rear
    adr     x3, size
    ldr     w3, [x3]
    sub     w3, w3, #1               // w3 = size - 1
    
    cmp     w2, w3
    bge     queue_full
    
    // Si front es -1, inicializarlo
    adr     x3, front
    ldr     w4, [x3]
    cmp     w4, #-1
    bne     skip_front
    mov     w4, #0
    str     w4, [x3]

skip_front:
    // Incrementar rear y guardar valor
    add     w2, w2, #1               // rear++
    str     w2, [x1]                 // Actualizar rear
    
    // Guardar valor en queue
    adr     x1, queue
    str     w0, [x1, w2, SXTW 2]
    
    // Imprimir mensaje
    adr     x0, msg_enq
    mov     w1, w0
    bl      printf
    
    mov     w0, #1                   // Retorno exitoso
    b       enqueue_end

queue_full:
    adr     x0, msg_full
    bl      printf
    mov     w0, #0                   // Retorno fallido

enqueue_end:
    ldp     x29, x30, [sp], #16
    ret

// Función dequeue
dequeue:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Verificar si la cola está vacía
    adr     x1, front
    ldr     w2, [x1]                 // w2 = front
    adr     x3, rear
    ldr     w3, [x3]                 // w3 = rear
    
    cmp     w2, #-1
    beq     queue_empty
    cmp     w2, w3
    bgt     queue_empty
    
    // Obtener valor
    adr     x4, queue
    ldr     w0, [x4, w2, SXTW 2]    // w0 = valor
    
    // Incrementar front
    add     w2, w2, #1               // front++
    str     w2, [x1]                 // Actualizar front
    
    // Si front > rear, resetear cola
    cmp     w2, w3
    ble     print_dequeue
    
    mov     w2, #-1
    str     w2, [x1]                 // front = -1
    adr     x1, rear
    str     w2, [x1]                 // rear = -1

print_dequeue:
    // Imprimir mensaje
    mov     w1, w0
    adr     x0, msg_deq
    bl      printf
    
    b       dequeue_end

queue_empty:
    adr     x0, msg_empty
    bl      printf
    mov     w0, #-1                  // Retorno error

dequeue_end:
    ldp     x29, x30, [sp], #16
    ret

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Enqueue 10
    mov     w0, #10
    bl      enqueue

    // Enqueue 20
    mov     w0, #20
    bl      enqueue

    // Enqueue 30
    mov     w0, #30
    bl      enqueue

    // Dequeue
    bl      dequeue

    // Enqueue 40
    mov     w0, #40
    bl      enqueue

    // Dequeue todo
dequeue_loop:
    adr     x0, front
    ldr     w0, [x0]                 // w0 = front
    cmp     w0, #-1
    beq     done
    adr     x1, rear
    ldr     w1, [x1]                 // w1 = rear
    cmp     w0, w1
    bgt     done
    bl      dequeue
    b       dequeue_loop

done:
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
