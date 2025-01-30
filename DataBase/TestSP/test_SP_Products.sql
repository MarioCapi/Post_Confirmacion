DO $$
DECLARE
    v_result JSON;  
BEGIN    
    CALL management.sp_insert_product('002','nomProd','kg','generic_prod',8900,v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

--test OK--
URL:  http://127.0.0.1:5000/api/products/api/products_create;
{
    "codeProducto": "007",
    "nombre_producto": "Producto de Prueba desde postman",
    "unidad_de_medida": "kg",
    "descripcion": "Este es un producto de prueba para el endpoint desde postman.",
    "precio_unitario": 157.99
}


--Test for Users SPs

DO $$
DECLARE
    v_result JSON;  
BEGIN    
    CALL management.sp_read_producto(v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

--test OK--
GET: http://127.0.0.1:5000/api/products/api/products_read

{
    "message": [
        {
            "codeProducto": "001",
            "descripcion": "generic_prod",
            "id_producto": 1,
            "nombre_producto": "nomProd",
            "precio_unitario": 8900.0,
            "unidad_de_medida": "kg"
        },
        {
            "codeProducto": "002",
            "descripcion": "generic_prod",
            "id_producto": 3,
            "nombre_producto": "nomProd",
            "precio_unitario": 8900.0,
            "unidad_de_medida": "kg"
        },
        {
            "codeProducto": "003",
            "descripcion": "generic_prod",
            "id_producto": 5,
            "nombre_producto": "nomProd",
            "precio_unitario": 8900.0,
            "unidad_de_medida": "kg"
        },
        {
            "codeProducto": "007",
            "descripcion": "Este es un producto de ACTUALIZADO para el endpoint desde postman.",
            "id_producto": 6,
            "nombre_producto": "Producto de Prueba ACTUALIZADO DESDE EL postman",
            "precio_unitario": 15.8,
            "unidad_de_medida": "kg"
        }
    ]
}



DO $$
DECLARE
	v_id varchar := '001';  
    v_result JSON;  
BEGIN    
    CALL management.sp_delete_producto(v_id,v_result);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;
--test ok-- 
DELETE: http://127.0.0.1:5000/api/products/api/products_delete/008








DO $$
DECLARE
    v_id INT := 2;  
    v_result JSON;  
BEGIN    
    CALL "Management".sp_update_producto (v_id,'"CANELA ASTILLA"','Kg',2500);    
    RAISE NOTICE 'Resultado: %', v_result;
END $$;

--test OK--
put:  http://127.0.0.1:5000/api/products/api/products_update
{
    "codeProducto": "007",
    "nombre_producto": "Producto de Prueba ACTUALIZADO DESDE EL postman",
    "unidad_de_medida": "kg",
    "descripcion": "Este es un producto de ACTUALIZADO para el endpoint desde postman.",
    "precio_unitario": 15.8
}

