
CREATE OR REPLACE TRIGGER TRG_VALIDAR_INICIO_MISION
BEFORE INSERT OR UPDATE ON Personaje_Mision
FOR EACH ROW
DECLARE
    v_conteo_previas_no_completadas NUMBER;
BEGIN
    -- solo si inserto o actualizo algo y el nuevo estado es En progreso
    IF (INSERTING OR UPDATING) AND :new.estado_mision_pers = 'En progreso' THEN
    
       --cuento las previas que no cumplen
        SELECT COUNT(*)
        INTO v_conteo_previas_no_completadas
        FROM Mision_Es_Previa_De_Mision pre
        WHERE 
            pre.codMision2 = :new.idMision 
            AND NOT EXISTS (
                SELECT 1
                FROM Personaje_Mision pm
                WHERE pm.idMision = pre.codMision1      
                  AND pm.emailJugador = :new.emailJugador 
                  AND pm.estado_mision_pers = 'Completada'
            );

        IF v_conteo_previas_no_completadas > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'No se puede iniciar la misión. Existen misiones previas no completadas.');
        END IF;
    END IF;
END;



CREATE OR REPLACE TRIGGER TRG_AJUSTAR_CARACTERISTICAS
BEFORE UPDATE ON Personaje
FOR EACH ROW
BEGIN
    -- Validamos y ajustamos la FUERZA
    IF :new.fuerza > 100 THEN
        :new.fuerza := 100;
    ELSIF :new.fuerza < 0 THEN
        :new.fuerza := 0;
    END IF;

    -- Validamos y ajustamos la AGILIDAD
    IF :new.agilidad > 100 THEN
        :new.agilidad := 100;
    ELSIF :new.agilidad < 0 THEN
        :new.agilidad := 0;
    END IF;

    -- Validamos y ajustamos la INTELIGENCIA
    IF :new.inteligencia > 100 THEN
        :new.inteligencia := 100;
    ELSIF :new.inteligencia < 0 THEN
        :new.inteligencia := 0;
    END IF;

    -- Validamos y ajustamos la VITALIDAD
    IF :new.vitalidad > 100 THEN
        :new.vitalidad := 100;
    ELSIF :new.vitalidad < 0 THEN
        :new.vitalidad := 0;
    END IF;

    -- Validamos y ajustamos la RESISTENCIA
    IF :new.resistencia > 100 THEN
        :new.resistencia := 100;
    ELSIF :new.resistencia < 0 THEN
        :new.resistencia := 0;
    END IF;
END;
