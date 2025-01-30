-- test para crear usuario 
DO $$
BEGIN
    CALL "management".sp_create_usuario('mario', '123456', 'correo@ejemplo.com');
END $$;


-- test para leer usuarios
DO $$
DECLARE
    resultado JSON; -- Variable para almacenar el resultado del procedimiento
BEGIN
    -- Prueba 1: Leer un usuario específico que existe
    RAISE NOTICE 'Prueba 1: Leer usuario con ID 1';
    CALL "management".sp_read_usuario(1, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 2: Leer un usuario específico que no existe
    RAISE NOTICE 'Prueba 2: Leer usuario con ID inexistente (99999)';
    CALL "management".sp_read_usuario(99999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 3: Leer todos los usuarios
    RAISE NOTICE 'Prueba 3: Leer todos los usuarios';
    CALL "management".sp_read_usuario(999999999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;

    -- Prueba 4: Tabla sin registros (asegúrate de probar esto con la tabla vacía)
    RAISE NOTICE 'Prueba 4: Leer todos los usuarios en una tabla vacía';
    CALL "management".sp_read_usuario(999999999, resultado);
    RAISE NOTICE 'Resultado: %', resultado;
END;
$$;

--test para actualizar usuarios 
DO $$
BEGIN
    -- Llama al procedimiento con valores de prueba
    CALL "management".sp_update_usuario(
        p_id_usuario := 2,
        p_username := 'nuevo_usuario',
        p_password := 'nueva_contraseña',
        p_email := 'nuevo_email@example.com'
    );

    -- Opcional: puedes agregar un SELECT para verificar los cambios
    RAISE NOTICE 'Actualización completada. Verifique los datos.';
END;
$$;

--test para eliminar usuario
DO $$
BEGIN
    -- Llama al procedimiento con un ID existente para probar la eliminación
    CALL "management".sp_delete_usuario(2);
    RAISE NOTICE 'Usuario con ID 1 eliminado correctamente.';

    -- Llama al procedimiento con un ID inexistente para probar el manejo de errores
    BEGIN
        CALL "management".sp_delete_usuario(99999);
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Error esperado: %', SQLERRM;
    END;
END;
$$;