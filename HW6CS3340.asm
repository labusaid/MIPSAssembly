.data
NewLine: .asciiz "\n"
Space: .asciiz " "
Zero: .word 0
Error: .asciiz  "No data was found in input file"
Temp1: .word 0
Temp2: .word 0

inFile: .asciiz "input.txt"
PrintBefore: .asciiz "The array before: "
PrintAfter: .asciiz "The array after: "
PrintMean: .asciiz "The mean is: "
PrintMedian: .asciiz "The median is: "
PrintSD: .asciiz "The standard deviation is: "

Mean: .float 0
Median: .word 0
SD: .word 0
IntBuffer: .space  80
#TODO: Remove test array
     .align 2
IntArr: .space 80

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

.macro printFloat (%float)
li $v0, 2
l.s $f12, %float
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
#TODO: Fix file opening and reading (idk what's wrong with it)
jal openFile
jal fillArr

#exit if num of bytes read <= 0
ble $v0, 0, error

printString(PrintBefore)
jal printArr
printString(NewLine)

#TODO: Fix infinite loop in selection sort
#jal selectionSortArr
printString(PrintAfter)
jal printArr
printString(NewLine)

printString(PrintMean)
#TODO: Fix calcMean
jal calcMean
printFloat(Mean)
printString(NewLine)

printString(PrintMedian)
jal calcMedian
printInt(Median)
printString(NewLine)

printString(PrintSD)
jal calcSD
printFloat(SD)
printString(NewLine)

j exit

#-----Functions-----#
#Opens file and reads data into IntBuffer
openFile:
    li   $v0, 13
    la   $a0, inFile
    li   $a1, 0 #flag for reading
    li   $a2, 0 #mode is ignored
    syscall
    move $s0, $v0 #save file descriptor 
    
    li   $v0, 14
    move $a0, $s0 #file descriptor 
    la   $a1, IntBuffer #address of buffer
    li   $a2, 80 #buffer length
    syscall

jr $ra

#Extracts integers from IntBuffer and inserts them into IntArr
fillArr:
    la $a0, IntBuffer
    li $t1, 48
    li $t2, 57
    la $a1, IntArr
    loop1:
        #load character
        addi $a0, $a0, 8
        lb $t0, ($a0)
        #test character
        beqz $t0, endLoop1 #break on $t0 == 0
        blt $t0, $t1, loop1
        bgt $t0, $t2, loop1
        subi $t0, $t0, 48
        sw $t0, ($a1)
        addi $a1, $a1, 4
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

    bnez $t0, loop3 #exit loop if selected element is 0
jr $ra

#Calculates mean of IntArr
calcMean:
    la $a1, IntArr
    lw $t0, 0($a1)
    li $t1, 0
    li $t2, 0
    #$t0 is the array int, $t1 is the total, $t2 is the num of items in the array
    loop4:
	add $t1, $t1, $t0
        addi $a1, $a1, 4
        lw $t0, 0($a1)
        addi $t2, $t2, 1
    bnez $t0, loop4 #exit loop if element is 0
    
    #using even registers for simplicity (could be changed to doubles easier)
    sw $t1, Temp1
    sw $t2, Temp2
    lwc1 $f0, Temp1
    lwc1 $f2, Temp2
    cvt.s.w $f0, $f0
    cvt.s.w $f2, $f2
    div.s $f4, $f0, $f2
    s.s $f4, Mean
jr $ra

#Calculates median of IntArr
calcMedian:
    #assumes list is already sorted
    la $a1, IntArr
    lw $t0, 0($a1)
    li $t2, 0
    #count num of items in loop
    loop5:
        addi $a1, $a1, 4
        lw $t0, 0($a1)
        addi $t2, $t2, 1
    bnez $t0, loop5 #exit loop if element is 0
    div $t1, $t2, 2
    mul $t1, $t1, 4
    la $a1, IntArr
    add $a1, $a1, $t1
    lw $t3, 0($a1)
    sw $t3, Median
jr $ra

#Calculates standardDeviation of IntArr
calcSD:
    #load first element and clear registers
    la $a1, IntArr
    lw $t0, 0($a1)
    li $t1, 0
    li $t2, 0
    lwc1 $f0, Zero
    lwc1 $f2, Zero
    lwc1 $f4, Zero
    
    #$t0 is the array int, $t2 is the num of items in the array
    loop6:
    	#loads next element
        addi $a1, $a1, 4
        lw $t0, 0($a1)
        addi $t2, $t2, 1 #counts elements in array
        
        #convert element to float
        mtc1 $t0, $f2
        cvt.s.w $f2, $f2
        
        #calculations
        sub.s $f2, $f2, $f4 #subtracted mean from element
        mul.s $f2, $f2, $f2 #squared $f2
        add.s $f0, $f0, $f2 #added $f1
        
    bnez $t0, loop6 #exit loop if element is 0
    
    #convert num of elements into float
    mtc1 $t2, $f8
    cvt.s.w $f8, $f8
    
    #final calculations
    div.s $f6, $f0, $f8
    sqrt.s $f10, $f6
    
    s.s $f10, SD

jr $ra

#error
error:
printString(Error)
#exit
exit:
li $v0, 10
syscall
