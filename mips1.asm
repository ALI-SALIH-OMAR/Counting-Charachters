.data
	.asciiz		
	Input_File: "C:\\Users\\st201736370\\Downloads\\CS2\\input.txt"		# Provided the directory to read the file From
	InputFile:  "input.txt"		# Read a File from the Mars Folder
	Array: .space 10000
			
	Letters: "Letters = "
	Digits: "\nDigits = "
	Special: "\nSpecial Characters = "
	Lines: "\nLines = "
			
	Error_Message:"Error: input.txt does NOT exist."

.text

	# open file to read only           
	la $a0 , Input_File
	li $a1 , 0
	li $v0 , 13
	syscall 
	
	# does the file exist in the provided directory? 
	bgez $v0, Exist
	
	la $a0 , InputFile
	li $a1 , 0
	li $v0 , 13
	syscall
	
	# dose the file exist in Mars Folder?
	bgez $v0, Exist
	
	# File Not Found situation then Print Error Message and terminate
	li $v0 , 4           
	la $a0 , Error_Message
	syscall 
	j Terminate
	Exist:
		# read from the file
		move $a0,$v0         
		la $a1 ,Array
		li $a2 , 10000
		li $v0 , 14  
		syscall 

	# store the number of characters read from the file
	move $s1,$v0
 
	#close file reading function
	li $v0 , 16  
	syscall 

	# count number of Letters, Digits, Other Special Characters and Lines
	la $t1, Array           # initialize the array address
	li $t2, 0               # counter
	li $s2, 0               # number of Letters
	li $s3, 0               # number of Digits
	li $s4, 0               # number of Other Special Characters 
	li $s5, 0               # number of Lines
	li $k1, 0               # $k0 will be one if the last element was Letter
                        	# $k1 will be one if the current element was Letter
                        	# if ($k0 > $k1) word++  
        beq $t2, $s1, Terminate
        
	loop:
		move $k0,$k1
		li $k1, 0
		lbu  $s0,($t1)
		ble $s0,9,Other
		bgeu $s0,11,Digit
		addiu $s5,$s5,1
		li $k1,1  
		j Line_Checking
		Digit:
		# if (Ascii charachter <= 47) Go to Other Condtion;
		# Since What is less or equal to 47 in Ascii is a specail charachter
		bleu $s0,47,Other     
		# if (Ascii charachter <= 47) Go to Capital_Letter_Checking Condtion;
		# Since What is Greater or equal to 58 in Ascii is not a Digit      
		bgeu $s0,58,Capital_Letter_Checking
		# Then what is left will be (Ascii charachter>47 && Ascii charachter<58) which is a digit in Ascii
		addiu $s3,$s3,1 
		li $k1,1   
		j Line_Checking

		Capital_Letter_Checking:            # Capital Letters
	
			bleu $s0,64,Other         
			bgeu $s0,91,Small_Letter_Checking
			addiu $s2,$s2,1 
			li $k1,1 
			j Line_Checking

		Small_Letter_Checking:            # Small Letters
			bleu $s0,96,Other        
			bgeu $s0,123,Other 
			addiu $s2,$s2,1  
			li $k1,1 
			j Line_Checking

		Other:                 # other characters
			addiu $s4,$s4,1
		Line_Checking:
			bleu $k0,$k1,no        # is it a word ?	
			no:
				addiu $t1,$t1,1         # +1 to the address 
				addiu $t2,$t2,1         # +1 to the counter
				#if (countter != size of file ) then continue the loop
				bleu  $t2,$s1,loop

	move $k0,$k1          # to check if the last thing in the file is word
	li $k1, 0
	add $t5,$s2,$s3
	add $t5,$s4,$t5
	add $t5,$s5,$t5
	bleu $k0,$k1,Print       
	
	Print:
	#display the info of the file in Counting Characters
		li $v0 , 1           
		move $a0 , $t5
		syscall
		#display the Number of Letters counted
		li $v0 , 4           
		la $a0 , Letters
		syscall
		li $v0 , 1           
		move $a0 , $s2
		syscall
		
	 	#display the Number of Digits counted
		li $v0 , 4           
		la $a0 , Digits
		syscall
		li $v0 , 1           
		move $a0 , $s3
		syscall
		
		#display the Number of Other Special Characters counted
		li $v0 , 4           
		la $a0 , Special
		syscall
		li $v0 , 1           
		move $a0 , $s4
		syscall
		
		#display the Number of new Lines added
		li $v0 , 4           
		la $a0 , Lines
		syscall
		li $v0 , 1           
		move $a0 , $s5
		syscall
		j Terminate
		
	Terminate:
	li $v0 , 10
	syscall
