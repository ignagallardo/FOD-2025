{10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.

Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___

NOTA: La información está ordenada por código de provincia y código de localidad.}


program ej10;
const
	valorAlto = 9999;
type
	votos = record
		prov: integer;
		loc: integer;
		mesa: integer;
		cant: integer;
	end;
	
	maestro = file of votos;
	
procedure leer(var mae: maestro; var v: votos);
begin
	if(not EOF(mae))then
		read(mae, v)
	else
		v.prov:= valorAlto;
end;

procedure recorrer(var mae: maestro);
var
	cantLoc: integer;
	cantProv: integer;
	total: integer;
	cod: integer;
	loc: integer;
	v: votos;
begin
	reset(mae);
	
	total:= 0;
	leer(mae, v);
	while(v.prov <> valorAlto)do 
	begin
		cod:= v.prov;
		cantProv:= 0;
		writeln('Provincia: ', v.prov);
		while(v.prov = cod)do
		begin
			loc:= v.loc;
			cantLoc:= 0;
			writeln('Localidad:', v.loc);
			while(v.prov = cod) and (v.loc = loc)do 
			begin
				cantLoc:= cantLoc + v.cant;
				leer(mae, v);
			end;
			writeln('Total votos localidad: ', cantLoc);
			writeln('...................... ..............');
			cantProv:= cantProv + cantLoc;
		end;
		writeln('...................... ..............');
		writeln('Total votos provincia: ', cantProv);
		total:= total + cantProv;
	end;
	writeln('Cantidad total de votos: ', total);
	close(mae);
end;

var
	mae: maestro;
begin
	recorrer(mae);
end.










