program ej;
const
	valorAlto = 'zzz';
type
	distribucion = record
		nom: string[40];
		anio: integer;
		num: integer;
		cant: integer;
		desc: string[40];
	end;
	
	maestro = file of distribucion;	//se dispone
	
procedure leer(var mae: maestro; var d: distribucion);
begin
	if(not EOF(mae))then
		read(mae, d)
	else
		d.nom:= valorAlto;
end;

procedure leerDis(var d: distribucion);
begin
	writeln('');
	readln(d.nom);
	if(d.nom <> valorAlto)then begin
		writeln('');
		readln(d.anio);
		writeln('');
		readln(d.num);
		writeln('');
		readln(d.cant);
		writeln('');
		readln(d.desc);
	end;
end;

function buscarDistribucion(var mae: maestro; nombre: string): integer;
var
	d: distribucion;
	aux: integer;
begin
	reset(mae);
	aux:= -1;
	leer(mae, d);
	while(d.nom <> valorAlto)do begin
		if(d.nom = nombre)then
			aux:= filepos(mae);
		leer(mae, d);
	end;
	close(mae);
	buscarDistribucion:= aux;
end;

procedure altaDistribucion(var mae: maestro; nueva: distribucion);
var
	d: distribucion;
	pos, cab: integer;
begin
	pos:= buscarDistribucion(mae, nueva.nom);
	if(pos = -1)then begin
		reset(mae);
		leer(mae, d); //leo cabecera para ver si hay lugares libres
		if(d.cant < 0)then begin
			cab:= filepos(mae) - 1;
			seek(mae, (d.cant*-1));
			leer(mae, d);
			seek(mae, filepos(mae) - 1);
			write(mae, nueva);
			seek(mae, cab);
			write(mae, d);
		end
		else begin
			seek(mae, filesize(mae));
			write(mae, nueva);
		end;
		close(mae);
		writeln('Se guardo correctamente la nueva distribucion')
	end
	else
		writeln('Ya existe la distribucion');
end;

procedure bajaDistribucion(var mae: maestro; borrar: string);
var
	d, cab: distribucion;
	pos: integer;
begin
	pos:= buscarDistribucion(mae, borrar);
	if(pos = -1)then 
		writeln('Distribucion no existente')
	else begin
		reset(mae);
		leer(mae, cab);  //leo cabecera
		seek(mae, pos);
		leer(mae, d);
		seek(mae, filepos(mae) - 1);
		write(mae, cab); //guardo dato de cabecera en el borrado
		seek(mae, 0);
		d.cant:= pos * -1; //actualizo el campo desarrolladores con la pos borrada
		write(mae, d);  //guardo nueva cabecera
		close(mae);
	end;
end;

var
	mae: maestro;
	d: distribucion;
	op: integer;
begin
	assign(mae, 'distribucionesLinux');
	rewrite(mae);
	{cargarArchivo(mae); //se dispone}
	writeln('Ingrese la accion a realizar: 1. Buscar - 2. Alta - 3. Baja');
	readln(op);
	leerDis(d);
	case op of
		1: buscarDistribucion(mae, d.nom);
		2: altaDistribucion(mae, d);
		3: bajaDistribucion(mae, d.nom);
		else writeln('Accion invalida');
	end;
end.



