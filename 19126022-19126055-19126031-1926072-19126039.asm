	.data
file: .asciiz "D:/dethi.txt"   #path of file dethi.txt
nguoichoiPath: .asciiz "D:/nguoichoi.txt" #path of nguoichoi.txt
p_name: .asciiz "Enter your name: "
str1: .asciiz "Your guess: "
messPlayerLost: .asciiz	"------YOU LOST------\n"
messShowName: .asciiz "Name: "
messShowTTScore: .asciiz "Total score: "
messShowTTWinTurns: .asciiz "\nTotal win turns: "
messAskToContinue: .asciiz "\nDo you want to start new game ??? (Y/N) "
endline: .asciiz "\n"
Top10: 	.asciiz "------ Top 10 ------"

ROUND_1:	.asciiz "______\n|/   |\n|\n|\n|\n-\n"
ROUND_2:	.asciiz "______\n|/   |\n|    O\n|\n|\n-\n"
ROUND_3:	.asciiz "______\n|/   |\n|    O\n|    |\n|\n-\n"
ROUND_4:	.asciiz "______\n|/   |\n|    O\n|   /|\n|\n-\n"
ROUND_5:	.asciiz "______\n|/   |\n|    O\n|   /|\\ \n|\n-\n"
ROUND_6:	.asciiz "______\n|/   |\n|    O\n|   /|\\ \n|   /\n-\n"
ROUND_7:	.asciiz "______\n|/   |\n|    O\n|   /|\\ \n|   / \\ \n-\n"

score: .word 0
totalWinTurns: .word 0
arrSize: .word 0
num_player: .word 1

name: .space 30
test: .space 1024
word: .space 25
guess: .space 25
flag: .space 25
wordAlreadyGuess: .space 30
Answer: .space 5
player: .space 1024
ScoreArr: .space 400 
NumArr: .space 400

	.text
main:
#==== void: Scanf Name === #
Scf_name:
	#Show: Enter your name: 
	   li $v0, 4
	   la $a0, p_name
	   syscall 	
	#Read name
	   li $v0, 8
	   la $a0, name
	   li $a1, 30
	   syscall
	la $s0, name
	jal Loop_insertName
	
#==== void: ====#
Open_file:
	#openFile
	li $v0, 13   #13 to open file
	la $a0, file  #file is string contains file path 
	li $a1, 0  #0 for read mode
	li $a2, 0 
	syscall
	move $s0, $v0  #save file descriptor in $s0
	
	#readfile
	li $v0, 14  #14 to read file
	move $a0, $s0  #pass file descriptor to $a0
	la $a1, test    #test is the space to read into, declared in .data segment
	li $a2, 1024 # maximum length can read from the file
	syscall
	#close
	li $v0, 16  #16 to close file
	move $a0, $s0 #pass file descriptor to $a0
	syscall
	jal randnum # jump to randnum function 
	la $t0, word #load address of word into $t0
	la $t1, guess #load address of guess into $t1
	li $t3, '*' #load immediate “*” into $t3
	li $s1,0  #load immediate value 0 into $s1
	jal PrintToGuess # jump to PrintToGuess function - function to take and print * word to guess
	move $s1, $v0
	move $s2, $v0
	jal Endline
	li $t6,0
#==== void: Scanf Guess=== #
scan:	
    	li $v0,4
    	la $a0,str1 #Print str1
    	syscall 
    	li $v0,8
    	la $a0,flag #Scan your guess to flag
    	la $a1,25 #Set string length
    	syscall
    	li $t1,-1 #Set $t1 = -1
    	la $t0,flag #Set content of flag to $t0
	jal countWords #call the function countWords
	add $s0,$0,$v0 # Set the retrurn value of the func countWords to $s0
	la $t0,flag #Set content of flag to $t0
	la $t1,word #Set content of word to $t1
	beq $s0,1,compareCharacters #if strlen of flag-$s0=1, go to compareCharacters
	j compareAns #else goto compareAns
