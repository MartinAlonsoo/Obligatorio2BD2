SET SERVEROUTPUT ON;

-- Limpieza completa de tablas relevantes para asegurar un entorno limpio
DELETE FROM Personaje_Mision;
DELETE FROM Log_Aumento_Nivel;
DELETE FROM Log_Premio_Diario;
DELETE FROM Personaje_Posee_Items;
DELETE FROM Personaje_Posee_Habilidades;
DELETE FROM Mision_Es_Previa_De_Mision;
DELETE FROM Mision_Da_Recompensa;
DELETE FROM Recompensa_Posee_Item;
DELETE FROM Personaje;
DELETE FROM Jugador;
DELETE FROM Misiones;
DELETE FROM Items;
DELETE FROM Habilidades;
DELETE FROM Recompensa;
COMMIT;

-- Creación de datos base autocontenida
INSERT INTO Jugador (nombre, fecha_registro, email, contrasena, nombrePais, cantHoras, nombreRegion) VALUES ('JUG1', TO_DATE('01/01/2024','DD/MM/YYYY'), 'wukong@monkey.com', 'pass123', 'China', 50, 'AMERICA');
INSERT INTO Jugador (nombre, fecha_registro, email, contrasena, nombrePais, cantHoras, nombreRegion) VALUES ('Tripitaka', TO_DATE('15/03/2024','DD/MM/YYYY'), 'tripitaka@templo.com', 's123456', 'India', 20, 'ASIA');
INSERT INTO Personaje (email_Jugador, id, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, cantMonedas) VALUES ('wukong@monkey.com', 1, 'Bestia', 90, 80, 60, 70, 65, 120, 5000);
INSERT INTO Personaje (email_Jugador, id, especie, fuerza, agilidad, inteligencia, vitalidad, resistencia, nivel, cantMonedas) VALUES ('tripitaka@templo.com', 2, 'Humano', 40, 45, 85, 50, 60, 80, 300);

INSERT INTO Misiones (id, nombre, descripcion, nivelMin, estado) VALUES (101, 'Mision A', 'La primera mision.', 1, 'Principal');
INSERT INTO Misiones (id, nombre, descripcion, nivelMin, estado) VALUES (1002, 'Mision B', 'Requiere Mision A.', 5, 'Principal');
INSERT INTO Mision_Es_Previa_De_Mision(codMision1, codMision2) VALUES (101, 1002);

INSERT INTO Items (nombre, categoria, rareza, nivelMinUtilizacion, intercambiable) VALUES ('Espada de Jade', 'Arma', 'Rara', 10, 'S');
INSERT INTO Items (nombre, categoria, rareza, nivelMinUtilizacion, intercambiable) VALUES ('Armadura de Fuego', 'Armadura', 'Epica', 100, 'S'); -- Hecho intercambiable para la prueba
INSERT INTO Items (nombre, categoria, rareza, nivelMinUtilizacion, intercambiable) VALUES ('Reliquia Celestial', 'Reliquia', 'Legendaria', 120, 'N');
INSERT INTO Items (nombre, categoria, rareza, nivelMinUtilizacion, intercambiable) VALUES ('Daga Veloz', 'Arma', 'Comun', 5, 'S');
INSERT INTO Items (nombre, categoria, rareza, nivelMinUtilizacion, intercambiable) VALUES ('Daga lenta', 'Arma', 'Comun', 5, 'S');

INSERT INTO Recompensa (id, cantMonedas, cantExperiencia) VALUES (1, 1000, 200);
INSERT INTO Mision_Da_Recompensa (codMision, idRecompensa) VALUES (101, 1);
COMMIT;

