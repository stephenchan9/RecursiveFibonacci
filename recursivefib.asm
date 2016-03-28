; Assignment 2 Recursive Fibonacci
; Stephen Chan
; 9419
; CPSC 240 Assignment 2
; Partner: Daniel Berumen
; Creates a recursive fibonacci array of values.

INCLUDE Irvine32.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
str1 BYTE "CPSC 240 Recursive function written by: Stephen Chan",0			;------------------
str2 BYTE "This program calculates the Fibonacci number of N.",0			;Header Declarations
str3 BYTE "Enter integer number N: ",0
str4 BYTE "The fibonacci(",0
str5 BYTE ") is: ",0
str6 BYTE "Elapsed time (ms) = ",0
str7 BYTE "Press any key to continue or 'Q' or 'q' to quit: ",0				;------------------
																			
.code
;-------------------------------------------------------
; generate_fibonacci proc uses ebx ecx
; Generates fibonacci values and sums them to register eax
; Receives: ebx,ecx
; Returns: eax
;------------------------------------------------------- 

generate_fibonacci proc uses ebx ecx
	cmp eax,1							
	je one								;if f(n)==1
	jl zero								;if f(n)==0
	push eax							;save n
	dec eax								;n-1
	call generate_fibonacci				;f(n-1)
	mov ebx,eax							;mov value from eax to ebx
	pop eax								;restore n
	sub eax,2							;n-2
	call generate_fibonacci				;f(n-2)
	mov ecx,eax							;mov value from eax to ecx
	add ebx,ecx							;f(n-1)+ f(n-2)
	mov eax,ebx							
	ret
one:
	mov eax,1
	ret
zero: 
	mov eax,0
	ret
generate_fibonacci endp


main proc
	mov edx, OFFSET str1		;Header 
	call WriteString
	call Crlf

	mov edx, OFFSET str2		;Header
	call WriteString
	call Crlf
L1:
	mov edx, OFFSET str3		;Prompt user to enter a value
	call WriteString
	call ReadInt				;Reads User value 
	call Crlf

	push eax					;Pushes user value in order to save the value and open the register for the start time.
	call GetMSeconds			;Get start time
	mov ebx,eax					;Moves the start time to register ebx
	pop eax						;Pops value user entered

	mov edx, OFFSET str4		;Header for fibonacci count
	call WriteString
	call WriteDec				
	
	call generate_fibonacci		;Calls the procedure

	mov edx, OFFSET str5		;Header for fibonacci sum
	call WriteString
	call WriteDec
	call Crlf

	call GetMSeconds			;End time of calculation
	sub eax,ebx					;Calculates the time elapsed from start to end
	
	mov edx, OFFSET str6		;Header for the elapsed time
	call WriteString
	call WriteDec
	call Crlf

	mov edx, OFFSET str7		;Header prompting the user to enter q to quit or enter any key to continue
	call WriteString 
	call ReadChar				;Reads the user input

	cmp al,'q'					;Compares user with lower case q character
	je quit						;Jumps to loop to exit program if equal
	cmp al,'Q'					;Compares with Upper case Q
	je quit						;Jumps to loop to exit program if equal
	
	call Crlf					;endline
	call Clrscr					;Clear the screen
	jnz L1						;Loop back to beginning
quit:
	invoke ExitProcess,0

main endp
end main