#==== void check_name ==== #
Loop_insertName:
		lb	$a0, 0($s0) # $a0 = $s0
		beq	$a0, 10, Open_file  
		slti  	$t0, $a0, '0' # $a0 < ‘0’ ->$ t0=1
		beq 	$t0, 1, Scf_name # $t0 == 1 Insert name again
		sgt  	$t0, $a0, '9' #$a0 > '9' -> t0 = 1
		beq 	$t0, 1, Loop_1 # t0 == 1 go to  Loop_1
		j gon # $t0 == 0 go to gon
		Loop_1:
			blt  	$a0, 'A', Scf_name #$ a0 < 'A' -> Insert name
			sgt	$t0, $a0, 'Z' #$ a0 > ‘Z’ -> t0 = 1
			beq	$t0, 1, Loop_2 #$ t0 == 1 go to Loop_2
			j gon #$t0 == 0 go to gon
		Loop_2: 
			blt	$a0, 'a', Scf_name #$a0 < 'a' insert name
			sgt	$t0, $a0, 'z' #$a0 > ‘z’ -> t0 = 1
			beq 	$t0, 1, Scf_name #$t0 == 1 Insert name
	gon:
		addi $s0, $s0, 1
		bne $a0, 10, Loop_insertName
		jr $ra
#==== void: ====#
randnum:
	li $a1, 850  #load immediate upper limit number
	li $v0, 42 # 42 to get random number
	syscall
	la $t0, test  # load address of test into $t0 - test is the space contains words read from dethi.txt
	add $t0, $t0, $a0 # plus the address with the previous random number to get the address of the ‘random number’ byte in test
	j search # jump to search function
search:
	lb $t2, 0($t0)  #load into $t2 first byte at the address saved in $t0 
	beq $t2, '-', Next   # if value stored in $t2 equal ‘ - ‘ jump to Next function
	addi $t0, $t0, 1 # increase the address stored in $t0 by 1
	j search # jump to search function again
Next:
	addi $t0, $t0, 1 # increase the address stored in $t0 by 1
	la $t1, word  # load address of word into $t1 to get word for further use
	j TakeWord # jump to TakeWord function
TakeWord:
	lb $t2, 0($t0)  #load into $t2 first byte at the address saved in $t0
	beq $t2, '-', ExitW  # if value stored in $t2 equal ‘ - ‘ jump to ExitW function
	beqz $t2, ExitW  #   if value stored in $t2 equal 0 jump to ExitW function
	sb $t2, 0($t1) # store byte in $t2 into memory addressed in $t1
	addi $t0, $t0, 1 # increase the address stored in $t0 by 1
	addi $t1, $t1, 1 # increase the address stored in $t1 by 1
	j TakeWord #jump to TakeWord function
ExitW:
	li $t3,'\n' #load “\n” into $t3 to mark end of one word later
	sb $t3,0($t1) #store byte in $t3 into memory addressed in $t1 to mark end of word
	jr $ra # jump to address store in $ra ( jump back to main )
PrintToGuess:
	lb $t2, 0($t0) # load into $t2 first byte at the address saved in $t0
	beq $t2,'\n', exitGuess  # if value stored in $t2 equal ‘ \n ‘ jump to exitGuess function
	sb $t3, 0($t1) # store the previous saved value (*) into memory addressed in $t1
	addi $t0, $t0, 1  #  increase the address stored in $t0 by 1
	addi $t1, $t1, 1   # increase the address stored in $t1 by 1
	addi $s1, $s1, 1  # increase the value stored in $t1 by 1
	j PrintToGuess #jump to PrintToGuess
exitGuess:
	la $a0, guess # load address of guess into $a0 in order to prepare to print ***
	li $v0, 4 # 4 to print string
	syscall
	add $v0,$0,$s1 # pass the value of $s1 to $v0 in order to return the value
	jr $ra # jump back to the address stored in $ra (main)
