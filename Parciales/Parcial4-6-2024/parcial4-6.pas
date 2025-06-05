program parcial2024;
const
	valorAlto = 9999;
type
	dias = 1..31;
	meses = 1..12;
	date = record
		dia: dias;
		mes: meses;
		anio: integer;
	end;
	prestamo = record
		sucursal: integer;
		dni: integer;
		num: integer;
		fecha: date;
		monto: real;
	end;
	
	archivo = file of prestamo;	//se dispone
	texto = text;
	
function extraerAnio(f: date): integer; //se dispone
begin
	extraerAnio:= f.anio;
end;

procedure leer(var arc: archivo; var p: prestamo);
begin
	if(not EOF(arc))then
		read(arc, p)
	else
		p.sucursal:= valorAlto;
end;

procedure procesar(var arc: archivo; var tex: texto);
var
	p: prestamo;
	codSucursal, dniAct, anioAct, cantVentas, cantTotal, cantSucursal, cantEmpresa: integer;
	montoVentas, montoTotal, montoSucursal, montoEmpresa: real;
begin
	reset(arc);
	rewrite(tex);
	leer(arc, p);
	write(tex, 'Informe de ventas de la empresa');
	cantEmpresa:= 0;
	montoEmpresa:= 0.0;
	while(p.sucursal <> valorAlto)do begin
		codSucursal:= p.sucursal;
		cantSucursal:= 0;
		montoSucursal:= 0.0;
		writeln(tex, 'Sucursal ', p.sucursal);
		while((p.sucursal <> valorAlto) AND (p.sucursal = codSucursal))do begin
			dniAct:= p.dni;
			cantTotal:= 0;
			montoTotal:= 0.0;
			writeln(tex, 'Empleado: DNI ', p.dni);
			while((p.sucursal <> valorAlto) AND (p.sucursal = codSucursal) AND (p.dni = dniAct))do begin
				anioAct:= extraerAnio(p.fecha);
				cantVentas:= 0;
				montoVentas:= 0;
				while((p.sucursal <> valorAlto) AND (p.sucursal = codSucursal) AND (p.dni = dniAct) AND (p.fecha.anio = anioAct))do begin
					cantVentas:= cantVentas + 1;
					montoVentas:= montoVentas + p.monto;
					leer(arc, p);
				end;
				cantTotal:= cantTotal + cantVentas;
				montoTotal:= montoTotal + montoVentas;
				writeln(tex, 'Año: ', anioAct, '		Cantidad de ventas: ', cantVentas, '	Monto de ventas: ', montoVentas);
			end;
			cantSucursal:= cantSucursal + cantTotal;
			montoSucursal:= montoSucursal + montoTotal;
			writeln(tex, 'Total ventas empleado: ', cantTotal);
			writeln(tex, 'Monto total empleado: ', montoTotal);
		end;
		cantEmpresa:= cantEmpresa + cantSucursal;
		montoEmpresa:= montoEmpresa + montoSucursal;
		writeln(tex, 'Cantidad total de ventas sucursal: ', cantSucursal);
		writeln(tex, 'Monto total vendido por sucursal: ', montoSucursal);
		writeln(tex, 'Sucursal', codSucursal);
	end;
	writeln(tex, 'Cantidad de ventas de la empresa: ', cantEmpresa);
	writeln(tex, 'Monto total vendido por la empresa: ', montoEmpresa);
	close(tex);
	close(arc);
end;
	
var
	arc: archivo;
	tex: texto;
begin
	//cargarArchivo(arc); //se dispone
	assign(tex, 'archivo.txt');
	procesar(arc, tex);
end.
	
	
	
	
	
	
	
	
	
	
	
	
	
