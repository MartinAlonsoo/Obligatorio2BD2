CREATE OR REPLACE PROCEDURE PRC_INTERCAMBIAR_ITEMS (
    p_email_jugador1 IN VARCHAR2,
    p_nombre_item1   IN VARCHAR2,
    p_email_jugador2 IN VARCHAR2,
    p_nombre_item2   IN VARCHAR2
)
IS
    -- Declaramos variables para validaciones y datos necesarios
    v_item1_intercambiable   Items.intercambiable%TYPE;
    v_item2_intercambiable   Items.intercambiable%TYPE;
    v_conteo_item1           NUMBER;
    v_conteo_item2           NUMBER;
    v_id_personaje1          Personaje.id%TYPE;
    v_id_personaje2          Personaje.id%TYPE;

BEGIN
    -- PASO 2: REALIZAR VALIDACIONES PREVIAS

    -- Validar que no se esté intercambiando consigo mismo
    IF p_email_jugador1 = p_email_jugador2 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Un jugador no puede intercambiar ítems consigo mismo.');
    END IF;

    -- Validar que ambos ítems sean intercambiables
    SELECT intercambiable INTO v_item1_intercambiable FROM Items WHERE nombre = p_nombre_item1;
    SELECT intercambiable INTO v_item2_intercambiable FROM Items WHERE nombre = p_nombre_item2;

    IF v_item1_intercambiable = 'N' OR v_item2_intercambiable = 'N' THEN
        RAISE_APPLICATION_ERROR(-20011, 'Uno o ambos ítems no son intercambiables.');
    END IF;

    -- Validar que cada jugador posea el ítem que ofrece
    SELECT COUNT(*) INTO v_conteo_item1 FROM Personaje_Posee_Items WHERE emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1;
    SELECT COUNT(*) INTO v_conteo_item2 FROM Personaje_Posee_Items WHERE emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2;

    IF v_conteo_item1 = 0 OR v_conteo_item2 = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Uno de los jugadores no posee el ítem que intenta intercambiar.');
    END IF;

    -- PASO 3: EJECUTAR LA TRANSACCIÓN DE INTERCAMBIO

    -- Obtenemos los IDs de los personajes para la actualización
    SELECT id INTO v_id_personaje1 FROM Personaje WHERE email_Jugador = p_email_jugador1;
    SELECT id INTO v_id_personaje2 FROM Personaje WHERE email_Jugador = p_email_jugador2;

    -- Bloqueamos las dos filas en la tabla Personaje_Posee_Items para evitar que otro proceso
    -- las modifique mientras realizamos el intercambio. Esto es CRUCIAL para la concurrencia.
    -- Aunque no seleccionamos nada, el FOR UPDATE bloquea las filas que cumplen el WHERE.
    FOR rec IN (
        SELECT * FROM Personaje_Posee_Items
        WHERE (emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1)
           OR (emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2)
        FOR UPDATE
    ) LOOP
        -- El loop está vacío a propósito, solo lo usamos para el bloqueo.
        NULL;
    END LOOP;

    -- Realizamos el intercambio. Simplemente actualizamos el dueño de cada ítem.
    -- Nota: Al intercambiar, es lógico que ambos ítems pasen a estar "no equipados".
    UPDATE Personaje_Posee_Items
    SET emailJugador = p_email_jugador2,
        idPersonaje = v_id_personaje2,
        equipado = 'N'
    WHERE emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1;

    UPDATE Personaje_Posee_Items
    SET emailJugador = p_email_jugador1,
        idPersonaje = v_id_personaje1,
        equipado = 'N'
    WHERE emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2;

    -- PASO 4: FINALIZAR LA TRANSACCIÓN
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Intercambio realizado exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        -- Si cualquier cosa falla (una validación, un update, etc.),
        -- revertimos TODOS los cambios hechos dentro del procedimiento.
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error durante el intercambio. La transacción ha sido revertida. Error: ' || SQLERRM);
        RAISE; -- Re-lanzamos el error.
END PRC_INTERCAMBIAR_ITEMS;