countWords:
    	lb $a0,0($t0)
    	addi $t0,$t0,1
    	addi $t1,$t1,1
    	bne $a0,'\n',countWords
    	add $v0,$0,$t1
	jr $ra
compareAns:
	lb $a0,0($t0) #get one character (ith)from <flag>-$t0
	lb $a1,0($t1) #get one character from <word>-$t1
	beq $a1,$0,win #if $a1=EOF, go to win
	bne $a0,$a1,loss #if $a0_ith character from <flag> != $a1_ith character from <word>, go to loss
	addi $t0,$t0,1 #i++ 
	addi $t1,$t1,1 #i++
	j compareAns # do it again
loss: #set the number of character that user guess truly to <score> 
	sub $s1,$s1,$s2 #$s1=$s1_strlen of <word> - $s2_characters that user guess truly
	li $v0,1
	add $a0,$0,$s1 # print user’s score
	syscall
	jal get_score # call func get_score
	jal Endline #call func Endline
	j Round.7
win: #Set strlen of <word> to <score>
	li $v0, 1
	add $a0, $0, $s1 #print strlen of <word>
	syscall
	lw $t0, totalWinTurns #load content of <totalWinTurns> to $t0
	addi $t0,$t0,1 #$t0++
	sw $t0, totalWinTurns #save content of $t0 to <totalWinTurns>
	jal get_score #call func get_score
	jal Endline #call func Endline 
	sw $0, arrSize #save 0 to <arrSize>
	la $t0, wordAlreadyGuess
	jal Erase 
	li $v0, 4
	la $a0, word
	syscall
	la $t0, word #Set content of <word> to $t0
	jal Erase #call func Erase to delete the content of string <word>
	la $t0, guess  #Set content of <guess> to $t0
	jal Erase #call func Erase to delete the content of string <guess>
	j Open_file # return Open_file to random for new word
#==============void: Get score ==============#
get_score: #save content of $s1_characters that user guess truly to <score>
	lw $s0, score #load content of <score> to $s0
	add $s0, $s0, $s1 # $s0 = $s0 + $s1_characters that user guess truly
	sw $s0, score #save content of $s0 to <score>
	jr $ra 
Erase:
	li $t2, 0x00 #load immediate value NULL into $t2 in order to erase space later
	lb $t1, 0($t0)  #load into $t1 first byte at the address saved in $t0
	beq $t1,0x00,ExitE # if value stored in $t2 equal NULL jump to exitE function
	sb $t2, 0($t0)  #store the previous saved NULL value into memory addressed in $t1
	addi $t0, $t0, 1 # increase the address stored in $t0 by 1
	j Erase # jump to Erase function
ExitE:
	jr $ra # jump back to the address stored in $ra 
Endline:
	li $v0, 4
	la $a0,endline #print “\n”
	syscall
	jr $ra	
checkWordAlreadyGuess:
	addi $sp, $sp, -4
	sw $ra, ($sp)
	
	la $t3, wordAlreadyGuess #set <wordAlreadyGuess> to $t3
    	li $t2, 0	 #i
	lw $t5, arrSize #load content of <arrSize>_strlen of <wordAlreadyGuess> to $t5
	beqz $t5, setWordAlreadyGuess # if $t5_strlen of <wordAlreadyGuess> = 0, go to setWordAlreadyGuess; else goto checkWordAlreadyGuess_loop
	
checkWordAlreadyGuess_loop: #for (int i = 0; i <= strlen of <wordAlreadyGuess>; i++)
	bgt $t2, $t5, setWordAlreadyGuess # i <= strlen of <wordAlreadyGuess>
	lb $a1, 0($t3) #load one character (jth)  from <wordAlreadyGuess> to $a1
	beq $a1, $a0, scan #if $a1 = $a0_character that user enter, go to scan to enter <flag> again
	addi $t3, $t3, 1 #j++
	addi $t2, $t2, 1 #i++
	j checkWordAlreadyGuess_loop
	
