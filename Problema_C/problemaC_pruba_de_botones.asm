.include "m328pdef.inc"

.org 0x0000
rjmp reset

reset:
ldi r16, 0xFF
out DDRD, r16

cbi DDRB, 0
cbi DDRB, 1
cbi DDRB, 2

ldi r18, 1
ldi r17, 0b00000001

main:

sbis PINB, 0
rjmp revisar_anterior

inc r18
cpi r18, 3
brne esperar_pb0
ldi r18, 1

esperar_pb0:
sbic PINB, 0
rjmp esperar_pb0
rjmp inicializar_patron

revisar_anterior:

sbis PINB, 1
rjmp revisar_reset
dec r18

cpi r18, 0
brne esperar_pb1
ldi r18, 2

esperar_pb1:
sbic PINB, 1
rjmp esperar_pb1
rjmp inicializar_patron

revisar_reset:

sbis PINB, 2
rjmp elegir_secuencia
ldi r18, 1

esperar_pb2:

sbic PINB, 2
rjmp esperar_pb2
rjmp inicializar_patron

inicializar_patron:

cpi r18, 1
breq inicio_sec1
ldi r17, 0b10000000
rjmp elegir_secuencia

inicio_sec1:

ldi r17, 0b00000001

elegir_secuencia:

cpi r18, 1
breq secuencia1
rjmp secuencia2

secuencia1:

out PORTD, r17
rcall retardo
lsl r17
brne volver_main1
ldi r17, 0b00000001

volver_main1:

rjmp main

secuencia2:

out PORTD, r17
rcall retardo
lsr r17
brne volver_main2
ldi r17, 0b10000000

volver_main2:

rjmp main

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