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
	li $v0 , 13
	la $a0 , Input_File
	li $a1 , 0
	syscall 
	
	# does the file exist in the provided directory? 
	bgez $v0, Exist
	
	li $v0 , 13
	la $a0 , InputFile
	li $a1 , 0
	syscall
	
	# does the file exist in Mars Folder?
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
	move $t1,$v0
 
	#close file reading function
	li $v0 , 16  
	syscall 

	# count number of Letters, Digits, Other Special Characters and Lines
	la $t2, Array           # initialize the array address
	li $t3, 0               # counter
	li $t4, 0		# Outside Ascii Checker
	li $t5, 0               # number of Letters
	li $t6, 0               # number of Digits
	li $t7, 0               # number of Other Special Characters 
	li $t8, 0               # number of Lines
        
	loop:
		lbu  $t0,($t2)
		
		# if (Ascii charachter <= 9) Go to Other Condtion;
		# Since What is less or equal to 9 in Ascii is a specail charachter
		ble $t0,9,Other
		
		# if (Ascii charachter >= 11) Go to Digit Condtion;
		# Since What is Greater or equal to 11 in Ascii is not a new line
		bgeu $t0,11,Digit
		
		# Then what is left will be (Ascii charachter==10 which is a "\n" in Ascii
		addiu $t8,$t8,1
		j Cursor
		
		Digit:
		# if (Ascii charachter <= 47) Go to Other Condtion;
		# Since What is less or equal to 47 in Ascii is a specail charachter
		bleu $t0,47,Other     
		
		# if (Ascii charachter <= 47) Go to Capital_Letter_Checking Condtion;
		# Since What is Greater or equal to 58 in Ascii is not a Digit      
		bgeu $t0,58,Capital_Letter_Checking
		
		# Then what is left will be (Ascii charachter>47 && Ascii charachter<58) which is a digit in Ascii
		addiu $t6,$t6,1 
		j Cursor

		Capital_Letter_Checking:            # Capital Letters
	
			bleu $t0,64,Other         
			bgeu $t0,91,Small_Letter_Checking
			addiu $t5,$t5,1 
			j Cursor

		Small_Letter_Checking:            # Small Letters
			bleu $t0,96,Other        
			bgeu $t0,123,Other 
			addiu $t5,$t5,1  
			j Cursor

		Other:                 # other characters
			bgtu $t0,127,E_ASCII
			addiu $t7,$t7,1
		E_ASCII:
			li $t4,1
		Cursor:
				addiu $t2,$t2,1         # +1 to the address 
				addiu $t3,$t3,1         # +1 to the counter
				#if (countter != size of file ) then continue the loop
				bne  $t3,$t1,loop


	beqz $t4,Print
	addiu $t7,$t7,2
	Print:
	#display the info of the file in Counting Characters
		
		#display the Number of Letters counted
		li $v0 , 4           
		la $a0 , Letters
		syscall
		li $v0 , 1           
		move $a0 , $t5
		syscall
		
	 	#display the Number of Digits counted
		li $v0 , 4           
		la $a0 , Digits
		syscall
		li $v0 , 1           
		move $a0 , $t6
		syscall
		
		#display the Number of Other Special Characters counted
		li $v0 , 4           
		la $a0 , Special
		syscall
		li $v0 , 1           
		move $a0 , $t7
		syscall
		
		#display the Number of new Lines added
		li $v0 , 4           
		la $a0 , Lines
		syscall
		li $v0 , 1           
		move $a0 , $t8
		syscall
		
	Terminate:
		li $v0 , 10
		syscall
