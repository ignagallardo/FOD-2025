{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program ej2;
const
	valorAlto = 9999;
type
	producto = record
		cod: integer;
		nom: string[30];
		precio: real;
		stock: integer;
		stockMin: integer;
	end;
	
	datos = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of datos;
	
procedure leerDetalle(var det: detalle; var d:datos);
begin
	if(not EOF(det))then
		read(det, d)
	else
		d.cod:= valorAlto;
end;

procedure cargarMaestro(var mae: maestro);
var
	p: producto;
begin
	assign(mae, 'archivoMaestro');
	rewrite(mae);
	writeln('Ingrese el codigo de producto');
	readln(p.cod);
	while(p.cod <> -1)do begin
		writeln('Ingrese el codigo de producto');
		readln(p.nom);
		writeln('Ingrese el precio de producto');
		readln(p.precio);
		writeln('Ingrese el stock de producto');
		readln(p.stock);
		writeln('Ingrese el stock minimo de producto');
		readln(p.stockMin);
		read(mae, p);
		writeln('Ingrese el codigo de producto');
		readln(p.cod);
	end;
	close(mae);
end;

procedure cargarDetalle(var det: detalle);
var
	d: datos;
begin
	assign(det, 'archivoDetalle');
	rewrite(det);
	writeln('Ingrese el codigo de producto');
	readln(d.cod);
	while(d.cod <> -1)do begin
		writeln('Ingrese la cantidad de productos vendidos');
		readln(d.cant);
		read(det, d);
		writeln('Ingrese el codigo de producto');
		readln(d.cod);
	end;
	close(det);
end;

procedure actualizarMaestro(var mae: maestro; var det: detalle);
var
	p: producto;
	d: datos;
	aux, total: integer;
begin
	reset(mae); 
	reset(det);
	leerDetalle(det, d);
	read(mae, p);
	while(d.cod <> valorAlto)do begin
		aux:= d.cod;
		total:= 0;
		while(d.cod = aux)do begin
			total:= total + d.cant;
			leerDetalle(det, d);
		end;
		while(p.cod <> aux)do
			read(mae, p);
		p.stock:= p.stock - total;
		seek(mae, filepos(mae)-1);
		write(mae, p);
		if(not EOF(mae))then
			read(mae, p);
	end;
	close(det);
	close(mae);
end;

procedure stockMinimo(var mae: maestro);
var
	txt: text;
	p: producto;
begin
	reset(mae);
	assign(txt, 'stockMenor.txt');
	rewrite(txt);
	while(not EOF(mae))do begin
		read(mae, p);
		if(p.stock < p.stockMin)then
			writeln(txt, ' cod ', p.cod, ' precio ', p.precio:0:2, ' stock ', p.stock, ' stock minimo ', p.stockMin, ' nombre ', p.nom);
	end;
	close(mae);
	close(txt);
end;

var
	mae: maestro;
	det: detalle;
begin
	cargarMaestro(mae);
	cargarDetalle(det);
	actualizarMaestro(mae, det);
	stockMinimo(mae);
end.
