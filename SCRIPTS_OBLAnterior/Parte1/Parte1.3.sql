ALTER SESSION SET NLS_DATE_FORMAT='DD/MM/YYYY';

-- Borrado de tablas (en orden inverso de dependencias)
DROP TABLE Mision_Es_Previa_De_Zona       CASCADE CONSTRAINTS;
DROP TABLE Mision_Es_Previa_De_Mision     CASCADE CONSTRAINTS;
DROP TABLE Recompensa_Posee_Item          CASCADE CONSTRAINTS;
DROP TABLE Mision_Da_Recompensa           CASCADE CONSTRAINTS;
DROP TABLE Enemigo_Deja_Recompensa        CASCADE CONSTRAINTS;
DROP TABLE Jefe_Aparece_En_Mision         CASCADE CONSTRAINTS;
DROP TABLE Enemigo_Habita_En_Zona         CASCADE CONSTRAINTS;
DROP TABLE Jefe_Tiene_Habilidades         CASCADE CONSTRAINTS;
DROP TABLE Personaje_Posee_Items          CASCADE CONSTRAINTS;
DROP TABLE Personaje_Posee_Habilidades    CASCADE CONSTRAINTS;
-- DROP TABLE Jugador_Tiene_Personaje     CASCADE CONSTRAINTS;
DROP TABLE Mapa                           CASCADE CONSTRAINTS;
DROP TABLE CaracteristicaAfectada         CASCADE CONSTRAINTS;
DROP TABLE Item_Material                  CASCADE CONSTRAINTS;
DROP TABLE Item_Consumible                CASCADE CONSTRAINTS;
DROP TABLE Item_Armadura                  CASCADE CONSTRAINTS;
DROP TABLE Item_Arma                      CASCADE CONSTRAINTS;
DROP TABLE Item_Reliquia                  CASCADE CONSTRAINTS;
DROP TABLE Items                          CASCADE CONSTRAINTS;
DROP TABLE Misiones                       CASCADE CONSTRAINTS;
DROP TABLE Recompensa                     CASCADE CONSTRAINTS;
DROP TABLE Zona                           CASCADE CONSTRAINTS;
DROP TABLE EnemigoJefe                    CASCADE CONSTRAINTS;
DROP TABLE EnemigoElite                   CASCADE CONSTRAINTS;
DROP TABLE EnemigoNormal                  CASCADE CONSTRAINTS;
DROP TABLE Enemigo                        CASCADE CONSTRAINTS;
DROP TABLE Habilidades                    CASCADE CONSTRAINTS;
DROP TABLE Personaje                      CASCADE CONSTRAINTS;
DROP TABLE Jugador                        CASCADE CONSTRAINTS;
DROP TABLE Mision_Es_Previa_De_Habilidad CASCADE CONSTRAINTS;
-- Tablas de entidades

CREATE TABLE Jugador (
    nombre         VARCHAR2(50)  NOT NULL,
    fecha_registro DATE          NOT NULL,
    email          VARCHAR2(40)  NOT NULL,
    contrasena     VARCHAR2(40)  NOT NULL,
    nombrePais     VARCHAR2(20)  NOT NULL,
    cantHoras      NUMBER(5)     NOT NULL  CHECK (cantHoras >= 0),
    nombreRegion   VARCHAR2(20)  NOT NULL  CHECK (nombreRegion IN ('AMERICA','AFRICA','EUROPA','ASIA','OCEANIA')),
    CONSTRAINT pk_Jugador        PRIMARY KEY (email),
    CONSTRAINT uq_Jugador_nombre UNIQUE (nombre)
);

