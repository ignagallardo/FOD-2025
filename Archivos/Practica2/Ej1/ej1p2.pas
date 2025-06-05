{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program ej1;
const
	valorAlto = 9999;
type
	empleado = record
		cod: integer;
		nom: string[40];
		monto: real;
	end;
	
	arch = file of empleado;
	
procedure leer(var a: arch; var e: empleado);
begin
	if(not EOF(a))then
		read(a, e)
	else
		e.cod:= valorAlto;
end;

procedure cargarEmpleados(var a: arch);
var
	e: empleado;
begin
	assign(a, 'archivoEmpleados');
	rewrite(a);
	writeln('Ingrese el codigo del empleado');
	readln(e.cod);
	while(e.cod <> -1)do begin
		writeln('Ingrese el nombre del empleado');
		readln(e.nom);
		writeln('Ingrese el monto de comision del empleado');
		readln(e.monto);
		write(a, e);
		writeln('Ingrese el codigo de empleado');
		readln(e.cod);
	end;
	close(a);
end;

procedure cargarCompacto(var a: arch; var com: arch);
var
	e: empleado;
	codActual: integer;
	montoTotal: real;
begin
	assign(com, 'archivoCompacto');
	rewrite(com);
	reset(a);
	leer(a, e);
	while(e.cod <> valorAlto)do begin
		codActual:= e.cod;
		montoTotal:= 0;
		while(e.cod <> valorAlto) and (codActual = e.cod)do begin
			montoTotal:= montoTotal + e.monto;
			leer(a, e);
		end;
		e.monto:= montoTotal;
		write(com, e);
	end;
	close(a);
	close(com);
end;

procedure cargarTexto(var com: arch);
var
	txt:text; e: empleado;
begin
	assign(txt, 'archivoTexto.txt');
	rewrite(txt);
	reset(com);
	while(not EOF(com))do begin
		read(com, e);
		writeln(txt, 'Codigo ', e.cod, 'Comision ', e.monto:0:2, 'Nombre ', e.nom);
	end;
	close(com);
	close(txt);
end;

var
	a: arch; 
	com: arch;
begin
	cargarEmpleados(a);
	cargarCompacto(a, com);
	cargarTexto(com);
end.




