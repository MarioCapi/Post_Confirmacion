DO $$
DECLARE
    record management.inventario%ROWTYPE;
    total_registros INTEGER;
    total_obtenidos INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_registros FROM management.inventario;
    FOR record IN
        SELECT id,
            nombre_especia,
            cantidad,
            unidad_medida,
            fecha_ingreso,
            proveedor,
            precio_compra,
            ubicacion,
            notas
        FROM management.inventario
    LOOP
        total_obtenidos := total_obtenidos + 1;
        RAISE NOTICE 'ID: %, Nombre: %, Cantidad: %, Unidad: %, Fecha: %, Proveedor: %, Precio: %, Ubicación: %, Notas: %',
            record.id, record.nombre_especia, record.cantidad, record.unidad_medida, record.fecha_ingreso,
            record.proveedor, record.precio_compra, record.ubicacion, record.notas;  -- Mostrar cada registro
    END LOOP;    
    
    IF total_registros = total_obtenidos THEN
        RAISE NOTICE 'Test exitoso: Se obtuvieron % registros, que coinciden con el total esperado.', total_obtenidos;
    ELSE
        RAISE EXCEPTION 'Test fallido: Se esperaban % registros, pero se obtuvieron %.', total_registros, total_obtenidos;
    END IF;
END;
$$;
--====--====--====--====--====--====--====--====--====--====--====--====
--====--====--====--====--====--====--====--====--====--====--====--====




--====--====--====--====--====--====--====--====--====--====--====--====
--READ
DO $$
DECLARE    
    mensaje JSON;    
BEGIN	      
    CALL "management".obtener_inventario(999999999, mensaje);  -- Obtener todos los registros
     RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;
DO $$
DECLARE    
    mensaje JSON;    
BEGIN
    CALL "management".obtener_inventario(1, mensaje); 
    RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;
--====--====--====--====--====--====--====--====--====--====--====--====
--INSERT
DO $$
DECLARE
    resultado TEXT;
BEGIN
    CALL "management".insertar_inventario(
        'Especia rara', 
        10, 
        'Kgramos', 
        '2023-11-29', 
        'Proveedor A', 
        1.50, 
        'Estante 1 bodega 2', 
        'Sin notas',
        resultado
    );
    RAISE NOTICE '%', resultado;
END;
$$;

--====--====--====--====--====--====--====--====--====--====--====--====
--Delete
DO $$
DECLARE
    resultado TEXT;  
BEGIN
    CALL "management".eliminar_inventario(3, resultado);  
    RAISE NOTICE '%', resultado;
END;
$$;
--====--====--====--====--====--====--====--====--====--====--====--====
--UPDATE
DO $$
DECLARE
    resultado TEXT;  
BEGIN
    CALL "management".actualizar_inventario(
        4,
        'Cilantro', 
        150, 
        'Kgramos', 
        '2023-11-15', 
        'Proveedor AAA', 
        1.95,  -- Nuevo precio
        'Estante 1 bodega 1, barrio nuevo', 
        'Notas actualizadas',
        resultado
    );
    RAISE NOTICE '%', resultado;  
END;
$$;
--====--====--====--====--====--====--====--====--====--====--====--====

