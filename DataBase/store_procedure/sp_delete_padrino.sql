--sp ára eliminar un padrino
CREATE OR REPLACE PROCEDURE "management".sp_delete_padrino(
    p_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Eliminar el padrino
    DELETE FROM "management".padrinos
    WHERE id = p_id;
    
    -- Verificar si se eliminó correctamente
    IF FOUND THEN
        RAISE NOTICE 'Padrino con ID % eliminado exitosamente.', p_id;
    ELSE
        RAISE NOTICE 'Padrino con ID % no encontrado.', p_id;
    END IF;
END;
$$;