--Crear base de datos
CREATE DATABASE "CeyTauro";
--crear equema "Management"
CREATE SCHEMA "management";

--crear tablas
CREATE TABLE "management".usuarios (
    id_usuario SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE management.productos 
(id_producto SERIAL PRIMARY KEY,
codeProducto VARCHAR NOT NULL,
nombre_producto VARCHAR(255) NOT NULL,
unidad_de_medida VARCHAR(10) NOT NULL,
descripcion TEXT, 
precio_unitario DECIMAL(10, 2));
ALTER TABLE management.productos
ADD CONSTRAINT unique_codeProducto UNIQUE (codeProducto);



CREATE TABLE management.clientes (
    id SERIAL PRIMARY KEY,
    nombre_razonsocial VARCHAR(200) NOT NULL,
    numero_identificacion VARCHAR(50) UNIQUE NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    direccion_envio TEXT,
    direccion_facturacion TEXT,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Table: management.inventario-- DROP TABLE IF EXISTS management.inventario;
CREATE TABLE IF NOT EXISTS management.inventario
(
    id serial primary key,
    nombre_especia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    cantidad integer NOT NULL,
    unidad_medida character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fecha_ingreso date NOT NULL,
    proveedor character varying(100) COLLATE pg_catalog."default",
    precio_compra numeric(10,2),
    ubicacion character varying(100) COLLATE pg_catalog."default",
    notas text COLLATE pg_catalog."default"    
)


CREATE TABLE management.ventas (
    id_venta 				SERIAL PRIMARY KEY, 
	consecutivo_factura		bigint NOT NULL,    
	numero_identi_cliente	VARCHAR(20),
    id_producto 			INT NOT NULL,
    cantidad 				INT NOT NULL CHECK (cantidad > 0),
	total 					DECIMAL(15, 2),
    estado              	VARCHAR(20),
    estado_formapago    	VARCHAR(20),
    fecha_venta 			TIMESTAMP DEFAULT NOW(),
	
    
    CONSTRAINT fk_cliente FOREIGN KEY (numero_identi_cliente) 
        REFERENCES management.clientes (numero_identificacion) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_producto FOREIGN KEY (id_producto) 
        REFERENCES management.productos (id_producto) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE "management".proveedores (
    id_proveedor SERIAL PRIMARY KEY,            
    nit_proveedor BIGINT NOT NULL UNIQUE,       
    nombre_contacto VARCHAR(255) NOT NULL,      
    razon_social VARCHAR(255) NOT NULL,         
    telefono_contacto VARCHAR(50),             
    direccion VARCHAR(255),                    
    correo_electronico VARCHAR(255)            
);

