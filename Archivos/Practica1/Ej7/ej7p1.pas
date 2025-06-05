{Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.}

program ej7;
type

	novela = record
		cod: integer;
		nom: string;
		gen: string;
		precio: real;
	end;
	
	archTxt = text;
	archBin = file of novela;

procedure leerNovela(var n: novela);
begin
	writeln('Ingrese el codigo de la novela');
	readln(n.cod);
	if(n.cod <> 0)then begin
		writeln('Ingrese el nombre de la novela');
		readln(n.nom);
		writeln('Ingrese el genero de la novela');
		readln(n.gen);
		writeln('Ingrese el precio de la novela');
		readln(n.precio);
	end;
end;

procedure cargarTxt(var txt: archTxt);
var
	n: novela;
begin
	assign(txt, 'novelas.txt');
	rewrite(txt);
	leer(n);
	while(n.cod <> 0)do begin
		writeln(txt, c.cod, ' ', c.precio, ' ', c.gen);
		writeln(txt, c.nom);
		leer(n);
	end;
	close(txt);
end;
		
procedure cargarBin(var bin: archBin; nombreFisico: string);
var
	n: novela;
begin
	
end;
		
		
