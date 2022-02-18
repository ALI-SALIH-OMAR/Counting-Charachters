.data
	.asciiz		Input_File: "C:\\Users\\st201736370\\Downloads\\CS2\\input.txt" 
			Array: .space 10000
			
			Letters: "\nLetters = "
			Digits: "\nDigits = "
			Others: "\nSpecial Charachters = "
			Lines: "\nlines = "
			
			Error_Message:"Error: input.txt does NOT exist."

################### macro segment ##################
# display string
.macro printS(%S)
li $v0 , 4           
la $a0 , %S
syscall 
.end_macro

# display number
.macro printN(%N)
li $v0 , 1           
move $a0 , %N
syscall 
.end_macro

# display string & number
.macro printSN(%S,%N)
printS(%S)
printN(%N)
.end_macro

################### Code segment ###################
.text
	# open file to read only           
	la $a0 , inputfile
	li $a1 , 0
	li $v0 , 13
	syscall 

	# dose the file exist ? 
	bgez $v0,continue 
	printS (error_msg)
	li $v0 , 10
	syscall
	
	continue:
		# read from the file
		move $a0,$v0         
		la $a1 ,array
		li $a2 , 10000
		li $v0 , 14  
		syscall 

	# stor the number of carcters readed
	move $s1,$v0
 
	#close file
	li $v0 , 16  
	syscall 

	# count number of Letters, numbers, other and word
	la $t1, array           # initialze the array addrss
	li $s2, 0               # number of Letters
	li $s3, 0               # number of numbers 
	li $s4, 0               # number of other 
	li $s5, 0               # number of words
	li $t2, 0               # counter
	li $k1, 0               # $k0 will be one if the last elmant was Letter
                        # $k1 will be one if the current elmant was Letter
                        # if ($k0 > $k1) word++  
	loop:
		move $k0,$k1
		li $k1, 0
		lb $s0,($t1)

	ble $s0,47,other         # numbers  
	bge $s0,58,cpital_check
	add $s3,$s3,1  
	j word_check

	cpital_check:            # cpital Letters
		ble $s0,64,other         
		bge $s0,91,small_check
		add $s2,$s2,1 
		li $k1,1 
		j word_check

	small_check:            # small Letters
		ble $s0,96,other        
		bge $s0,123,other 
		add $s2,$s2,1  
		li $k1,1 
		j word_check

	other:                 # other characters
		add $s4,$s4,1

	word_check:
		ble $k0,$k1,no        # is it a word ?
		add $s5,$s5,1 
	no:

		add $t1,$t1,1         # +1 to the address 
		add $t2,$t2,1         # +1 to the counter
		bne $t2,$s1,loop

	move $k0,$k1          # to chack if the last thing in the file is word
	li $k1, 0
	ble $k0,$k1,no2       
	add $s5,$s5,1 
	no2:

	#display the info of the file 
	printS  (array)
	printSN (str1,$s2)
	printSN (str2,$s3)
	printSN (str3,$s4)
	printSN (str4,$s5)
