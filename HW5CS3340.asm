.data
NewLine: .asciiz "\n"

NamePrompt: .asciiz "What is your name? "
HeightPrompt: .asciiz "Please enter your height in inches: "
WeightPrompt: .asciiz "Now enter your weight in pounds (round to a whole number): "

Height: .word 0
Weight: .word 0
Temp1: .word 0
Temp2: .word 0
#It took me almost 3 hours to figure out that not defining this as 0 meant that bmiuw became BMI
BMI: .double 0

bmiuw: .double 18.5
bminw: .double 25
bmiow: .double 30

BMIIs: .asciiz "Your bmi is: "
Underweight: .asciiz "This is considered underweight. \n"
Normalweight: .asciiz "This is a normal weight. \n"
Overweight: .asciiz "This is considered overweight. \n"
Obese: .asciiz "This is considered obese. \n"
UserName: .ascii

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
#Prompt for name
printString(NamePrompt)
readString(UserName)

#Prompt for height
printString(HeightPrompt)
readInt(Height)
#Prompt for weight
printString(WeightPrompt)
readInt(Weight)

#Int calculations
#Weight *703
lw $t1, Weight
li $t2 703
mult $t1, $t2
mflo $t3
sw $t3, Temp1

#Height ^2
lw $t1, Height
mult $t1, $t1
mflo $t4
sw $t4, Temp2

#Float conversions
lwc1 $f0, Temp1
lwc1 $f2, Temp2
cvt.d.w $f0, $f0
cvt.d.w $f2, $f2

#Float Calculations
div.d $f4, $f0, $f2
# $f0 is height*703, $f2 is weight^2, $f4 is $f0/$f2

#Saving BMI to memory
sdc1 $f4, BMI

#Remove \n from UserName
#Omitted for simplicity due to responce on Piazza
#Print Header
printString(UserName)
printString(BMIIs)
printDoubleReg($f4)
printString(NewLine)

#Determine results and print
test0:
ldc1 $f6, bmiuw
c.lt.d $f4, $f6
printDoubleReg($f6)
printString(NewLine)
bc1f test1
printString(Underweight)
j exit

test1:
ldc1 $f6, bminw
c.lt.d $f4, $f6
printDoubleReg($f6)
printString(NewLine)
bc1f test2
printString(Normalweight)
j exit

test2:
ldc1 $f6 bmiow
c.lt.d $f4, $f6
printDoubleReg($f6)
printString(NewLine)
bc1f test3
printString(Overweight)
j exit

test3:
printString(Obese)
j exit

#exit
exit:
li $v0, 10
syscall