-- Update Ventas
DO $$
DECLARE
    resultado JSON;
BEGIN
    resultado := management.actualizar_estado_venta(
        1, -- ID de la venta
        'Pago completado', -- Nuevo estado_formapago    opcionales para actualizar
        'Procesado' -- Nuevo estado                     opcionales para actualizar
    );
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;

-- Ó


SELECT management.actualizar_estado_venta(1, 'FIADA', 'ANULADA');
