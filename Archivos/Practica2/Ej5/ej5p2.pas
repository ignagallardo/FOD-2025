{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.

Notas:

● Cada archivo detalle está ordenado por cod_usuario y fecha.

● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.

● El archivo maestro debe crearse en la siguiente ubicación física: /var/log}

program ej5;
const   
    valorAlto = 9999;
    dimf = 5;
type
    sesion = record
        cod: integer;
        fecha: string[10];
        tiempo: real;
    end;

    maestro = file of sesion;
    detalle = file of sesion;
    vector = array [1..dimf] of detalle;
    sesiones = array [1..dimf] of sesion;

procedure leer(var det: detalle; var s:sesion);
begin   
    if(not EOF(det))then
        read(det, s)
    else
        s.cod:= valorAlto;
end;

procedure minimo(var v: vector; var min: sesion; var s: sesiones);
var
    i, pos: integer;
begin   
    min.cod:= valorAlto;
    for i:= 1 to dimf do 
    begin
        if(s[i].cod < min.cod)then
        begin
            min:= s[i];
            pos:= i;
        end;
    end;
    if(min.cod <> valorAlto)then
        leer(v[pos], s[pos]);
end;

procedure crearMaestro(var mae: maestro; var v: vector);
var
    min: sesion;
    i: integer;
    ses: sesiones;
    aux: sesion;
begin
    assign(mae, '/var/log');
    rewrite(mae);
    for i:= 1 to dimf do
    begin
        reset(v[i]);
        leer(v[i], ses[i]);
    end;
    minimo(v, min, ses);
    while(min.cod <> valorAlto)do 
    begin
        aux.cod:= min.cod;
        aux.tiempo:= 0;
        while(min.cod = aux.cod)do begin
			aux.fecha:= min.fecha;
			while(aux.fecha = min.fecha) and (min.cod = aux.cod)do {puedo tener dos archivos con fechas distintas pero mismo usuario}
			begin
				aux.tiempo:= aux.tiempo + min.tiempo;
				minimo(v, min, ses);
			end;
			write(mae, aux);
        end;
    end;
    close(mae);
    for i:= 1 to dimf do
        close(v[i]);
end;

{falta crear detalles}

var
    mae: maestro;
    v: vector;
begin
    {crearDetalles(v);}
    crearMaestro(mae, v);
    {imprimirMaestro(mae);}
end.

    
