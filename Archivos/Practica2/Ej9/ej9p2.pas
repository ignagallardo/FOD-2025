{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

program ej9;
const 
	valorAlto = 9999;
type
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: integer;
	end;
	
	cliente = record
		cod: integer;
		nom: string[40];
	end;
	
	venta = record
		cli: cliente;
		f:fecha;
		monto: real;
	end;
	
	maestro = file of venta;
	
procedure leerMaestro(var mae: maestro; var v:venta);
begin
	if(not EOF(mae))then
		read(mae, v)
	else
		mae.cli.cod:= valorAlto;
end;

procedure procesar(var mae: maestro);
var
	v:venta;
	montoMes, montoAnio, montoEmpresa: real;
	cod: integer;
	f: fecha;
begin
	reset(mae);
	montoEmpresa:= 0;
	leerMaestro(mae, v);
	while(mae.cli.cod <> valorAlto)do 
	begin
		cod:= v.cod.cli;
		while(cod = v.cod.cli)do
		begin
			f.anio:= v.f.anio;
			montoAnio:= 0;
			while(cod = v.cod.cli) and (f.anio = v.f.anio)do
			begin
				f.mes:= v.f.mes;
				montoMes:= 0;
				writeln('El cliente ', v.cli.nom, ' con codigo ', v.cli.cod);
				while(cod = v.cod.cli) and (f.anio = v.f.anio) and (f.mes = v.f.mes)do
				begin
					totalMes:= totalMes + v.monto;
					leerMaestro(mae, v);
				end;
					if(montoMes <> 0)then
						writeln('Gasto $', montoMes, ' en el mes ', f.mes);
				totalAnio:= totalAnio + totalMes;
			writeln('Y en el año gasto $', montoAnio);
		montoEmpresa:= montoEmpresa + montoAnio;
	end;
	writeln('El monto total de ventas de la empresa es de $', totalEmpresa);
	close(mae);
end;

var
	mae: maestro;
begin
	assign(mae, 'archivoMaestro');
	procesar(mae);
end.
				
				
				
				
				
				
				


