.include "m328pdef.inc"
.org 0x0000
rjmp reset

reset:
ldi r16, 0xFF
out DDRD, r16
ldi r17, 0b00000001

main:
ida:
out PORTD, r17
rcall retardo
cpi r17, 0b10000000
breq vuelta
lsl r17
rjmp ida

vuelta:
lsr r17

regreso:
out PORTD, r17
rcall retardo
cpi r17, 0x00000001
breq ida 
lsr r17
rjmp regreso

retardo:
ldi r20, 20
RET1:
ldi r21, 255
RET2:
ldi r22, 255
RET3:
dec r22
brne RET3
dec r21
brne RET2
dec r20
brne RET1

ret
