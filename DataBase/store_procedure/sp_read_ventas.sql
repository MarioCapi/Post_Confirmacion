CREATE OR REPLACE FUNCTION management.get_sales_report(
    p_fecha_inicio DATE DEFAULT NULL,
    p_fecha_final DATE DEFAULT NULL,
    p_numero_identificacion VARCHAR DEFAULT NULL,
    p_codeproducto VARCHAR DEFAULT NULL,
    p_consecutivo_factura BIGINT DEFAULT NULL,
    OUT resultado JSON
)
RETURNS JSON AS $$
BEGIN
    -- Intenta realizar la consulta
    BEGIN
        SELECT json_agg(row_to_json(t))
        INTO resultado
        FROM (
            SELECT
				ve.id_venta,
                cl.nombre_razonsocial,
                cl.numero_identificacion, 
                pr.codeproducto,
                ve.consecutivo_factura, 
                ve.cantidad,
                ve.total, 
                ve.estado,
                ve.estado_formapago,
                pr.precio_unitario,
                pr.nombre_producto,
                ve.fecha_venta
            FROM management.clientes cl
            INNER JOIN management.ventas ve 
                ON cl.numero_identificacion = ve.numero_identi_cliente
            INNER JOIN management.productos pr 
                ON ve.id_producto = pr.id_producto
            WHERE 
                (p_fecha_inicio IS NULL OR ve.fecha_venta >= p_fecha_inicio) AND
                (p_fecha_final IS NULL OR ve.fecha_venta <= p_fecha_final) AND
                (p_numero_identificacion IS NULL OR cl.numero_identificacion = p_numero_identificacion) AND
                (p_codeproducto IS NULL OR pr.codeproducto = p_codeproducto) AND
                (p_consecutivo_factura IS NULL OR ve.consecutivo_factura = p_consecutivo_factura)
        ) t;

        -- Controla el caso en que no haya resultados
        IF resultado IS NULL THEN
            resultado := json_build_object(
                'status', 'success',
                'message', 'No records found',
                'data', '[]'
            );
        END IF;

    EXCEPTION
        -- Captura errores y envía un mensaje de error
        WHEN OTHERS THEN
            resultado := json_build_object(
                'status', 'error',
                'message', SQLERRM
            );
    END;
END;
$$ LANGUAGE plpgsql;