CREATE TABLE Personaje (
    email_Jugador VARCHAR2(40)  NOT NULL,
    id            NUMBER(5)     NOT NULL,
    especie       VARCHAR2(10)  NOT NULL CHECK (especie IN ('Bestia','Espíritu','Humano','Demonio')),
    fuerza        NUMBER(10)    NOT NULL CHECK (fuerza BETWEEN 0 AND 100),
    agilidad      NUMBER(10)    NOT NULL CHECK (agilidad BETWEEN 0 AND 100),
    inteligencia  NUMBER(10)    NOT NULL CHECK (inteligencia BETWEEN 0 AND 100),
    vitalidad     NUMBER(10)    NOT NULL CHECK (vitalidad BETWEEN 0 AND 100),
    resistencia   NUMBER(10)    NOT NULL CHECK (resistencia BETWEEN 0 AND 100),
    nivel         NUMBER(10)    NOT NULL CHECK (nivel BETWEEN 0 AND 342),
    cantMonedas   NUMBER(10)    NOT NULL,
    CONSTRAINT pk_Personaje         PRIMARY KEY (email_Jugador),
    CONSTRAINT uq_Personaje_id      UNIQUE (id),
    CONSTRAINT fk_Personaje_Jugador FOREIGN KEY (email_Jugador)
        REFERENCES Jugador(email)
);

CREATE TABLE Habilidades (
    nombre        VARCHAR2(20)  NOT NULL,
    nivelMin      NUMBER(3)     NOT NULL  CHECK (nivelMin BETWEEN 0 AND 342),
    tipoEnergia   VARCHAR2(10)  NOT NULL  CHECK (tipoEnergia IN ('Energia','Mana')),
    clasificacion VARCHAR2(10)  NOT NULL  CHECK (clasificacion IN ('Ataque','Defensa','Magia')),
    CONSTRAINT pk_Habilidades PRIMARY KEY (nombre)
);

CREATE TABLE Enemigo (
    nombre     VARCHAR2(20) NOT NULL,
    nivel      NUMBER(10)   NOT NULL,
    tipo       VARCHAR2(10) NOT NULL,
    ubicacion  VARCHAR2(100),
    CONSTRAINT pk_Enemigo PRIMARY KEY (nombre)
);

CREATE TABLE EnemigoNormal (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_EnemigoNormal       PRIMARY KEY (nombre),
    CONSTRAINT fk_EnemigoNormal       FOREIGN KEY (nombre)
      REFERENCES Enemigo(nombre)
);

CREATE TABLE EnemigoElite (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_EnemigoElite        PRIMARY KEY (nombre),
    CONSTRAINT fk_EnemigoElite        FOREIGN KEY (nombre)
      REFERENCES Enemigo(nombre)
);

CREATE TABLE EnemigoJefe (
    nombre            VARCHAR2(20) NOT NULL,
    habilidadEspecial VARCHAR2(100),
    CONSTRAINT pk_EnemigoJefe        PRIMARY KEY (nombre),
    CONSTRAINT fk_EnemigoJefe        FOREIGN KEY (nombre)
      REFERENCES Enemigo(nombre)
);

CREATE TABLE Zona (
    nombre      VARCHAR2(20) NOT NULL,
    descripcion VARCHAR2(50) NOT NULL,
    nivelMin    NUMBER(3)    NOT NULL CHECK (nivelMin BETWEEN 0 AND 342),
    limites     NUMBER(5)    NOT NULL,
    CONSTRAINT pk_Zona PRIMARY KEY (nombre)
);

CREATE TABLE Recompensa (
    id              NUMBER(5)  NOT NULL,
    cantMonedas     NUMBER(10) NOT NULL,
    cantExperiencia NUMBER(10) NOT NULL,
    CONSTRAINT pk_Recompensa PRIMARY KEY (id)
);

CREATE TABLE Misiones (
    id         NUMBER(5)  NOT NULL,
    nombre     VARCHAR2(20) NOT NULL,
    descripcion VARCHAR2(50) NOT NULL,
    nivelMin   NUMBER(3)    NOT NULL CHECK (nivelMin BETWEEN 0 AND 342),
    estado     VARCHAR2(10) NOT NULL CHECK (estado IN ('Principal','Secundaria','Especial')),
    CONSTRAINT pk_Misiones PRIMARY KEY (id)
);

CREATE TABLE Items (
    nombre               VARCHAR2(20) NOT NULL,
    rareza               VARCHAR2(10) NOT NULL  CHECK (rareza IN ('Comun','Rara','Epica','Legendaria')),
    nivelMinUtilizacion  NUMBER(3)     NOT NULL  CHECK (nivelMinUtilizacion BETWEEN 0 AND 342),
    intercambiable       CHAR(1)       NOT NULL  CHECK (intercambiable IN ('S','N')),
    CONSTRAINT pk_Items PRIMARY KEY (nombre)
);

