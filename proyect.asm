
.data
   

.text


main:
   
   li      $v0, 100            
    syscall

    li      $a0, 0x000000       ; Color negro
    li      $v0, 103            
    syscall
    

    li      $a0, 128            ; Centro X
    li      $a1, 64             ; Centro Y
    li      $a2, 0xFF0000       ; Rojo
    li      $v0, 101
    syscall

    li      $v0, 102            
    syscall

    
loop:
    j loop