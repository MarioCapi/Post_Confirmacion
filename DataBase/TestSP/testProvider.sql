--test crear proveedor
DO $$
BEGIN
    -- Llamada al procedimiento almacenado con valores de prueba
    CALL "management".sp_create_proveedor(
        123456789,           -- _nit_proveedor
        'carlos',  -- _nombre_contacto
        'Razón Social Prueba', -- _razon_social
        '123-456-7890',       -- _telefono_contacto
        'Calle 123, Ciudad',  -- _direccion
        'contacto@empresa.com' -- _correo_electronico
    );
END $$;

--test para leer proveedor
DO $$
BEGIN
    -- Consultar todos los proveedores
    RAISE NOTICE 'Consultando todos los proveedores:';
    CALL "management".sp_read_proveedor();

    -- Consultar un proveedor específico por NIT
    RAISE NOTICE 'Consultando proveedor con NIT 123456789:';
    CALL "management".sp_read_proveedor(123456789);

END $$;

--test para actualizar proveedor
DO $$
BEGIN
    -- Llamar al procedimiento para actualizar un proveedor
    CALL "management".sp_update_proveedor(
        123456789, -- NIT del proveedor (debe existir)
        'nombre contacto actualizado', -- Nuevo nombre de contacto
        'ABC S.A.', -- Nueva razón social
        '123456789', -- Nuevo teléfono de contacto
        'Calle Nueva 123', -- Nueva dirección
        'nuevo_contacto@abc.com' -- Nuevo correo electrónico
    );
END $$;

--test para eliminar proveedor
DO $$
DECLARE
    resultado JSON;
BEGIN
    -- Llamar al procedimiento y recibir el JSON de resultado
    CALL "management".sp_delete_proveedor('9635289652', resultado);
    RAISE NOTICE 'Resultado: %', resultado; -- Mostrar el resultado en la consola
END $$;

