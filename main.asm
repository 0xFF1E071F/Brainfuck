;-----------------------------------------------------------------------
; 
%out лллллл                лл          лллллл                 лл    
%out   лл   лл               лл          лл                     лл    
%out   лл   лл                           лл                     лл    
%out   лл   лл  лллл  лллл   лл  лл лл   лл      лл  лл   лллл  лл  лл
%out   лллллл   лл   л   лл  лл  ллл лл  лл      лл  лл  лл  лл лл лл 
%out   лл   лл  лл     лллл  лл  лл  лл  лллл    лл  лл  лл     лллл  
%out   лл   лл  лл    лл лл  лл  лл  лл  лл      лл  лл  лл     лллл  
%out   лл   лл  лл   лл  лл  лл  лл  лл  лл      лл  лл  лл     лл лл 
%out   лл   лл  лл   лл  лл  лл  лл  лл  лл      лл ллл  лл  лл лл лл 
%out лллллл   лл    ллллл  лл  лл  лл  лл       лл лл   лллл  лл  лл
;
; 09.09.10
;	23hs	Sleepy. Checking code.
;			Recoded in common MASM syntax.
;			Recoded in C#.
;			Found teh dammed bug: Branch 'cache' didn't work as expected;
;			 still can't manage to make it work properly.
;			No bound checking anymore. Still checking for stack overflow.
;			Gone to bed.
;			
; 29.09.10
;	10hs	Rainy day. Restart coding.
;			Changed branch format. Using the stack since it's how it manages;
;			 now can have an unlimited (virtually) number of nested blocks.
;			Removed preservation of edx. Using ebx instead.
;			Fixed unseen nested block bug.
;			Added stack control flag.
;			Added data block control.
;			Various testing scripts. Simplier ones werks, others doesn't.
;	11hs	Using extremelly nasty name conventions. Went too far.
;			 Classing brainfuck VM and interpreter (auxiliar functions).
;	12hs	Fukken frustrated can't find teh dammed bug!
;			Gone away.
;
; 28.09.10
;	18hs	Late afternoon. Start coding.
;			Switching to hardcore mode.
;			Switching to DOTNAME. Looks so cool.
;			Done interpreter. Manages input/output.
;			Done data pointer management, data management.
;			Added ';' for single line comments.
;	18:30hs	Problems with nested blocks.
;			Fixed trashing of ecx, edx (interpreter?getchar and setchar
;            caused it - added push reg / pop reg)
;			Still problems with nested blocks.
;	20hs	Gone to dinner.
;	23hs	Gone to sleep.
;
;-----------------------------------------------------------------------
.386
.model flat, stdcall
option casemap:none
option dotname

;-----------------------------------------------------------------------
includelib	kernel32.lib

extrn ExitProcess@4 	:near

;-----------------------------------------------------------------------
.const
	szscriptpath db "test.bf",0
	
;-----------------------------------------------------------------------
.code
	include	interpreter.asm
	include	brainfuck.asm

start:
	call	interpreter?console?argv
	test	eax, eax
	jz		@f
	push	eax
	call	interpreter?initialize
	;push	eax			; fall through
	call	interpreter?script?load
	test	eax, eax
	js		@f
	push	eax
	call	brainfuck?initialize
	call	brainfuck?run
@@: push	0
    call	ExitProcess@4
    
    ret		; wait... what?

end start
;-----------------------------------------------------------------------

