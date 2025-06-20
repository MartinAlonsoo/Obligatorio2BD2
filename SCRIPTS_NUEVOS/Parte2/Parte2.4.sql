CREATE OR REPLACE PROCEDURE PRC_INTERCAMBIAR_ITEMS (
    p_email_jugador1 IN VARCHAR2,
    p_nombre_item1   IN VARCHAR2,
    p_email_jugador2 IN VARCHAR2,
    p_nombre_item2   IN VARCHAR2
)
IS
    -- Declaración de variables para validaciones
    v_item1_intercambiable   Items.intercambiable%TYPE;
    v_item2_intercambiable   Items.intercambiable%TYPE;
    v_conteo_item1           NUMBER;
    v_conteo_item2           NUMBER;
BEGIN
    -- Validaciones iniciales
    IF p_email_jugador1 = p_email_jugador2 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Un jugador no puede intercambiar ítems consigo mismo.');
    END IF;

    SELECT intercambiable INTO v_item1_intercambiable FROM Items WHERE nombre = p_nombre_item1;
    SELECT intercambiable INTO v_item2_intercambiable FROM Items WHERE nombre = p_nombre_item2;

    IF v_item1_intercambiable = 'N' OR v_item2_intercambiable = 'N' THEN
        RAISE_APPLICATION_ERROR(-20011, 'Uno o ambos ítems no son intercambiables.');
    END IF;

    SELECT COUNT(*) INTO v_conteo_item1 FROM Personaje_Posee_Items WHERE emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1;
    SELECT COUNT(*) INTO v_conteo_item2 FROM Personaje_Posee_Items WHERE emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2;

    IF v_conteo_item1 = 0 OR v_conteo_item2 = 0 THEN
        RAISE_APPLICATION_ERROR(-20012, 'Uno de los jugadores no posee el ítem que intenta intercambiar.');
    END IF;

    -- Bloqueamos las dos filas para evitar problemas de concurrencia
    FOR rec IN (
        SELECT * FROM Personaje_Posee_Items
        WHERE (emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1)
           OR (emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2)
        FOR UPDATE
    ) LOOP
        NULL;
    END LOOP;

    UPDATE Personaje_Posee_Items
    SET nombreItem = p_nombre_item2, equipado = 'N'
    WHERE emailJugador = p_email_jugador1 AND nombreItem = p_nombre_item1;

    UPDATE Personaje_Posee_Items
    SET nombreItem = p_nombre_item1, equipado = 'N'
    WHERE emailJugador = p_email_jugador2 AND nombreItem = p_nombre_item2;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Intercambio realizado exitosamente.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error durante el intercambio. La transaccion ha sido revertida. Error: ' || SQLERRM);
        RAISE;
END PRC_INTERCAMBIAR_ITEMS;
/
