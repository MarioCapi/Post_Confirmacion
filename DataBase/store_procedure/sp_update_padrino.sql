CREATE OR REPLACE PROCEDURE "management".sp_update_padrino(
    p_id INT,
    p_nombre VARCHAR(100),
    p_apellido VARCHAR(100),
    p_tipo_documento VARCHAR(50),
    p_numero_documento VARCHAR(50),
    p_edad INT,
    p_telefono VARCHAR(20),
    p_email VARCHAR(100),
    p_fecha_nacimiento DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Actualizar el padrino
    UPDATE "management".padrinos
    SET
        nombre = p_nombre,
        apellido = p_apellido,
        tipo_documento = p_tipo_documento,
        numero_documento = p_numero_documento,
        edad = p_edad,
        telefono = p_telefono,
        email = p_email,
        fecha_nacimiento = p_fecha_nacimiento
    WHERE id = p_id;
    
    -- Verificar si se actualizó correctamente
    IF FOUND THEN
        RAISE NOTICE 'Padrino con ID % actualizado exitosamente.', p_id;
    ELSE
        RAISE NOTICE 'Padrino con ID % no encontrado.', p_id;
    END IF;
END;
$$;