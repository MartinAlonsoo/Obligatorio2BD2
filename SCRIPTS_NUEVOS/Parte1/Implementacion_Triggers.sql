CREATE OR REPLACE TRIGGER TRG_VALIDAR_MISION_PREVIA
BEFORE UPDATE ON Misiones
FOR EACH ROW
DECLARE
    v_conteo_previas_no_completadas NUMBER;
BEGIN
    
    
    IF UPDATING('estado_Avance') AND :new.estado_Avance = 'En progreso' THEN
        SELECT COUNT(*)
        INTO v_conteo_previas_no_completadas
        FROM Misiones m
        JOIN Mision_Es_Previa_De_Mision pre
          ON m.id = pre.codMision1 
        WHERE pre.codMision2 = :new.id 
          AND m.estado_Avance != 'Completada';

        
        IF v_conteo_previas_no_completadas > 0 THEN
            
            RAISE_APPLICATION_ERROR(-20001, 'No se puede iniciar la misión. Existen misiones previas no completadas.');
        END IF;
    END IF;
    NULL; 

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
/