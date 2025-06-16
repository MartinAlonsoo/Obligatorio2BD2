-- =======================
-- DATOS DE PRUEBA
-- =======================

-- Jugadores
INSERT INTO Jugador 
  (nombre, fecha_registro, email, contrasena, nombrePais, cantHoras, nombreRegion)
VALUES
  ('JUG1', TO_DATE('01/01/2024','DD/MM/YYYY'), 'wukong@monkey.com', 'pass123', 'China', 50, 'AMERICA');

INSERT INTO Jugador 
  (nombre, fecha_registro, email, contrasena, nombrePais, cantHoras, nombreRegion)
VALUES
  ('Tripitaka', TO_DATE('15/03/2024','DD/MM/YYYY'), 'tripitaka@templo.com', 's123456', 'India', 20, 'ASIA');

-- Personajes
INSERT INTO Personaje 
  (email_Jugador, id, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, cantMonedas)
VALUES
  ('wukong@monkey.com', 1, 'Bestia', 90, 80, 60, 70, 65, 120, 5000);

INSERT INTO Personaje 
  (email_Jugador, id, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, cantMonedas)
VALUES
  ('tripitaka@templo.com', 2, 'Humano', 40, 45, 85, 50, 60, 80, 300);

-- Habilidades
INSERT INTO Habilidades 
  (nombre, nivelMin, tipoEnergia, clasificacion)
VALUES
  ('Bastón Extensible', 20, 'Energia', 'Ataque');

INSERT INTO Habilidades 
  (nombre, nivelMin, tipoEnergia, clasificacion)
VALUES
  ('Escudo Espiritual', 15, 'Mana', 'Defensa');

INSERT INTO Habilidades 
  (nombre, nivelMin, tipoEnergia, clasificacion)
VALUES
  ('Llamas Celestiales', 50, 'Mana', 'Magia');

-- Enemigos
INSERT INTO Enemigo 
  (nombre, nivel, tipo, ubicacion)
VALUES
  ('Tigre Demonio', 60, 'Feral', 'Bosque de Bambú');

INSERT INTO Enemigo 
  (nombre, nivel, tipo, ubicacion)
VALUES
  ('Mono Blanco', 30, 'Simio', 'Cueva del Viento');

INSERT INTO Enemigo 
  (nombre, nivel, tipo, ubicacion)
VALUES
  ('Rey Toro', 150, 'Demonio', 'Volcán Ardiente');

-- Subtipos de enemigo
INSERT INTO EnemigoNormal (nombre) VALUES ('Mono Blanco');
INSERT INTO EnemigoElite  (nombre) VALUES ('Tigre Demonio');
INSERT INTO EnemigoJefe   (nombre, habilidadEspecial) VALUES ('Rey Toro', 'Carga Infernal');

-- Zonas
INSERT INTO Zona VALUES ('Bosque de Bambú', 'Zona con enemigos veloces y follaje denso.', 10, 500);
INSERT INTO Zona VALUES ('Volcán Ardiente', 'Zona final con lava y jefes de fuego.', 100, 800);

-- Mapa
INSERT INTO Mapa (id) VALUES (1);

-- Misiones
INSERT INTO Misiones 
  (id, nombre, descripcion, nivelMin, estado)
VALUES
  (101, 'Inicio del Viaje', 'Comienza tu travesía', 1, 'Principal');

INSERT INTO Misiones 
  (id, nombre, descripcion, nivelMin, estado)
VALUES
  (102, 'Furia del Volcán', 'Derrota al Rey Toro', 100, 'Principal');

-- Recompensas
INSERT INTO Recompensa 
  (id, cantMonedas, cantExperiencia)
VALUES
  (1, 1000, 200);

INSERT INTO Recompensa 
  (id, cantMonedas, cantExperiencia)
VALUES
  (2, 5000, 1000);

-- Items
INSERT INTO Items 
  (nombre, rareza, nivelMinUtilizacion, intercambiable)
VALUES
  ('Espada de Jade', 'Rara', 10, 'S');