-- Carga de datos específicos para escenarios de prueba
-- Para Servicio 2.1
INSERT INTO Personaje_Mision (emailJugador, idMision, estado_mision_pers, recompensas_recibidas, fecha_estado) VALUES ('wukong@monkey.com', 101, 'Completada', 'N', SYSDATE - 2);
INSERT INTO Personaje_Mision (emailJugador, idMision, estado_mision_pers, recompensas_recibidas, fecha_estado) VALUES ('wukong@monkey.com', 1002, 'En progreso', 'N', SYSDATE - 1);
-- Para Servicio 2.2
INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado) VALUES ('wukong@monkey.com', 1, 'Espada de Jade', 'S');
INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado) VALUES ('wukong@monkey.com', 1, 'Armadura de Fuego', 'S');
INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado) VALUES ('tripitaka@templo.com', 2, 'Espada de Jade', 'S');
INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado) VALUES ('wukong@monkey.com', 1, 'Reliquia Celestial', 'N');
-- Para Servicio 2.3
INSERT INTO Log_Aumento_Nivel (emailJugador, nivel_anterior, nivel_nuevo, fecha_aumento) VALUES ('wukong@monkey.com', 117, 120, SYSDATE - 0.5);
UPDATE Personaje_Mision SET fecha_estado = SYSDATE - 0.2 WHERE emailJugador = 'wukong@monkey.com' AND idMision = 101;
-- Para Servicio 2.4
INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado) VALUES ('tripitaka@templo.com', 2, 'Daga Veloz', 'N');
COMMIT;

BEGIN
    DBMS_OUTPUT.PUT_LINE('>> Datos de prueba cargados exitosamente.');
END;
/


--EJECUCIÓN DE PRUEBAS PARA LOS SERVICIOS

-- CASOS DE PRUEBA PARA EL SERVICIO 2.1:
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- INICIO PRUEBAS: 2.1 PRC_ASIGNAR_RECOMPENSAS ---');
END;
/
DECLARE
    v_monedas_antes NUMBER; v_monedas_despues NUMBER; v_estado_recompensa Personaje_Mision.recompensas_recibidas%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 1.1 (Feliz): Reclamando recompensas para Wukong, misión 101.');
    SELECT cantMonedas INTO v_monedas_antes FROM Personaje WHERE email_Jugador = 'wukong@monkey.com';
    DBMS_OUTPUT.PUT_LINE('   Monedas ANTES: ' || v_monedas_antes);
    PRC_ASIGNAR_RECOMPENSAS('wukong@monkey.com', 101);
    SELECT cantMonedas INTO v_monedas_despues FROM Personaje WHERE email_Jugador = 'wukong@monkey.com';
    DBMS_OUTPUT.PUT_LINE('   Monedas DESPUÉS: ' || v_monedas_despues);
    SELECT recompensas_recibidas INTO v_estado_recompensa FROM Personaje_Mision WHERE emailJugador = 'wukong@monkey.com' AND idMision = 101;
    DBMS_OUTPUT.PUT_LINE('   Verificando estado: ' || v_estado_recompensa);
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('>> FALLO INESPERADO: ' || SQLERRM);
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 1.2 (Triste): Intentando reclamar de nuevo las recompensas.');
    PRC_ASIGNAR_RECOMPENSAS('wukong@monkey.com', 101);
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20004 THEN DBMS_OUTPUT.PUT_LINE('>> ÉXITO: El procedimiento bloqueó la operación con el error esperado.'); ELSE DBMS_OUTPUT.PUT_LINE('>> FALLO: Se esperaba el error -20004 pero se obtuvo otro: ' || SQLERRM); END IF;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 1.3 (Triste): Intentando reclamar recompensas de una misión no completada.');
    PRC_ASIGNAR_RECOMPENSAS('wukong@monkey.com', 1002);
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20003 THEN DBMS_OUTPUT.PUT_LINE('>> ÉXITO: El procedimiento bloqueó la operación con el error esperado.'); ELSE DBMS_OUTPUT.PUT_LINE('>> FALLO: Se esperaba el error -20003 pero se obtuvo otro: ' || SQLERRM); END IF;
END;
/
COMMIT;

-- CASOS DE PRUEBA PARA EL SERVICIO 2.2:
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- INICIO PRUEBAS: 2.2 PRC_TOP_ITEMS_EQUIPADOS ---');
    DBMS_OUTPUT.PUT_LINE('-- Caso 2.1 (Feliz): Top 10 general (sin filtro).');
