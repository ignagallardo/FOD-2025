{Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
{Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente

procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado}

program ej3;
const
	valorAlto = 9999;
type
	reg_flor = record
		nom: String[45];
		cod: integer;
	end;
	
	archivo = file of reg_flor

procedure leer(var a: archivo; var r: reg_flor);
begin
	if(not EOF(a))then
		read(a, r)
	else
		reg_flor.cod:= valorAlto;
end;

procedure agregar(var a: archivo; nombre: string; codigo: integer);
var
	r: reg_flor;
	pos: integer;
begin
	reset(a);
	leer(a, r);
	if(r.cod < 0)then begin
		seek(r.cod * -1);
		read(a, r);
		pos:= r.cod;
		seek(a, filepos - 1);
		write(a, nombre, codigo);
		seek(a, 0);
		write(a, pos);
	end
	else begin
		while(r.cod <> valorAlto)do
			leer(a, r);
	end;
	close(a);
end;

procedure listarSinEliminadas(var a: archivo);
var
	r: reg_flor;
begin
	reset(a);
	leer(a, r);
	while(r.cod <> valorAlto)do begin
		if(r.cod > 0)then			//consultar condicion para evitar eliminadas
			writeln(r.nom, r.cod);
		leer(a, r);
	end;
	close(a);
end;

procedure eliminarFlor(var a: archivo; flor: reg_flor);
var
	r, cabecera: reg_flor;
begin
	reset(a);
	leer(a, cabecera);
	r:= cabecera;
	while(r.cod <> valorAlto and r.cod <> flor.cod)do 
		leer(a, r);
	if(r.cod = flor.cod)then begin
		seek(a, filepos -1);
		write(a, cabecera); //escribo los datos que estaban en la cabecera en el ultimo eliminado
		seek(a, 0);
		r.cod:= r.cod * -1;
		write(a, r); //escribo los datos del ultimo eliminado en la cabecera
	end;
	close(a);
end;

var
	a: archivo;
	nombre: string;
	codigo: integer;
	flor: reg_flor;
begin
	//cargarArchivo
	writeln('Ingrese el nombre');
	readln(nombre);
	writeln('Ingrese el codigo');
	readln(codigo);
	agregar(a, nombre, codigo);
	
	listarSinEliminadas(a);
	
	writeln('Ingrese flor a eliminar');
	readln(flor.cod);
	eliminarFlor(a, flor);
	 
	listarSinEliminadas(a);
end.



