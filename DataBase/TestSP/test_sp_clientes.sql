--READ
DO $$
DECLARE    
    mensaje JSON;    
BEGIN	      
    CALL management.leer_cliente('999999999', mensaje);
     RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;



DO $$
DECLARE    
    mensaje JSON;    
BEGIN
    CALL management.leer_cliente('721885858', mensaje); 
    RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================


DO $$
DECLARE
    mensaje JSON;
BEGIN
    CALL management.insertar_cliente(
        'Empresa Ejemplo',
        '123456789',
        'ejemplo@empresa.com',
        '5551234567',
        'Calle Falsa 123',
        'Calle Verdadera 456',
        mensaje
    );
    RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================


DO $$
DECLARE
    mensaje JSON;
BEGIN    
    CALL management.actualizar_cliente(
        1,
        'Empresa Actualizada', -- Nuevo nombre
        '99', 
        'actualizado@actualizado.com',
        '0000000', 
        'Nueva Dirección Envío',
        NULL, 
        mensaje
    );    
    RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================

DO $$
DECLARE
    mensaje JSON;
BEGIN    
    CALL management.eliminar_cliente(1, mensaje);
    RAISE NOTICE 'Resultado: %', mensaje;
END;
$$;

--=============================--=============================--=============================--=============================
--=============================--=============================--=============================--=============================
