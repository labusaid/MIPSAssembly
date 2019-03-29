.data
NewLine: .asciiz "\n"

Error: .asciiz  "No data was found in input file"

inFile: "input.txt"

IntBuffer: .space  80
IntArr: .word 

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
main:
jal readFile
#exit if num of bytes read <= 0
ble $v0, 0, error

j exit

readFile:
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

#return num of bytes in $v0

jr $ra


#error
error:
printString(Error)
#exit
exit:
li $v0, 10
syscall