END;
/
BEGIN
    PRC_TOP_ITEMS_EQUIPADOS();
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 2.2 (Feliz): Top 10 filtrando por categoría ''Arma''.');
END;
/
BEGIN
    PRC_TOP_ITEMS_EQUIPADOS(p_categoria => 'Arma');
END;
/
COMMIT;

-- CASOS DE PRUEBA PARA EL SERVICIO 2.3
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- INICIO PRUEBAS: 2.3 PRC_ACREDITAR_PREMIO_DIARIO ---');
    DBMS_OUTPUT.PUT_LINE('-- Caso 3.1 (Feliz): Ejecutando el premio diario por primera vez.');
END;
/
BEGIN
    PRC_ACREDITAR_PREMIO_DIARIO();
END;
/
SELECT emailJugador, item_recibido, TO_CHAR(fecha_premio, 'DD-MM-YYYY') AS fecha FROM Log_Premio_Diario WHERE TRUNC(fecha_premio) = TRUNC(SYSDATE);
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 3.2 (Triste - Idempotencia): Ejecutando el premio por segunda vez. No debería hacer nada.');
END;
/
BEGIN
    PRC_ACREDITAR_PREMIO_DIARIO();
END;
/
SELECT COUNT(*) AS "Premios entregados hoy" FROM Log_Premio_Diario WHERE TRUNC(fecha_premio) = TRUNC(SYSDATE);
COMMIT;


-- CASOS DE PRUEBA PARA EL SERVICIO 2.4
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- INICIO PRUEBAS: 2.4 PRC_INTERCAMBIAR_ITEMS ---');
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 4.1 (Triste): Wukong intenta intercambiar su Reliquia Celestial (no intercambiable).');
    PRC_INTERCAMBIAR_ITEMS('wukong@monkey.com', 'Reliquia Celestial', 'tripitaka@templo.com', 'Daga Veloz');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -20011 THEN DBMS_OUTPUT.PUT_LINE('>> ÉXITO: El procedimiento bloqueó el intercambio de un ítem no permitido.'); ELSE DBMS_OUTPUT.PUT_LINE('>> FALLO: Se esperaba el error -20011 pero se obtuvo otro: ' || SQLERRM); END IF;
END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('-- Caso 4.2 (Feliz): Wukong intercambia su ''Armadura de Fuego'' por la ''Daga Veloz'' de Tripitaka.');
    DBMS_OUTPUT.PUT_LINE('   Items de Wukong ANTES: ');
    FOR item_rec IN (SELECT nombreItem FROM Personaje_Posee_Items WHERE emailJugador = 'wukong@monkey.com' ORDER BY nombreItem) LOOP DBMS_OUTPUT.PUT_LINE('   - ' || item_rec.nombreItem); END LOOP;
    DBMS_OUTPUT.PUT_LINE('   Items de Tripitaka ANTES: ');
    FOR item_rec IN (SELECT nombreItem FROM Personaje_Posee_Items WHERE emailJugador = 'tripitaka@templo.com' ORDER BY nombreItem) LOOP DBMS_OUTPUT.PUT_LINE('   - ' || item_rec.nombreItem); END LOOP;
    PRC_INTERCAMBIAR_ITEMS('wukong@monkey.com', 'Armadura de Fuego', 'tripitaka@templo.com', 'Daga Veloz');
    DBMS_OUTPUT.PUT_LINE('   Items de Wukong DESPUÉS: ');
    FOR item_rec IN (SELECT nombreItem FROM Personaje_Posee_Items WHERE emailJugador = 'wukong@monkey.com' ORDER BY nombreItem) LOOP DBMS_OUTPUT.PUT_LINE('   - ' || item_rec.nombreItem); END LOOP;
    DBMS_OUTPUT.PUT_LINE('   Items de Tripitaka DESPUÉS: ');
    FOR item_rec IN (SELECT nombreItem FROM Personaje_Posee_Items WHERE emailJugador = 'tripitaka@templo.com' ORDER BY nombreItem) LOOP DBMS_OUTPUT.PUT_LINE('   - ' || item_rec.nombreItem); END LOOP;
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('>> FALLO INESPERADO: ' || SQLERRM);
END;
/
COMMIT;