CREATE TABLE CaracteristicaAfectada (
    nombreItem     VARCHAR2(20) NOT NULL,
    caracteristica VARCHAR2(15) NOT NULL CHECK (caracteristica IN ('Agilidad','Fuerza','Inteligencia','Vitalidad','Resistencia')),
    cantAfectacion NUMBER(3)    NOT NULL CHECK (cantAfectacion >= 0),
    CONSTRAINT pk_CaracteristicaAfectada     PRIMARY KEY (nombreItem, caracteristica),
    CONSTRAINT fk_CaractAfectada_Items       FOREIGN KEY (nombreItem)
      REFERENCES Items(nombre)
);

CREATE TABLE Item_Arma (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_Item_Arma       PRIMARY KEY (nombre),
    CONSTRAINT fk_Item_Arma       FOREIGN KEY (nombre)
      REFERENCES Items(nombre)
);

CREATE TABLE Item_Armadura (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_Item_Armadura   PRIMARY KEY (nombre),
    CONSTRAINT fk_Item_Armadura   FOREIGN KEY (nombre)
      REFERENCES Items(nombre)
);

CREATE TABLE Item_Consumible (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_Item_Consumible PRIMARY KEY (nombre),
    CONSTRAINT fk_Item_Consumible FOREIGN KEY (nombre)
      REFERENCES Items(nombre)
);

CREATE TABLE Item_Material (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_Item_Material   PRIMARY KEY (nombre),
    CONSTRAINT fk_Item_Material   FOREIGN KEY (nombre)
      REFERENCES Items(nombre)
);

CREATE TABLE Item_Reliquia (
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_Item_Reliquia   PRIMARY KEY (nombre),
    CONSTRAINT fk_Item_Reliquia   FOREIGN KEY (nombre)
      REFERENCES Items(nombre)
);

CREATE TABLE Mapa (
    id NUMBER(5) NOT NULL,
    CONSTRAINT pk_Mapa PRIMARY KEY (id)
);

CREATE TABLE Personaje_Posee_Habilidades (
    emailJugador   VARCHAR2(40) NOT NULL,
    idPersonaje    NUMBER(5)    NOT NULL,
    nombreHabilidad VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_PoseeHab       PRIMARY KEY (emailJugador, idPersonaje, nombreHabilidad),
    CONSTRAINT fk_PoseeHab_Pers  FOREIGN KEY (emailJugador)
      REFERENCES Personaje(email_Jugador),
    CONSTRAINT fk_PoseeHab_Hab   FOREIGN KEY (nombreHabilidad)
      REFERENCES Habilidades(nombre)
);

CREATE TABLE Personaje_Posee_Items (
    emailJugador VARCHAR2(40) NOT NULL,
    idPersonaje  NUMBER(5)    NOT NULL,
    nombreItem   VARCHAR2(20) NOT NULL,
    equipado     CHAR(1)      NOT NULL  CHECK (equipado IN ('S','N')),
    CONSTRAINT pk_PoseeItem    PRIMARY KEY (emailJugador, idPersonaje, nombreItem),
    CONSTRAINT fk_PoseeItem_Pers   FOREIGN KEY (emailJugador)
      REFERENCES Personaje(email_Jugador),
    CONSTRAINT fk_PoseeItem_Item   FOREIGN KEY (nombreItem)
      REFERENCES Items(nombre)
);

CREATE TABLE Jefe_Tiene_Habilidades (
    nombreJefe      VARCHAR2(20) NOT NULL,
    nombreHabilidad VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_JefeHab        PRIMARY KEY (nombreJefe, nombreHabilidad),
    CONSTRAINT fk_JefeHab_Jefe   FOREIGN KEY (nombreJefe)
      REFERENCES EnemigoJefe(nombre),
    CONSTRAINT fk_JefeHab_Hab    FOREIGN KEY (nombreHabilidad)
      REFERENCES Habilidades(nombre)
);