setWordAlreadyGuess:
	la $t3, wordAlreadyGuess #set <wordAlreadyGuess> to $t3
	add $t3,$t3,$t5 #wordAlreadyGuess[$t5]
	sb $a0, 0($t3) #add $a0_<flag> to end of string <wordAlreadyGuess>

	addi $t5,$t5,1 #increase the strlen of <wordAlreadyGuess> by 1
	sw $t5, arrSize

	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra 
compareCharacters:
	lb $a0,0($t0) #load content of <flag> to $a0
	jal checkWordAlreadyGuess 	
	li $t2,0 #count
	la $t3,guess
	li $t5,0 #countTimesReplace_characters that user guess truly
loop: #while (word[i] != NULL)
	lb $a1,0($t1)
	beq $a1,'\n',out
	beq $a0,$a1,replace 
	addi $t1,$t1,1 #i++
	addi $t2,$t2,1 #count++
	j loop
replace: 
	add $t4,$t2,$t3 
	sb $a0,0($t4) #save $a0_<flag> to guess[i] 
	addi $t5,$t5,1 #countTimesReplace++
	addi $t1,$t1,1#i ++
	addi $t2,$t2,1#count ++
	j loop
out:	
	sub $s2,$s2,$t5 #$s2 = $s2_strlen of <word> - $t5_characters that user guess truly
	beqz $s2,win
	beqz $t5,PrintHangman #if $t5_characters that user guess truly = 0, print Hangman
	j continue
continue:
	la $a0,guess
	li $v0,4
	syscall
	jal Endline
	j scan
PrintHangman:
	addi $t6, $t6, 1
	beq $t6, 1, Round.1
	beq $t6, 2, Round.2
	beq $t6, 3, Round.3
	beq $t6, 4, Round.4
	beq $t6, 5, Round.5
	beq $t6, 6, Round.6
	beq $t6, 7, loss
		Round.1:
       			li $v0, 4
       			la $a0, ROUND_1
			syscall
			j scan
		Round.2:
        		li $v0, 4
        		la $a0, ROUND_2
			syscall
			j scan
		Round.3:
        		li $v0, 4
        		la $a0, ROUND_3
			syscall
			j scan
		Round.4:
        		li $v0, 4
        		la $a0, ROUND_4
			syscall
			j scan
		Round.5:
        		li $v0, 4
        		la $a0, ROUND_5
			syscall
			j scan
		Round.6:
        		li $v0, 4
        		la $a0, ROUND_6
			syscall
			j scan
		Round.7:
        		li $v0, 4
        		la $a0, ROUND_7
			syscall
			li $v0, 4
			la $a0, word
			syscall
			jal _funcShowInfo
			jal _funcWriteInfoToFile
			jal _PrintTop10
			_PrintTop10_Next:
			j askingToContinue
#==== void: PrintTop10 ===#
_PrintTop10:
	#openFile
	li $v0, 13 
	la $a0, nguoichoiPath
	li $a1, 0
	li $a2, 0 
	syscall
	move $s0, $v0 
	#readfile
	li $v0, 14 
	move $a0, $s0 
	la $a1, player
	la $a2, 1024
	syscall
	#close
	li $v0, 16
	move $a0, $s0 
	syscall
	li $a0, 10
	li $v0, 11
	syscall
#==== Void: Getscore ====#
#@input: file nguoichoi.txt
#@output: mang chua diem 
	la $t0, player
	la $t1, 0 #counter
	li $s1, 0 #numplayer
	la $a1, ScoreArr
GetScore.while:
	jal TakePlayer 
	la $a0, word
	jal TakeScore
	#Convert string to int
        	la $a0, score #save score(str) to $a0
        	jal atoi
	sb $v0, 0($a1) #save (int)score in array $a1
	addi $a1, $a1, 4 #increase address of array ScoreArr
	addi $s1, $s1, 1 #increase numplayer
	j GetScore.while
GetScore.End:	
	#Save $s1 into num_player
	la $t0, num_player
	sw $s1, 0($t0)
	jal Create_NumArr 
	jal Sort
	
