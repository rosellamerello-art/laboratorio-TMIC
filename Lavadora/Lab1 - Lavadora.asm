.include "m328pdef.inc" ; Define device ATmega328P
.cseg
.org 0x0000

jmp reset

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
      
      ldi r16, 255
      mov r23, r16        
      rjmp main
main:
    rcall leer_seleccion
    cpi   r22, 1
    brne  m_check_inicio
    rcall actualizar_carga     

m_check_inicio:
    rcall leer_inicio
    cpi   r21, 1
    brne  main
    rcall verificar_listo
    cpi r26, 1
    brne main
    sbi   portb, portb0        
    rjmp  main
      
Leer_inicio:
      ldi r21, 0
      sbic pind, pind2
      rjmp li_fin
      
      ldi r20, 25
      rcall delay_ms_r20
      
      sbic pind, pind2
      rjmp li_fin
      
      ldi r21, 1
      
li_espera_suelta:
      sbis pind, pind2
      rjmp li_espera_suelta

li_fin:
      ret

Leer_seleccion:
      ldi r22, 0
      sbic pind, pind3
      rjmp ls_fin
      
      ldi r20, 25
      rcall delay_ms_r20
      
      sbic pind, pind3
      rjmp ls_fin
      
      ldi r22, 1
      
ls_espera_suelta:
      sbis pind, pind3
      rjmp ls_espera_suelta


ls_fin:
      ret

verificar_listo:
      in r16, pind
      andi r16, 0b00110000
      cpi r16, 0b00110000
      breq vl_ok
      ldi r26, 0
      ret
vl_ok:
      ldi r26, 1
      ret
      
actualizar_carga:
      inc r23
      cpi r23, 3
      brne ac_set_leds
      ldi   r23, 0
      
ac_set_leds:
      in r16, portc
      andi r16, 0b11111000
      out portc, r16
      
      in r16, portc
      cpi r23, 0
      breq ac_ligera
      cpi r23, 1
      breq ac_media
      cpi r23, 2
      ori r16, 0b00000100
      rjmp ac_done
ac_ligera:
      ori r16, 0b00000001
      rjmp ac_done
ac_media:
      ori r16, 0b00000010
      
ac_done:
      out portc, r16
      ret
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
      
delay_ms_r20:
      push r20
dr20_loop:
      rcall delay_1ms
      dec r20
      brne dr20_loop
      pop r20
      ret
