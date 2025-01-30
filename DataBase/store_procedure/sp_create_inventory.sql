CREATE OR REPLACE PROCEDURE "management".obtener_inventario(
    p_id INTEGER,
    OUT mensaje JSON
)
LANGUAGE plpgsql
AS $$
DECLARE
    registros JSON;
BEGIN    
    IF p_id <> 999999999 THEN
        SELECT json_agg(t)
        INTO registros
        FROM (
            SELECT id,
                nombre_especia,
                cantidad,
                unidad_medida,
                fecha_ingreso,
                proveedor,
                precio_compra,
                ubicacion,
                notas
            FROM "management".inventario
            WHERE id = p_id
        ) t;
        
        IF registros IS NOT NULL THEN                        
            mensaje := registros;
        ELSE            
            mensaje := json_build_object('No se encontró ningún registro con ID',p_id);
        END IF;
    ELSE
        -- Obtener todos los registros
        SELECT json_agg(t)
        INTO registros
        FROM (
            SELECT id,
                nombre_especia,
                cantidad,
                unidad_medida,
                fecha_ingreso,
                proveedor,
                precio_compra,
                ubicacion,
                notas
            FROM "management".inventario
        ) t;
        mensaje := registros;  
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mensaje := 'Error al obtener el inventario: ' || SQLERRM;  -- Mensaje de error
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================

CREATE OR REPLACE PROCEDURE "management".insertar_inventario(
    p_nombre_especia VARCHAR(50),
    p_cantidad INTEGER,
    p_unidad_medida VARCHAR(50),
    p_fecha_ingreso DATE,
    p_proveedor VARCHAR(100),
    p_precio_compra NUMERIC(10,2),
    p_ubicacion VARCHAR(100),
    p_notas TEXT,
    OUT mensaje TEXT 
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "management".inventario (nombre_especia, cantidad, unidad_medida, fecha_ingreso, proveedor, precio_compra, ubicacion, notas)
    VALUES (p_nombre_especia, p_cantidad, p_unidad_medida, p_fecha_ingreso, p_proveedor, p_precio_compra, p_ubicacion, p_notas);
    
    mensaje := 'Registro insertado correctamente: ' || p_nombre_especia; 

EXCEPTION
    WHEN OTHERS THEN
        mensaje := 'Error al insertar el registro: ' || SQLERRM;  
END;
$$;
--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================

CREATE OR REPLACE PROCEDURE "management".eliminar_inventario(
    p_id INTEGER,
    OUT mensaje TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM "management".inventario
    WHERE id = p_id;

    IF FOUND THEN
        mensaje := 'Registro con ID ' || p_id || ' eliminado correctamente.';
    ELSE
        mensaje := 'No se encontró ningún registro con ID ' || p_id || '.';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mensaje := 'Error al eliminar el registro: ' || SQLERRM;
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================

CREATE OR REPLACE PROCEDURE "management".actualizar_inventario(
    p_id INTEGER,
    p_nombre_especia VARCHAR(50),
    p_cantidad INTEGER,
    p_unidad_medida VARCHAR(50),
    p_fecha_ingreso DATE,
    p_proveedor VARCHAR(100),
    p_precio_compra NUMERIC(10,2),
    p_ubicacion VARCHAR(100),
    p_notas TEXT,
    OUT mensaje TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "management".inventario
    SET nombre_especia = p_nombre_especia,
        cantidad = p_cantidad,
        unidad_medida = p_unidad_medida,
        fecha_ingreso = p_fecha_ingreso,
        proveedor = p_proveedor,
        precio_compra = p_precio_compra,
        ubicacion = p_ubicacion,
        notas = p_notas
    WHERE id = p_id;

    IF FOUND THEN
        mensaje := 'Registro con ID ' || p_id || ' actualizado correctamente.';  -- Mensaje de éxito
    ELSE
        mensaje := 'No se encontró ningún registro con ID ' || p_id || '.';  -- Mensaje si no se encuentra el registro
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        mensaje := 'Error al actualizar el registro: ' || SQLERRM;  -- Mensaje de error
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================
