--========--========--========--========--========--========--========--========
--READ  
CREATE OR REPLACE PROCEDURE "management".leer_cliente(
    p_numero_identificacion varchar,
    OUT mensaje JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    registros JSON;
BEGIN    
    IF p_numero_identificacion <> '999999999' THEN
        SELECT json_agg(t)
        INTO registros
        FROM (
            SELECT id,
                   nombre_razonsocial,
                   numero_identificacion,
                   correo_electronico,
                   telefono,
                   direccion_envio,
                   direccion_facturacion
            FROM "management".clientes
            WHERE numero_identificacion = p_numero_identificacion
        ) t;

        IF registros IS NOT NULL THEN
            mensaje := json_build_object(
                'error', FALSE,
                'datos', registros
            );
        ELSE
            mensaje := json_build_object(
                'error', TRUE,
                'mensaje', 'No se encontró ningún registro.',
                'numero_identificacion', p_numero_identificacion
            );
        END IF;

    ELSE
        -- Recupera todos los clientes
        SELECT COALESCE(json_agg(t), '[]'::JSON) -- Asegura que registros sea un JSON válido
        INTO registros
        FROM (
            SELECT id,
                   nombre_razonsocial,
                   numero_identificacion,
                   correo_electronico,
                   telefono,
                   direccion_envio,
                   direccion_facturacion
            FROM "management".clientes
        ) t;

        mensaje := json_build_object(
            'error', FALSE,
            'datos', registros
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Ocurrió un error al obtener los clientes.',
            'detalle', SQLERRM
        );
END;
$$;

--========--========--========--========--========--========--========--========
--========--========--========--========--========--========--========--========
--Insertar

CREATE OR REPLACE PROCEDURE management.insertar_cliente(
    p_nombre_razonsocial VARCHAR,
    p_numero_identificacion VARCHAR,
    p_correo_electronico VARCHAR,
    p_telefono VARCHAR,
    p_direccion_envio TEXT,
    p_direccion_facturacion TEXT,
    OUT mensaje JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    INSERT INTO management.clientes (
        nombre_razonsocial,
        numero_identificacion,
        correo_electronico,
        telefono,
        direccion_envio,
        direccion_facturacion
    )
    VALUES (
        p_nombre_razonsocial,
        p_numero_identificacion,
        p_correo_electronico,
        p_telefono,
        p_direccion_envio,
        p_direccion_facturacion
    );    
    mensaje := json_build_object(
        'error', FALSE,
        'mensaje', 'Cliente insertado correctamente.'
    );

EXCEPTION
    WHEN unique_violation THEN        
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Error: número de identificación o correo ya existen.'
        );
    WHEN OTHERS THEN
        -- Manejar otros errores
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Error al insertar el cliente.',
            'detalle', SQLERRM
        );
END;
$$;

--========--========--========--========--========--========--========--========
--========--========--========--========--========--========--========--========
--Actualizar

CREATE OR REPLACE PROCEDURE management.actualizar_cliente(
    p_id INT,
    p_nombre_razonsocial VARCHAR,
    p_numero_identificacion VARCHAR,
    p_correo_electronico VARCHAR,
    p_telefono VARCHAR,
    p_direccion_envio TEXT,
    p_direccion_facturacion TEXT,
    OUT mensaje JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    UPDATE management.clientes
    SET nombre_razonsocial = COALESCE(p_nombre_razonsocial, nombre_razonsocial),
        numero_identificacion = COALESCE(p_numero_identificacion, numero_identificacion),
        correo_electronico = COALESCE(p_correo_electronico, correo_electronico),
        telefono = COALESCE(p_telefono, telefono),
        direccion_envio = COALESCE(p_direccion_envio, direccion_envio),
        direccion_facturacion = COALESCE(p_direccion_facturacion, direccion_facturacion)
    WHERE id = p_id;

    -- Verificar si se actualizó algún registro
    IF FOUND THEN
        mensaje := json_build_object(
            'error', FALSE,
            'mensaje', 'Cliente actualizado correctamente.',
            'id', p_id
        );
    ELSE
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'No se encontró el cliente con el ID proporcionado.',
            'id', p_id
        );
    END IF;

EXCEPTION
    WHEN unique_violation THEN
        -- Manejar violaciones de restricciones únicas
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Error: número de identificación o correo ya existen.'
        );
    WHEN OTHERS THEN
        -- Manejar otros errores
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Error al actualizar el cliente.',
            'detalle', SQLERRM
        );
END;
$$;

--========--========--========--========--========--========--========--========
--========--========--========--========--========--========--========--========
--Eliminar

CREATE OR REPLACE PROCEDURE management.eliminar_cliente(
    p_id INT,
    OUT mensaje JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    DELETE FROM management.clientes
    WHERE id = p_id;    
    IF FOUND THEN
        mensaje := json_build_object(
            'error', FALSE,
            'mensaje', 'Cliente eliminado correctamente.',
            'id', p_id
        );
    ELSE
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'No se encontró el cliente con el ID proporcionado.',
            'id', p_id
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores generales
        mensaje := json_build_object(
            'error', TRUE,
            'mensaje', 'Error al eliminar el cliente.',
            'detalle', SQLERRM
        );
END;
$$;
