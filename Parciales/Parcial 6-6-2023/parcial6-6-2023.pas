program parcial;
const
	valorAlto = 9999;
type
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	
	empleado = record
		dni: integer;
		nom: string[30];
		ape: string[30];
		edad: integer;
		dom: string[30];
		nacimiento: fecha;
	end;

	archivo = file of empleado;
	
procedure leer(var a: archivo; var e: empleado);
begin
	if(not EOF(a))then
		read(a, e)
	else
		e.dni:= valorAlto;
end;

function existeEmpleado(var a: archivo; dni: integer): boolean; //no hace falta implementar
var
	e: empleado;
	ok: boolean;
begin
	ok:= false;
	leer(a, e);
	while(e.dni <> valorAlto) and (not ok)do begin
		if(e.dni = dni)then
			ok:= true;
		leer(a, e);
	end;
	existeEmpleado:= ok;
end;

procedure leerFecha(var f: fecha);
begin
	readln(f.dia);
	readln(f.mes);
	readln(f.anio);
end;

procedure leerEmpleado(var e: empleado);
begin
	writeln('Ingrese el dni del empleado');
	readln(e.dni);
	writeln('Ingrese el nombre del empleado');
	readln(e.nom);
	writeln('Ingrese el apellido del empleado');
	readln(e.ape);
	writeln('Ingrese la edad del empleado');
	readln(e.edad);
	writeln('Ingrese el domicilio del empleado');
	readln(e.dom);
	writeln('Ingrese la fecha de nacimiento del empleado');
	leerFecha(e.nacimiento);
end;

procedure agregar(var a: archivo);
var
	cabecera, e, nuevo: empleado;
	pos: integer;
begin
	writeln('Ingrese los datos del empleado a agregar');
	leerEmpleado(nuevo);
	reset(a);
	if(not existeEmpleado(a, nuevo.dni))then begin
		leer(a, cabecera);
		if(cabecera.dni < 0)then begin
			pos:= cabecera.dni * -1;
			seek(a, pos);
			leer(a, e);
			seek(a, filepos(a) - 1);
			write(a, nuevo);
			seek(a, 0);
			write(a, e);
		end
		else begin
			seek(a, filesize(a));
			write(a, nuevo);
		end;
	end
	else
		writeln('El elmpleado de dni ', nuevo.dni, ' ya existe');
	close(a);
end;

procedure eliminar(var a: archivo);
var
	dni: integer;
	cabecera, e: empleado;
begin
	writeln('Ingrese el dni del empleado a eliminar');
	readln(dni);
	reset(a);
	if(existeEmpleado(a, dni))then begin //preguntar si tengo que buscar el empleado en el archivo o puedo usar dni como pos
		leer(a, cabecera);
		e.dni:= cabecera.dni;
		ok:= false;
		while(e.dni <> dni)do begin //no hace falta preguntar por valor alto porque ya se que existe
			leer(a, e);
		end;
		seek(a, filepos(a) - 1);
		write(a, cabecera); 
		seek(a, 0);
		e.dni:= (filepos(a)-1) * -1: //pos del borrado
		write(a, e); 
	end
	else
		writeln('El empleado de dni ', dni, ' no existe');
	close(a);
end;
			
var
	op: integer;
	a: archivo;
begin
	assign(a, 'archivoEmpleados');
	writeln('Ingrese la accion a realizar. 1. Alta - 2. Baja');
	readln(op);
	case op of
		1: agregar(a);
		2: eliminar(a);
		else writeln('La opcion ingresada no existe');
	end;
end.







