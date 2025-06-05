{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program ej3;
const
	valorAlto = 'ZZZZ';
type
	regMae = record
		nom: string[20];
		cant: integer;
		total: integer;
	end;
	
	regDet = record
		nom: string[20];
		cod: integer;
		cant: integer;
		total: integer;
	end;
	
	maestro = file of regMae;
	detalle = file of regDet;
	
procedure leer(var det: detalle; var rd: regDet);
begin
	if(not EOF(det))then
		read(det, rd)
	else
		rd.nom:= valorAlto;
end;

procedure cargarMaestro(var mae: maestro);
var
	rm: regMae;
begin
	assign(mae, 'archivoMaestro');
	rewrite(mae);
	writeln('Ingrese el nombre de provincia');
	readln(rm.nom);
	while(rm.nom <> 'ZZZZ')do begin
		writeln('Ingrese la cantidad de personas alfabetizadas');
		readln(rm.cant);
		writeln('Ingrese el total de personas encuestadas');
		readln(rm.total);
		read(mae, rm);
		writeln('Ingrese el nombre de provincia');
		readln(rm.nom);
	end;
	close(mae);
end;

procedure minimo(var d1: detalle; var d2: detalle; var min: regDet; var reg1: regDet; var reg2: regDet);
begin
	if(reg1.nom <= reg2.nom)then begin
		min:= reg1;
		leer(d1, reg1);
	end
	else begin
		min:= reg2;
		leer(d2, reg2);
	end;
end;

procedure actualizarMaestro(var mae: maestro; var det, det2: detalle);
var
	rm: regMae;
	rd, rd2: regDet;
	min: regDet;
begin
	reset(mae);
	reset(det);
	reset(det2);
	leer(det, rd);
	leer(det2, rd2);
	minimo(det, det2, min, rd, rd2);
	while(min.nom <> valorAlto)do 
	begin
		read(mae, rm);
		while(rm.nom <> min.nom)do
			read(mae, rm);
		while(rm.nom = min.nom)do begin
			rm.cant:= rm.cant + min.cant;
			rm.total:= rm.total + min.total;
			minimo(det, det2, min, rd, rd2);
		end;
		seek(mae, filepos(mae)-1);
		write(mae, rm);
	end;
	close(mae);
	close(det);
	close(det2);
end;

var
	mae: maestro;
	det: detalle;
	det2: detalle;
begin
	assign(det, 'detalle1');
	assign(det2, 'detalle2');
	//cargarMaestro(mae);
	actualizarMaestro(mae, det, det2);
end.
