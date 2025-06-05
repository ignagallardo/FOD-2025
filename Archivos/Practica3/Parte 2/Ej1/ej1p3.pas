program ej1parte2;
const
	valorAlto = 9999;
type
	producto = record
		cod: integer;
		nom: string;
		precio: real;
		stock: integer;
		stockMin: integer;
	end;

	venta = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	
procedure actualizar(var mae: maestro; var det: detalle);
var
	p: producto;
	v: venta;
	cod, ventas: integer;
begin
	reset(mae);
	reset(det);
	
	while(not EOF(mae))do begin
		read(mae, p);
		cod:= p.cod;
		ventas:= 0;
		while(not EOF(det))do begin
			read(det, v);
			if(v.cod = cod)then
				ventas:= ventas + v.cant;
		end;
		seek(det, 0);
		if(ventas > 0)then begin
			p.stock:= p.stock - ventas;
			seek(mae, filepos(mae) -1);
			write(mae, p);
		end;
	end;
	close(mae);
	close(det);
end;
	
//procedure crear maestro, crear detalle

var
	mae: maestro;
	det: detalle;
begin
	assign(mae, 'maestro');
	assing(det, 'detalle');
	rewrite(mae); 
	rewrite(det);
	actualizar(mae, det);
end.
	
	
	
	
	
	
	
	
	
	
	
