{7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.

Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.

Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:

● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado.

Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales}

program ej7;
const
	valorAlto = 9999;
type
	regMae = record
		cod: integer;
		ape: string[20];
		nom: string[20];
		cursadas: integer;
		finales: integer;
	end;
	
	reg1 = record
		cod: integer;
		materia: integer;
		año: string[10];
		resul: boolean; //aprobado o desaprobado
	end;
	
	reg2 = record
		cod: integer;
		materia: integer;
		fecha: string[20];
		nota: real;
	end;
	
	maestro = file of regMae;
	detalle1 = file of reg1;
	detalle2 = file of reg2;
	
procedure leerCursada(var det: detalle1; var r1: reg1);
begin
	if(not EOF(det))then
		read(det, r1)
	else
		r1.cod:= valorAlto;
end;

procedure leerFinal(var det2: detalle2; var r2: reg2);
begin
	if(not EOF(det2))then
		read(det2, r2)
	else
		r2.cod:= valorAlto;
end;

procedure leerMaestro(var mae: maestro; var reg: regMae);
begin
	if(not EOF(mae))then
		read(mae, reg)
	else
		reg.cod:= valorAlto;
end;

procedure minimo(var det: detalle1; var det2: detalle2; var r1: reg1; var r2: reg2; var min: regMae);
begin
	leerCursada(det, r1);
	leerFinal(det2, r2);
	if(r1.cod <= r2.cod) and (r2.materia <= r2.materia)do 
	begin
		min.cod:= r1.cod;
		if(r1.resul)then 
			min.cursadas:= min.cursadas + 1;
		leerCursada(det, r1);
	end
	else begin
		min.cod:= r2.cod;
		if(r2.nota => 4)then
			min.finales:= min.finales + 1;
		leerFinal((det2, r2);
	end;
end;

procedure actualizarMaestro(var mae: maestro; var det: detalle1; var det2: detalle2);
var
	aux, min: regMae;
	r1: reg1;
	r2: reg2;
begin
	reset(mae);
	reset(det);
	reset(det2);
	
	minimo(det, det2, r1, r2, min);
	while(min <> valorAlto)do begin
		read(mae, aux);
		while(not EOF(mae)) and (aux.cod <> min.cod) do
			leerMaestro(mae, reg);
		while(min.cod = aux.cod)do
			minimo(det, det2, r1, r2, min);
		seek(mae, filepos(mae) - 1);
		aux.cursadas:= aux.cursadas + min.cursadas;
		aux.finales:= aux.finales + min.finales;
		write(mae, reg);
	end;
	
	close(mae);
	close(det);
	close(det2);
end;

var
	mae: maestro;
	det: detalle1;
	det2: detalle2;
begin
	assign(mae, 'archivoMaestro');
	assign(det, 'detalle1');
	assign(det2, 'detalle2');
	actualizarMaestro(mae, det, det2);
end.












