CREATE OR REPLACE PROCEDURE management.crear_venta(
    consecutivo_factura     BIGINT,
    numero_identi_cliente   VARCHAR,
    estado                  VARCHAR,
    formapago               VARCHAR,
    productos_json JSON,
    OUT resultado JSON
)
LANGUAGE plpgsql AS $$
DECLARE
    item JSON;
    id_producto_get INT;
    cantidad INT;
    precio_unitario_get DECIMAL(10, 2);
    total DECIMAL(15, 2);
    id_cliente INT;
    mensajes JSONB := '[]'::JSONB;
    errores JSONB := '[]'::JSONB;
BEGIN
    BEGIN
        SELECT id 
        INTO id_cliente
        FROM management.clientes
        WHERE numero_identificacion = numero_identi_cliente;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'El cliente con número % no existe.', numero_identi_cliente;
        END IF;

        
        FOR item IN SELECT * FROM json_array_elements(productos_json) LOOP
            BEGIN
                IF item->>'id_producto' IS NULL OR item->>'cantidad' IS NULL THEN
                    RAISE EXCEPTION 'El JSON de producto no contiene todas las claves requeridas (id_producto, cantidad).';
                END IF;

                
                id_producto_get := (item->>'id_producto')::INT;
                cantidad := (item->>'cantidad')::INT;

                -- Validar que la cantidad sea positiva
                IF cantidad <= 0 THEN
                    RAISE EXCEPTION 'La cantidad para el producto % debe ser mayor a 0.', id_producto;
                END IF;

                -- Verificar si el producto existe y obtener el precio unitario
                SELECT precio_unitario
                INTO precio_unitario_get
                FROM management.productos pro
                WHERE pro.id_producto = id_producto_get;

                IF NOT FOUND THEN
                    RAISE EXCEPTION 'El producto con ID % no existe.', id_producto_get;
                END IF;                
                total := precio_unitario_get * cantidad;
                -- Insertar la venta en la tabla                
                INSERT INTO management.ventas (
                    consecutivo_factura,
                    numero_identi_cliente,
                    id_producto,
                    cantidad,
					estado,
					estado_formapago,
                    total,
                    fecha_venta
                )
                VALUES (
                    consecutivo_factura,
                    numero_identi_cliente,
                    id_producto_get,
                    cantidad,
					estado,
					formapago,
                    total,
                    NOW()
                );
                mensajes := mensajes || jsonb_build_object(
                    'id_producto', id_producto_get,
                    'cantidad', cantidad,
                    'mensaje', 'Venta creada exitosamente'
                );
            EXCEPTION WHEN OTHERS THEN
                errores := errores || jsonb_build_object(
                    'id_producto', id_producto_get,
                    'cantidad', cantidad,
                    'error', SQLERRM
                );
            END;
        END LOOP;

    EXCEPTION WHEN OTHERS THEN
        resultado := jsonb_build_object(
            'estado', 'error',
            'mensaje', SQLERRM,
            'detalles', errores
        )::JSON;
        RETURN;
    END;

    resultado := jsonb_build_object(
        'estado', CASE WHEN jsonb_array_length(errores) > 0 THEN 'parcial' ELSE 'exito' END,
        'ventas_exitosas', mensajes,
        'errores', errores
    )::JSON;

END;
$$;
