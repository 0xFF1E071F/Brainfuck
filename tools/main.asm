;-----------------------------------------------------------------------
.386
.model flat, stdcall
option casemap:none
option dotname

;-----------------------------------------------------------------------
includelib	kernel32.lib

extern  ExitProcess@4     :near
	
;-----------------------------------------------------------------------
.code
	include	io.asm

start:
	push	1
	call	io?console?argv
	test	eax, eax
	jz		@f
	push	eax
	call	io?initialize
	;push	eax			; fall through
	call	io?script?load
	test	eax, eax
	js		@f

	
	push	2
	call	io?console?argv
	call	io?script?save
@@: push	0
    call	ExitProcess@4
    
    ret		; wait... what?

end start
;-----------------------------------------------------------------------

