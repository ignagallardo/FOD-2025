{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program ej2p1;
type
	archivo= file of integer;
	
procedure abrir(var archivazo:archivo);
var 
	prom, dato, cant, cantTotal:integer;
begin
	prom:=0;
	cant:=0;
	cantTotal:=0;
	reset(archivazo);
	while not(eof(archivazo))do
	begin
		read(archivazo, dato);
		prom:=prom + dato;
		cantTotal:= cantTotal + 1;
		if(dato<1500)then
		begin
			cant:=cant + 1;
		end
	end;
	close(archivazo);
	prom:=prom div cantTotal;
	writeln('num < 1500 ', cant);
	writeln('promedio ', prom);
end;

procedure imprimir(var archivazo:archivo);
var
	num:integer;
begin
	reset(archivazo);
	while not(eof(archivazo))do
	begin
		writeln(filepos(archivazo));
		read(archivazo, num);
		writeln('el numero es ', num);
	end;
	close(archivazo);
end;
var
	arch:archivo; nombre:string;
begin
	writeln('ingrese nom');
	readln(nombre);
	assign(arch, nombre);
	abrir(arch);
	imprimir(arch);
end.
