-- Procedimiento para crear un nuevo proveedor

CREATE OR REPLACE PROCEDURE "management".sp_create_proveedor(
    IN _nit_proveedor BIGINT,
    IN _nombre_contacto VARCHAR(255),
    IN _razon_social VARCHAR(255),
    IN _telefono_contacto VARCHAR(50),
    IN _direccion VARCHAR(255),
    IN _correo_electronico VARCHAR(255),
    OUT p_resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intentar insertar el proveedor
    INSERT INTO "management".proveedores (
        nit_proveedor, nombre_contacto, razon_social, telefono_contacto, direccion, correo_electronico
    ) VALUES (
        _nit_proveedor, _nombre_contacto, _razon_social, _telefono_contacto, _direccion, _correo_electronico
    );

    -- Asignar resultado exitoso
    p_resultado := json_build_object(
        'status', 'success',
        'message', 'Proveedor creado exitosamente',
        'nit_proveedor', _nit_proveedor
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Ocurrió un error al crear el proveedor',
            'error_detail', SQLERRM
        );
END;
$$;


-- Procedimiento para leer todos los proveedores o uno específico por NIT "Probado en DB"

CREATE OR REPLACE PROCEDURE "management".sp_read_proveedor(OUT p_resultado JSON, IN p_nit_proveedor VARCHAR DEFAULT NULL) LANGUAGE plpgsql AS $$
DECLARE
    proveedores_record RECORD;
    all_proveedores JSON;
BEGIN
    IF p_nit_proveedor IS NOT NULL THEN
        -- Si se proporciona el nit_proveedor, buscar ese proveedor específico
        SELECT id_proveedor, nit_proveedor, nombre_contacto, razon_social, telefono_contacto, direccion, correo_electronico
        INTO proveedores_record
        FROM "management".proveedores
        WHERE nit_proveedor = p_nit_proveedor;

        -- Si no se encuentra el proveedor, lanzar excepción
        IF NOT FOUND THEN
            p_resultado := json_build_object(
                'status', 'error',
                'message', 'Proveedor no encontrado',
                'nit_proveedor', p_nit_proveedor
            );
        ELSE
            -- Devolver el proveedor en formato JSON
            p_resultado := json_build_object(
                'status', 'success',
                'data', json_build_object(
                    'id_proveedor', proveedores_record.id_proveedor,
                    'nit_proveedor', proveedores_record.nit_proveedor,
                    'nombre_contacto', proveedores_record.nombre_contacto,
                    'razon_social', proveedores_record.razon_social,
                    'telefono_contacto', proveedores_record.telefono_contacto,
                    'direccion', proveedores_record.direccion,
                    'correo_electronico', proveedores_record.correo_electronico
                )
            );
        END IF;

    ELSE
        -- Si no se proporciona el nit_proveedor, devolver todos los proveedores
        SELECT json_agg(
            json_build_object(
                'id_proveedor', p.id_proveedor,
                'nit_proveedor', p.nit_proveedor,
                'nombre_contacto', p.nombre_contacto,
                'razon_social', p.razon_social,
                'telefono_contacto', p.telefono_contacto,
                'direccion', p.direccion,
                'correo_electronico', p.correo_electronico
            )
        ) INTO all_proveedores
        FROM "management".proveedores p;

        -- Devolver la lista de todos los proveedores
        p_resultado := json_build_object(
            'status', 'success',
            'data', all_proveedores
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Control de error genérico
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Ocurrió un error al consultar los proveedores',
            'error_detail', SQLERRM
        );
END;
$$;

-- Procedimiento para actualizar un proveedor

CREATE OR REPLACE PROCEDURE "management".sp_update_proveedor (
    IN _nit_proveedor BIGINT,
    IN _nombre_contacto VARCHAR(255),
    IN _razon_social VARCHAR(255),
    IN _telefono_contacto VARCHAR(50),
    IN _direccion VARCHAR(255),
    IN _correo_electronico VARCHAR(255),
    OUT p_resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intentar la actualización del registro
    UPDATE "management".proveedores
    SET nombre_contacto = _nombre_contacto,
        razon_social = _razon_social,
        telefono_contacto = _telefono_contacto,
        direccion = _direccion,
        correo_electronico = _correo_electronico
    WHERE nit_proveedor = _nit_proveedor;

    -- Verificar si se actualizó alguna fila
    IF FOUND THEN
        p_resultado := json_build_object(
            'status', 'success',
            'message', 'Proveedor actualizado exitosamente',
            'nit_proveedor', _nit_proveedor
        );
    ELSE
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Proveedor no encontrado',
            'nit_proveedor', _nit_proveedor
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejar errores y retornar información
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Error al actualizar el proveedor',
            'error_detail', SQLERRM
        );
END;
$$;


-- Procedimiento para eliminar un proveedor

CREATE OR REPLACE PROCEDURE "management".sp_delete_proveedor(
    IN p_nit_proveedor BIGINT, 
    OUT p_resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Intentar eliminar el proveedor
    DELETE FROM "management".proveedores
    WHERE nit_proveedor = p_nit_proveedor;

    -- Verificar si la eliminación afectó alguna fila
    IF FOUND THEN
        p_resultado := json_build_object(
            'status', 'success',
            'message', 'Proveedor eliminado exitosamente',
            'nit_proveedor', p_nit_proveedor
        );
    ELSE
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Proveedor no encontrado',
            'nit_proveedor', p_nit_proveedor
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejo genérico de errores
        p_resultado := json_build_object(
            'status', 'error',
            'message', 'Ocurrió un error al eliminar el proveedor',
            'error_detail', SQLERRM
        );
END;
$$;
