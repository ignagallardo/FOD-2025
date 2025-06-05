{Realizar un programa que genere un archivo de novelas filmadas durante el presente
aÃ±o. De cada novela se registra: cÃ³digo, gÃ©nero, nombre, duraciÃ³n, director y precio.
El programa debe presentar un menÃº con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la tÃ©cnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creaciÃ³n del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
cÃ³digo de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperaciÃ³n de espacio. En
particular, para el campo de â€œenlaceâ€ de la lista (utilice el cÃ³digo de
novela como enlace), se debe especificar los nÃºmeros de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:

i. Dar de alta una novela leyendo la informaciÃ³n desde teclado. Para
esta operaciÃ³n, en caso de ser posible, deberÃ¡ recuperarse el
espacio libre. Es decir, si en el campo correspondiente al cÃ³digo de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posiciÃ³n 5, copiarlo en la posiciÃ³n 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posiciÃ³n 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la informaciÃ³n desde
teclado. El cÃ³digo de novela no puede ser modificado.

iii. Eliminar una novela cuyo cÃ³digo es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posiciÃ³n 8, en el campo
cÃ³digo de novela del registro cabecera deberÃ¡ figurar -8, y en el
registro en la posiciÃ³n 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse â€œnovelas.txtâ€.
NOTA: Tanto en la creaciÃ³n como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

program ej3;
const 
	valorAlto = 32420;
type
	cadena = string[20];
	novela = record
		cod: integer;
		gen: cadena;
		nom: cadena;
		duracion: real;
		dir: cadena;
		precio: real;
	end;
	
	archivo = file of novela;
	
procedure leerNovela(var n: novela);
begin
	writeln('Ingrese el codigo de novela');
	readln(n.cod);
	writeln('Ingrese el genero de la novela');
	readln(n.gen);
	writeln('Ingrese el nombre de la novela');
	readln(n.nom);
	writeln('Ingrese la duracion de la novela');
	readln(n.duracion);
	writeln('Ingrese el director de la novela');
	readln(n.dir);
	writeln('Ingrese el precio de la novela');
	readln(n.precio);
end;

procedure leer(var a: archivo; var n: novela);
begin
	if(not EOF(a))then
		read(a, n)
	else
		n.cod:= valorAlto;
end;

procedure cargarBinario(var a: archivo; var t: text);
var
	n: novela;
	nom: string;
begin
	writeln('Ingrese el nombre del archivo binario');
	readln(nom);
	assign(a, nom);
	rewrite(a);
	reset(t);
	while(not EOF(t))do begin
		readln(t, n.cod, n.duracion, n.dir);
		readln(t, n.precio);
		readln(t, n.nom);
		readln(t, n.gen);
		write(a, n);
	end;
	close(a);
	close(t);
end;

{Dar de alta una novela leyendo la informaciÃ³n desde teclado. Para
esta operaciÃ³n, en caso de ser posible, deberÃ¡ recuperarse el
espacio libre. Es decir, si en el campo correspondiente al cÃ³digo de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posiciÃ³n 5, copiarlo en la posiciÃ³n 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posiciÃ³n 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre. }

procedure alta(var a: archivo);
var
	n, aux: novela;
begin
	leerNovela(n);
	reset(a);
	leer(a, aux);
	if(aux.cod < 0)then
	begin
		seek(a, aux.cod * -1); //si el codigo es -5 por ej, va a la pos 5 y copia el nuevo registro
		read(a, aux);
		seek(a, filepos(a) -1);
		write(a, n);
		seek(a, 0); //copia el registro obtenido de la pos 5 y lo pone en la pos 0
		write(a, aux);
	end 
	else begin //si no hay espacios libres, es decir, cod = 0,  agrega al final
		seek(a, filesize(a)); //no es filesize -1 porque sino escribo sobre el ult reg guardado
		write(a, n);
	end;
	close(a);
end;

procedure modificar(var a: archivo);
var
	aux, n: novela;
begin
	writeln('Se le van a pedir los datos de la novela a modificar');
	leerNovela(n);
	reset(a);
	leer(a, aux);
	while(aux.cod <> valorAlto) and (aux.cod <> n.cod)do
	begin
		leer(a, aux);
	end;
	if(aux.cod = n.cod)then
	begin
		seek(a, filepos(a) -1);
		write(a, n);
		writeln('Los datos de la novela ', n.nom, ' fueron actualizados');
	end
	else writeln('La novela no se encuentra en el archivo');
	close(a);
end;

{iii. Eliminar una novela cuyo cÃ³digo es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posiciÃ³n 8, en el campo
cÃ³digo de novela del registro cabecera deberÃ¡ figurar -8, y en el
registro en la posiciÃ³n 8 debe copiarse el antiguo registro cabecera.}
	
procedure eliminar(var a: archivo);
var
	cod, pos: integer;
	n, aux: novela;
begin
	writeln('Ingrese el codigo de la novela a eliminar');
	readln(cod);
	leer(a, n); //leo la cabecera (pos 0)
	leer(a, aux);
	while(aux.cod <> valorAlto) and (aux.cod <> cod)do
	begin
		leer(a, aux);
	end;
	if(aux.cod = cod)then
	begin
		pos:= filepos(a) - 1;
		seek(a, pos);
		write(a, n);
		seek(a, 0);
		aux.cod:= aux.cod * -1;
		write(a, aux);
	end 
	else writeln('La novela de codigo ', cod, ' no se encuentra en el archivo');
	close(a);
end;

procedure menuB(var a: archivo; opcion: integer);
begin
	case(opcion)of
	1: alta(a);
	2: modificar(a);
	3: eliminar(a);
	end;
end;	
		
procedure listar(var a: archivo; var txt: text);
var
	n: novela;
begin
	reset(a);
	rewrite(txt);
	leer(a, n);
	while(n.cod <> valorAlto)do 
	begin
		writeln(txt, n.cod, n.precio, n.gen);
		writeln(txt, n.nom);
		writeln(txt, n.duracion);
		writeln(txt, n.dir);
		leer(a, n);
	end;
	close(a);
	close(txt);
end;

var
	txt: text;
	txt2: text;
	a: archivo;
	opcion, op: integer;
	nom: string;
begin
	writeln('Ingrese la accion a realizar');
	readln(opcion);
	case(opcion) of
	0: writeln('El programa ha finalizado');
	1: begin
		writeln('Ingrese el nombre del archivo de texto');
		readln(nom);
		assign(txt, 'archivoInicial');
		rewrite(txt);
		cargarBinario(a, txt);
	   end;
	2: begin 
		writeln('Ingrese 1: Agregar novela, 2: Modificar una novela, 3: Eliminar una novela');
		readln(op);
		menuB(a, op);
	   end;
	3: begin
		writeln('Ingrese el nombre del nuevo archivo de texto');
		readln(nom);
		assign(txt2, nom);
		listar(a, txt2);
	   end;
	end;
end.
