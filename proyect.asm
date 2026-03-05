.data
px: .word 128
py: .word 64

.text
main:
    li      $v0, 100        ; Start engine
    syscall

loop:
    li      $a0, 0x000000   ; Clear black
    li      $v0, 103
    syscall

    la      $t0, px
    lw      $a0, 0($t0)     ; current x
    la      $t0, py
    lw      $a1, 0($t0)     ; current y
    li      $a2, 30         ; width
    li      $a3, 15         ; height
    li      $t1, 0xFF0000   ; red
    
    addi    $sp, $sp, -4
    sw      $t1, 0($sp)     ; 5th arg
    jal     rect
    addi    $sp, $sp, 4

    li      $v0, 102        ; Refresh
    syscall

    li      $v0, 104        ; Get key
    syscall
    move    $t0, $v0
    li      $t1, 1
    beq     $t0, $t1, up
    li      $t1, 2
    beq     $t0, $t1, down
    li      $t1, 3
    beq     $t0, $t1, left
    li      $t1, 4
    beq     $t0, $t1, right
    li      $t1, 5
    beq     $t0, $t1, salir
    j       loop

up:
    la      $t0, py
    lw      $t1, 0($t0)
    addi    $t1, $t1, -1
    sw      $t1, 0($t0)
    j       loop
down:
    la      $t0, py
    lw      $t1, 0($t0)
    addi    $t1, $t1, 1
    sw      $t1, 0($t0)
    j       loop
left:
    la      $t0, px
    lw      $t1, 0($t0)
    addi    $t1, $t1, -1
    sw      $t1, 0($t0)
    j       loop
right:
    la      $t0, px
    lw      $t1, 0($t0)
    addi    $t1, $t1, 1
    sw      $t1, 0($t0)
    j       loop

salir:
    li      $v0, 105        ; Exit graphics
    syscall
    

rect: ; a0:x, a1:y, a2:w, a3:h, 0($sp):color
    addi    $sp, $sp, -32
    sw      $ra, 28($sp)
    sw      $s0, 0($sp)
    sw      $s1, 4($sp)
    sw      $s2, 8($sp)
    sw      $s3, 12($sp)
    sw      $s4, 16($sp)
    sw      $s5, 20($sp)
    sw      $s6, 24($sp)

    move    $s0, $a0        ; x1
    move    $s1, $a1        ; y1
    add     $s2, $a0, $a2   ; x2
    add     $s3, $a1, $a3   ; y2
    lw      $s4, 32($sp)    ; color
    
    move    $s5, $s1        ; cy
ly: slt     $t0, $s5, $s3
    beq     $t0, $zero, re
    move    $s6, $s0        ; cx
lx: slt     $t0, $s6, $s2
    beq     $t0, $zero, next_y
    
    beq     $s5, $s1, draw    ; top
    addi    $t1, $s3, -1
    beq     $s5, $t1, draw    ; bot
    beq     $s6, $s0, draw    ; left
    addi    $t1, $s2, -1
    beq     $s6, $t1, draw    ; right
    j       salt
draw: li      $v0, 101
    move    $a0, $s6
    move    $a1, $s5
    move    $a2, $s4
    syscall
salt: addi    $s6, $s6, 1
    j       lx
next_y: addi    $s5, $s5, 1
    j       ly
re: lw      $s0, 0($sp)
    lw      $s1, 4($sp)
    lw      $s2, 8($sp)
    lw      $s3, 12($sp)
    lw      $s4, 16($sp)
    lw      $s5, 20($sp)
    lw      $s6, 24($sp)
    lw      $ra, 28($sp)
    addi    $sp, $sp, 32
    jr      $ra