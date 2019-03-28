.data
a: .word 0
b: .word 0
c: .word 0

out1: .word 0
out2: .word 0
out3: .word 0

name: .asciiz "not found"

namePrompt: .asciiz "Enter your name: "
intPrompt: .asciiz "Enter an integer between 1-100: "
outMessage: .asciiz "Your answers are: "
space: .asciiz " "

.text
main:
#Prompt for name
la $a0,namePrompt
li $v0,4
syscall

#Recieve name
la $a0,name
la $a1,name
li $v0, 8
syscall

#Prompt for an integers a,b,c
#a
la $a0,intPrompt
li $v0,4
syscall
la $a0,a
la $a1,a
li $v0, 5
syscall
sw $v0, a
#b
la $a0,intPrompt
li $v0,4
syscall
la $a0,b
la $a1,b
li $v0, 5
syscall
sw $v0, b
#c
la $a0,intPrompt
li $v0,4
syscall
la $a0,b
la $a1,b
li $v0, 5
syscall
sw $v0, c

#load inputs into registers
lw $t1,a
lw $t2,b
lw $t3,c

#Calculate out1 (2a-b+9)
add $t4,$t1,$t1
sub $t4,$t4,$t2
add $s1,$t4,9
sw $s1,out1

#Calculate out2 (c-b+(a-5))
sub $t4,$t1,5
add $t4,$t4,$t3
sub $s2,$t4,$t2
sw $s2,out2

#Calculate out3 ((a-3)+(b+3)-(c+7))
sub $t4,$t1,3
add $t4,$t4,$t2
add $t4,$t4,3
add $t5,$t3,7
sub $s3,$t4,$t5
sw $s3,out3

#Display user name
la $a0,name
li $v0,4
syscall

#Diplay results
li $v0,4
la $a0,outMessage
syscall

li $v0,1
la $a0,out1
syscall

li $v0,4
la $a0,space
syscall

li $v0,1
la $a0,out2
syscall

li $v0,4
la $a0,space
syscall

li $v0,1
la $a0,out3
syscall

#Exit
li $v0, 10
syscall

#I have no idea why it's printing the wrong values, the correct answers are in memory
#Enter your name: Lathe
#Enter an integer between 1-100: 1
#Enter an integer between 1-100: 2
#Enter an integer between 1-100: 3
#Lathe
#Your answers are: 268501004 268501008 268501012