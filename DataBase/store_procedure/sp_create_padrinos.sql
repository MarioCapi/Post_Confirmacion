--sp para crear padrinos 
CREATE OR REPLACE PROCEDURE "management".sp_create_padrino(
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
    -- Insertar el nuevo padrino
    INSERT INTO management.padrinos (
        nombre, apellido, tipo_documento, numero_documento, edad, telefono, email, fecha_nacimiento
    ) VALUES (
        p_nombre, p_apellido, p_tipo_documento, p_numero_documento, p_edad, p_telefono, p_email, p_fecha_nacimiento
    );
    
    -- Mensaje de éxito
    RAISE NOTICE 'Padrino creado exitosamente.';
END;
$$;