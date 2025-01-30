CREATE OR REPLACE FUNCTION management.actualizar_estado_venta(
    p_id_venta INT, 
    p_estado_formapago VARCHAR(20) DEFAULT NULL, 
    p_estado VARCHAR(20) DEFAULT NULL
)
RETURNS JSON AS $$
DECLARE
    resultado JSON;
BEGIN    
    IF p_estado_formapago IS NULL AND p_estado IS NULL THEN
        resultado := json_build_object(
            'status', 'error',
            'message', 'Debe proporcionar al menos un campo para actualizar.'
        );
        RETURN resultado;
    END IF;
    
    BEGIN
        UPDATE management.ventas
        SET 
            estado_formapago = COALESCE(p_estado_formapago, estado_formapago), 
            estado = COALESCE(p_estado, estado)
        WHERE id_venta = p_id_venta;

        IF FOUND THEN
            resultado := json_build_object(
                'status', 'success',
                'message', 'Actualización exitosa',
                'id_venta', p_id_venta,
                'campos_actualizados', json_build_object(
                    'estado_formapago', p_estado_formapago,
                    'estado', p_estado
                )
            );
        ELSE
            resultado := json_build_object(
                'status', 'error',
                'message', 'No se encontró una venta con el id especificado.',
                'id_venta', p_id_venta
            );
        END IF;    
    EXCEPTION
        WHEN OTHERS THEN
            resultado := json_build_object(
                'status', 'error',
                'message', 'Error durante la actualización: ' || SQLERRM
            );
    END;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;
