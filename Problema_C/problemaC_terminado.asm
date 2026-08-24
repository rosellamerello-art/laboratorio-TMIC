.include "m328pdef.inc"

.org 0x0000
rjmp reset

reset:
ldi r16, 0xFF
out DDRD, r16
cbi DDRB, 0
cbi DDRB, 1
cbi DDRB, 2

cbi PORTB, 0
cbi PORTB, 1
cbi PORTB, 2

ldi r18, 1
rjmp inicializar_secuencia

main:
sbis PINB, 0
rjmp revisar_anterior
inc r18
cpi r18, 9
brne esperar_pb0
ldi r18, 1

esperar_pb0:
sbic PINB, 0
rjmp esperar_pb0
rjmp inicializar_secuencia

revisar_anterior:
sbis PINB, 1
rjmp revisar_reset
dec r18
cpi r18, 0
brne esperar_pb1
ldi r18, 8

esperar_pb1:
sbic PINB, 1
rjmp esperar_pb1
rjmp inicializar_secuencia

revisar_reset:
sbis PINB, 2
rjmp elegir_secuencia
ldi r18, 1

esperar_pb2:
sbic PINB, 2
rjmp esperar_pb2
rjmp inicializar_secuencia

inicializar_secuencia:
cpi r18, 1 
brne init2
ldi r17, 0b00000001
rjmp main

init2:
cpi r18, 2
brne init3
ldi r17, 0b10000000
rjmp main

init3:
cpi r18, 3
brne init4
ldi r17, 0b00000001
ldi r19, 0
rjmp main

init4:
cpi r18, 4
brne init5
ldi r17, 0b10101010
rjmp main

init5:
cpi r18, 5
brne init6
ldi r17, 0b00000001
rjmp main

init6:
cpi r18, 6
brne init7
ldi r17, 0b11111111
rjmp main

init7:
cpi r18, 7
brne init8
ldi r17, 0b10000001
rjmp main

init8:
ldi r17, 0b00011000
rjmp main

elegir_secuencia:
cpi r18, 1
brne elegir2
rjmp secuencia1

elegir2:
cpi r18, 2
brne elegir3
rjmp secuencia2

elegir3:
cpi r18, 3
brne elegir4
rjmp secuencia3

elegir4:
cpi r18, 4
brne elegir5
rjmp secuencia4

elegir5:
cpi r18, 5
brne elegir6
rjmp secuencia5

elegir6:
cpi r18, 6
brne elegir7
rjmp secuencia6

elegir7:
cpi r18, 7
brne elegir8
rjmp secuencia7

elegir8:
rjmp secuencia8

secuencia1:
out PORTD, r17
rcall retardo
lsl r17
brne fin_sec1
ldi r17, 0b00000001

fin_sec1:
rjmp main

secuencia2:
out PORTD, r17
rcall retardo
lsr r17
brne fin_sec2
ldi r17, 0b10000000

fin_sec2:
rjmp main

secuencia3:
out PORTD, r17
rcall retardo
cpi r19, 0
brne sec3_vuelta

sec3_ida:
cpi r17, 0b10000000
brne sec_mover_izq
ldi r19, 1
lsr r17
rjmp main

sec_mover_izq:
lsl r17
rjmp main

sec3_vuelta:
cpi r17, 0b00000001
brne sec3_mover_der
ldi r19, 0
lsl r17
rjmp main

sec3_mover_der:
lsr r17
rjmp main

secuencia4:
out PORTD, r17
rcall retardo
com r17
rjmp main

secuencia5:
out PORTD, r17
rcall retardo
cpi r17, 0b11111111
brne sec5_continuar
ldi r17, 0b00000001
rjmp main

sec5_continuar:
lsl r17
ori r17, 0b00000001
rjmp main

secuencia6:
out PORTD, r17
rcall retardo
lsr r17
brne fin_sec6
out PORTD, r17
rcall retardo
ldi r17, 0b11111111

fin_sec6:
rjmp main

secuencia7:
out PORTD, r17
rcall retardo
cpi r17, 0b10000001
brne sec7_paso2
ldi r17, 0b01000010
rjmp main

sec7_paso2:
cpi r17, 0b01000010
brne sec7_paso3
ldi r17, 0b00100100
rjmp main

sec7_paso3:
cpi r17, 0b00100100
brne sec7_reinicio
ldi r17, 0b00011000
rjmp main

sec7_reinicio:
ldi r17, 0b10000001
rjmp main

secuencia8:
    out PORTD, r17
    rcall retardo
    cpi r17, 0b00011000
    breq sec8_paso2
    cpi r17, 0b00100100
    breq sec8_paso3
    cpi r17, 0b01000010
    breq sec8_paso4
    ldi r17, 0b00011000
    rjmp main

sec8_paso2:
    ldi r17, 0b00100100
    rjmp main

sec8_paso3:
    ldi r17, 0b01000010
    rjmp main

sec8_paso4:
    ldi r17, 0b10000001
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