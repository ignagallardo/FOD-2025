program parcial;
const 
	valorAlto = 9999;
	dimF = 30;
type
	rango = 1..dimF;
	
	dato = record
		cod: integer;
		nom: string[50];
		casos: integer;
	end;
	
	informe = record
		cod: integer;
		casos: integer;
	end;
	
	maestro = file of dato;
	detalle = file of informe;
	
	vecDet = array[rango] of detalle;
	vecInfo = array[rango] of informe;
	
procedure leer(var det: detalle; var i: informe);
begin
	if(not EOF(det))then
		read(det, i)
	else
		i.cod:= valorAlto;
end;

procedure minimo(var v: vecDet; var v2: vecInfo; var min: informe);
var
	i, pos: integer;
begin
	min.cod:= valorAlto;
	for i:= 1 to dimF do begin
		if(v2[i].cod < min.cod)then begin
			min:= v2[i];
			pos:= i;
		end;
	end;
	
	if(min.cod <> valorAlto)then
		leer(v[pos], v2[pos]);
end;

procedure actualizar(var mae: maestro; var v: vecDet);
var
	min: informe;
	d: dato;
	i, codAct, cant: integer;
	v2: vecInfo;
begin
	reset(mae);
	for i:= 1 to dimF do begin
		reset(v[i]);
		leer(v[i], v2[i]);
	end;
	minimo(v, v2, min);
	while(min.cod <> valorAlto)do begin
		codAct:= min.cod;
		cant:= 0;
		while(min.cod <> valorAlto) and (codAct = min.cod)do begin
			cant:= cant + min.casos;
			minimo(v, v2, min);
		end;
		read(mae, d);
		while(d.cod <> codAct)do begin
			if(d.casos > 15)then
				writeln('El municipio ', d.cod, ', registro un total de ', d.casos, ' casos positivos de dengue');
			read(mae, d);
		end;
		seek(mae, filepos(mae) - 1);
		d.casos:= d.casos + cant;
		write(mae, d);
	end;
	close(mae);
	for i:= 1 to dimF do 
		close(v[i]);
end;
	
var
	mae: maestro;
	v: vecDet;
	nombre: string[30];
	i: integer;
begin
	//cargarMaestro(mae);
	//cargarDetalles(v);
	writeln('Ingrese el nombre del archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	for i:= 1 to dimF do begin
		writeln('Ingrese el nombre del archivo maestro');
		readln(nombre);
		assign(v[i], nombre);
	end;
end.
	
	
	
	
