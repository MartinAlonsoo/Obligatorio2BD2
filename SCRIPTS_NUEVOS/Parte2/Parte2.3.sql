
--Trigger para poblar los registros de subida de nivel
CREATE OR REPLACE TRIGGER TRG_LOG_NIVEL
AFTER UPDATE OF nivel ON Personaje
FOR EACH ROW
WHEN (new.nivel > old.nivel)
BEGIN
    INSERT INTO Log_Aumento_Nivel (emailJugador, nivel_anterior, nivel_nuevo)
    VALUES (:new.email_Jugador, :old.nivel, :new.nivel);
END;

--Trigger para actualizar la fecha cuando se completa una mision
CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_FECHA_MISION
BEFORE UPDATE ON Personaje_Mision
FOR EACH ROW
-- La cláusula WHEN es una forma eficiente de hacer que el cuerpo del trigger
-- solo se ejecute si se cumple esta condición específica.
WHEN (new.estado_mision_pers = 'Completada' AND old.estado_mision_pers != 'Completada')
BEGIN
    -- Si el nuevo estado es 'Completada' y el estado anterior no lo era,
    -- modificamos el valor de la columna 'fecha_estado' que está a punto de ser guardado.
    :new.fecha_estado := SYSDATE;
END;
/


CREATE OR REPLACE PROCEDURE PRC_ACREDITAR_PREMIO_DIARIO
IS
    -- Cursor para obtener la lista de todos los personajes candidatos
    CURSOR c_candidatos IS
        WITH 
        jugadores_level_up AS (
            -- Obtenemos jugadores que subieron 3+ niveles en las últimas 24h
            SELECT emailJugador
            FROM Log_Aumento_Nivel
            WHERE fecha_aumento >= SYSDATE - 1
            GROUP BY emailJugador
            HAVING (MAX(nivel_nuevo) - MIN(nivel_anterior)) >= 3
        ),
        jugadores_mision_completa AS (
            -- Obtenemos jugadores que completaron una misión principal en las últimas 24h
            SELECT pm.emailJugador
            FROM Personaje_Mision pm
            JOIN Misiones m ON pm.idMision = m.id
            WHERE pm.estado_mision_pers = 'Completada'
              AND m.tipo_mision = 'Principal' -- Asumiendo que renombraste la columna 'estado'
              AND pm.fecha_estado >= SYSDATE - 1
        )
        -- La lista final de candidatos es la intersección de los dos grupos
        -- menos los que ya recibieron el premio hoy.
        SELECT emailJugador FROM jugadores_level_up
        INTERSECT
        SELECT emailJugador FROM jugadores_mision_completa
        MINUS
        SELECT emailJugador FROM Log_Premio_Diario WHERE TRUNC(fecha_premio) = TRUNC(SYSDATE);

    -- Variables para la lógica de ítem aleatorio
    v_rareza_aleatoria   Items.rareza%TYPE;
    v_item_aleatorio     Items.nombre%TYPE;
    v_id_personaje       Personaje.id%TYPE;

BEGIN
    -- Recorremos cada candidato elegible
    FOR candidato IN c_candidatos LOOP
        BEGIN
            -- Guardamos el estado para un posible rollback individual
            SAVEPOINT sp_jugador;

            -- 1. Elegir una rareza aleatoria (ej. 70% Común, 20% Rara, 8% Épica, 2% Legendaria)
            DECLARE
                v_rand_num NUMBER := DBMS_RANDOM.VALUE(0, 1);
            BEGIN
                IF v_rand_num < 0.70 THEN v_rareza_aleatoria := 'Comun';
                ELSIF v_rand_num < 0.90 THEN v_rareza_aleatoria := 'Rara';
                ELSIF v_rand_num < 0.98 THEN v_rareza_aleatoria := 'Epica';
                ELSE v_rareza_aleatoria := 'Legendaria';
                END IF;
            END;
            
            -- 2. Seleccionar un ítem al azar de esa rareza
            SELECT nombre INTO v_item_aleatorio
            FROM (
                SELECT nombre FROM Items WHERE rareza = v_rareza_aleatoria ORDER BY DBMS_RANDOM.VALUE
            ) WHERE ROWNUM = 1;

            -- Obtenemos el ID del personaje
            SELECT id INTO v_id_personaje FROM Personaje WHERE email_Jugador = candidato.emailJugador;

            -- 3. Acreditar el ítem en el inventario
            INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado)
            VALUES (candidato.emailJugador, v_id_personaje, v_item_aleatorio, 'N');
            
            -- 4. Registrar que se entregó el premio para asegurar la idempotencia
            INSERT INTO Log_Premio_Diario (emailJugador, item_recibido)
            VALUES (candidato.emailJugador, v_item_aleatorio);
            
            DBMS_OUTPUT.PUT_LINE('Premio (' || v_item_aleatorio || ') entregado a ' || candidato.emailJugador);
            
        EXCEPTION
            WHEN OTHERS THEN
                -- Si falla la entrega para un jugador, hacemos rollback a su punto de guardado
                -- y continuamos con el siguiente, para no detener todo el proceso.
                ROLLBACK TO sp_jugador;
                DBMS_OUTPUT.PUT_LINE('Error procesando a ' || candidato.emailJugador || '. Omitiendo...');
        END;
    END LOOP;

    -- Confirmamos todos los cambios de todos los jugadores procesados exitosamente.
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Proceso de acreditación de premios diarios finalizado.');
    
EXCEPTION
    WHEN OTHERS THEN
        -- Si ocurre un error catastrófico, revertimos toda la transacción.
        ROLLBACK;
        RAISE;
END PRC_ACREDITAR_PREMIO_DIARIO;