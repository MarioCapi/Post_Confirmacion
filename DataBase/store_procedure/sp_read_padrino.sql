--sp para leer padrinos
CREATE OR REPLACE PROCEDURE "management".sp_read_padrinos(
    p_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    padrino_record "management".padrinos%ROWTYPE;
BEGIN
    -- Si se proporciona un ID, buscar el padrino correspondiente
    IF p_id IS NOT NULL THEN
        -- Obtener los datos del padrino por ID
        SELECT * INTO padrino_record
        FROM "management".padrinos
        WHERE id = p_id;
        
        -- Verificar si se encontró el padrino
        IF FOUND THEN
            RAISE NOTICE 'Padrino encontrado: %', padrino_record;
        ELSE
            RAISE NOTICE 'Padrino con ID % no encontrado.', p_id;
        END IF;
    ELSE
        -- Si no se proporciona un ID, mostrar todos los padrinos
        RAISE NOTICE 'Listado de todos los padrinos:';
        FOR padrino_record IN SELECT * FROM "management".padrinos LOOP
            RAISE NOTICE 'Padrino: %', padrino_record;
        END LOOP;
    END IF;
END;
$$;