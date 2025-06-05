{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.

Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}


program ej6;
const
	valorAlto = 9999;
type
	prenda = record
		cod: integer;
		descr: string;
		colores: string;
		tipo: string;
		stock: integer;
		precio: real;
	end;
	
	archivo = file of prenda;
	cod_prenda = file of integer;
	
procedure leer(var a: archivo; var p: prenda);
begin
	if(not EOF(a))then
		read(a, p)
	else
		p.cod:= valorAlto;
end;

procedure leer2(var c: cod_prenda; var x: integer);
begin
	if(not EOF(c))then
		read(c, x)
	else
		x:= valorAlto;
end;

procedure bajaLogica(var a: archivo; var c: cod_prenda);
var
	x: integer;
	p: prenda;
begin
	reset(a);
	reset(c);
	
	leer2(c, x);
	leer(a, p);
	while(x <> valorAlto)do begin
		while(p.cod <> valorAlto) and (p.cod <> x)do 
			leer(a, p);
		if(p.cod = x)then begin
			p.cod:= p.cod * -1;  //¿solo pongo el codigo de la prenda en negativo?
			seek(a, filepos - 1);
			write(a, p);
		end;
		seek(a, 0);
		leer2(c, x);
	end;
	close(a);
	close(c);
end;

procedure compactar(var a: archivo; var aux: archivo);
var
	p: prenda;
begin
	reset(a);
	rewrite(aux);
	
	leer(a, p);
	//puedo poner un if preguntando si la cabecera es = 0, entonces no hay borrados?
	while(p.cod <> valorAlto)do begin
		if(p.cod > 0)then
			write(aux, p);
		leer(a, p);
	end;
	
	close(a);
	close(aux);
end;

var
	a, aux: archivo;
	c: cod_prenda;
	nom, archivoPrincipal: string;
begin
	writeln('Ingrese el nombre del archivo principal');
	readln(archivoPrincipal);
	assign(a, archivoPrincipal);
	
	assign(c, 'prendasABorrar');
	
	bajaLogica(a, c);
	
	writeln('Ingres el nombre del archivo auxiliar');
	readln(nom);
	assign(aux, nom);
	
	compactar(a, aux);
	
	assign(aux, archivoPrincipal); //reemplazo archivo actualizado por el principal
end.
	
	
	
	
	
	
	
	
