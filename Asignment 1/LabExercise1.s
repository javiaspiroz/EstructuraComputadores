.data
	WordSearch: .byte 'H', 'E', 'l', 'l', 'O', 'k', 'N', 'X',      
					.byte	'a', 'g', 'h', 'k', 'k', 'm','e', 'E',           
					.byte	'B', 'x', 'E', 'L', 'C', 'c', 'C', 'D',             
					.byte	'O', 'O', 'L', 'O', 'L', 'L', 'E', 'H',      
					.byte	'L', 'L', 'L', 's', 'I', 'O', 'u', 'K',      
					.byte	'L', 'B', 'O', 'Y', 'U', 'J', 'X', 'O',      
					.byte	'E', 'H', 'E', 'L', 'L', 'O', 'H', 'i',      
					.byte	'H', 'J', 'K', 'J', 'T', 'F', 'J', 'c'  
	Word: .asciiz "Hello"
	N: .word 8 #dimension of the word search
	
.text
	.globl main
	main:
		subu $sp $sp 4
		sw $ra ($sp)
		la $a0 WordSearch
		la $a1 Word
		lw $a2 N
		jal SearchWords
		move $a0 $v0
		li $v0 1
		syscall
		lw $ra ($sp)
		addu $sp $sp 4
		jr $ra
		
	SearchWords:
		subu $sp $sp 4
		sw $ra ($sp)
		move $s0 $a0 #to visit the matrix adding one to this value
		li $s1 0 #i
		lb $s3 ($a1) #first char of the word
		li $s7 0 #result
		loop1: 
			beq $s1 $a2 end1
			li $s2 0 #j
		loop2: 
			beq $s2 $a2 end2
			lb $s4 ($s0) #current char of the matrix
			addi $s5 $a2 -1 #dimension-1 to check for the edges of the matrix
			li $s6 96
			bgt $s3 $s6 toUpper #if the first char is in upper case or lower case
				li $s6 32
				add $s6 $s6 $s3
				b compare
			toUpper:
				li $s6 -32
				add $s6 $s6 $s3
			compare:
			beq $s4 $s3 then
			beq $s4 $s6 then
			b endIf
			then:
			#we first check if the word is of length 1, checking if the next char is 0
			lb $s6 1($a1)
			beqz $s6 length1
			#if not, we have to look for the rest of the string in the four possible directions
			move $a3 $s1 #to pass i as an argument, j will be passed using the stack before each calling
			#check for exceptions in position where we can't call any of the auxiliary subrutines
			beqz $s1 upperRow
			beq $s1 $s5 bottomRow
			beqz $s2 firstColumn
			beq $s2 $s5 lastColumn
			#if we have reached here there are no more exceptions so we call the four auxiliary subrutines
			subu $sp $sp 4
			sw $s2 ($sp) #to pass j as an argument
			jal SearchRight
			add $s7 $s7 $v0
			subu $sp $sp 4
			sw $s2 ($sp) #to pass j as an argument
			jal SearchLeft
			add $s7 $s7 $v0
			subu $sp $sp 4
			sw $s2 ($sp) #to pass j as an argument
			jal SearchUp
			add $s7 $s7 $v0
			subu $sp $sp 4
			sw $s2 ($sp) #to pass j as an argument
			jal SearchDown
			add $s7 $s7 $v0
			b endIf
			upperRow: 
				beqz $s2 upperLeftCorner
				beq $s2 $s5 upperRightCorner
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchRight
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchLeft
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchDown
				add $s7 $s7 $v0
				b endIf
			bottomRow:
				beqz $s2 bottomLeftCorner
				beq $s2 $s5 bottomRightCorner
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchRight
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchLeft
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchUp
				add $s7 $s7 $v0
				b endIf
			firstColumn:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchRight
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchUp
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchDown
				add $s7 $s7 $v0
				b endIf
			lastColumn:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchLeft
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchUp
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchDown
				add $s7 $s7 $v0
				b endIf
			upperLeftCorner:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchRight
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchDown
				add $s7 $s7 $v0
				b endIf
			upperRightCorner:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchLeft
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchDown
				add $s7 $s7 $v0
				b endIf
			bottomLeftCorner:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchRight
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchUp
				add $s7 $s7 $v0
				b endIf
			bottomRightCorner:
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchLeft
				add $s7 $s7 $v0
				subu $sp $sp 4
				sw $s2 ($sp) #to pass j as an argument
				jal SearchUp
				add $s7 $s7 $v0
				b endIf
			length1: #we have found the character, so we add 1 to the result
				addi $s7 $s7 1
			endIf:
				addi $s0 $s0 1 #next position in the matrix
				addi $s2 $s2 1 #j++
				b loop2
		end2:
			addi $s1 $s1 1 #i++
			b loop1
		end1:
			move $v0 $s7
			lw $ra ($sp)
			addu $sp $sp 4
			jr $ra
			
	SearchRight:
		lw $t0 ($sp) #column
		addu $sp $sp 4
		addi $t0 $t0 1 #to look to the right we start from the next column
		addi $t1 $a1 1 #we start looking from the second character
		loopRight: 
			lb $t2 ($t1)
			beqz $t2 foundR #if we reached the end of the string then we found it
			beq $t0 $a2 notFoundR #if we reach the end of the row we didn't find it.
			#get the adress for the char
			mul $t3 $a3 $a2 #row*dimension
			addu $t3 $t3 $t0 #add the column
			addu $t3 $t3 $a0 #add initial adress
			lb $t3 ($t3)
			li $t4 96
			bgt $t2 $t4 toUpperR
				li $t4 32
				add $t4 $t4 $t2
				b compareR
			toUpperR:
				li $t4 -32
				add $t4 $t4 $t2
			compareR:
			beq $t3 $t2 thenR
			beq $t3 $t4 thenR
			b notFoundR
			thenR:
			#if they are equal we continue looking for the next char in the string
			addi $t1 $t1 1
			addi $t0 $t0 1 #we go to the next column
			b loopRight
		notFoundR: li $v0 0 #if we didn't find the string we return 0
			b endRight
		foundR: li $v0 1 #1 if we found it
		endRight: jr $ra
		
	SearchLeft:
		lw $t0 ($sp) #column
		addu $sp $sp 4
		addi $t0 $t0 -1 #to look to the left we start from the previous column
		addi $t1 $a1 1 #we start looking from the second character
		loopLeft: 
			lb $t2 ($t1)
			beqz $t2 foundL #if we reached the end of the string then we found it
			bltz $t0 notFoundL #if we go past the first column we didn't find the string
			#get the adress for the char
			mul $t3 $a3 $a2 #row*dimension
			addu $t3 $t3 $t0 #add the column
			addu $t3 $t3 $a0 #add initial adress
			lb $t3 ($t3)
			li $t4 96
			bgt $t2 $t4 toUpperL
				li $t4 32
				add $t4 $t4 $t2
				b compareL
			toUpperL:
				li $t4 -32
				add $t4 $t4 $t2
			compareL:
			beq $t3 $t2 thenL
			beq $t3 $t4 thenL
			b notFoundL
			thenL:
			#if they are equal we continue looking for the next char in the string
			addi $t1 $t1 1
			addi $t0 $t0 -1 #we go to the previous column
			b loopLeft
		notFoundL: li $v0 0 #if we didn't find the string we return 0
			b endLeft
		foundL: li $v0 1 #1 if we found it
		endLeft: jr $ra
		
	SearchUp:
		lw $t0 ($sp) #column
		addu $sp $sp 4
		addi $t1 $a3 -1 #to look upwards we start from the previous row
		addi $t2 $a1 1 #we start looking from the second character
		loopUp: 
			lb $t3 ($t2)
			beqz $t3 foundU #if we reached the end of the string then we found it
			bltz $t1 notFoundU #if we go past the first row we didn't find the string
			#get the adress for the char
			mul $t4 $t1 $a2 #row*dimension
			addu $t4 $t4 $t0 #add the column
			addu $t4 $t4 $a0 #add initial adress
			lb $t4 ($t4)
			li $t5 96
			bgt $t3 $t5 toUpperU
				li $t5 32
				add $t5 $t5 $t3
				b compareU
			toUpperU:
				li $t5 -32
				add $t5 $t5 $t3
			compareU:
			beq $t4 $t3 thenU
			beq $t4 $t5 thenU
			b notFoundU
			thenU:
			#if they are equal we continue looking for the next char in the string
			addi $t2 $t2 1
			addi $t1 $t1 -1 #we go to the previous row
			b loopUp
		notFoundU: li $v0 0 #if we didn't find the string we return 0
			b endUp
		foundU: li $v0 1 #1 if we found it
		endUp: jr $ra
		
	SearchDown:
		lw $t0 ($sp) #column
		addu $sp $sp 4
		addi $t1 $a3 1 #to look upwards we start from the next row
		addi $t2 $a1 1 #we start looking from the second character
		loopDown: 
			lb $t3 ($t2)
			beqz $t3 foundD #if we reached the end of the string then we found it
			beq $t1 $a2 notFoundD #if we go past the first row we didn't find the string
			#get the adress for the char
			mul $t4 $t1 $a2 #row*dimension
			addu $t4 $t4 $t0 #add the column
			addu $t4 $t4 $a0 #add initial adress
			lb $t4 ($t4)
			li $t5 96
			bgt $t3 $t5 toUpperD
				li $t5 32
				add $t5 $t5 $t3
				b compareD
			toUpperD:
				li $t5 -32
				add $t5 $t5 $t3
			compareD:
			beq $t4 $t3 thenD
			beq $t4 $t5 thenD
			b notFoundD
			thenD:
			#if they are equal we continue looking for the next char in the string
			addi $t2 $t2 1
			addi $t1 $t1 1 #we go to the next row
			b loopDown
		notFoundD: li $v0 0 #if we didn't find the string we return 0
			b endDown
		foundD: li $v0 1 #1 if we found it
		endDown: jr $ra
		