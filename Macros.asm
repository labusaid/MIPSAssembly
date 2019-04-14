#-----Macros-----#
.macro printInt(%int)
li $v0, 1
lw $a0, %int
syscall
.end_macro

.macro readInt(%int)
li $v0, 5
syscall
sw $v0, %int
.end_macro

.macro printString(%str)
li $v0, 4
la $a0, %str
syscall
.end_macro

.macro readString(%str)
li $v0, 8
li $a1, 20
la $a0, %str
syscall
.end_macro

.macro printFloat(%float)
li $v0, 2
l.s $f12, %float
syscall
.end_macro

.macro printDoubleReg(%doublereg)
li $v0, 3
mov.d $f12, %doublereg
syscall
.end_macro

.macro promptString(%prompt, %save)
li $v0, 54
la $a0, %prompt
la $a1, %save
li $a2, 64
syscall
.end_macro

.macro removeNL()
li $t0, 0 # Set index to 0
    remove:
        lb $a3, inFile($t0) # Load character at index
        addi $t0, $t0, 1 # Increment index
        bnez $a3, remove # Loop until the end of string is reached
        beq $a1, $t0, skip # Do not remove \n when string = maxlength
        subiu $t0, $t0, 2 # If above not true, Backtrack index to '\n'
        sb $0, inFile($t0) # Add the terminating character in its place
    skip:
.end_macro