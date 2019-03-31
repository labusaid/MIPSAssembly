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
printString(NewLine)
jal selectionSortArr
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
    beqz $t0, endLoop1
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
    lw $a0, 0($a1)
    loop2:
    li $v0, 1
    syscall
    printString(Space)
    #loads next element of IntArr into $a0
    addi $a1, $a1, 4
    lw $a0, 0($a1)
    #exit loop if IntArr element is 0
    bnez $a0, loop2
jr $ra

#Selection sorts IntArr
selectionSortArr:
    la $a1, IntArr
    lw $t0, 0($a1)
    la $a2, IntArr
    lw $t1, 0($a1)
    la $a3, IntArr
    lw $t2, 0($a1)
    loop3:
        #selects next elements of IntArr
        addi $a1, $a1, 4
        lw $t0, 0($a1)
        move $a2, $a1
        lw $t1, 0($a2)
        addi $a3, $a1, 4
        lw $t2, 0($a3)
        
        #$t0 is selected element, $t1 is compared element; $a1 and $a2 are their respective addresses
        inLoop3:
            #what this really needs in a do while loop to clean up the code
            #load next element in $t1
            addi $a2, $a2, 4
            lw $t1, 0($a2)
            beqz $t1 skip3 #if($t1 < $t2 && $t1! = 0)
            bge $t1, $t2, skip3
                move $t2, $t1 #set #t2 to value of $t1
                move $a3, $a2 #set $a3 to address of $t1
            skip3:
        bnez $t1, inLoop3 #loop while $t1 != 0 (while not all elements have been compared)

        #swap selected element with min found
        sw $t0, 0($a3) #save $t0 to min address
        sw $t3, 0($a1) #save $t3 to selected address

        #debug
        li $v0, 1
        move $a0, $t0
        syscall
        printString(Space)

    bnez $t0, loop3 #exit loop if  selected element is 0
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
