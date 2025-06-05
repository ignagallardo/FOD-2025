{4. Agregar al menú del programa del ejercicio 3, opciones para:

a. Añadir uno o más empleados al final del archivo con sus datos ingresados por
teclado. Tener en cuenta que no se debe agregar al archivo un empleado con
un número de empleado ya registrado (control de unicidad).

b. Modificar la edad de un empleado dado.

c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.

d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}

program ej3p1fod;
type
	empleado=record
		numEmp:integer;
		ape:string;
		nom:string;
		edad:integer;
		dni:integer;
	end;
	archivo=file of empleado;
	
	archTexto= text;
	
	textoDni = text;

procedure leer(var e:empleado);
begin
	writeln('ingrese ape');
	readln(e.ape);
	if(e.ape<>'fin')then
	begin
		writeln('numero emple');
		readln(e.numEmp);
		writeln('nombre');
		readln(e.nom);
		writeln('edad');
		readln(e.edad);
		writeln('dni');
		readln(e.dni);
	end;
end;
procedure carga(var arch:archivo);
var
	emp:empleado;
begin
	rewrite(arch);
	leer(emp);
	while(emp.ape<>'fin')do
	begin
		write(arch, emp);
		leer(emp);
	end;
	close(arch);
end;
procedure imprimirEmpleado( e:empleado);
begin
		writeln('numero emple', e.numEmp);
		writeln('apellido', e.ape);
		writeln('nombre', e.nom);
		writeln('edad', e.edad);
		writeln('dni', e.dni);
end;

procedure listarPorNombre(var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	while not(eof(arch))do
	begin
		read(arch, e);
		imprimirEmpleado(e);
	end;
	close(arch);
end;

procedure imprimirEmp(var arch: archivo);
var
	e: empleado; persona:string;
begin
	writeln('INGRESE APEllido o nombre');
	readln(persona);
	reset(arch);
	while not eof(arch)do
	begin
		read(arch, e);
		if(e.nom = persona) then 
			imprimirEmpleado(e)
		else if(e.ape = persona) then
			imprimirEmpleado(e);
	end;
	close(arch);
end;
procedure imprimirJubilados(var arch:archivo);
var
	e:empleado;
begin
	reset(arch);
	while not(eof(arch))do
	begin
		read(arch, e);
		if(e.edad>70)then
		begin
			imprimirEmpleado(e);
		end;
	end;
	close(arch);
end;

procedure agregar (var arch: archivo);
var
	e, emp: empleado; ok: boolean;
begin
	reset(arch);
	leer(e);
	while(e.ape<> 'fin') do {preguntar si esta bien la condicion}
	begin
		ok:= false;
		while not eof(arch) and not ok do
		begin
			read(arch, emp);
			if(emp.numEmp = e.numEmp)then
				ok:= true;
		end;
		if(ok = false)then
			write(arch, e);
		leer(e);
	end;
	close(arch);
end;

procedure actualizar(var arch: archivo);
var
 ok: boolean; e: empleado; num, edadNueva: integer;
begin
	writeln('Ingrese un numero de empleado a buscar');
	readln(num);
	writeln('Ingrese la edad a actualizar');
	readln(edadNueva);
	ok:= false;
	reset(arch);
	while not eof(arch) and not ok do
	begin
		read(arch, e);
		if(e.numEmp = num)then
		begin
			ok:= true;
			e.edad:= edadNueva;
			seek(arch, filepos(arch) - 1);
			write(arch, e);
		end;
	end;
	close(arch);
end;

procedure exportarTodo(var arch: archivo; var text: archTexto);
var
	e: empleado;
begin
	assign(text, 'todos_empleados.txt');
	rewrite(text);
	reset(arch);
	while not eof(arch) do
	begin
		read(arch, e);
		with e do
			writeln(text, ' ', numEmp, ' ', ape, ' ', nom, ' ', edad, ' ', dni);
	end;
	writeln('Archivo cargado');
	close(arch);
	close(text);
end;

procedure exportarDni(var dtEmp: textoDni; var arch: archivo);
var
	e: empleado;
begin
	assign(dtEmp, 'faltaDNIEmpleado.txt');
	rewrite(dtEmp);
	reset(arch);
	
	while not eof(arch) do
	begin
		read(arch, e);
		if(e.dni = 00)then
		begin
			with e do
				writeln(dtEmp, ' ', numEmp, ' ', ape, ' ', nom, ' ', edad, ' ', dni);
		end;
	end;
	close(arch);
	close(dtEmp);
end; 

var
	arch: archivo; nombreFisico:string; opcion:integer;
	text: archTexto; dtEmp: textoDni;
begin
	{preguntar si se usa case y si hay que poner la carga en el case}
	writeln('ingrese nombre fisico');
	readln(nombreFisico);
	assign(arch, nombreFisico); {nomFisico.dat}
	carga(arch);
	writeln();
	readln(opcion);
	case opcion of
		1: imprimirEmp(arch);
		2:listarPorNombre(arch);
		3:imprimirJubilados(arch);
		4: agregar(arch);
		5: actualizar(arch);
		6: exportarTodo(arch, text);
		7: exportarDni(dtEmp, arch);
	end;
end.



