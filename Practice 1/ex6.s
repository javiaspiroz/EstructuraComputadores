.data
num1: .word 54587
num2: .word 7956
.text
.globl main
main:
lw $a0 num1
lw $a1 num2
bgt $a0 $a1 else
move $t2 $a1
b end
else:
move $t2 $a0
end:
li $v0, 1     
move $a0, $t2
syscall
jr $ra 
