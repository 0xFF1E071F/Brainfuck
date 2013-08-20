@echo off
set filename=main

set masm=z:\programs\development\rce\assemblers\masm
set path=%path%%masm%\bin

set masm_inc=%masm%\include
set masm_lib=%masm%\lib


%masm%\bin\ml  /c /coff /nologo  /I%masm_inc% /I%masm%\macros /I%cd%\include /I%cd%\..\common /Fo%cd%\bin\%filename%.obj %filename%.asm
%masm%\bin\link /libpath:%masm_lib% /nologo /SUBSYSTEM:CONSOLE %cd%\bin\%filename%.obj /out:bin\%filename%.exe

echo Asphyxia//MAL
pause>nul