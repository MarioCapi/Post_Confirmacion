-- crear usuario
CREATE OR REPLACE PROCEDURE "management".sp_create_usuario(
    p_username VARCHAR(50),
    p_password VARCHAR(100),
    p_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "management".usuarios (username, password, email)
    VALUES (p_username, p_password, p_email);
END;
$$;

-- leer usuario
CREATE OR REPLACE PROCEDURE "management".sp_read_usuario(
    IN p_usuario_id INT,
    OUT result JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    usuario_record JSON;
BEGIN
    -- Si se proporciona un ID de usuario específico
    IF p_usuario_id <> 999999999 THEN
        SELECT row_to_json(u) INTO usuario_record
        FROM "management".usuarios u
        WHERE id_usuario = p_usuario_id;

        -- Si no se encuentra un usuario con el ID proporcionado
        IF usuario_record IS NULL THEN
            result := json_build_object('mensaje', 'No se encontraron registros para ese ID');
        ELSE
            result := usuario_record;
        END IF;

    -- Si no se proporciona un ID o se pasa el valor especial para todos los usuarios
    ELSE
        SELECT json_agg(row_to_json(u)) INTO usuario_record
        FROM (
            SELECT id_usuario, username, email
            FROM "management".usuarios
            ORDER BY id_usuario
        ) AS u;

        -- Si no hay registros en la tabla
        IF usuario_record IS NULL OR usuario_record::TEXT = '[]' THEN
            result := json_build_object('mensaje', 'No se encontraron registros.');
        ELSE
            result := usuario_record;
        END IF;
    END IF;
END;
$$;



--actualizar usuario
CREATE OR REPLACE PROCEDURE "management".sp_update_usuario(
    p_id_usuario INT,
    p_username VARCHAR(50),
    p_password VARCHAR(100),
    p_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "management".usuarios
    SET username = p_username,
        password = p_password,
        email = p_email
    WHERE id_usuario = p_id_usuario;
END;
$$;

--eliminar usuario
CREATE OR REPLACE PROCEDURE "management".sp_delete_usuario(
    p_id_usuario INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intenta eliminar el usuario con el ID especificado
    DELETE FROM "management".usuarios
    WHERE id_usuario = p_id_usuario;

    -- Verifica si la operación DELETE afectó alguna fila
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuario con ID % no encontrado.', p_id_usuario;
    END IF;
END;
$$;





