.include "m328Pdef.inc"

.def temp    = r16
.def rA      = r17
.def rB      = r18
.def rS      = r19
.def rF      = r20
.def rFlags  = r21   ; bit0=C, bit1=N, bit2=Z

.org 0x0000
    rjmp RESET

.org 0x002A          
RESET:
    
    ldi   temp, low(RAMEND)
    out   SPL, temp
    ldi   temp, high(RAMEND)
    out   SPH, temp

    
    ldi   temp, 0b01111111
    out   DDRB, temp
    clr   temp
    out   PORTB, temp

    
    ldi   temp, 0b01110000
    out   DDRC, temp
    ldi   temp, 0b00001111      
    out   PORTC, temp

    clr   temp
    out   DDRD, temp
    ldi   temp, 0b01111111      
    out   PORTD, temp

MAIN:
    rcall LEER_ENTRADAS
    
    rjmp  MAIN

LEER_ENTRADAS:
    
    in    temp, PINC
    andi  temp, 0b00001111
    com   temp
    andi  temp, 0b00001111
    mov   rA, temp

    in    temp, PIND
    andi  temp, 0b00001111
    com   temp
    andi  temp, 0b00001111
    mov   rB, temp

    in    temp, PIND
    andi  temp, 0b01110000
    swap  temp                 
    com   temp
    andi  temp, 0b00000111
    mov   rS, temp

    ret
