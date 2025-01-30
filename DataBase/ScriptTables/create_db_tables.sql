--Crear base de datos
CREATE DATABASE "Post_Confirmacion";
--crear equema "Management"
CREATE SCHEMA "management";

-- Crear el schema "management" si no existe
CREATE SCHEMA IF NOT EXISTS management;

-- Cambiar al schema "management"
SET search_path TO management;

--crear tablas
CREATE TABLE "management".users (
    id_usuario SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- 3. Crear la tabla "padrinos" (primera tabla sin dependencias)
CREATE TABLE "management".padrinos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    numero_documento VARCHAR(50) NOT NULL UNIQUE,
    edad INT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_nacimiento DATE NOT NULL
);

-- 4. Crear la tabla "curso" (segunda tabla sin dependencias)
CREATE TABLE "management".curso (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(200) NOT NULL,
    fecha_inicio DATE NOT NULL
);

-- 5. Crear la tabla "ahijados" (depende de "padrinos" y "curso")
CREATE TABLE "management".ahijados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(50) NOT NULL,
    numero_documento VARCHAR(50) NOT NULL UNIQUE,
    edad INT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    fecha_nacimiento DATE NOT NULL,
    curso_id INT, -- Relación con la tabla "curso"
    padrino_id INT, -- Relación con la tabla "padrinos"
    FOREIGN KEY (curso_id) REFERENCES management.curso(id) ON DELETE SET NULL,
    FOREIGN KEY (padrino_id) REFERENCES management.padrinos(id) ON DELETE SET NULL
);

-- 6. Crear la tabla "campamento" (sin dependencias)
CREATE TABLE "management".campamento (
    id SERIAL PRIMARY KEY,
    descripcion VARCHAR(200) NOT NULL,
    año INT NOT NULL
);

-- 7. Crear la tabla "inscripciones_campamento" (depende de "ahijados")
CREATE TABLE "management".inscripciones_campamento (
    id SERIAL PRIMARY KEY,
    ahijado_id INT NOT NULL, -- Relación con la tabla "ahijados"
    abono NUMERIC(10, 2) NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (ahijado_id) REFERENCES management.ahijados(id) ON DELETE CASCADE
);