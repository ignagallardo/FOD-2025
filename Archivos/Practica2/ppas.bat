@echo off
d:\dev-pas\bin\dlltool.exe -S d:\dev-pas\bin\asw.exe -D d:\documentos\nacho\fod\archivos\practica2\ej4p2.exe -e exp.$$$ -b base.$$$ -d ej4p2.def
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
