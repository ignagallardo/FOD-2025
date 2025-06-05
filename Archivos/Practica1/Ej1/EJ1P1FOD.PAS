{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.}
program ej1p1;
type
	archivo= file of integer;

procedure carga(var arch: archivo);
var
	num:integer;
begin
	rewrite(arch);
	writeln('ingrese num');
	readln(num);
	while(num<>30000)do
	begin
		write(arch, num);
		writeln('ingrese num');
		readln(num);
	end;
	close(arch);
end;
var
	nombreFisico:string; arch:archivo; num:integer;
begin
	writeln('ingrese nom');
	readln(nombreFisico);
	assign(arch, nombreFisico);
	carga(arch);
	reset(arch);
	while not(eof(arch))do
	begin
		writeln(filepos(arch));
		read(arch, num);
		writeln(filepos(arch));
		writeln('el numero es ', num);
	end
end.
