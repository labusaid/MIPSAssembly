.data
NewLine: .asciiz "\n"
Space: .asciiz " "
Error: .asciiz  "No data was found in input file"

inFile: "input.txt"

IntBuffer: .space  80
#TODO: Remove test array
IntArr: .word 18, 9, 27, 5, 48, 16, 2, 53, 64, 98, 49, 82, 7, 17, 53, 38, 65, 71, 24, 31, 0

#-----Macros-----#
.macro printInt (%int)
li $v0, 1
lw $a0, %int
syscall
.end_macro

.macro readInt (%int)
li $v0, 5
syscall
sw $v0, %int
.end_macro

.macro printString (%str)
li $v0, 4
la $a0, %str
syscall
.end_macro

.macro readString (%str)
li $v0, 8
li $a1, 20
la $a0, %str
syscall
.end_macro

.macro printDoubleReg (%doublereg)
li $v0, 3
mov.d $f12, %doublereg
syscall
.end_macro

.text
#-----Main Loop-----#
main:
#TODO: Fix file opening and reading
#jal openFile
#jal fillArr
#exit if num of bytes read <= 0
#ble $v0, 0, error
jal printArr

j exit

#-----Functions-----#
#Opens file and reads data into IntBuffer
openFile:
li   $v0, 13
la   $a0, inFile
la $a1, 0
syscall
#$s1 = File Descriptor
move $s1, $v0
li $v0, 14
la $a1, IntBuffer
syscall
#set $a0 to address of filename
move $a0, $s1
jr $ra

#Extracts integers from IntBuffer and inserts them into IntArr
fillArr:
la $a0, ($s1)
li $t1, 48
li $t2, 57
la $a1, IntArr
loop1:
#load character
addi $a0, $a0, 8
lb $t0, ($a0)
#test character
beq $t0, $zero, endLoop1
blt $t0, $t1, loop1
bgt $t0, $t2, loop1
sw $t0, ($a1)
addi $a1, $a1, 1
j loop1
endLoop1:
jr $ra

#Prints all ints in IntArr
printArr:
la $a1, IntArr
loop2:
li $v0, 1
lw $a0, 0($a1)
syscall
addi $a1, $a1, 4
printString(Space)
lw $a0, 0($a1)
bnez $a0, loop2
endLoop2:
jr $ra

#Selection sorts IntArr
selectionSortArr:

jr $ra

#Calculates mean of IntArr
calcMean:

jr $ra

#Calculates median of IntArr
calcMedian:

jr $ra

#Calculates standardDeviation of IntArr
calcSD:

jr $ra

#error
error:
printString(Error)
#exit
exit:
li $v0, 10
syscall
