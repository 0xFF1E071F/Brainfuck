;-----------------------------------------------------------------------
extern	CreateFileA@28	  :near
extern	ReadFile@20		  :near
extern	CloseHandle@4	  :near
extern  GetCommandLineA@0 :near
extern	WriteFile@20	  :near

;-----------------------------------------------------------------------
.data?
	io?_hscript			dd	?
	io?_script?bytesread	dd	?
	io?_script?buffer	db 1024*500 dup(?)

;-----------------------------------------------------------------------
.code
io?initialize:

	ret

io?script?load:
	push	ebp
	mov		ebp, esp
	push	0
	push	80h		 ;FILE_ATTRIBUTE_NORMAL
	push	3		 ;OPEN_EXISTING
	push	0
	push	1		 ;FILE_SHARE_READ
	push	80000000h;GENERIC_READ
	push	[ebp+8]
	call	CreateFileA@28
	cmp		eax, -1
	jz		@f
	mov		io?_hscript, eax
	push	0
	push	offset io?_script?bytesread
	push	sizeof io?_script?buffer
	push	offset io?_script?buffer
	push	eax
	call	ReadFile@20
	push	eax
	push	io?_hscript
	call	CloseHandle@4
	pop		eax
	dec		eax
	js		@f
	mov		eax, offset io?_script?buffer
@@: leave
	ret

io?script?save:
	push	ebp
	mov		ebp, esp
	push	0
	push	80h		 ;FILE_ATTRIBUTE_NORMAL
	push	3		 ;OPEN_EXISTING
	push	0
	push	2		 ;FILE_SHARE_READ
	push	0C0000000h;GENERIC_READ
	push	[ebp+8]
	call	CreateFileA@28
	cmp		eax, -1
	jz		@f
	push	0
	push	offset io?_script?bytesread
	push	sizeof io?_script?buffer
	push	offset io?_script?buffer
	push	eax
	call	WriteFile@20
	push	io?_hscript
	call	CloseHandle@4
@@:	leave
	ret
	
io?script?length:
	and		al, 0
	mov		ecx, -1
	repnz	scasb
	not		ecx
	ret
	
io?console?argv:
	push	ebp
	mov		ebp, esp
	
	call	GetCommandLineA@0
	mov		edi, eax
	movzx	eax, byte ptr [edi]
	inc		edi
	and		ecx, 0
	dec		ecx
	repne	scasb
	cmp		byte ptr [edi], 0
	jz		.end
	
	mov		esi, edi
	inc		esi
@@:	inc		edi
	cmp		byte ptr [edi], 0
	jz		@f
	cmp		byte ptr [edi], 20h
	jnz		@b
	and		byte ptr [edi], 0
	jmp		@b
@@: and		eax, 0
	mov		edi, esi
@@:	cmp		[ebp+8], eax
	jz		@f

	inc		edi
	cmp		byte ptr [edi], 0
	jnz		@b
	inc		eax
	jmp		@b
	
@@:	dec		edi
	
	mov		eax, edi
	leave
	ret
.end:
	xor		eax, eax
	leave
	ret
	

;-----------------------------------------------------------------------
