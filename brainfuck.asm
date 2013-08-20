;-----------------------------------------------------------------------
.data?
	BRAINFUCK_DATA_SIZE		equ	30000
	brainfuck?_cells		db  BRAINFUCK_DATA_SIZE dup(?)	; standard 30k cells
	brainfuck?_code			dd	?

;-----------------------------------------------------------------------
.code
brainfuck?initialize:
brainfuck?reset:
	and		eax, 0
	mov		ecx, sizeof brainfuck?_cells/4
	mov		edi, offset brainfuck?_cells
	rep		stosd
	push	[esp+4]
	pop		brainfuck?_code
	ret

brainfuck?run:
	push	ebp
	mov		ebp, esp
	push	-1				; stack control flag
	
	mov		esi, brainfuck?_code; code ptr (instruction ptr)
	mov		edi, esi
	call	interpreter?script?length
	mov		edi, offset brainfuck?_cells; data ptr 
	xor		ebx, ebx

.next:
	lodsb
	dec		ecx				; script len
	test	al, al
	jz		.halt
	cmp		al, ';'
	jnz		@f
	mov		al, 0Dh
	xchg	esi, edi
	repnz	scasb			; fukken scas werks over edi
	xchg	esi, edi
	;cmp		byte ptr [esi], 10h
	;jnz		.next
	;inc		esi
	jmp		.next
@@: cmp		al, '+'
	jnz		@f
	inc		byte ptr [edi]
	jmp		.next
@@:	cmp		al, '-'
	jnz		@f
	dec		byte ptr [edi]
	jmp		.next
@@: cmp		al, '>'
	jnz		@f
	inc		edi
	;cmp		edi, offset brainfuck?_cells+BRAINFUCK_DATA_SIZE
	;js		.ceil
	;mov		edi, offset brainfuck?_cells
;.ceil:
	jmp		.next
@@: cmp		al, '<'
	jnz		@f
	dec		edi
	;cmp		edi, offset brainfuck?_cells
	;jnc		.floor
	;mov		edi, offset brainfuck?_cells
	;add		edi, BRAINFUCK_DATA_SIZE
;.floor:
	jmp		.next

@@: cmp		al, '['
	jnz		@f
	; the instructions at [ ... ] are executed if byte at [edi] == 0
	push	esi
	dec		dword ptr [esp]

	cmp		byte ptr [edi], 0
	jnz		.next
	test	ebx, ebx
	;jnz		.branch			; fuck you branch caching
	xor		ebx, ebx
	dec		esi
.block:
	cmp		byte ptr [esi], '['
	jnz		.rb
	inc		ebx
.rb:cmp		byte ptr [esi], ']'
	jnz		.lb
	dec		ebx
.lb:inc		esi
	test	ebx, ebx
	jnz		.block
	mov		ebx, esi

.branch:
	pop		esi
	mov		esi, ebx
	xor		ebx, ebx
	jmp		.next

@@:	cmp		al, ']'
	jnz		@f
	mov		ebx, esi
	cmp		dword ptr [esp], -1
	jz		.next
	pop		esi
	jmp		.next

@@: cmp		al, '.'
	jnz		@f
	call	interpreter?console?putchar
	jmp		.next
@@:	cmp		al, ','
	jnz		.next
	;jnz		@f
	call	interpreter?console?getchar
@@:	jmp		.next	
.halt:

@@:	cmp		dword ptr [esp], -1
	jz		@f
	add		esp, 4
	jmp		@b
@@:	leave
	ret
