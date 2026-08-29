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

BUCLE:
    rjmp BUCLE

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

TABLA_PORTD:
    .db 0xFC, 0x18, 0x6C, 0x7C, 0x98, 0xB4, 0xF4, 0x1C, 0xFC, 0xBC

TABLA_PORTB:
    .db 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x00, 0x01, 0x01
