.include "Macros.asm"

.data
NewLine: .asciiz "\n"
Space: .asciiz  " "
Error: .asciiz  "error in file read"
.align 2
inFile: .space  64
inFilePrompt: .asciiz  "Please input the file name."

OrigD: .asciiz "Original Data:\n"
CompD: .asciiz "Compressed Data:\n"
DcompD: .asciiz "Decompressed Data:\n"
OrigFS: .asciiz "Original File Size:\n"
CompFS: .asciiz "Compressed File Size:\n"

.align 2
originalSize: .word 0
compressedSize: .word 0

.align 2
Buffer: .space  1024
ucBuffer: .space 1024

.text
#-----Main-----#
main:
#get input file name
promptString(inFilePrompt,inFile)
removeNL()

#open file and exit if not found
jal openFile
blt $v0, 0, error

#read file into buffer
jal readFile

#closes file
jal closeFile

#print contents of buffer
printString(OrigD)
printString(Buffer)
printString(NewLine)

#compress
li $v0, 9
li $a0, 1024
syscall
move $s1, $v0 #save heap address to $s1
jal compress

#print contents of buffer
printString(CompD)
jal printCompressed
printString(NewLine)

#decompress
move $a1, $s1
jal decompress

#print decompressed data
printString(DcompD)
printString(ucBuffer)
printString(NewLine)

#print number of bytes in each
printString(OrigFS)
printInt(originalSize)
printString(NewLine)

printString(CompFS)
printInt(compressedSize)
printString(NewLine)

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
    sw $v0, originalSize #stores size in bytes of read file
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

#compresses the buffer starting at $a1
compress:
    la $t0, Buffer
    move $t1, $s1
    
    li $t4, 1 #$t4 = 1
    compressLoop:
        lb $t2, 0($t0) #$t2 = current char
        lb $t3, 1($t0) #$t3 = next char
        
        bne $t2, $t3, onEnd
        
        addi $t4, $t4, 1 #count++
        addi $t0, $t0, 1 #point to next char in static buffer
    j compressLoop
    
    #runs on end of matching chars
    onEnd:
        sb $t2, 0($t1) #store byte ascii char
        sb $t4, 1($t1) #store byte count
        
        addi $t0, $t0, 1 #staticPointer++
        addi $t1, $t1, 2 #heap += 2
        
        li $t4, 1 #reset counter
        beq $t3, 0, exitCompressLoop #exit when nextchar == null
    j compressLoop
    
    exitCompressLoop:
    sub $t1, $t1, $s1 #saves size of compressed data
    sw $t1, compressedSize
jr $ra

printCompressed:
    move $a1, $s1
    #load character into $t1
    lb $t1, ($a1)
    #load count into $t2 (offset by 1 byte from char)
    lb $t2, 1($a1)
    printCompressedLoop:
        printCharReg($t1)
        printIntReg($t2)
        
        #next character
        addi $a1, $a1, 2
        
        #load character into $t1
        lb $t1, ($a1)
        #load count into $t2 (offset by 1 byte from char)
        lb $t2, 1($a1)
    bne $t1, 0 printCompressedLoop
jr $ra

#decompresses the buffer starting at $a1
decompress:
    la $a2, ucBuffer
    decompressLoop:
        #load character into $t1
        lb $t1, ($a1)
        #load count into $t2 (offset by 1 byte from char)
        lb $t2, 1($a1)

        #for count, sb char ($t3 is index)
        li $t3, 0 #i = 0
        dcCountLoop:
            sb $t1, ($a2)
            addi $t3, $t3 1 #i++
            addi $a2, $a2, 1
        blt $t3, $t2, dcCountLoop #i <= $t3
        
        #next character
        addi $a1, $a1, 2
    bne $t1, 0 decompressLoop
jr $ra

#error
error:
printString(Error)
#exit
exit:
li $v0, 10
syscall
