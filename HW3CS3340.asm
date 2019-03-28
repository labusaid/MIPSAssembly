.data
NewLine: .asciiz "\n"

StringPrompt: .asciiz "Please input a string."
Words: .asciiz " words "
Characters: .asciiz " characters "
Goodbye: .asciiz "goodbye"

WordCount: .word 0
CharacterCount: .word 0
UserString: .asciiz

.text
main:
#Dialog syscall
li $v0,54
la $a0,StringPrompt
la $a1,UserString
la $a2,1000
syscall
#Exit program if cancel was clicked or there was no input
bne $a1,0,exit

#Call function charWordCount
la $a0,UserString
jal charWordCount

#Save returned values
sw $v0,CharacterCount
sw $v1,WordCount

#Outputs
	#Output UserString
	la $a0,UserString
	li $v0,4
	syscall
	#Ouput word count
	la $a0,WordCount
	lw $a0,0($a0)
	li $v0,1
	syscall
	#Output "words"
	la $a0,Words
	li $v0,4
	syscall
	#Output character count
	la $a0,CharacterCount
	lw $a0,0($a0)
	li $v0,1
	syscall
	#Output "characters"
	la $a0,Characters
	li $v0,4
	syscall

#loop
j main

exit:
la $a0,Goodbye
li $v0, 59
syscall
li $v0, 10
syscall

#charWordCount function
charWordCount:
	#save $s1 to stack
	addi $sp, $sp, -4
	sw $s1, 0($sp)
	
	move $t0,$a0
	#reset the counts to 0
	addi $t1,$0,0
	addi $s1,$0,0
	#Count characters
	loop:
		lb   $a0,0($t0)
		beqz $a0,done
  		addi $t0,$t0,1
    		addi $t1,$t1,1
    		
    		bne $a0,32,loop
    		addi $s1,$s1,1
    		
    		j loop
	done:
	#Save results to registers
	sub $t1,$t1,1
	addi $s1,$s1,1
	move $v0,$t1
	move $v1,$s1
	
	#Restore value and free up memory from stack
	lw $s1, 0($sp)
	addi $sp, $sp, 4
	
	#Return to main program
	jr $ra
