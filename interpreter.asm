;-----------------------------------------------------------------------
extern	GetStdHandle@4	  :near
extern	SetConsoleMode@8  :near
extern	CreateFileA@28	  :near
extern	ReadFile@20		  :near
extern	CloseHandle@4	  :near
extern  GetCommandLineA@0 :near
extern	WriteFile@20	  :near

;-----------------------------------------------------------------------
.data?
	interpreter?_hconsole		dd	?
	interpreter?_hscript		dd	?
	interpreter?_console?bytesread	dd	?
	interpreter?_script?buffer	db 1024*500 dup(?)

;-----------------------------------------------------------------------
.code
interpreter?initialize:
	push    -11
	call    GetStdHandle@4
	mov		interpreter?_hconsole, eax
    push	4 or 2 or 1
	push    interpreter?_hconsole
	call    SetConsoleMode@8
	ret

interpreter?script?load:
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
	mov		interpreter?_hscript, eax
	push	0
	push	offset interpreter?_console?bytesread
	push	sizeof interpreter?_script?buffer
	push	offset interpreter?_script?buffer
	push	eax
	call	ReadFile@20
	push	eax
	push	interpreter?_hscript
	call	CloseHandle@4
	pop		eax
	dec		eax
	js		@f
	mov		eax, offset interpreter?_script?buffer
@@: leave
	ret

interpreter?script?length:
	and		al, 0
	mov		ecx, -1
	repnz	scasb
	not		ecx
	ret
	
interpreter?console?argv:
	call	GetCommandLineA@0
	mov		edi, eax
	movzx	eax, byte ptr [edi]
	inc		edi
	and		ecx, 0
	dec		ecx
	repne	scasb
	cmp		byte ptr [edi], 0
	jz		@f
	inc		edi
	mov		eax, edi
	ret
@@:	xor		eax, eax
	ret
	
interpreter?console?getchar:
	push	ecx
	
	push	0
	push	offset interpreter?_console?bytesread
	push	1
    push	edi
    push	interpreter?_hconsole
    call	ReadFile@20
    
    pop		ecx
	ret

interpreter?console?putchar:
	push	ecx
	
	push	0
	push	offset interpreter?_console?bytesread
	push	1
    push	edi
    push	interpreter?_hconsole
    call	WriteFile@20
    
    pop		ecx
	ret

;-----------------------------------------------------------------------