CREATE TABLE Enemigo_Habita_En_Zona (
    nombreZona    VARCHAR2(20) NOT NULL,
    nombreEnemigo VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_HabitaZona     PRIMARY KEY (nombreZona, nombreEnemigo),
    CONSTRAINT fk_HabitaZona_Zona FOREIGN KEY (nombreZona)
      REFERENCES Zona(nombre),
    CONSTRAINT fk_HabitaZona_Enemigo FOREIGN KEY (nombreEnemigo)
      REFERENCES Enemigo(nombre)
);

CREATE TABLE Jefe_Aparece_En_Mision (
    codigoMision NUMBER(5)  NOT NULL,
    nombreJefe   VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_JefeAparece PRIMARY KEY (codigoMision, nombreJefe),
    CONSTRAINT fk_JefeApm_Mision FOREIGN KEY (codigoMision)
      REFERENCES Misiones(id),
    CONSTRAINT fk_JefeApm_Jefe    FOREIGN KEY (nombreJefe)
      REFERENCES EnemigoJefe(nombre)
);

CREATE TABLE Enemigo_Deja_Recompensa (
    nombreEnemigo VARCHAR2(20) NOT NULL,
    idRecompensa  NUMBER(5)    NOT NULL,
    CONSTRAINT pk_DejaRec       PRIMARY KEY (nombreEnemigo, idRecompensa),
    CONSTRAINT fk_DejaRec_Enemigo FOREIGN KEY (nombreEnemigo)
      REFERENCES Enemigo(nombre),
    CONSTRAINT fk_DejaRec_Rec      FOREIGN KEY (idRecompensa)
      REFERENCES Recompensa(id)
);

CREATE TABLE Mision_Da_Recompensa (
    codMision     NUMBER(5) NOT NULL,
    idRecompensa  NUMBER(5) NOT NULL,
    CONSTRAINT pk_DaRec       PRIMARY KEY (codMision, idRecompensa),
    CONSTRAINT fk_DaRec_Mision FOREIGN KEY (codMision)
      REFERENCES Misiones(id),
    CONSTRAINT fk_DaRec_Rec      FOREIGN KEY (idRecompensa)
      REFERENCES Recompensa(id)
);

CREATE TABLE Recompensa_Posee_Item (
    nombreItem   VARCHAR2(20) NOT NULL,
    idRecompensa NUMBER(5)    NOT NULL,
    CONSTRAINT pk_RecPosee      PRIMARY KEY (nombreItem, idRecompensa),
    CONSTRAINT fk_RecPosee_Item FOREIGN KEY (nombreItem)
      REFERENCES Items(nombre),
    CONSTRAINT fk_RecPosee_Rec  FOREIGN KEY (idRecompensa)
      REFERENCES Recompensa(id)
);

CREATE TABLE Mision_Es_Previa_De_Mision (
    codMision1 NUMBER(5) NOT NULL,
    codMision2 NUMBER(5) NOT NULL,
    CONSTRAINT pk_PreviaMision  PRIMARY KEY (codMision1, codMision2),
    CONSTRAINT fk_PreviaM1       FOREIGN KEY (codMision1)
      REFERENCES Misiones(id),
    CONSTRAINT fk_PreviaM2       FOREIGN KEY (codMision2)
      REFERENCES Misiones(id)
);

CREATE TABLE Mision_Es_Previa_De_Zona (
    codMision  NUMBER(5)    NOT NULL,
    nombreZona VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_PreviaZona    PRIMARY KEY (codMision, nombreZona),
    CONSTRAINT fk_PreviaZ_Mision FOREIGN KEY (codMision)
      REFERENCES Misiones(id),
    CONSTRAINT fk_PreviaZ_Zona   FOREIGN KEY (nombreZona)
      REFERENCES Zona(nombre)
);

CREATE TABLE Mision_Es_Previa_De_Habilidad (
    codMision  NUMBER(5)    NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_PreviaHabilidad    PRIMARY KEY (codMision, nombre),
    CONSTRAINT fk_PreviaH_Mision FOREIGN KEY (codMision)
      REFERENCES Misiones(id),
    CONSTRAINT fk_PreviaH_Habilidad   FOREIGN KEY (nombre)
      REFERENCES Habilidades(nombre)
);
