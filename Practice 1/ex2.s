.data

.text
.globl main
main:
li $t0 6
li $t1 7
li $t2 3
addu $t3 $t0 $t1
mul $t5 $t3 $t3

li $v0, 1       
move $a0, $t5
syscall
jr $ra 