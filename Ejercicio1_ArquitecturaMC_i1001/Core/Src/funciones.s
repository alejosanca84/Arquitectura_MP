.syntax unified        @ Usar sintaxis unificada de ARM (Thumb-2)
    .global productoEscalar32_Asm @ Hacer el símbolo visible para C

    .section .text         @ Definir sección de código
    .thumb_func            @ Indicar que es función Thumb

productoEscalar32_Asm:
    @ R0 = vectorIn (puntero)
    @ R1 = vectorOut (puntero)
    @ R2 = longitud
    @ R3 = escalar

    PUSH {R4, LR}          @ Guardamos R4 (registro preservado) y LR (Link Register)

    CBZ R2, exit           @ Compare and Branch on Zero: Si longitud (R2) es 0, salimos

loop:
    LDR R4, [R0], #4       @ Carga el valor de [R0] en R4 y suma 4 a R0 (Post-indexed)
                           @ Ahora R4 tiene el valor actual del vectorIn

    MUL R4, R4, R3         @ Multiplica R4 = R4 * R3 (escalar)
                           @ El Cortex-M4 tiene multiplicador por hardware de 1 ciclo

    STR R4, [R1], #4       @ Guarda R4 en la dirección [R1] y suma 4 a R1 (Post-indexed)

    SUBS R2, R2, #1        @ Resta 1 a la longitud (R2) y actualiza banderas (S)
    BNE loop               @ Branch if Not Equal: Si Z=0 (R2 != 0), salta a 'loop'

exit:
    POP {R4, PC}           @ Restauramos R4 y cargamos LR en PC para retornar
