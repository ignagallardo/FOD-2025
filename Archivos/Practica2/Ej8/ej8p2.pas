{8. Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.

Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.

Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.

Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.

Nota: cada archivo debe recorrerse una única vez}

program ej8;
const
	valorAlto = 9999;
	df = 16;
type
	reg_maestro = record
		cod: integer;
		nom: string;
		habitantes: integer;
		total: real;
	end;
	
	reg_detalle = record
		cod: integer;
		cant: real;
	end;
	
	maestro = file of reg_maestro;
	detalle = file of reg_detalle;
	
	vec_detalles = array [1..df] of detalle;
	vec_registro = array [1..df] of reg_detalle;
	
procedure leerDetalle(var det: detalle; var reg: reg_detalle);
begin
	if(not EOF(det))then
		read(det, reg)
	else
		reg.cod:= valorAlto;
end;

procedure leerMaestro(var mae: maestro; var reg_mae: reg_maestro);
begin
	if(not EOF(mae))then
		read(mae, reg_mae)
	else
		reg_mae.cod:= valorAlto;
end;

procedure minimo(var vec: vec_detalles; var min: reg_detalle; var vec_reg: vec_registro);
var
	i, pos: integer;
begin
	min.cod:= valorAlto;
	for i:= 1 to df do begin
		if(vec[i].cod < min.cod)then begin
			min:= vec[i];
			pos:= i;
		end;
	end;
	if(min.cod <> valorAlto)then
		leerDetalle(vec[pos], vec_reg[pos]);
end;

procedure actualizarMaestro(var mae: maestro; var vec: vec_detalles);
var
	aux, min: reg_detalle;
	vec_reg: vec_registro;
	reg: reg_maestro;
	i: integer;
begin
	reset(mae);
	
	for i:= 1 to df do begin
		reset(vec[i]);
		leerDetalle(vec[i], vec_reg[i]);
	end;
	
	leerMaestro(mae, reg);
	
	while(reg.cod <> valorAlto)do begin
		minimo(vec, min, vec_reg);
		if(reg.cod = min.cod)then begin	
			aux.cod:= min.cod;
			while(aux.cod = min.cod) and (min.cod <> valorAlto)do begin
				reg.total:= reg.total + min.cant;
				minimo(vec, min, vec_reg);
			end;
			seek(mae, filepos(mae) - 1);
			write(mae, reg);
		end;
		if(reg.total > 10000)then
			writeln('Codigo de provincia ', reg.cod, ', nombre de provincia ', reg.nom, '. Promedio de consumo ', (reg.total/reg.habitantes), 
			' kg de yerba por persona');
		leerMaestro(mae, reg);
	end;
	
	close(mae);
	for i:= 1 to df do 
		close(vec[i]);
end;

var
	mae: maestro;
	vec: vec_detalles;
	i: integer;
	cadena: string;
begin
	assign(mae, 'archivoMaestro');
	for i:= 1 to df do begin
		cadena:= 'detalle' + i;
		assign(vec[i], cadena);
	end;
	actualizarMaestro(mae, vec);
end.








