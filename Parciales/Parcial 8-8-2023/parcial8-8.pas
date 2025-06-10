{
    Una empresa dedicada a la venta de golosinas posee un archivo que contiene Información
    sobre los productos que tiene a la venta. De cada producto se registran los siguientes datos:
    código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
    La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada una de
    las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada sucursal. De
    cada venta se registra código de producto y cantidad vendida. Se debe realizar un
    procedimiento que actualice el stock en el archivo maestro con la información disponible en los
    archivos detalles y que además informe en un archivo de texto aquellos productos cuyo monto
    total vendido en el día supere los $10.000. En el archivo de texto a exportar, por cada producto
    incluido, se deben informar todos sus datos. Los datos de un producto se deben organizar en el
    archivo de texto para facilitar el uso eventual del mismo como un archivo de carga.
    El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos
    y módulos usados en el mismo.

    Notas:
        • Todos los archivos se encuentran ordenados por código de producto.
        • En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.
        • Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
        • Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la
        actualización del archivo maestro con los archivos detalles, así como la generación del
        archivo de texto solicitado.
}

program parcial;
const
	valorAlto = 9999;
	dimF = 20;
type
	producto = record
		cod: integer;
		nom: string[30];
		precio: real;
		stock: integer;
		stockMin: integer;
	end;
	
	info = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of info;
	texto = text;
	
	vector = array[1..dimF] of detalle;
	vecReg = array[1..dimF] of info;

procedure leer(var d: detalle; var i: info);
begin
	if(not EOF(d))then
		read(d,i)
	else
		i.cod:= valorAlto;
end;

procedure minimo(var v: vector; var v2: vecReg; var min: info);
var
	pos, i: integer;
begin
	pos:= 0;
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

procedure cargarTexto(var t: texto; p: producto);
begin
	write(t, p.cod, p.precio, p.stock, p.stockMin, p.nom);
end;

procedure actualizar(var mae: maestro; var v: vector; var t: texto);
var
	min: info;
	p: producto;
	cantTotal, codAct, i: integer;
	v2: vecReg;
begin
	reset(mae);
	rewrite(t);
	for i:= 1 to dimF do begin
		reset(v[i]);
		leer(v[i], v2[i]);
	end;
	minimo(v, v2, min);
	while(min.cod <> valorAlto)do begin
		codAct:= min.cod;
		cantTotal:= 0;
		while(min.cod = codAct)do begin
			cantTotal:= cantTotal + min.cant;
			minimo(v, v2, min);
		end;
		read(mae, p);
		while(p.cod <> codAct)do begin
			read(mae, p);
		end;
		seek(mae, filepos(mae)-1);
		p.stock:= p.stock - cantTotal;
		write(mae, p);
		if((cantTotal*p.precio) > 10000)then
			cargarTexto(t, p);
	end;
	close(mae);
	close(t);
	for i:= 1 to dimF do 
		close(v[i]);
end;

var
	mae: maestro;
	v: vector;
	t: texto;
begin
	//cargarMaestro(mae);
	//cargarDetalles(v);
	actualizar(mae, v, t);
end.
	
	
	
	
