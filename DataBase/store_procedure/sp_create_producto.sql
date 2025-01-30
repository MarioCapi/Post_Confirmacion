CREATE OR REPLACE PROCEDURE management.sp_insert_product(
    IN _codeProducto VARCHAR,
    IN _nombre_producto VARCHAR,
    IN _unidad_de_medida VARCHAR,
    IN _descripcion TEXT,
    IN _precio_unitario DECIMAL,
    OUT resultado JSON
)
LANGUAGE plpgsql AS $$
BEGIN    
    BEGIN
        INSERT INTO "management".productos (
            codeProducto,
            nombre_producto,
            unidad_de_medida,
            descripcion,
            precio_unitario
        )
        VALUES (
            _codeProducto,
            _nombre_producto,
            _unidad_de_medida,
            _descripcion,
            _precio_unitario
        );        
        resultado := jsonb_build_object(
            'estado', 'exito',
            'mensaje', 'Insertado exitosamente'
        )::JSON;

    EXCEPTION        
        WHEN unique_violation THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', 'El código de producto ya existe. No se pudo insertar.'
            )::JSON;
        WHEN others THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', SQLERRM
            )::JSON;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE management.sp_read_producto(
    OUT resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    BEGIN
        resultado := jsonb_agg(jsonb_build_object(
            'id_producto', id_producto,
            'codeProducto', codeProducto,
            'nombre_producto', nombre_producto,
            'unidad_de_medida', unidad_de_medida,
            'descripcion', descripcion,
            'precio_unitario', precio_unitario
        ))::JSON
        FROM management.productos;
        
        IF resultado IS NULL THEN
            resultado := jsonb_build_object(
                'estado', 'vacio',
                'mensaje', 'No se encontraron productos.'
            )::JSON;
        END IF;

    EXCEPTION
        WHEN others THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', SQLERRM
            )::JSON;
    END;
END;
$$;


CREATE OR REPLACE PROCEDURE management.sp_delete_producto(
    IN _codeProducto VARCHAR,
    OUT resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    BEGIN
        DELETE FROM management.productos
        WHERE codeProducto = _codeProducto;        
        IF NOT FOUND THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', 'No se encontró ningún producto con el código proporcionado.'
            )::JSON;
        ELSE
            resultado := jsonb_build_object(
                'estado', 'exito',
                'mensaje', 'Producto eliminado exitosamente.'
            )::JSON;
        END IF;
    EXCEPTION
        WHEN others THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', SQLERRM
            )::JSON;
    END;
END;
$$;

CREATE OR REPLACE PROCEDURE management.sp_update_product(
    IN _codeProducto VARCHAR,
    IN _nombre_producto VARCHAR,
    IN _unidad_de_medida VARCHAR,
    IN _descripcion TEXT,
    IN _precio_unitario DECIMAL,
    OUT resultado JSON
)
LANGUAGE plpgsql
AS $$
BEGIN    
    BEGIN
        UPDATE management.productos
        SET nombre_producto = _nombre_producto,
            unidad_de_medida = _unidad_de_medida,
            descripcion = _descripcion,
            precio_unitario = _precio_unitario
        WHERE codeProducto = _codeProducto;
        
        IF NOT FOUND THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', 'No se encontró ningún producto con el código proporcionado.'
            )::JSON;
        ELSE
            resultado := jsonb_build_object(
                'estado', 'exito',
                'mensaje', 'Producto actualizado exitosamente.'
            )::JSON;
        END IF;

    EXCEPTION
        WHEN others THEN
            resultado := jsonb_build_object(
                'estado', 'error',
                'mensaje', SQLERRM
            )::JSON;
    END;
END;
$$;







