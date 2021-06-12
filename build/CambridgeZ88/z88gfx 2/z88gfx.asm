; 
; Copy a screen to the map
;
; The z88 map consists of an area of 256 8x8 pixels graphics
;
; The HIRES0 character set contains the bitmaps that are displayed
; in the map area. When the map is opened (using window()) these
; are automatically setup, so we can just right directly to the 
; map area.
;
; The HIRES0 (at base_graphics) each byte represents the following
; position on screen.
;
; (x,y)
; (0,0) row 0
; ...
; (0,0) row 7
; (0,1) row 0
; ...
; (0,7) row 7

SECTION code_user

PUBLIC _z88_copy_char_screen_to_map
PUBLIC _z88_copy_zx0_char_screen_to_map
PUBLIC _z88_copy_line_screen_to_map

EXTERN base_graphics    ; Populated by window() call
EXTERN swapgfxbk        ; Library routine that pages in the HIRES0 character set
EXTERN asm_dzx0_standard


; Copy a screen to the map - the screen is arranged optimally for
; the z88. In a character by character basis.
;
; This could be extended to support a dzx0 version of the source file
;
; void z88_copy_char_screen_to_map(void *data)
_z88_copy_char_screen_to_map:
    call    swapgfxbk
    pop     bc
    pop     hl       ; Screen data
    push    hl
    push    bc
    ld      de,(base_graphics)
    ld      bc,32 * 64
    ldir
    call    swapgfxbk
    ret

; Copy a zx0 compressed screen to the map - the screen is arranged optimally for
; the z88. In a character by character basis.
;
;
; void z88_copy_zx0_char_screen_to_map(void *data)
 
_z88_copy_zx0_char_screen_to_map:
    call    swapgfxbk
    pop     bc
    pop     hl       ; Screen data
    push    hl
    push    bc
    ld      de,(base_graphics)
    call    asm_dzx0_standard
    call    swapgfxbk
    ret

; Copy a screen to the map - the screen is arranged line by line
;

; Copy a screen to the map - the screen is arranged line by line
;
; void z88_copy_line_screen_to_map(void *data)
_z88_copy_line_screen_to_map:
    call    swapgfxbk
    pop     bc
    pop     hl       ; Screen data
    push    hl
    push    bc
    call    copy_screen
    call    swapgfxbk
    ret

copy_screen:
    ld      de,(base_graphics)
    ld      c,8      ; 8 rows of characters
next_row:
    push    hl
    ld      b,32     ; 32 characters per row
next_char_in_row:
    push    bc
    push    hl
    ld      bc,32
    ld      a,8
inner_char_loop:
    ex      af,af
    ld      a,(hl)
    ld      (de),a
    inc     de
    add     hl,bc
    ex      af,af
    dec     a
    jp      nz,inner_char_loop
    pop     hl 
    inc     hl
    pop     bc
    djnz    next_char_in_row
    pop     hl
    inc     h         ;Go to next row in source
    dec     c
    jp      nz,next_row
    ret

