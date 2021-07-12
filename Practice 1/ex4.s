.data
yes: .asciiz "Multiple"
no: .asciiz "Not Multiple"
.text
.globl main
main:
li $t0 8
li $t1 2
rem $t2 $t0 $t1
beqz $t2 else
la $a1 no
b end
else:
la $a1 yes
end:

li $v0, 4      
move $a0, $a1
syscall
jr $ra 