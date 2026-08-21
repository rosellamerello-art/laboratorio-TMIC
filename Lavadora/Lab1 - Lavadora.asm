;.include "m328pdef.inc" ; Define device ATmega328P
.cseg
.org 0x0000

rjmp  Start
   rjmp reset

reset:
      ldi r16, HIGH(RAMEND)
      out sph, r16
      ldi r16, low(RAMEND)
      out spl, r16 
  
      ldi r16, 0b00011111
      out DDRB, r16
      ldi r16, 0b00000000
      out PORTB, r16
      
      ldi r16, 0b00000111
      out DDRC, r16
      ldi r16, 0b00000000
      out PORTC, r16
      
      ldi r16, 0b01000000
      out DDRD, r16
      ldi r16, 0b00001100
      out PORTD, r16
      
Loop:
      rjmp  Loop

delay_1ms:
      ldi r18, 21
d1ms_loop:
      ldi r17, 253
d1ms_loop2:
      dec r17
      brne d1ms_loop2
      dec r18
      brne d1ms_loop
      ret
      
delay_seg:
dseg_loop:
      ldi r19, 250
dseg_1000:
      rcall delay_1ms
      rcall delay_1ms
      rcall delay_1ms
      rcall delay_1ms
      dec r19
      brne dseg_1000
      dec r20
      brne dseg_loop
      ret
