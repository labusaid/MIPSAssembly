.include "Macros.asm"

.data
NewLine: .asciiz "\n"
Space: .asciiz  " "
Error: .asciiz  "error in file read"
.align 2
inFile: .space  64
inFilePrompt: .asciiz  "Please input the file name."

Buffer: .space  1024

.text
#-----Main-----#
main:
#get input file name
promptString(inFilePrompt,inFile)
removeNL()

#check if something was input
#la $t1, inFile
#la $t2, ($t1)
#beq $t2, $zero, exit

#open file and exit if not found
jal openFile
blt $v0, 0, error

#read file into buffer
jal readFile

#print contents of buffer
printString(Buffer)

#compress

#print contents of buffer

#decompress

#print number of bytes in each

j exit

#-----Functions-----#
#opens file
openFile:
    li   $v0, 13
    la  $a0, inFile
    li   $a1, 0 #flag for reading
    li   $a2, 0 #mode is ignored
    syscall
    move $s0, $v0 #save file descriptor 
jr $ra

#reads data into Buffer
readFile:
    li   $v0, 14
    move $a0, $s0 #file descriptor 
    la   $a1, Buffer #address of buffer
    li   $a2, 1024 #buffer length
    syscall
jr $ra

#closes file
closeFile:
    li $v0, 16
    move $a0, $s1
    syscall
jr $ra

#prints the buffer
printBuffer:
    la $a1, Buffer
    lw $a0, 0($a1)
    loop2:
    li $v0, 1
    syscall
    #loads next element of IntArr into $a0
    addi $a1, $a1, 4
    lw $a0, 0($a1)
    #exit loop if IntArr element is 0
    bnez $a0, loop2
jr $ra

#error
error:
printString(Error)
#exit
exit:
li $v0, 10
syscall
