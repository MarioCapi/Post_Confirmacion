DO $$
DECLARE
    resultado JSON;
BEGIN
    CALL management.crear_venta(
        1001, 
        '7788', 
		'CREADA',
		'DEBE',
        '[
			{"id_producto": 1, "cantidad": 2},{"id_producto": 2, "cantidad": 16},{"id_producto": 3, "cantidad": 12}
		]'::JSON,resultado
    );    
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;

-- POSTMAN --http://127.0.0.1:5000/api/ventas/api/ventas_create 
{
    "consecutivo_factura": 12345,
    "numero_identi_cliente": "123456789",
    "estado": "Pendiente",
    "formapago": "DEBE",
    "productos_json": [
        {"id_producto": 1, "cantidad": 2},
        {"id_producto": 2, "cantidad": 1}
    ]
}


--POSTMAN --http://127.0.0.1:5000/api/ventas/api/ventas_update 
{
    "id_venta": 1,
    "estado_formapago": "PagoAPI",
    "estado": "ProcesadoAPI"
}