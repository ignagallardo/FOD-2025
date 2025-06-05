{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}

program ej4;
const
	valorAlto = 9999;
	dimf = 30;
type
	
	producto = record
		cod: integer;
		nom: string[40];
		des: string[40];
		stock: integer;
		stockMin: integer;
		precio: real;
	end;

	venta = record	
		cod: integer;
		cant: integer;
	end;

	maestro = file of producto;
	detalle = file of venta;

	vector = array [1..dimf] of detalle;
	vec = array [1..dimf] of venta;

procedure leer(var det: detalle; var v: venta);
begin
	if(not EOF(det))then
		read(det, v)
	else
		v.cod:= valorAlto;
end;

procedure minimo(var v: vector; var v2: vec; var min: venta);
var
	i, pos: integer;
begin
	min.cod:= valorAlto;
	for i:= 1 to dimf do
	begin	
		if(v2[i].cod < min.cod)then
		begin	
			min:= v2[i];
			pos:= i;
		end;
	end;
	if(min.cod <> valorAlto)then
		leer(v[pos], v2[pos]);
end;

procedure actualizarMaestro(var mae: maestro; var v: vector);
var
	min: venta;
	i, aux, cant: integer;
	v2: vec;
	p: producto;
begin
	reset(mae);
	for i:= 1 to dimf do
	begin
		reset(v[i]);
		leer(v[i], v2[i]);
	end;
	minimo(v, v2, min);
	while(min.cod <> valorAlto)do 
	begin
		aux:= min.cod;
		cant:= 0;
		while(min.cod <> valorAlto) and (aux = min.cod)do
		begin	
			cant:= cant + min.cant;
			minimo(v, v2, min);
		end;
		read(mae, p);
		while(p.cod <> aux)do
			read(mae, p);
		seek(mae, filepos(mae)-1);
		p.stock:= p.stock - cant;
		write(mae, p);
	end;
	close(mae);
	for i:= 1 to dimf do
		close(v[i]);
end;

procedure crearMaestro(var mae: maestro);
var	
	txt: text;
	p: producto;
	nombre: string;
begin
	assign(txt, 'productos.txt');
	reset(txt);
	writeln('Ingrese el nombre del archivo maestro');
	readln(nombre);
	assign(mae, nombre);
	rewrite(mae);
	while(not EOF(txt))do
	begin
		with p do
		begin
			readln(txt, cod, stock, stockMin, precio, nom);
			readln(txt, des);
			write(mae, p);
		end;
	end;
	writeln('Archivo maestro binario cargado');
	close(txt);
	close(mae);
end;

procedure cargarDetalle(var det: detalle);
var
	v: venta;
	nom: string;
begin
	writeln('Ingrese el nombre del archivo detalle');
	readln(nom);
	assign(det, nom);
	rewrite(det);
	writeln('Ingrese el codigo del producto vendido');
	readln(v.cod);
	while(v.cod <> -1)do 
	begin
		writeln('Ingrese la cantidad vendida');
		readln(v.cant);
		write(det, v);
	end;
	writeln('Archivo detalle binario cargado');
end;

procedure cargarTodosDetalles(var v: vector);
var
	i: integer;
begin
	for i:= 1 to dimf do
		cargarDetalle(v[i]);
end;

procedure aTexto(var mae: maestro; var txt: text);
var
	p: producto;
begin
	assign(txt, 'maestro.txt');
	rewrite(txt);
	reset(mae);
	while(not EOF(mae))do
	begin
		read(mae, p);
		if(p.stock < p.stockMin)then
		begin
			with p do
			begin
				writeln(txt, precio, ' ', stock, ' ', nom);
				writeln(txt, des);
			end;
		end;
	end;
end;

var
	mae: maestro;
	txt: text;
	v: vector;
begin
	crearMaestro(mae);
	cargarTodosDetalles(v);
	actualizarMaestro(mae, v);
    aTexto(mae, txt);
end.
