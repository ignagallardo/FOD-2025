@echo off
d:\dev-pas\bin\dlltool.exe -S d:\dev-pas\bin\asw.exe -D d:\documentos\nacho\fod\archivos\practica1\ej5\ej5p1.exe -e exp.$$$ -b base.$$$ -d ej5p1.def
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
