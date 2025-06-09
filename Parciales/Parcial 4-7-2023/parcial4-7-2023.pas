program parcial;
const
	valorAlto = 9999;
type
	equipo = record
		cod: integer;
		nom: string[40];
		anio: integer;
		torneo: integer;
		rival: integer;
		golesFavor: integer;
		golesContra: integer;
		puntos: integer;
	end;
	
	archivo = file of equipo;
	
procedure leer(var a: archivo; var e: equipo);
begin
	if(not EOF(a))then
		read(a, e)
	else
		e.anio:= valorAlto;
end;

procedure cargarArchivo(var a: archivo);
var
  e: equipo;
begin
  rewrite(a);

  // Año 2023 - Torneo 1
  e.cod := 1; e.nom := 'Boca Juniors'; e.anio := 2023; e.torneo := 1; e.rival := 2;
  e.golesFavor := 2; e.golesContra := 0; e.puntos := 3; write(a, e);
  e.rival := 3; e.golesFavor := 1; e.golesContra := 1; e.puntos := 1; write(a, e);

  e.cod := 2; e.nom := 'River Plate'; e.anio := 2023; e.torneo := 1; e.rival := 1;
  e.golesFavor := 0; e.golesContra := 2; e.puntos := 0; write(a, e);
  e.rival := 3; e.golesFavor := 2; e.golesContra := 1; e.puntos := 3; write(a, e);

  e.cod := 3; e.nom := 'Independiente'; e.anio := 2023; e.torneo := 1; e.rival := 1;
  e.golesFavor := 1; e.golesContra := 1; e.puntos := 1; write(a, e);
  e.rival := 2; e.golesFavor := 1; e.golesContra := 2; e.puntos := 0; write(a, e);

  // Año 2023 - Torneo 2
  e.cod := 1; e.nom := 'Boca Juniors'; e.anio := 2023; e.torneo := 2; e.rival := 4;
  e.golesFavor := 0; e.golesContra := 3; e.puntos := 0; write(a, e);

  e.cod := 4; e.nom := 'Estudiantes de La Plata'; e.anio := 2023; e.torneo := 2; e.rival := 1;
  e.golesFavor := 3; e.golesContra := 0; e.puntos := 3; write(a, e);

  // Año 2024 - Torneo 1
  e.cod := 1; e.nom := 'Boca Juniors'; e.anio := 2024; e.torneo := 1; e.rival := 2;
  e.golesFavor := 2; e.golesContra := 2; e.puntos := 1; write(a, e);
  e.rival := 3; e.golesFavor := 3; e.golesContra := 1; e.puntos := 3; write(a, e);

  e.cod := 2; e.nom := 'River Plate'; e.anio := 2024; e.torneo := 1; e.rival := 1;
  e.golesFavor := 2; e.golesContra := 2; e.puntos := 1; write(a, e);
  e.rival := 3; e.golesFavor := 1; e.golesContra := 1; e.puntos := 1; write(a, e);

  e.cod := 3; e.nom := 'Independiente'; e.anio := 2024; e.torneo := 1; e.rival := 1;
  e.golesFavor := 1; e.golesContra := 3; e.puntos := 0; write(a, e);
  e.rival := 2; e.golesFavor := 1; e.golesContra := 1; e.puntos := 1; write(a, e);

  // Año 2024 - Torneo 2
  e.cod := 2; e.nom := 'Gimnasia y esgrima de La Plata'; e.anio := 2006; e.torneo := 2; e.rival := 4;
  e.golesFavor := 0; e.golesContra := 7; e.puntos := 0; write(a, e);

  e.cod := 4; e.nom := 'Estudiantes de La Plata'; e.anio := 2006; e.torneo := 2; e.rival := 2;
  e.golesFavor := 7; e.golesContra := 0; e.puntos := 3; write(a, e);

  close(a);
end;


procedure informar(var a: archivo);
var
	e: equipo;
	nomCampeon, nomAct: string;
	anioAct, torneoAct, equipo, diferencia: integer;
	totalGoles, totalContra, ganados, perdidos, empatados, totalPuntos, campeon: integer;
begin
	reset(a);
	leer(a, e);
	while(e.anio <> valorAlto)do begin
		anioAct:= e.anio;
		writeln('Anio ', anioAct);
		while(e.anio <> valorAlto) and (e.anio = anioAct)do begin
			torneoAct:= e.torneo;
			campeon:= 0;
			nomCampeon:= '';
			writeln('Torneo ', torneoAct);
			while(e.anio = anioAct) and (e.torneo = torneoAct)do begin
				equipo:= e.cod;
				nomAct:= e.nom;
				totalGoles:= 0;
				totalContra:= 0;
				diferencia:= 0;
				perdidos:= 0;
				ganados:= 0;
				empatados:= 0;
				totalPuntos:= 0;
				writeln('Equipo ', equipo, ' ', nomAct);
				while(e.anio = anioAct) and (e.torneo = torneoAct) and (e.cod = equipo)do begin
					totalGoles:= totalGoles + e.golesFavor;
					totalContra:= totalContra + e.golesContra;
					case e.puntos of
						0: perdidos:= perdidos + 1;
						1: empatados:= empatados + 1;
						3: ganados:= ganados + 1;
					end;
					totalPuntos:= totalPuntos + e.puntos;
					leer(a, e);
				end;
				if(totalPuntos > campeon)then begin
					campeon:= totalPuntos;
					nomCampeon:= nomAct;
				end;
				diferencia:= totalGoles - totalContra;
				writeln('Goles a favor ', totalGoles);
				writeln('Goles en contra ', totalContra);
				writeln('Diferencia de gol ', diferencia);
				writeln('Partidos ganados ', ganados);
				writeln('Partidos empatados ', empatados);
				writeln('Partidos perdidos ', perdidos);
				writeln('Cantidad total de puntos ', totalPuntos);
				writeln('-----------------------------------------');
			end;
			writeln('El equipo ', nomCampeon, ' fue campeon del torneo ', torneoAct, ', del anio ', anioAct);
			writeln('-----------------------------------------');
		end;
		writeln('-----------------------------------------');
	end;
	close(a);
end;

var
	a: archivo;
begin
	assign(a, 'archivoTorneos.dat');
	cargarArchivo(a);
	informar(a);
end.
			
			
			
			
			
			
			
			
