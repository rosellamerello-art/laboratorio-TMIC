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
    rcall OPERAR
    rcall ACTUALIZAR_SALIDAS
    rcall RETARDO_DEBOUNCE
    rjmp  MAIN

    RETARDO_DEBOUNCE:
    ldi   r23, 50
D1: ldi   r24, 255
D2: dec   r24
    brne  D2
    dec   r23
    brne  D1
    ret

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
    
OPERAR:
    cpi   rS, 0
    breq  OP_CLEAR
    cpi   rS, 1
    breq  OP_SUB
    cpi   rS, 2
    breq  OP_ADD
    cpi   rS, 3
    breq  OP_XOR
    cpi   rS, 4
    breq  OP_AND
    cpi   rS, 5
    breq  OP_OR
    cpi   rS, 6
    breq  OP_SHL
    cpi   rS, 7
    breq  OP_INC
    rjmp  FIN_OP

OP_CLEAR:
    clr   temp
    clr   rFlags
    rjmp  GUARDAR

OP_SUB:
    mov   temp, rA
    sub   temp, rB
    rjmp  CALC_CARRY

OP_ADD:
    mov   temp, rA
    add   temp, rB
    rjmp  CALC_CARRY

OP_XOR:
    mov   temp, rA
    eor   temp, rB
    clr   rFlags        
    rjmp  GUARDAR

OP_AND:
    mov   temp, rA
    and   temp, rB
    clr   rFlags
    rjmp  GUARDAR

OP_OR:
    mov   temp, rA
    or    temp, rB
    clr   rFlags
    rjmp  GUARDAR

OP_SHL:
    mov   temp, rA
    add   temp, rA      
    rjmp  CALC_CARRY

OP_INC:
    mov   temp, rA
    subi  temp, 0xFF    
    rjmp  CALC_CARRY

CALC_CARRY:
    clr   rFlags
    sbrc  temp, 4               
    ori   rFlags, 0b00000001    

GUARDAR:
    andi  temp, 0x0F            
    mov   rF, temp

    sbrc  rF, 3                 
    ori   rFlags, 0b00000010

    cpi   rF, 0
    brne  NO_ZERO
    ori   rFlags, 0b00000100    
NO_ZERO:

FIN_OP:
    ret

ACTUALIZAR_SALIDAS:
    
    clr   temp
    sbrc  rFlags, 0
    ori   temp, 0b00010000      
    sbrc  rFlags, 1
    ori   temp, 0b00100000      
    sbrc  rFlags, 2
    ori   temp, 0b01000000      
    or    temp, rF              
    out   PORTB, temp

    in    temp, PORTC           
    andi  temp, 0b00001111      
    mov   r22, rS
    lsl   r22
    lsl   r22
    lsl   r22
    lsl   r22                  
    or    temp, r22
    out   PORTC, temp

    ret
