.include "m328pdef.inc"

.def contador = r16
.def temporal = r17
.def patron = r18


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
clr contador

PRINCIPAL:
rjmp PRINCIPAL