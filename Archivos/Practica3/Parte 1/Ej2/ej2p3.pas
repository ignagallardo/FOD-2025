{Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.

Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program ej2;
const
	valorAlto = 9999;
	caracter = '$';
type
	cadena = string[20];
	asistente = record
		num: integer;
		ape: cadena;
		nom: cadena;
		email: cadena;
		tel: integer;
		dni: integer;
	end;
	
	archivo = file of asistente;

procedure leer(var arch: archivo; var a: asistente);
begin
	if(not EOF(arch))then
		read(arch, a)
	else
		a.num:= valorAlto;
end;

procedure cargarBin(var arch: archivo; var t: text);
var
	a: asistente;
begin
	reset(t);
	rewrite(arch);
	while(not EOF(t))do 
	begin
		readln(t, a.num, a.ape, a.nom);
		readln(t, a.email, a.tel, a.dni);
		write(arch, a);
	end;
	close(t);
	close(arch);
end;

procedure bajaLogica(var arch: archivo);
var
	a: asistente;
begin
	reset(arch);
	leer(arch, a);
	while(a.num <> valorAlto)do
	begin
		if(a.num < 1000)then
		begin
			a.ape:= Concat(caracter, a.ape);
			seek(arch, filepos(arch) - 1);
			write(arch, a);
		end;
		read(arch, a);
	end;
	close(arch);
end;

var
	arch: archivo;
	txt: text;
	nomArch: string;
begin
	writeln('Ingrese el nombre del archivo de texto');
	readln(nomArch);
	assign(txt, nomArch);
	assign(arch, 'archivoBinario');
	cargarBin(arch, txt);
	bajaLogica(arch);
end.
