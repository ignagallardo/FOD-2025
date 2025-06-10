{ A partir de un siniestro ocurrido se perdieron las actas de nacimiento y fallecimientos de
toda la provincia de buenos aires de los últimos diez años. En pos de recuperar dicha
información, se deberá procesar 2 archivos por cada una de las 50 delegaciones distribuidas
en la provincia, un archivo de nacimientos y otro de fallecimientos y crear el archivo maestro
reuniendo dicha información.

Los archivos detalles con nacimientos, contendrán la siguiente información: nro partida
nacimiento, nombre, apellido, dirección detallada (calle, nro, piso, depto, ciudad), matrícula
del médico, nombre y apellido de la madre, DNI madre, nombre y apellido del padre, DNI del
padre.

En cambio, los 50 archivos de fallecimientos tendrán: nro partida nacimiento, DNI, nombre y
apellido del fallecido, matrícula del médico que firma el deceso, fecha y hora del deceso y
lugar.

Realizar un programa que cree el archivo maestro a partir de toda la información de los
archivos detalles. Se debe almacenar en el maestro: nro partida nacimiento, nombre,
apellido, dirección detallada (calle, nro, piso, depto, ciudad), matrícula del médico, nombre y
apellido de la madre, DNI madre, nombre y apellido del padre, DNI del padre y si falleció,
además matrícula del médico que firma el deceso, fecha y hora del deceso y lugar. Se
deberá, además, listar en un archivo de texto la información recolectada de cada persona.

Nota: Todos los archivos están ordenados por nro partida de nacimiento que es única. Tenga
en cuenta que no necesariamente va a fallecer en el distrito donde nació la persona y
además puede no haber fallecido.}

program ej19;
const
	valorAlto = 9999;
	dimF = 50;
type
	nacimiento = record
		nro: integer;
		nom: string[20];
		ape: string[20];
		dir: string[20];
		medico: integer;
		nomMadre: string[30];
		dniMadre: integer;
		nomPadre: string[30];
		dniPadre: integer;
	end;
	
	date = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	
	fallecimiento = record
		nro: integer;
		nom: string[20];
		ape: string[20];
		dni: integer;
		medico: integer;
		fecha: date;
		hora: real;
		lugar: string;
	end;
	
	info = record
		nro: integer;
		nom: string;
		ape: string;
		dir: string;
		medico: integer;
		nomMadre: string;
		dniMadre: integer;
		nomPadre: string;
		dniPadre: integer;
		fallecio: boolean;
		medDeceso: integer;
		fecha: date;
		hora: real;
		lugar: string;
	end;
	
	archivoNac = file of nacimiento;
	archivoFal = file of fallecimiento;
	maestro = file of info;
	texto = text;
	
	vectorNac = array[1..dimF] of archivoNac;
	vectorFal = array[1..dimF] of archivoFal;
	vecRegNac = array[1..dimF] of nacimiento;
	vecRegFal = array[1..dimF] of fallecimiento;

procedure leerNac(var a: archivoNac; var n: nacimiento);
begin
	if(not EOF(a))then
		read(a, n)
	else
		n.nro:= valorAlto;
end;

procedure leerFal(var a: archivoFal; var f: fallecimiento);
begin
	if(not EOF(a))then
		read(a, f)
	else
		f.nro:= valorAlto;
end;

procedure minimoNac(var v: vectorNac; var v2: vecRegNac; var min: nacimiento);
var
	pos, i: integer;
begin
	min.nro:= valorAlto;
	for i:= 1 to dimF do begin
		if(v2[i].nro < min.nro)then begin
			min:= v2[i];
			pos:= i;
		end;
	end;
	
	if(min.nro <>valorAlto)then
		leerNac(v[pos], v2[pos]);
end;

procedure minimoFal(var v: vectorFal; var v2: vecRegFal; var min: fallecimiento);
var
	pos, i: integer;
begin
	min.nro:= valorAlto;
	for i:= 1 to dimF do begin
		if(v2[i].nro < min.nro)then begin
			min:= v2[i];
			pos:= i;
		end;
	end;
	
	if(min.nro <>valorAlto)then
		leerFal(v[pos], v2[pos]);
end;

procedure cargarMaestro(var m: maestro; var vNac: vectorNac; var vFal: vectorFal);
var
	min: nacimiento;
	min2: fallecimiento;
	v2Nac: vecRegNac;
	v2Fal: vecRegFal;
	i: integer;
	d: info;
begin
	rewrite(m);
	for i:= 1 to dimF do begin
		reset(vNac[i]);
		reset(vFal[i]);
		leerNac(vNac[i], v2Nac[i]);
		leerFal(vFal[i], v2Fal[i]);
	end;
	minimoNac(vNac, v2Nac, min);
	minimoFal(vFal, v2Fal, min2);
	while(min.nro <> valorAlto)do begin
		d.nro:= min.nro;
		d.nom:= min.nom;
		d.ape:= min.ape;
		d.dir:= min.dir;
		d.medico:= min.medico;
		d.nomMadre:= min.nomMadre;
		d.dniMadre:= min.dniMadre;
		d.nomPadre:= min.nomPadre;
		d.dniPadre:= min.dniPadre;
		d.medDeceso:= 0;
		d.hora:= 0.0;
		d.lugar:= '';
		d.fecha.dia:= 1;
		d.fecha.mes:= 1;
		d.fecha.anio:= 1;
		if(min.nro = min2.nro)then begin
			d.fallecio:= true;
			d.medDeceso:= min2.medico;
			d.fecha:= min2.fecha;
			d.hora:= min2.hora;
			d.lugar:= min2.lugar;
			minimoFal(vFal, v2Fal, min2);
		end
		else
			d.fallecio:= false;
		write(m, d);
		minimoNac(vNac, v2Nac, min);
	end;
	close(m);
	for i:= 1 to dimF do begin
		close(vNac[i]);
		close(vFal[i]);
	end;
end;

procedure generarTexto(var m: maestro; var txt: texto);
var
  d: info;
begin
  reset(m);
  assign(txt, 'listado.txt');
  rewrite(txt);
  while not EOF(m) do
  begin
    read(m, d);
    with d do
    begin
      writeln(txt, 'Partida Nacimiento: ', nro);
      writeln(txt, 'Nombre: ', nom, ' ', ape);
      writeln(txt, 'Dirección: ', dir);
      writeln(txt, 'Médico nacimiento: ', medico);
      writeln(txt, 'Madre: ', nomMadre, ' DNI: ', dniMadre);
      writeln(txt, 'Padre: ', nomPadre, ' DNI: ', dniPadre);
      if medDeceso <> 0 then
      begin
        writeln(txt, 'Fallecido');
        writeln(txt, 'Médico deceso: ', medDeceso);
        writeln(txt, 'Fecha: ', fecha.dia, '/', fecha.mes, '/', fecha.anio);
        writeln(txt, 'Hora: ', hora:0:2);
        writeln(txt, 'Lugar: ', lugar);
      end
      else
        writeln(txt, 'Vivo');
      writeln(txt, '------------------------');
    end;
  end;
  close(txt);
  close(m);
end;

var
	mae: maestro;
	vNac: vectorNac;
	vFal: vectorFal;
	txt: texto;
begin
	//cargarDetalles
	assign(mae, 'maestro.dat');
	cargarMaestro(mae, vNac, vFal);
	generarTexto(mae, txt);
end.
