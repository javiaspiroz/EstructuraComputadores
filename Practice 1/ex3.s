.data

.text
.globl main
main:
li $t0 0
li $t1 100

loop:
bge $t0 $t1 end
addi $t0 $t0 1
addu $t2 $t2 $t0

b loop
end:


li $v0, 1       
move $a0, $t2
syscall
jr $ra 