#Print Top10
PrintTop10:
	#Print message: --Top 10--
	la $a0, Top10
	li $v0, 4
	syscall
	
	la $t0, 0 #counter=0
	la $t1, 10 #condition of loop 
	la $a1, NumArr 
	la $t2, num_player #num_player
	lw $t6, 0($t2) #num_player

	Print.while:
	beq $t0, $t1, Print.while.end #or : counter <= 10
	beq $t0, $t6, Print.while.end #counter = num_player
	
	lb $t3, 0($a1) #load byte of array NumArr
	
	move $a2, $t3 # $a2 = NumArr[counter]

	la $t4, player 
	li $t5, -1 
	jal TakePlayertoPrint
	
	addi $t0, $t0, 1 #counter++
	addi $a1, $a1, 4 #Go to next address of NumArr 
	j Print.while
	
Print.while.end:
	j _PrintTop10_Next


#===== Take ten-diem-solanchoi from ‘player’ and print====#
TakePlayertoPrint:
	lb $t2, 0($t4) #loadbyte cua player	
	beq $t2, '*', Count #if $t2 = *
	_Next:
	beq $t5, $a2, PrintPlayer  #if number of ‘*’ = $a2 -> Print
	 	
	addi $t4, $t4, 1
	j TakePlayertoPrint
Count:
	addi $t5, $t5, 1
	j _Next
PrintPlayer:
	addi $t4, $t4, 1
	#Print ‘\n’
	li $v0, 4
    	la $a0, endline
   	syscall 
	#Print until next ‘*’
	PrintPlayer.loop:
	lb $t3, 0($t4)
	beq $t3, '*', TakePlayertoPrint.Exit
	 #Print
	li $v0, 11
    	move $a0, $t3
   	syscall

	addi $t4, $t4, 1
	j PrintPlayer.loop

TakePlayertoPrint.Exit:
	jr $ra
#==== void: creatNumArr ====#
Create_NumArr:
#Dau ham:
	sub $sp, $sp, -4
	sw $ra, 0($sp)
#Than ham:	
	li $t0, 0 #counter
	la $t2, num_player #Nplayer
	lw $t3, 0($t2)
	la $a2, NumArr
	CreatenumArr:
	beq $t0, $t3, CreatenumArrEnd
	sb $t0, 0($a2)	
	addi $t0, $t0, 1
	addi $a2, $a2, 4
	j CreatenumArr
CreatenumArrEnd:
#Cuoiham
	lw $ra, ($sp)
	add $sp, $sp, 4
	jr $ra
#==== end of createNumArr ====#
#==== function: atoi (Convert str to num) ====#
atoi: 
#Prepare stack to save variable 
	sub $sp, $sp,-16
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)

	move $t0, $a0 # luu $a0 vao $t0
	li $v0, 0 #gan bien tra ve la 0
next: # get the first byte
	lb $t1, ($t0)
# Check if char is a number
	blt $t1, 48, endloop
	bgt $t1, 57, endloop
# update result: $v0 = v0*10 + $t1 - 48
	mulo $v0, $v0, 10
	add $v0, $v0, $t1
	sub $v0, $v0, 48
#  update address to next char
	add $t0, $t0, 1
	b next
endloop:
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	add $sp, $sp, 16

	jr $ra
#==== end of atoi ====#

#==== Take ten-diem-solanchoi ====#
TakePlayer:
	lb $t2, 0($t0)
	beq $t2, '*', _TakePlayer_Next #Take until next ‘*’
	beqz $t0,TakePlayer.Exit #Loop until end of $t0
	addi $t0, $t0, 1 #increase address
	j TakePlayer 
_TakePlayer_Next:
	addi $t0, $t0, 1
	la $t1, word
	j _TakePlayer_TakeWord
