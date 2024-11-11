/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Medir el tiempo de ejecución de una operación en ARM64

Código equivalente en C#:
using System;
using System.Diagnostics;
class Program
{
    static void Main()
    {
        Stopwatch sw = new Stopwatch();
        sw.Start();
        
        // Operación a medir (ejemplo: bucle)
        for(int i = 0; i < 1000000; i++)
        {
            int x = i * i;
        }
        
        sw.Stop();
        Console.WriteLine($"Tiempo de ejecución: {sw.ElapsedMilliseconds} ms");
    }
}
*/

.data
    iterations:     .word   1000000
    msg_start:      .string "Iniciando medición de tiempo...\n"
    msg_end:        .string "Tiempo de ejecución: %lld ciclos\n"

.text
.global main

main:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Imprimir mensaje inicial
    adr     x0, msg_start
    bl      printf

    // Obtener tiempo inicial
    mrs     x19, CNTVCT_EL0    // Leer contador de ciclos

    // Operación a medir
    adr     x20, iterations
    ldr     w20, [x20]         // w20 = número de iteraciones
    mov     w21, #0            // w21 = contador

measure_loop:
    cmp     w21, w20
    bge     end_measure

    // Operación dummy (multiplicación)
    mul     w22, w21, w21

    add     w21, w21, #1
    b       measure_loop

end_measure:
    // Obtener tiempo final y calcular diferencia
    mrs     x20, CNTVCT_EL0    
    sub     x20, x20, x19      // x20 = ciclos transcurridos

    // Mostrar resultado
    adr     x0, msg_end
    mov     x1, x20
    bl      printf

    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
