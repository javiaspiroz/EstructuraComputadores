.data
WordSearch: .byte 'g','d', 's', 'a'
				.byte 'l','L', 'o', 's'
				.byte 'o','j', 'l', 'k'
				.byte 'S','f', 'n', 'd'
				
Word: .asciiz "sOl"
N: .word 4

    # dimension of the wordsearch 
		 

		 
.text
	.globl main
	
	
	main:
		sub $sp $sp 4 #stack to store the value of ra 
		sw $ra ($sp)
		la $a0 WordSearch #inputs
		la $a1 Word
		lw $a2 N
		jal SearchWords #call the function search word, that is returning the number of words found
		move $a0 $v0
		li $v0 1
		syscall
		lw $ra ($sp)
		addi $sp $sp 4
		jr $ra
	
	
	SearchWords:
			sub $sp $sp 32 #stack to store the value of ra 
			sw $ra 28($sp)
			sw $s0 24($sp)
			sw $s1 20($sp)
			sw $s2 16($sp)
			sw $s3 12($sp)
			sw $s4 8($sp)
			sw $s6 4($sp)
			sw $s7 ($sp)		
			
			li $s0 0 #number of words found, first set to 0
			li $s1 0 #i
			li $s2 0 #j
			li $s6 0 #counter of the elements of the MATRIX
			mul $s7 $a2 $a2 #64 (number of elements of the MATRIX)
			move $s4 $a0#Address of the MATRIX
			move $s3 $a1 #Address of the WORD
		travel_matrix: bge $s6 $s7 end_travel_matrix 
			lbu $a0 ($s3) #stores the letter of the WORD
			lbu $t2 ($s4) #stores the letter in the MATRIX	
			jal mayus_min #calls the function that check if it is mayus or min
			move $t0 $v0 #Mayus letter
			move $a0 $t2 #Change the input of the mayus_min
			jal mayus_min #now we are setting the letter of the matrix to mayus
			move $t2 $v0 #Move the output of the function to t2
		beq $t2 $t0 loop_right #When the letter of the array is equal to the letter of the word goes to run_right
			b next
			
			
loop_right:	addi $s1 $s1 1 #Increase by 1 the value of x
			bge $s1 $a2 loop_left #Check if you are out of the limit
			addi $s4 $s4 1 #Increase by one the address of the matrix to travel through it
			lbu $t2 ($s4) #Store the new value of that element of the matrix
			jal mayus_min
			move $t2 $v0
			addi $s3 $s3 1 #Increase by one the address of the word to compare the next byte
			lbu $a0 ($s3)#Store the new value of the byte of the word
			jal mayus_min
			move $a0 $v0 
			beqz $a0 right_found #WORD FOUND
		beq $t2 $a0 loop_right #Compare the new element of the matrix with the letter of the word
			b loop_left
			
right_found:addi $s0 $s0 1 #Increase by one the counter because we have found the word.
			move $s3 $a1 #Address of the WORD
			b loop_right
		
loop_left: # sub $s1 $s1 1 #Decrease the value of x
			bltz $s1 loop_down #Check if you are out of bounds
			sub $s4 $s4 1 #Decrease by one the value of the address of the matrix to travel through it on the left
			lbu $t2 ($s4) #load the new byte of that address
			jal mayus_min 
			move $t2 $v0 
			addi $s3 $s3 1 #Increase by one the address of the word to compare the next byte
			lbu $a0 ($s3)#Store the new value of the byte of the word
			jal mayus_min
			move $a0 $v0 
			beqz $a0 left_found #WORD FOUND!
		beq $t2 $a0 loop_left #Compare the new element of the matrix with the letter of the word
			b loop_down
			 
left_found: addi $s0 $s0 1 #Increase by one the counter if we have found a word on the left 
			move $s3 $a1
			b loop_left

loop_down: add $s1 $s1 $a2 #Add the size of the matrix to i
			bge $s1 $a2 loop_up #When the i is out of bounds
			add $s4 $s4 $a2 #Increase the value of the address to go to the next row
			lbu $t2 ($s4) #Load the new byte of the new address
			jal mayus_min
			move $t2 $v0
			addi $s3 $s3 1 #Increase by one the value of the address of the word
			lbu $a0 ($s3) #Load the new byte of the word
			jal mayus_min
			move $a0 $v0
			beqz $a0 down_found #When the byte has reach 0 the word is found
		beq $t2 $a0 loop_down #Compare the new element of the matrix with the letter of the word
			b loop_up
down_found: addi $s0 $s0 1 #Increase by one when the word has been found
			move $s3 $a1
			b loop_down
			
loop_up: 
			sub $s1 $s1 $a2 #Decrease the value of i to go up
			bltz $s1 next
			sub $s4 $s4 $a2 #Decrease the address of the matrix to go up
			lbu $t2 ($s4) #Load the new byte of that address
			jal mayus_min
			move $t2 $v0
			addi $s3 $s3 1 #Increase by one the value of the address of the word
			lbu $a0 ($s3) #Load the new byte of the word
			jal mayus_min
			move $a0 $v0 
			beqz $a0 up_found #When the byte has reach 0 the word is found
	
		beq $t2 $a0 loop_up #Compare the new element of the matrix with the letter of the word
			b next
up_found: addi $s0 $s0 1
			move $s3 $a1
			b loop_up
next:		
			addi $s4 $s4 1 #Go to the next letter of the matrix
			addi $s1 $s1 1 #Increase by one the i to move through the matrix
			addi $s6 $s6 1 #Increase the counter of element
			#bge $s6 $s7 end_travel_matrix
			bge $s1 $a2 out #When that happen the matrix is out of bounds 
			b travel_matrix
			out: 
			li $s1, 0 #Initialize again the value of i to 0
			addi $s2 $s2 1 #Increase the j by one to move
			b travel_matrix #Call again the loop travel_matrix
		
end_travel_matrix:
			move $v0 $s0
			lw $ra 28($sp)
			lw $s0 24($sp)
			lw $s1 20($sp)
			lw $s2 16($sp)
			lw $s3 12($sp)
			lw $s4 8($sp)
			lw $s6 4($sp)
			lw $s7 ($sp)
			addi $sp $sp 32
			jr $ra
		
mayus_min:	li $t0 97
			blt $a0 $t0 skip
			sub $v0 $a0 32
			
skip:
			
			move $v0 $a0
			jr $ra
			