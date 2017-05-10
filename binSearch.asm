;;; ; binSearch.asm
;;; ; Michelle Wong
;;; ;
; ; Contains a function that searches a sorted array of integers for an integer key, and returns the index of the key to eax if found, and if not, -1 to eax.  
;;; ;Recurse is a function that is recursive, and calls itself within binSearch. 
;;; ;-------------------------------------

	extern _printInt
	extern _println
	extern _printRegs
	
	global binSearch


;;; ;RECURSE FUNCTION: this function is the one that does all the recursion. 
recurse:
;;; ;BASE CASE 
;;; ;if left >= right:
;;; ;return -1
	push eax	    	;save key 
	push ebx		;save address
	push ecx		;save left
	push edx		;save right
	cmp ecx, edx 		;compare left and right
	jge error    	 	;if left>right, move -1 to eax and return 
	
	push eax		;save key again for use 
;;; ;mid = (left + right) + 1  / 2 
	add ecx, edx		;ecx <- left+right
	mov eax, ecx		;eax <-left+right
	mov ecx, 2		;ecx <- 2
	inc eax			;add one so we can get an even number for mid 
	mov edx, 0		;edx <- 0
	div ecx			;eax <- mid: left+right/2
;;; ;if key = A[mid]:
;;; ;return mid
	mov ecx, eax		;ecx <- mid
;;; ;loop "mid" times, moving to the next value in the table until we reach the mid value in the array. 
for:	add ebx, 4		
	loop for

	mov ecx, dword[ebx]	;ecx <- A[mid], eax <- mid 
	pop edx			;edx <-key
	
	cmp edx, ecx		;if key = A[mid]:
	je exit			;return mid, eax already has mid

	
;;; ;RECURSE PART
;;; ;if key < A[mid]
;;; ;return binSearch(key, A, left, mid-1)

	cmp edx, ecx		;edx has key, ecx has A[mid]
	jg else

	pop edx			;edx <-right
	pop ecx			;pop old left
	
	dec eax			;eax <- mid-1
	mov edx, eax		;edx <- right (mid-1)
	pop ebx			;ebx <-address
	pop eax			;eax <- key
	call recurse
	ret 
	
;;; ;else:
;;; ;return binSearch(key, A, mid+1, right)
else:	
	pop edx 		;edx <-right
	pop ecx			;pop old left
	
	inc eax		;eax <- left:  mid+1
	mov ecx, eax	;ecx <- left (mid+1) 
	pop ebx		;ebx <- address
	pop eax		;eax <- key
	call recurse		;recurse(key, A, mid+1, right)
	ret
;;; ;exit
exit:
	push eax		;<- keep the index
	pop eax			;eax <- index
	pop edx			;pop right
	pop ecx			;pop left
	pop ebx			;pop address
	pop edx			;pop the key somewhere else, instead of back to eax
	ret
;;; ;return -1 
error:	
	mov eax, -1		;eax <- -1 
	pop edx			;pop right
	pop ecx			;pop left
	pop ebx			;pop address
	pop edx			;pop the key somewhere else
	ret
	
;;; ;Beginning of binSearch function. Calls recurse, a recursive function that does the searching. 
binSearch:	
	push ebp
	mov ebp, esp
	push edx
	push ecx
	push ebx
	mov eax, dword[ebp+16]	;edx <- key
	mov ebx, dword[ebp+20]	;pass address of table to ebx 
	mov ecx, dword[ebp+12]	;ecx <- left
	mov edx, dword[ebp+8]	;edx <-right
	
	call recurse
	
	pop ebx
	pop ecx
	pop edx
	pop ebp
	ret
	

