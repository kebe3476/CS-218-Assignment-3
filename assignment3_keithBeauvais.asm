section .data
; System service call values
SERVICE_EXIT equ 60
SERVICE_WRITE equ 1
EXIT_SUCCESS equ 0
STANDARD_OUT equ 1
NEWLINE equ 10
programDone db "Program Done.", NEWLINE 
stringLength dq 14


NUMBER_IN_ARRAY equ 10
;Data Variables
departmentHeadcountArray dw 43, 217, 19, 1036, 407, 8, 806, 560, 1, 96 


section .bss

newArray resw 10 ; word sized array 10 elements uninitialzed 
totalPizzaRequired resw 1 ; word sized variable 1 element unitialized used for the total number 
averagePizzaRequired resw 1; word sized variable 1 element uniitalized used for the average

section .text
global _start
_start:


mov rcx, NUMBER_IN_ARRAY ; 10 
mov rbx, 0 ; counter
mov di, 3 ; 3 slices per person
mov r8w, 8 ; 8 slices per pizza
mov r10w, 1 ; rounding up 

arrayLoop:
	;moving one array into another array 
	mov ax, word[departmentHeadcountArray+rbx*2]
	mov r9w, ax ; creates copy in r9w
	mul di ; dx:ax now filled multiplied by 3
	div r8w ; ax -> quotient dx -> remainder divided by 8
	cmp dx, 0 ; compares 0 to remainder if they not equal then need to round up
	je staySame 
		add ax, r10w ; rounds up if there is a remainder of 1 
		staySame: ; if there is no remainder than there is no need to round up
		mov word[newArray+rbx*2], ax ; adds the new quotient to the new array 
		inc rbx
		dec rcx
		cmp rcx, 0 ; compares 0 to how many indexes are left in the array
		jne arrayLoop ; if that the rcx register does not equal 0 then it will go back up and if it is a 0 then it will exit the loop

mov rcx, NUMBER_IN_ARRAY ; resets the number in rcx to be 10
mov rbx, 0 ; resets count to be 0

mov ax, word[newArray+rbx*2] ; moving the 0 index into ax 
inc rbx ; increment the index
mov r9w, word[newArray+rbx*2] ; moving the 1 index into bx
add ax, r9w ; adding the two to create the first total
mov word[totalPizzaRequired], ax ; moving the total into the variable

averageLoop:
	inc rbx ; increase the index by 1
	mov ax, word[newArray+rbx*2] ; moves the next index position into the ax register
	add ax, word[totalPizzaRequired] ; adds the total and the new number in ax register together
	mov word[totalPizzaRequired], ax ; moves the new total in ax into the variable
	cmp rbx, 9 ; compares rbx to 9 to see if we have gone through the entire array
	jb averageLoop ; if it is less than 10 then it will loop otherwise will move on

mov dx, 0 ; moving 0 into upper dx register for dx:ax, getting ready to divide
mov ax, word[totalPizzaRequired] ; moves the total into the ax register
mov r10w, 10 ; moves 10 into r10w register
div r10w ; divides the total by 10 to get the average 
mov word[averagePizzaRequired], ax ; moves the quotient into the average variable

endProgram:
; 	Outputs "Program Done." to the console
	mov rax, SERVICE_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, programDone
	mov rdx, qword[stringLength]
	syscall

; 	Ends program with success return value
	mov rax, SERVICE_EXIT
	mov rdi, EXIT_SUCCESS
	syscall