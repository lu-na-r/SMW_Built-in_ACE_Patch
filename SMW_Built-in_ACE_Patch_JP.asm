; SMW Built-in ACE Patch
; ver. 1.0.0


!CodeEditorOpenFlag = $79

; do not modify here
org $009356

db $0b 


; modifies break vector adderess so that BRK won't crash the game
; delete here if you want to run BRK on your SMW
; then, you must put $68 on your code so that the game won't crash
org $00ffe6

db $ee,$b9


; for BRK
org $00b9ee

pla
pla
pla
pla
rtl


; modifies bootstrap to expand intended RAM
org $00804c

jsl $03d693
nop #2


; expanded intended RAM (expanded bootstrap)
org $03d68e

db $22,$55,$e0,$03,$6b ; jsl $03e055, rtl

modifyIntendedRAM:
    ldx #$00
    expandIntendedRAM:
    lda $03d68e,x
    sta $7f8182,x 
    inx
    cpx #$05
    bne expandIntendedRAM

clearFlag:
    stz !CodeEditorOpenFlag

eraseCodeEditorArea:
    jsl eraseCodeLong
    rtl


; code to be run every frame
org $03e055

checkGM:
    lda $0100
    cmp #$0e
    beq checkCodeEditorOpenFlag
    cmp #$14
    bne returntoIntendedRAM

checkCodeEditorOpenFlag:
    lda !CodeEditorOpenFlag
    cmp #$01
    beq gotoCodeEditor

; check if R and L are being held
checkExecuteCommand:
    ldx $17
    cpx #$30
    bne checkOpenCommand
    lda $7f9d00
    beq returntoIntendedRAM
    bra executeArbitraryCode

; check if R and Select are being held
checkOpenCommand:
    ldx $17
    cpx #$10
    bne returntoIntendedRAM
    ldx $15
    cpx #$20
    beq openCodeEditor

returntoIntendedRAM:
    rtl

openCodeEditor:
    ; play sfx sound
    lda #$29
    sta $1dfc
    ; code editor open flag set
    inc !CodeEditorOpenFlag
    rtl

gotoCodeEditor:
    jsl codeEditor
    rtl

executeArbitraryCode:
    ; play sfx sound
    ; do not modify here (lda #$05; sta $1df9)
    lda #$05
    sta $1df9
    jsl $7f9d00
    rtl


; hex editor code by SethBling and Mally
; modefied by tomoha for Code Editor
org $0fef90

codeEditor:
    ; store $0100 to $f8. this is only used for a couple compare instructions
    lda #$01
    sta $f9		
    stz $f8

    ; code editor area $7f9d00 - $7f9dff
    rep #$20
    lda #$7f9d
    sta $fe
    sep #$20

checkSelect:
    ; check if Select is being pressed
    lda $15
    and #$20
    tax

    ; move cursor/page/bank with UDLR
    lda $fb
    ldy $16

checkRight:
    ; check if right is being pressed
    dey
    bne checkLeft
    inc a
    inc $de

checkLeft:
    ; check if left is being pressed
    dey
    bne checkDown
    dec a
    dec $de
    
checkDown:
    ; check if down is being pressed
    cpy #$02
    bne checkUp
    adc #$0f        ; carry is set, plus $0f
    dec $df
   
checkUp:
    ; check if up is being pressed
    cpy #$06
    bne noUp
    adc #$ef        ; carry is set, minus $0f
    inc $df
    
noUp:
    ; update the cursor if select isn’t being pressed
    sta $fb,x
    tay

    ; increment/decrement value at cursor
    lda [$fd],y

    ldx $18

checkR:
    ; check if R is being pressed
    cpx #$10
    beq incVal

checkL:
    ; check if L is being pressed
    cpx #$20
    bne checkLR
    dec a
    
checkLR:
    ; check of both L and R are being held
    ldx $17
    cpx #$30
    bne checkSX
    inc a
    inc a
    incVal:
    inc a

; check if X and Select are being held
checkSX:
    ldx $17
    cpx #$40
    bne checkSL
    ldx $15
    cpx #$60
    bne checkSL
    ldx #$20
    stx $1df9
    bra eraseCodeLong

; check if L and Select are being held
checkSL:
    ldx $17
    cpx #$20
    bne noClose
    ldx $15
    cpx #$20
    beq closeCodeEditor

noClose:
    sta [$fd],y

draw:
    ; set up stripe image loader
    rep #$30 ; 16-bit accumulator and index registers

    stz $24

    ; write 4-byte stripe image header
    lda #$a050
    sta $7f837d
    lda #$0009
    sta $3e
    lda #$ff03
    sta $7f837f

    xba         ; a becomes $03ff
    tax

    ldy #$00ff

    ; write all tiles to stripe data (400 bytes)
    
loop:
    lda [$fd],y

        pha
        jsr.w writeTile
        pla
        lsr a
        lsr a
        lsr a
        lsr a
        jsr.w writeTile

    dey
    bpl loop

    sep #$30 ; 8-bit accumulator and index registers

    tya
    sta $7f8781

returnSubroutine:
    rtl

writeTile:
    and #$000f		; draw hex digit
    ora #$3800		; tile properties
    cpy $fb		; check if highlighted by cursor
    bne noColor
    ora #$0400		; add color
    noColor:
    dex
    sta $7f8381,x	; write tile id and properties
    dex
    rts


eraseCodeLong:
    phx
    pha
    ldx #$00
  - lda #$00
    sta $7f9d00,x 
    txa 
    cmp #$ff
    inx
    bne - 
    pla
    plx
    rtl

closeCodeEditor:
    ; play sfx sound
    lda #$29
    sta $1dfc
    ; clear code editor open flag
    stz !CodeEditorOpenFlag

    ; thanks t.t for advising me this routine
    clearLayer3Long:
    rep #$30 ; 16-bit accumulator and index registers

    ; write 4-byte stripe image header
    lda #$a050
    sta $7f837d
    lda #$ff03
    sta $7f837f

    xba         ; a becomes $03ff
    tax

    lda #$38fc
  - dex
    sta $7f8381,x   ; write tile id and properties
    dex
    bpl -

    sep #$30 ; 8-bit accumulator and index registers
    txa
    sta $7f8781
    rtl
