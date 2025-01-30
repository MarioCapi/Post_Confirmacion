-- Crear la función para manejar la inserción
CREATE OR REPLACE FUNCTION "Management".log_insert_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.usuario_modifica := current_user;
    NEW.fecha_modifica := current_timestamp;
    NEW.accion_realizada := 'INSERTAR'; 
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear la función para manejar la actualización
CREATE OR REPLACE FUNCTION "Management".log_update_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modificado_por := current_user;
    NEW.fecha_modificacion := current_timestamp;
    NEW.accion := 'ACTUALIZAR';
    NEW.detalle_accion := 'Actualizado: ' || row_to_json(OLD);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear la función para manejar la eliminación
CREATE OR REPLACE FUNCTION "Management".log_delete_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO "Management".audit_log (tabla, modificado_por, fecha_modificacion, accion)
    VALUES (TG_TABLE_NAME, current_user, current_timestamp, 'Eliminado: ' || row_to_json(OLD));
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- Crear el trigger para insertar en todas las tablas relevantes
CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".usuarios
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".ventas
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".clientes
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".productos
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".factura
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".proveedores
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

CREATE TRIGGER trigger_insert AFTER INSERT ON "Management".inventario
FOR EACH ROW EXECUTE FUNCTION "Management".log_insert_trigger();

-- Crear el trigger para actualizar en todas las tablas relevantes
CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".usuarios
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".ventas
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".clientes
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".productos
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".factura
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".proveedores
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

CREATE TRIGGER trigger_update BEFORE UPDATE ON "Management".inventario
FOR EACH ROW EXECUTE FUNCTION "Management".log_update_trigger();

-- Crear el trigger para eliminar en todas las tablas relevantes
CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".usuarios
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".ventas
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".clientes
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".productos
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE OR REPLACE TRIGGER trigger_delete BEFORE DELETE ON "Management".productos
FOR EACH ROW  EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".factura
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".proveedores
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();

CREATE TRIGGER trigger_delete BEFORE DELETE ON "Management".inventario
FOR EACH ROW EXECUTE FUNCTION "Management".log_delete_trigger();