INSERT INTO Items 
  (nombre, rareza, nivelMinUtilizacion, intercambiable)
VALUES
  ('Armadura de Fuego', 'Epica', 100, 'N');

INSERT INTO Items 
  (nombre, rareza, nivelMinUtilizacion, intercambiable)
VALUES
  ('Reliquia Celestial', 'Legendaria', 120, 'N');

-- Características Afectadas
INSERT INTO CaracteristicaAfectada 
  (nombreItem, caracteristica, cantAfectacion)
VALUES
  ('Espada de Jade', 'Fuerza', 10);

INSERT INTO CaracteristicaAfectada 
  (nombreItem, caracteristica, cantAfectacion)
VALUES
  ('Armadura de Fuego', 'Resistencia', 25);

INSERT INTO CaracteristicaAfectada 
  (nombreItem, caracteristica, cantAfectacion)
VALUES
  ('Reliquia Celestial', 'Inteligencia', 40);

-- Subtipos de Ítems
INSERT INTO Item_Arma     (nombre) VALUES ('Espada de Jade');
INSERT INTO Item_Armadura (nombre) VALUES ('Armadura de Fuego');
INSERT INTO Item_Reliquia (nombre) VALUES ('Reliquia Celestial');

-- Personaje posee habilidades
INSERT INTO Personaje_Posee_Habilidades 
  (emailJugador, idPersonaje, nombreHabilidad)
VALUES
  ('wukong@monkey.com', 1, 'Bastón Extensible');

INSERT INTO Personaje_Posee_Habilidades 
  (emailJugador, idPersonaje, nombreHabilidad)
VALUES
  ('wukong@monkey.com', 1, 'Llamas Celestiales');

INSERT INTO Personaje_Posee_Habilidades 
  (emailJugador, idPersonaje, nombreHabilidad)
VALUES
  ('tripitaka@templo.com', 2, 'Escudo Espiritual');

-- Personaje posee ítems
INSERT INTO Personaje_Posee_Items 
  (emailJugador, idPersonaje, nombreItem, equipado)
VALUES
  ('wukong@monkey.com', 1, 'Espada de Jade', 'S');

INSERT INTO Personaje_Posee_Items 
  (emailJugador, idPersonaje, nombreItem, equipado)
VALUES
  ('wukong@monkey.com', 1, 'Reliquia Celestial', 'N');

-- Enemigos habitan zonas
INSERT INTO Enemigo_Habita_En_Zona 
  (nombreZona, nombreEnemigo)
VALUES
  ('Bosque de Bambú', 'Tigre Demonio');

INSERT INTO Enemigo_Habita_En_Zona 
  (nombreZona, nombreEnemigo)
VALUES
  ('Volcán Ardiente', 'Rey Toro');

-- Jefe aparece en misión
INSERT INTO Jefe_Aparece_En_Mision 
  (codigoMision, nombreJefe)
VALUES
  (102, 'Rey Toro');

-- Jefe tiene habilidades
INSERT INTO Jefe_Tiene_Habilidades 
  (nombreJefe, nombreHabilidad)
VALUES
  ('Rey Toro', 'Llamas Celestiales');

-- Recompensas dejadas por enemigos
INSERT INTO Enemigo_Deja_Recompensa 
  (nombreEnemigo, idRecompensa)
VALUES
  ('Rey Toro', 2);

-- Misiones dan recompensa
INSERT INTO Mision_Da_Recompensa 
  (codMision, idRecompensa)
VALUES
  (101, 1);

INSERT INTO Mision_Da_Recompensa 
  (codMision, idRecompensa)
VALUES
  (102, 2);

-- Recompensas poseen ítems
INSERT INTO Recompensa_Posee_Item 
  (nombreItem, idRecompensa)
VALUES
  ('Reliquia Celestial', 2);

-- Relaciones de misión previa
INSERT INTO Mision_Es_Previa_De_Mision 
  (codMision1, codMision2)
VALUES
  (101, 102);

INSERT INTO Mision_Es_Previa_De_Zona 
  (codMision, nombreZona)
VALUES
  (101, 'Volcán Ardiente');
