SET SERVEROUTPUT ON;

-- Iniciamos un log para ver los resultados de las pruebas de forma ordenada.
SPOOL casos_de_prueba_triggers.log

-- CONFIGURACIÓN INICIAL DE DATOS PARA LAS PRUEBAS

-- Limpiamos datos de pruebas anteriores para poder re-ejecutar el script
DELETE FROM Personaje_Mision WHERE emailJugador LIKE '%@test.com';
DELETE FROM Log_Aumento_Nivel WHERE emailJugador LIKE '%@test.com';
DELETE FROM Log_Premio_Diario WHERE emailJugador LIKE '%@test.com';
DELETE FROM Personaje WHERE email_Jugador LIKE '%@test.com';
DELETE FROM Jugador WHERE email LIKE '%@test.com';
DELETE FROM Mision_Es_Previa_De_Mision WHERE codMision1 >= 1001;
DELETE FROM Misiones WHERE id >= 1001;
COMMIT;

-- Creamos datos de prueba
INSERT INTO Jugador (nombre, fecha_registro, email, contrasena, nombrePais, cantHoras, nombreRegion)
VALUES ('Tester_1', SYSDATE, 'jugador1@test.com', 'test', 'Uruguay', 10, 'AMERICA');

INSERT INTO Personaje (email_Jugador, id, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, cantMonedas)
VALUES ('jugador1@test.com', 999, 'Humano', 50, 50, 50, 50, 50, 10, 1000);

INSERT INTO Misiones (id, nombre, descripcion, nivelMin, estado) VALUES (1001, 'Mision A', 'La primera mision.', 1, 'Principal');
INSERT INTO Misiones (id, nombre, descripcion, nivelMin, estado) VALUES (1002, 'Mision B', 'Requiere Mision A.', 5, 'Principal');
INSERT INTO Misiones (id, nombre, descripcion, nivelMin, estado) VALUES (1003, 'Mision C', 'Requiere Mision B.', 10, 'Secundaria');

INSERT INTO Mision_Es_Previa_De_Mision(codMision1, codMision2) VALUES (1001, 1002);
INSERT INTO Mision_Es_Previa_De_Mision(codMision1, codMision2) VALUES (1002, 1003);
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('>> Datos de configuración inicial cargados.');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END;
/


-- PRUEBAS PARA EL TRIGGER: TRG_AJUSTAR_CARACTERISTICAS
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO PRUEBAS: TRG_AJUSTAR_CARACTERISTICAS ---');
    DBMS_OUTPUT.PUT_LINE('-- Caso 1 (Feliz): Actualización normal de 50 a 75.');
END;
/
UPDATE Personaje SET fuerza = 75 WHERE email_Jugador = 'jugador1@test.com';
SELECT fuerza FROM Personaje WHERE email_Jugador = 'jugador1@test.com';
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 2 (Triste): Intento de poner agilidad a 150. Debería quedar en 100.');
END;
/
UPDATE Personaje SET agilidad = 150 WHERE email_Jugador = 'jugador1@test.com';
SELECT agilidad FROM Personaje WHERE email_Jugador = 'jugador1@test.com';
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 3 (Triste): Intento de poner inteligencia a -50. Debería quedar en 0.');
END;
/
UPDATE Personaje SET inteligencia = -50 WHERE email_Jugador = 'jugador1@test.com';
SELECT inteligencia FROM Personaje WHERE email_Jugador = 'jugador1@test.com';
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 4 (Feliz): Poner vitalidad en 100. Debería aceptarlo.');
END;
/
UPDATE Personaje SET vitalidad = 100 WHERE email_Jugador = 'jugador1@test.com';
SELECT vitalidad FROM Personaje WHERE email_Jugador = 'jugador1@test.com';
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- FIN PRUEBAS: TRG_AJUSTAR_CARACTERISTICAS ---');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END;
/

--==============================================================================
-- PRUEBAS PARA EL TRIGGER: TRG_VALIDAR_INICIO_MISION
--==============================================================================
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO PRUEBAS: TRG_VALIDAR_INICIO_MISION ---');
    DBMS_OUTPUT.PUT_LINE('-- Caso 1 (Feliz): Iniciar Mision A (ID 1001), que no tiene previas.');
END;
/
INSERT INTO Personaje_Mision (emailJugador, idMision, estado_mision_pers, fecha_estado) VALUES ('jugador1@test.com', 1001, 'En progreso', SYSDATE);
SELECT COUNT(*) AS "MISION 1001 EN PROGRESO" FROM Personaje_Mision WHERE emailJugador = 'jugador1@test.com' AND idMision = 1001;
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 2 (Triste): Intentar iniciar Mision C (ID 1003). Fallará porque Mision B no está completa.');
END;
/
BEGIN
    INSERT INTO Personaje_Mision (emailJugador, idMision, estado_mision_pers, fecha_estado) VALUES ('jugador1@test.com', 1003, 'En progreso', SYSDATE);
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20001 THEN
            DBMS_OUTPUT.PUT_LINE('>> ÉXITO: El trigger bloqueó la operación con el error esperado.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('>> FALLO: Se esperaba el error -20001 pero se obtuvo otro: ' || SQLERRM);
            RAISE;
        END IF;
END;
/
ROLLBACK;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 3 (Feliz): Completar Mision A e intentar iniciar Mision B (ID 1002).');
END;
/
-- Primero completamos la Misión A
UPDATE Personaje_Mision SET estado_mision_pers = 'Completada', fecha_estado = SYSDATE WHERE emailJugador = 'jugador1@test.com' AND idMision = 1001;
-- Ahora intentamos iniciar la Misión B
INSERT INTO Personaje_Mision (emailJugador, idMision, estado_mision_pers, fecha_estado) VALUES ('jugador1@test.com', 1002, 'En progreso', SYSDATE);
SELECT COUNT(*) AS "MISION 1002 EN PROGRESO" FROM Personaje_Mision WHERE emailJugador = 'jugador1@test.com' AND idMision = 1002;
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- FIN PRUEBAS: TRG_VALIDAR_INICIO_MISION ---');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
END;
/

SPOOL OFF;