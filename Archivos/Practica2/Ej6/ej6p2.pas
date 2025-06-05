{6. Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. 

Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas)}

program ej6;
const
	valorAlto = 9999;
	df = 10;
type
	infoMae = record
		codLoc: integer;
		localidad: string[40];
		codCepa: integer;
		cepa: string[20];
		activos: integer;
		nuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;
	
	infoDet = record
		codLoc: integer;
		codCepa: integer;
		activos: integer;
		nuevos: integer;
		recuperados: integer;
		fallecidos: integer;
	end;

	maestro = file of infoMae;
	detalle = file of infoDet;
	
	vector = array [1..df] of detalle;
	vectorReg = array [1..df] of infoDet;
	
procedure leer(var det: detalle; var info: infoDet);
begin
	if(not EOF(det))then
		read(det, info)
	else
		info.codLoc = valorAlto;
end;

procedure minimo(var vec: vector; var min: infoDet; var vr: vectorReg);
var
	i, pos: integer;
begin
	min.codLoc:= valorAlto;
	for i:= 1 to df do begin
		if(vr[i].codLoc < min.codLoc) or ((min.codloc = vector[i].codloc) and (min.codcep > vector[i].codcep))then begin {proque ahora tengo dos condiciones}
			min:= vr[i];
			pos:= i;
		end;
	end;
	if(min.codLoc <> valorAlto)then
		leer(vec[pos], vr[pos]);
end;

procedure actualizarMaestro(var mae: maestro; var vec: vector);
var
	i: integer;
	min, aux: infoDet;
	vr: vectorReg;
	rm: infoMae;
begin
	reset(mae);
	for i:= 1 to df do begin
		reset(v[i]);
		leer(vec[i], vr[i]); {me guardo el registro de cada archivo detalle}
	end;
	minimo(vec, min, vr);
	read(mae, rm);
	while(min.codLoc <> valorAlto)do begin
		aux.codLoc:= min.codLoc;
		while(aux.codLoc = min.codLoc)do begin
			aux.codCepa:= min.codCepa;
			aux.fallecidos:= 0;
			aux.recuperados:= 0;
			aux.activos:= 0;
			aux.nuevos:= 0;
			while((aux.codLoc = min.codLoc) and (aux.codCepa = min.codCepa))do begin
				aux.fallecidos:= aux.fallecidos + min.fallecidos;
				aux.recuperados:= aux.recuperados + min.recuperados;
				aux.activos:= aux.activos + min.activos;
				aux.nuevos:= aux.nuevos + min.nuevos;
				minimo(vec, min, vr);
			end;
			while(rm.codLoc <> aux.codLoc) or (rm.codCepa <> aux.codCepa)do 
				read(mae, rm);
			rm.fallecidos:= aux.fallecidos;
			rm.recuperados:= aux.recuperados;
			rm.activos:= aux.activos;
			rm.nuevos:= aux.nuevos;
			seek(mae, filepos(mae)-1);
			write(mae, r,m);
		end;
	end;
	close(mae);
	for i:= 1 to df do
		close(vec[i]);
end;

procedure informarCantLocalidades(var mae: maestro);
var
	cant: integer;
	rm: infoMae;
begin
	cant:= 0;
	reset(mae);
	while(not EOF(mae))do begin
		read(mae, rm);
		if(rm.activos > 50)then
			cant:= cant + 1;
	end;
	close(mae);
end;

var
	mae: maestro;
	vec: vector;
	i: integer;
	cadena: string;
begin
	writeln('Ingrese el nombre del archivo maestro');
	readln(cadena);
	assign(mae, cadena);
	for i:= 1 to df do begin
		writeln('Ingrese el nombre del archivo detalle ', i);
		readln(cadena);
		assign(det[i], cadena);
	end;
	actualizarMaestro(mae, vec);
end.