_TakePlayer_TakeWord:
	lb $t2, 0($t0)
	beq $t2, '*', TakePlayer.Exit
	beqz $t2, GetScore.End
	sb $t2, 0($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j _TakePlayer_TakeWord
TakePlayer.Exit:
	li $t3,'\n'
	sb $t3,0($t1)
	jr $ra
#==== Take Score ====#	
TakeScore:
	lb $t2, 0($a0)
	beq $t2, '-', _TakeScore_Next
	addi $a0, $a0, 1
	j TakeScore
_TakeScore_Next:
	addi $a0, $a0, 1
	la $t3, score 
	j _TakeScore_Score
_TakeScore_Score:
	lb $t4, 0($a0)
	beq $t4, '-', TakeScore.Exit
	sb $t4, 0($t3)
	addi $a0, $a0, 1
	addi $t3, $t3, 1
	j _TakeScore_Score
TakeScore.Exit:
	li $t5,'\n'
	sb $t5,0($t3)       
	jr $ra
#==== void Sort ====#
Sort:
	sub $sp, $sp,-28
	sw $ra, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	li $t0, 0 #counter i
	li $t1, 0 #counter j
	la $t2, num_player #Nplayer
	lw $t3, 0($t2)
	li $t4, 0
	li $t5, 0
LoopI:
	beq $t0, $t3, LoopI.End
	move $t1, $t0 #counter j
	move $t2, $t0 #temp_i de lay dia chi 
_LoopJ:
	beq $t1, $t3, _LoopJ.End
	#Goi dia chi i
	move $t4, $t2
	#$t4 x 4
	add $t4, $t4, $t4
	add $t4, $t4, $t4 
	#Score[i]
	lb $s0,  ScoreArr($t4)
	#Goi dia chi j
	move $t5, $t1
	#$t5 x 4
	add $t5, $t5, $t5
	add $t5, $t5, $t5 
	#Score[i]
	lb $s1,  ScoreArr($t5)
	addi $t1, $t1, 1
	bgt $s0, $s1, _LoopJ
	sb $s1,  ScoreArr($t4) #ScoreArr[i]
	sb $s0,  ScoreArr($t5) #ScoreArr[j]

	lb $s2,  NumArr($t4) #NumArr[i]
	lb $s3,  NumArr($t5) #NumArr[j]
	xor $s2, $s2, $s3
	xor $s3, $s2, $s3
	xor $s2, $s2, $s3
	sb $s2,  NumArr($t4) #NumArr[i]
	sb $s3,  NumArr($t5) #NumArr[j]  	
	j _LoopJ
_LoopJ.End:
	addi $t0, $t0, 1
	j LoopI
LoopI.End:
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t4, 20($sp)
	lw $t5, 24($sp)
	add $sp, $sp,28
	jr $ra
_funcShowInfo:
	#Backup reg
	addi $sp, $sp, -4
	sw $ra, ($sp)
	#Show You lost
	li $v0, 4
	la $a0, messPlayerLost
	syscall
	#Show messShowName
	li $v0, 4
	la $a0, messShowName
	syscall
	#Show playerName
	li $v0, 4
	la $a0, name
	syscall
	#Show  messShowTTScore
	li $v0, 4
	la $a0, messShowTTScore
	syscall
	#Show score
	li $v0, 1
	lw $a0, score
	syscall
	#Show messShowTTWinTurns
	li $v0, 4
	la $a0, messShowTTWinTurns
	syscall
	#Show totalWinTurns
	li $v0, 1
	lw $a0, totalWinTurns
	syscall
	#Restore reg 
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
#---End func showInfor
_funcWriteInfoToFile:
	#Backup reg
	addi $sp, $sp, -32
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $t0, 24($sp)
	sw $t1, 28($sp)
	#Check file if empty -> not add '*'
	#Open file nguoichoi.txt 
	li $v0, 13
	la $a0, nguoichoiPath
	li $a1, 0					#flag read
	li $a2, 0
	syscall
	move $s0, $v0					#store file desciptor in $s0
	li $v0, 9
	li $a0, 4096
	syscall
	move $t0, $v0
	#Read file nguoichoi.txt
	li $v0, 14
	move $a0, $s0
	move $a1, $t0
	li $a2, 4096
	syscall
	lb $t1, ($t0)			#Read first char in file
	#Close file
	li $v0, 16
	move $a0, $s0
	syscall
	#Allocate temp buffer for player info stored in $s1
	li $v0, 9
	la $a0, 100
	syscall
	move $s1, $v0
	move $s2, $s1			#use $s2 as a current pointer of $s1 ($s1 is original address)
	li $s4, 0			#len of information 
	la $s3, name	
	#If file is empty ($t1 == '\0') 
	bne $t1, '\0', _funcWriteInfoToFile.Loop.setNameInBuff
	#Concat *
	li $t1, '*'
	sb $t1, ($s2)
	addi $s4, $s4, 1
	addi $s2, $s2, 1
_funcWriteInfoToFile.Loop.setNameInBuff:
	lb $t1, ($s3)
	#End char may be '\0' or '\n'
	beq $t1, '\0', _funcWriteInfoToFile.setScoreInBuff
	beq $t1, '\n', _funcWriteInfoToFile.setScoreInBuff
	sb $t1, ($s2)
	addi $s2, $s2, 1
	addi $s3, $s3, 1
	addi $s4, $s4, 1
	j _funcWriteInfoToFile.Loop.setNameInBuff
_funcWriteInfoToFile.setScoreInBuff:
	#Concat -
	li $t0, '-'
	sb $t0, ($s2)
	addi $s2, $s2 ,1
	addi $s4, $s4, 1
	lw $a0, score
	jal _funcItoa
	move $t0, $v0
_funcWriteInfoToFile.setScoreInBuff.Loop:
	lb $t1, ($t0)
	beq $t1, '\0', _funcWriteInfoToFile.setTotalWinInBuff
	beq $t1, '\n', _funcWriteInfoToFile.setTotalWinInBuff
	sb $t1, ($s2)
	addi $s2, $s2, 1
	addi $t0, $t0, 1
	addi $s4, $s4, 1
	j _funcWriteInfoToFile.setScoreInBuff.Loop
_funcWriteInfoToFile.setTotalWinInBuff:
	#Concat -
	li $t0, '-'
	sb $t0, ($s2)
	addi $s2, $s2 ,1
	addi $s4, $s4, 1
	lw $a0, totalWinTurns
	jal _funcItoa
	move $t0, $v0
_funcWriteInfoToFile.setTotalWinInBuff.Loop:
	lb $t1, ($t0)
	beq $t1, '\0', _funcWriteInfoToFile.WriteToFile
	beq $t1, '\n', _funcWriteInfoToFile.WriteToFile
	sb $t1, ($s2)
	addi $s2, $s2, 1
	addi $t0, $t0, 1
	addi $s4, $s4, 1
	j _funcWriteInfoToFile.setTotalWinInBuff.Loop
_funcWriteInfoToFile.WriteToFile:
	#Concat *
	li $t1, '*'
	sb $t1, ($s2)
	addi $s4, $s4, 1
	#Open file nguoichoi.txt to append info before show
	li $v0, 13
	la $a0, nguoichoiPath
	li $a1, 9					#flag write - append
	li $a2, 0
	syscall
	move $s0, $v0					#store file desciptor in $s0
	#Write to file nguoichoi.txt
	li $v0, 15
	move $a0, $s0
	move $a1, $s1
	move $a2, $s4
	syscall
	#Close file
	li $v0, 16
	move $a0, $s0
	syscall
	#Restore reg 
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $t0, 24($sp)
	lw $t1, 28($sp)
	addi $sp, $sp, 32
	jr $ra
#---End funcWriteInfoToFile
_funcItoa:
	#Backup reg
	addi $sp, $sp, -52
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $t0, 16 ($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)
	sw $t4, 32($sp)
	sw $t5, 36($sp)
	sw $t6, 40($sp)
	sw $t7, 44($sp)
	sw $t8, 48($sp)
	#Init
	move $s0, $a0
	#Allocate memory for string
	li $v0, 9
	la $a0, 100
	syscall
	move $s1, $v0
	move $s2, $s1
	move $t0, $s0
	#if $a0 = 0 return '0'
	bne $t0, 0, _funcItoa.Loop.convert
	addi $t0, $t0, '0'
	sb $t0, ($s2)
	addi $s2, $s2, 1
	li $t0, '\0'
	sb $t0, ($s2)
	j _funcItoa.reverseStr.endLoop
_funcItoa.Loop.convert:
	beq $t0, 0, _funcItoa.reverseStr
	div $s0, $s0, 10
	mflo $t0			#result
	mfhi $t1			#remainder
	move $s0, $t0
	addi $t1, $t1, '0'
	sb $t1, ($s2)
	addi $s2, $s2, 1
	j _funcItoa.Loop.convert
_funcItoa.reverseStr:
	li $t0, '\0'
	sb $t0, ($s2)
	move $a0, $s1
	jal _funcgetStringLength
	move $t0, $v0
	move $s2, $s1	
	#(n - 1) /  2 = $t1
	addi $t1, $t0, -1
	div $t1, $t1, 2
	mflo $t1
	li $t2, 0	#idx
_funcItoa.reverseStr.Loop:	
	#Load a[i]
	add $t3, $t2, $s2
	lb $t4, ($t3)
	#Load a[n - i - 1]
	move $t5, $t0
	sub $t5, $t5, $t2
	subi $t5, $t5, 1
	add $t6, $t5, $s2
	lb $t7, ($t6)
	#Swap a[i]  a[n - i - 1]
	move $t8, $t4
	move $t4, $t7
	move $t7, $t8
	sb $t4, ($t3)
	sb $t7, ($t6)
	addi $t2, $t2, 1
	blt $t2, $t1,  _funcItoa.reverseStr.Loop
_funcItoa.reverseStr.endLoop:	
	#Return value
	move $v0, $s1
	#Restore reg
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $t0, 16 ($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $t3, 28($sp)
	lw $t4, 32($sp)
	lw $t5, 36($sp)
	lw $t6, 40($sp)
	lw $t7, 44($sp)
	lw $t8, 48($sp)
	addi $sp, $sp, 52
	jr $ra
#---End func itoa

#---Func getStringLength - lay chieu dài chuoi
#@params
#$a0 - chuoi can tính
#@return
#$v0 - chieu dài
_funcgetStringLength:
	#Backup reg
	addi $sp, $sp, -16
	sw $ra, ($sp)
	sw $s0, 4($sp)
	sw $t0, 8($sp)
	sw $t1, 12($sp)
	#Init
	move $s0, $a0
	li $t0, 0
_funcgetStringLength.Loop:
	lb $t1, ($s0)
	beq $t1, '\0', _funcgetStringLength.endLoop
	beq $t1, '\n', _funcgetStringLength.endLoop
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	j _funcgetStringLength.Loop
_funcgetStringLength.endLoop:
	#Return value
	move $v0, $t0
	#Restore reg
	lw $ra, ($sp)
	lw $s0, 4($sp)
	lw $t0, 8($sp)
	lw $t1, 12($sp)
	addi $sp, $sp, 16
	jr $ra
#---End func getStringLength


#==== void asking to continue ====#
askingToContinue: 
	#show 
	li $v0, 4
	la $a0, messAskToContinue
	syscall
	
	li $v0, 8
	la $a0, Answer
	la $a1, 5
	syscall
	sw $0, score
	sw $0, totalWinTurns
	sw $0, arrSize
	la $t0, Answer
	lb $a0, 0($t0)
	la $t0, wordAlreadyGuess
	jal Erase 
	la $t0, word
	jal Erase
	la $t0, guess
	jal Erase 
	beq $a0,'Y',Open_file
	beq $a0,'y',Open_file
	j exitAll
exitAll:
addi $v0, $0, 10 # set $v0, 10
syscall


