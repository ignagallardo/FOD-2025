{Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:

a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
 
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.

c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.

d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.

NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el
usuario.

NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique
en tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}

program ej5;
type
	celular = record
		cod: integer;
		nom: string;
		des: string;
		marca: string;
		precio: real;
		stockMin: integer;
		stock: integer;
	end;
	
	archTxt = text;
	archCel = file of celular;
	archSinStock = text;
	
procedure leerCelular(var c: celular);
begin
	writeln('Ingrese el codigo de celular');
	readln(c.cod);
	if(c.cod <> 0) then begin
		writeln('Ingrese el nombre del celular');
		readln(c.nom);
		writeln('Ingrese la descripcion del celular');
		readln(c.des);
		writeln('Ingrese la marca del celular');
		readln(c.marca);
		writeln('Ingrese el precio del celular');
		readln(c.precio);
		writeln('Ingrese el stock minimo del celular');
		readln(c.stockMin);
		writeln('Ingrese el stock actual del celular');
		readln(c.stock);
	end;
end;

procedure cargarTxt(var arch: archTxt); {para despues cargar arch de resgistros}
var
	c: celular;
begin
	rewrite(arch);
	leerCelular(c);
	while(c.cod <> 0)do begin
			writeln(arch, c.cod, ' ', c.precio, ' ', c.marca);
			writeln(arch, c.stock, ' ', c.stockMin, ' ', c.des);
			writeln(arch, c.nom);
		leerCelular(c);
	end;
	close(arch);
end;

procedure cargarReg(var arch: archTxt; var reg: archCel);
var
	c: celular;
begin
	rewrite(reg);
	reset(arch);
	while not eof(arch) do begin
		readln(arch, c.cod, c.precio, c.marca); 
		readln(arch, c.stock, c.stockMin, c.des);
		readln(arch, c.nom);
		write(reg, c);
	end;
	close(reg);
	close(arch);
end;

procedure listarCelConStock(var reg: archCel);
var
	c: celular;
	ok: boolean;
begin
	ok:= false;
	reset(reg);
	while not eof(reg) do begin
		read(reg, c);
		if(c.stock < c.stockMin) then begin
			writeln('Celular con stock menor al stock minimo. : Celular:', c.nom, ', precio: ', c.precio, ', marca: ', c.marca, 
			', stock: ', c.stock, ', stock minimo: ', c.stockMin, ', desc: ', c.des, ', codigo: ', c.cod);
			ok:= true;
		end;
	end;
	if(ok = false) then
		writeln('No se encontraron celulares con stock menor al minimo');
	close(reg);
end;

procedure listarPorDes(var reg: archCel);
var
	c: celular;
	buscada: string;
	ok: boolean;
begin
	ok:= false;
	writeln('Ingrese descripcion a buscar.');
	readln(buscada);
	reset(reg);
	while not eof(reg) do begin
		read(reg, c);
		if(Pos(LowerCase(buscada), LowerCase(c.des)) > 0) then begin
			writeln('Celular encontrado. Celular:', c.nom, ', precio: ', c.precio, ', marca: ', c.marca, ', stock: ', c.stock, ', stock minimo: ', c.stockMin, ', desc: ', c.des, ', codigo: ', c.cod);
			ok:= true;
		end;
	end;
	close(reg);
	if(ok = false) then
		writeln('No se encontro el celular buscado.');
end;
		
procedure exportar(var arch: archTxt; var reg: archCel);
var
	c: celular;
begin
	reset(reg);
	reset(arch);
	while not eof(reg) do begin
		read(reg, c);
		writeln(arch, ' ', c.cod, ' ', c.precio, ' ', c.marca);
		writeln(arch, ' ', c.stock, ' ', c.stockMin, ' ', c.des);
		writeln(arch, ' ', c.cod);
		
	end;
	close(reg);
	close(arch);
end;

procedure agregar(var reg: archCel);
var
	c: celular;
begin
	reset(reg);
	seek(reg, filesize(reg));
	leerCelular(c);
	while(c.cod <> 0)do begin
		write(reg, c);
		leerCelular(c);
	end;
	close(reg);
end;

procedure modificarStock(var reg: archCel);
var
	c: celular;
	ok: boolean;
	nombre: string;
	stockNuevo: integer;
begin
	writeln('Ingrese el nombre del producto a actualizar.');
	readln(nombre);
	writeln('Ingrese el nuevo stock del producto.');
	readln(stockNuevo);
	ok:= false;
	reset(reg);
	while not eof(reg) do begin
		read(reg, c);
		if(c.nom = nombre)then
			c.stock:= stockNuevo;
		seek(reg, filepos(reg)-1);
		write(reg, c);
	end;
	close(reg);
	if(ok = true) then writeln('Se pudo actualizar el stock del producto.')
	else writeln('No se pudo actualizar el stock del producto.')
end;

procedure sinStock(var reg: archCel; var noStock: archSinStock);
var
	c: celular;
begin
	assign(noStock, 'SinStock.txt');
	reset(reg);
	while not eof(reg)do begin
		read(reg, c);
		if(c.stock = 0)then begin
			writeln(noStock, c.cod, ' ', c.precio, ' ', c.marca);
			writeln(noStock, c.stock, ' ', c.stockMin, ' ', c.des);
			writeln(noStock, c.cod);
		end;
	end;
	close(noStock);
	close(reg);
end;

var
	arch: archTxt; reg: archCel; nomFisico: string; op: integer; noStock: archSinStock;
begin
	assign(arch, 'celulares.txt');
	cargarTxt(arch);
	
	writeln('Ingrese nombre fisico del archivo binario');
	readln(nomFisico);
	assign(reg, nomFisico + '.dat');
	cargarReg(arch, reg);
	
	Writeln('------------------------------------');
	Writeln('Ingrese una opcion para continuar');
	Writeln('------------------------------------');
	readln(op);

	case op of
		0: writeln('Programa finalizado.');
		1: listarCelConStock(reg);
		2: listarPorDes(reg);
		3: agregar(reg);
		4: modificarStock(reg);
		5: sinStock(reg, noStock);
	else
		writeln('Opcion invalida');
	end;
	exportar(arch, reg);
end.

{finaliza programa con error 105}
		
		
		
		


