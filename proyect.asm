.data

.text
main:
    li      $v0, 100        ; Start engine
    syscall

loop:
    li      $a0, 0x000000   ; Clear black
    li      $v0, 103
    syscall

    li      $a0, 128        ; Draw pixel
    li      $a1, 64
    li      $a2, 0xFF0000
    li      $v0, 101
    syscall

    li      $v0, 102        ; Refresh
    syscall

    li      $v0, 104        ; Get key
    syscall

    li      $t0, 5          ; Space = 5
    beq     $v0, $t0, salir ; Check v0 only

    j       loop

salir:
    li      $v0, 105        ; Exit graphics
    syscall

    li      $v0, 10         ; Exit program
    syscall