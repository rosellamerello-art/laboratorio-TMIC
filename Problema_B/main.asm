.include "m328pdef.inc"

.def contador = r16
.def temporal = r17
.def patron   = r18

.cseg
.org 0x0000
    rjmp RESET

.org 0x0034

RESET:
    cli
   
    ldi temporal, high(RAMEND)
    out SPH, temporal
    ldi temporal, low(RAMEND)
    out SPL, temporal

    clr r1

    ldi temporal, 0b11111100
    out DDRD, temporal

    ldi temporal, 0b00000001
    out DDRB, temporal

    ldi temporal, 0b00001110
    out PORTB, temporal

    clr contador
    rcall MOSTRAR_DIGITO

PRINCIPAL:
    sbic PINB, PB3
    rjmp REVISAR_INCREMENTO

    rcall RETARDO
    sbic PINB, PB3
    rjmp PRINCIPAL

    clr contador
    rjmp MOSTRAR

REVISAR_INCREMENTO:
    sbic PINB, PB1
    rjmp REVISAR_DECREMENTO

    rcall RETARDO
    sbic PINB, PB1
    rjmp PRINCIPAL

    inc contador
    cpi contador, 10
    brlo MOSTRAR

    clr contador
    rjmp MOSTRAR

REVISAR_DECREMENTO:
    sbic PINB, PB2
    rjmp PRINCIPAL

    rcall RETARDO
    sbic PINB, PB2
    rjmp PRINCIPAL

    tst contador
    brne RESTAR

    ldi contador, 9
    rjmp MOSTRAR

RESTAR:
    dec contador

MOSTRAR:
    rcall MOSTRAR_DIGITO

ESPERAR_SOLTAR:
    sbis PINB, PB1
    rjmp ESPERAR_SOLTAR

    sbis PINB, PB2
    rjmp ESPERAR_SOLTAR

    sbis PINB, PB3
    rjmp ESPERAR_SOLTAR

    rcall RETARDO
    rjmp PRINCIPAL

MOSTRAR_DIGITO:
    ldi ZH, high(TABLA_PORTD * 2)
    ldi ZL, low(TABLA_PORTD * 2)
    add ZL, contador
    adc ZH, r1
    lpm patron, Z
    out PORTD, patron

    ldi ZH, high(TABLA_PORTB * 2)
    ldi ZL, low(TABLA_PORTB * 2)
    add ZL, contador
    adc ZH, r1
    lpm patron, Z

    ori patron, 0b00001110
    out PORTB, patron
    ret

RETARDO:
    ldi r20, 2

RETARDO_1:
    ldi r21, 255

RETARDO_2:
    ldi r22, 210

RETARDO_3:
    dec r22
    brne RETARDO_3

    dec r21
    brne RETARDO_2

    dec r20
    brne RETARDO_1
    ret

TABLA_PORTD:
    .db 0xFC, 0x18, 0x6C, 0x7C, 0x98, 0xB4, 0xF4, 0x1C, 0xFC, 0xBC

TABLA_PORTB:
    .db 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x01, 0x01
