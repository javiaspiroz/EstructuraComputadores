.data
	WordSearch: .byte 'H', 'E', 'l', 'l', 'O', 'k', 'N', 'X',      
					.byte	'a', 'g', 'h', 'k', 'k', 'm','e', 'E',           
					.byte	'B', 'x', 'E', 'L', 'C', 'c', 'C', 'D',             
					.byte	'O', 'O', 'L'. 'O', 'L', 'L', 'E', 'H',      
					.byte	'L', 'L', 'L', 's', 'I', 'O', 'u', 'K',      
					.byte	'L', 'B', 'O', 'Y', 'U', 'J', 'X', 'O',      
					.byte	'E', 'H', 'E', 'L', 'L', 'O', 'H', 'i',      
					.byte	'H', 'J', 'K', 'J', 'T', 'F', 'J', 'c'    
		 Word: .asciiz   "Hello"   
	N: .word  8

.text
.globl main

	main:
			la $a0 WordSearch
			la $a1 Word
			lw $a2 N
			jal SearchWords
			li $v0 1
			move $a0 $v0			
			syscall

	SearchWords:
			lbu $t0 ($a0) ;#load the first char of the matrix
			lbu $t1 ($a1) ;#load the first char of the word
			move $t2 $a0 ;#copy the actual position of the matrix
			li $t3 0 ;#x position counter
			li $t4 0 ;#y position counter
			move $t5 $a1 ;#copy the actual position of the word
			li $a3 0 ;#char counter

	loop0:	beqz $t5 b0 ;#loop to search for the null pointer of the word
			lbu $s2 ($t5)
			addi $t5 $t5 1 ;#increase actual position of the word
			addi $a3 $a3 1 ;#increase char counter
			b loop0
	b0:		li $t7 0 ;#coincidences founded

	loop1:	beq $t1 $t0 b2 ;#check if they are equal
			addiu $t3 $t3 1 ;#increase x position counter
			addiu $t2 $t2 1 ;#increase address (next char of the array)
			blt $t3 $a2 b1 ;#check x position to know if y position has to be increased
			li $t3 0 ;
			addi $t4 $t4 1 ;#increase y position counter
	b1:		blt $t4 $a2 loop1
			b end

			#Right
	b2:		subu $sp $sp 20 ;#save the register data in the stack
			sw $a0 ($sp)
			sw $a1 4($sp)
			sw $a2 8($sp)
			sw $a3 12($sp)
			sw $ra 16($sp)
			jal SearchRight
			move $t8 $v0
			add $t7 $t7 $t8 ;#add the new coincidences founded to the counter of all the coincidences
			lw $a0 ($sp) ;#restore the values stored in the stack
			lw $a1 4($sp)
			lw $a2 8($sp)
			lw $a3 12($sp)
			lw $ra 16($sp)
			addiu $sp $sp 20 ;#save the register data in the stack

			#Left
			subu $sp $sp 20 ;#save the register data in the stack
			sw $a0 ($sp)
			sw $a1 4($sp)
			sw $a2 8($sp)
			sw $a3 12($sp)
			sw $ra 16($sp)
			jal SearchLeft
			move $t8 $v0
			add $t7 $t7 $t8 ;#add the new coincidences founded to the counter of all the coincidences
			lw $a0 ($sp) ;#restore the values stored in the stack
			lw $a1 4($sp)
			lw $a2 8($sp)
			lw $a3 12($sp)
			lw $ra 16($sp)
			addu $sp $sp 20 ;#save the register data in the stack

			#Top
			subu $sp $sp 20 ;#save the register data in the stack
			sw $a0 ($sp)
			sw $a1 4($sp)
			sw $a2 8($sp)
			sw $a3 12($sp)
			sw $ra 16($sp)
			jal SearchTop
			move $t8 $v0
			add $t7 $t7 $t8 ;#add the new coincidences founded to the counter of all the coincidences
			lw $a0 ($sp) ;#restore the values stored in the stack
			lw $a1 4($sp)
			lw $a2 8($sp)
			lw $a3 12($sp)
			lw $ra 16($sp)
			addu $sp $sp 20 ;#save the register data in the stack

			#Bottom
			subu $sp $sp 20 ;#save the register data in the stack
			sw $a0 ($sp)
			sw $a1 4($sp)
			sw $a2 8($sp)
			sw $a3 12($sp)
			sw $ra 16($sp)
			jal SearchBottom
			move $t8 $v0
			add $t7 $t7 $t8 ;#add the new coincidences founded to the counter of all the coincidences
			lw $a0 ($sp) ;#restore the values stored in the stack
			lw $a1 4($sp)
			lw $a2 8($sp)
			lw $a3 12($sp)
			lw $ra 16($sp)
			addu $sp $sp 20 ;#save the register data in the stack

			b loop1

	end:	move $v0 $t7
			jr $ra

	SearchRight:
			li $t0 0 ;#counter of equal chars read
			li $v0 0 ;#counter of coincidences
	loopR:	addu $a0 $a0 1 ;#right position of the matrix
			lbu $s0 ($a0)
			addu $a1 $a1 1 ;#next position of the word
			lbu $s1 ($a1)
			bne $s1 $s0 endR ;#check if the chars are not equal
			addi $t0 $t0 1 ;#if they are equal, increase the # of equal chars read
			bne $t0 $a3 loopR ;#check if it has read the number characters of the word searched
			addi $v0 $v0 1 ;#if yes, the number of coincidences increases by 1
	endR:	jr $ra

	SearchLeft:
			li $t0 0 ;#counter of equal chars read
			li $v0 0 ;#counter of coincidences
	loopL:	subu $a0 $a0 1 ;#left position of the matrix
			lbu $s0 ($a0)
			addu $a1 $a1 1 ;#next position of the word
			lbu $s1 ($a1)
			bne $s1 $s0 endL ;#check if the chars are not equal
			addi $t0 $t0 1 ;#if they are equal, increase the # of equal chars read
			bne $t0 $a3 loopL ;#check if it has read the number characters of the word searched
			addi $v0 $v0 1 ;#if yes, the number of coincidences increases by 1
	endL:	jr $ra

	SearchTop:
			li $t0 0 ;#counter of equal chars read
			li $v0 0 ;#counter of coincidences
	loopT:	subu $a0 $a0 $a2 ;#top position of the matrix
			lbu $s0 ($a0)
			addu $a1 $a1 1 ;#next position of the word
			lbu $s1 ($a1)
			bne $s1 $s0 endT ;#check if the chars are not equal
			addi $t0 $t0 1 ;#if they are equal, increase the # of equal chars read
			bne $t0 $a3 loopT ;#check if it has read the number characters of the word searched
			addi $v0 $v0 1 ;#if yes, the number of coincidences increases by 1
	endT:	jr $ra

	SearchBottom:
			li $t0 0 ;#counter of equal chars read
			li $v0 0 ;#counter of coincidences
	loopB:	addu $a0 $a0 $a2 ;#bottom position of the matrix
			lbu $s0 ($a0)
			addu $a1 $a1 1 ;#next position of the word
			lbu $s1 ($a1)
			bne $s1 $s0 endB ;#check if the chars are not equal
			addi $t0 $t0 1 ;#if they are equal, increase the # of equal chars read
			bne $t0 $a3 loopB ;#check if it has read the number characters of the word searched
			addi $v0 $v0 1 ;#if yes, the number of coincidences increases by 1
	endB:	jr $ra
