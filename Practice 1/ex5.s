.data
	N: .word 8
	msg1: .asciiz "\n"
	msg2: .asciiz " "

.text
.globl main
main:
	lw $a1 N
	la $a2 msg2
	la $a3 msg1
	li $s0 1
	
loop1:
	bgt $s0 $a1 end1
	li $s1 1
loop2:
	bgt $s1 $s0 end2
	li $v0, 1     
	move $a0, $s1
	syscall
	li $v0 4
	move $a0 $a2
	syscall
	addi $s1 $s1 1
	b loop2
end2:
	li $v0 4
	move $a0 $a3
	syscall
	addi $s0 $s0 1
	b loop1
end1:
	jr $ra
	
