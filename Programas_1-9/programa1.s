/*
Autor: [Zarza Morales Jose Diego] [2221036]
Propósito: Convertir temperatura de Celsius a Fahrenheit en ARM64
*/

.data
    fmt_str:    .string "%f°C es igual a %f°F\n"
    celsius:    .double 25.0
    const9:     .double 9.0
    const5:     .double 5.0
    const32:    .double 32.0

.text
.global main

main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Cargar valores
    adr     x0, celsius
    ldr     d0, [x0]
    fmov    d1, d0

    // Multiplicar por 9
    adr     x0, const9
    ldr     d2, [x0]
    fmul    d0, d0, d2

    // Dividir por 5
    adr     x0, const5
    ldr     d2, [x0]
    fdiv    d0, d0, d2

    // Sumar 32
    adr     x0, const32
    ldr     d2, [x0]
    fadd    d0, d0, d2

    // Imprimir resultado
    adr     x0, fmt_str
    bl      printf

    // Epílogo
    mov     w0, #0
    ldp     x29, x30, [sp], #16
    ret
