--DROP de usuarios
DROP USER ADM1;
DROP USER DIS1;
DROP USER JUG1;


--Creamos usuarios para poder hacer pruebas
CREATE USER ADM1 
IDENTIFIED BY adm1adm1
DEFAULT TABLESPACE SYSTEM
TEMPORARY TABLESPACE TEMP;

CREATE USER DIS1 
IDENTIFIED BY dis1dis1
DEFAULT TABLESPACE SYSTEM
TEMPORARY TABLESPACE TEMP;

CREATE USER JUG1 
IDENTIFIED BY jug1jug1
DEFAULT TABLESPACE SYSTEM
TEMPORARY TABLESPACE TEMP;


-- DROP de ROLES
DROP ROLE ADMINISTRADOR;
DROP ROLE JUGADOR;
DROP ROLE DISENIADOR;


--Creamos los ROLES
CREATE ROLE ADMINISTRADOR
NOT IDENTIFIED;

CREATE ROLE JUGADOR
NOT IDENTIFIED;

CREATE ROLE DISENIADOR
NOT IDENTIFIED;




--Drop de vistas
DROP VIEW JugadorVistaSinContra CASCADE CONSTRAINTS;
DROP VIEW InfoPropioJugador CASCADE CONSTRAINTS;
DROP VIEW PersonajeJugadorSinEspecie CASCADE CONSTRAINTS;
DROP VIEW PersonajeJugador CASCADE CONSTRAINTS;
--Creacion de vistas

CREATE OR REPLACE VIEW JugadorVistaSinContra AS
SELECT nombrePais, email, nombre, 
        fecha_registro, cantHoras, nombreRegion
FROM Jugador;

CREATE OR REPLACE VIEW InfoPropioJugador AS
SELECT *
FROM Jugador
WHERE nombre = USER; -- no es PK pero es UNIQUE

CREATE OR REPLACE VIEW PersonajeJugadorSinEspecie AS
SELECT p.id, p.email_Jugador, p.fuerza, p.agilidad, 
       p.inteligencia, p.vitalidad, p.resistencia, 
       p.nivel, p.cantMonedas
FROM Personaje p, Jugador j
WHERE p.email_Jugador = j.email
AND j.nombre = USER; -- no es PK pero es UNIQUE

CREATE OR REPLACE VIEW PersonajeJugador AS
SELECT p.id, p.email_Jugador, p.fuerza, p.agilidad, 
       p.inteligencia, p.vitalidad, p.resistencia, 
       p.nivel, p.cantMonedas, p.especie
FROM Personaje p, Jugador j
WHERE p.email_Jugador = j.email
AND j.nombre = USER; -- no es PK pero es UNIQUE

--Asignamos los privilegios a ROL ADMINISTRADOR
GRANT CREATE SESSION TO ADMINISTRADOR;
GRANT SELECT ON JugadorVistaSinContra TO ADMINISTRADOR;
GRANT UPDATE ON JugadorVistaSinContra TO ADMINISTRADOR;

--Asignamos los privilegios a ROL DISENIADOR
GRANT CREATE SESSION TO DISENIADOR;
GRANT SELECT ON Items TO DISENIADOR;
GRANT UPDATE ON Items TO DISENIADOR;
GRANT INSERT ON Items TO DISENIADOR;

GRANT SELECT ON Zona TO DISENIADOR;
GRANT UPDATE ON Zona TO DISENIADOR;
GRANT INSERT ON Zona TO DISENIADOR;

GRANT SELECT ON EnemigoJefe TO DISENIADOR;
GRANT UPDATE ON EnemigoJefe TO DISENIADOR;
GRANT INSERT ON EnemigoJefe TO DISENIADOR;

GRANT SELECT ON Enemigo TO DISENIADOR;
GRANT UPDATE ON Enemigo TO DISENIADOR;
GRANT INSERT ON Enemigo TO DISENIADOR;

--Asignamos los privilegios a ROL JUGADOR
GRANT CREATE SESSION TO JUGADOR;
GRANT SELECT ON InfoPropioJugador TO JUGADOR;
GRANT UPDATE ON InfoPropioJugador TO JUGADOR;

GRANT SELECT ON PersonajeJugadorSinEspecie TO JUGADOR;
GRANT UPDATE ON PersonajeJugadorSinEspecie TO JUGADOR;

GRANT SELECT ON PersonajeJugador TO JUGADOR;



-- Asignamos los roles a los usuarios
GRANT DISENIADOR TO DIS1;
GRANT JUGADOR TO JUG1;
GRANT ADMINISTRADOR TO ADM1;
