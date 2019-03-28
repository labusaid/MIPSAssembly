.data
NewLine: .asciiz "\n"

MonthPrompt: .asciiz "Please enter the month 1-12, enter 0 to exit. "
InvalidMonth: .asciiz "Please enter a valid number."

OutputString: .asciiz "The number of days in this month is: "

ShortMonthNum: .word 28
NormalMonthNum: .word 30
LongMonthNum: .word 31

Month: .word 0

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

.text
main:


loop:
#Prompt for name
printString(MonthPrompt)
readInt(Month)

lw $t1, Month

#Switch (This could be done with fall throughs but that would be less efficient)
li $t2, 0
beq $t1, $t2, exit

li $t2, 4
beq $t1, $t2, NormalMonth
li $t2, 6
beq $t1, $t2, NormalMonth
li $t2, 9
beq $t1, $t2, NormalMonth
li $t2, 11
beq $t1, $t2, NormalMonth

li $t2, 1
beq $t1, $t2, LongMonth
li $t2, 3
beq $t1, $t2, LongMonth
li $t2, 5
beq $t1, $t2, LongMonth
li $t2, 7
beq $t1, $t2, LongMonth
li $t2, 8
beq $t1, $t2, LongMonth
li $t2, 10
beq $t1, $t2, LongMonth

li $t2, 2
beq $t1, $t2, ShortMonth

ShortMonth:
printString(OutputString)
printInt(ShortMonthNum)
printString(NewLine)
j loop

NormalMonth:
printString(OutputString)
printInt(NormalMonthNum)
printString(NewLine)
j loop

LongMonth:
printString(OutputString)
printInt(LongMonthNum)
printString(NewLine)
j loop

#exit
exit:
li $v0, 10
syscall