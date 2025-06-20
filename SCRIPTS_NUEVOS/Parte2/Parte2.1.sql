CREATE OR REPLACE PROCEDURE PRC_ASIGNAR_RECOMPENSAS (
    p_email_jugador IN VARCHAR2,
    p_id_mision     IN NUMBER
)
IS
    v_estado_mision_personaje   Personaje_Mision.estado_mision_pers%TYPE;
    v_recompensas_recibidas     Personaje_Mision.recompensas_recibidas%TYPE;
    
    v_cant_monedas_rec          Recompensa.cantMonedas%TYPE;
    v_cant_xp_rec               Recompensa.cantExperiencia%TYPE;
    v_id_recompensa             Recompensa.id%TYPE;

    CURSOR c_items_recompensa(p_id_recompensa NUMBER) IS
        SELECT nombreItem
        FROM Recompensa_Posee_Item
        WHERE idRecompensa = p_id_recompensa;

BEGIN
    BEGIN
        SELECT estado_mision_pers, recompensas_recibidas
        INTO v_estado_mision_personaje, v_recompensas_recibidas
        FROM Personaje_Mision
        WHERE emailJugador = p_email_jugador AND idMision = p_id_mision;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'El personaje no ha comenzado o no existe en el registro de la misión.');
    END;

    IF v_estado_mision_personaje != 'Completada' THEN
        RAISE_APPLICATION_ERROR(-20003, 'La misión aún no ha sido completada por el personaje.');
    END IF;

    IF v_recompensas_recibidas = 'S' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Las recompensas para esta misión ya fueron asignadas a este personaje.');
    END IF;

    SELECT idRecompensa 
        INTO v_id_recompensa 
        FROM Mision_Da_Recompensa 
        WHERE codMision = p_id_mision;
    
    SELECT cantMonedas, cantExperiencia
    INTO v_cant_monedas_rec, v_cant_xp_rec
    FROM Recompensa
    WHERE id = v_id_recompensa;

    UPDATE Personaje
    SET cantMonedas = cantMonedas + v_cant_monedas_rec 
    WHERE email_Jugador = p_email_jugador;

    -- Asignamos los ítems usando el cursor
    FOR item_rec IN c_items_recompensa(v_id_recompensa) LOOP
        INSERT INTO Personaje_Posee_Items (emailJugador, idPersonaje, nombreItem, equipado)
        VALUES (
            p_email_jugador, 
            (SELECT id FROM Personaje WHERE email_Jugador = p_email_jugador),
            item_rec.nombreItem, 
            'N'
        );
    END LOOP;
    
    UPDATE Personaje_Mision
    SET recompensas_recibidas = 'S'
    WHERE emailJugador = p_email_jugador AND idMision = p_id_mision;
    
    COMMIT;
    
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Recompensas asignadas exitosamente al personaje ' || p_email_jugador);
    END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Error al asignar recompensas: ' || SQLERRM);
        END;
        RAISE;
END PRC_ASIGNAR_RECOMPENSAS;
