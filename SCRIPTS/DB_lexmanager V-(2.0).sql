
--BASE DE DATOS LEXMANAGER V-1

--____________________________________________
--SECCION DE ELIMINACION DE LAS TABLAS 
--____________________________________________

DROP TABLE IF EXISTS tab_act_abogado;
DROP TABLE IF EXISTS tab_fecha_activi;
DROP TABLE IF EXISTS tab_actividades;
DROP TABLE IF EXISTS tab_calendario;
DROP TABLE IF EXISTS tab_casos_cliente;
DROP TABLE IF EXISTS tab_clientes_abogados;
DROP TABLE IF EXISTS tab_abogados_casos;
DROP TABLE IF EXISTS tab_casos;
DROP TABLE IF EXISTS tab_juzgados;
DROP TABLE IF EXISTS tab_especi_abogado;
DROP TABLE IF EXISTS tab_tipocasos;
DROP TABLE IF EXISTS tab_usuario_rol;
DROP TABLE IF EXISTS tab_usuarios;
DROP TABLE IF EXISTS tab_modulos_rol;
DROP TABLE IF EXISTS tab_roles;
DROP TABLE IF EXISTS tab_modulos;
DROP TABLE IF EXISTS tab_personas;
DROP TABLE IF EXISTS tab_ciudades;
DROP TABLE IF EXISTS tab_dptos;
DROP TABLE IF EXISTS tab_parametros;

-- 20 TABLAS 


--DDL
--_____________________________________________________________________________________
-- SECCION CREACION DE TABLAS                 
--_____________________________________________________________________________________

--TABLA DE PARAMETROS 
CREATE TABLE IF NOT EXISTS tab_parametros 
(
    id_empresa      DECIMAL(10,0)       NOT NULL CHECK(id_empresa >=10000000    AND id_empresa<=9999999999), --identificador de la empresa
    nom_empresa	        VARCHAR           NOT NULL CHECK(LENGTH(nom_empresa) >= 5 AND LENGTH(nom_empresa) <= 60), --nombre de la empresa
    nom_replegal        VARCHAR	          NOT NULL CHECK(LENGTH(nom_replegal) >= 5 AND LENGTH(nom_replegal) <= 60), --nombre del representante legal
    año_actual         DECIMAL(4,0)      NOT NULL, --Año en el que estamos actualmente
    PRIMARY KEY(id_empresa)
);

-- TABLA DEPARTAMENTOS
CREATE TABLE IF NOT EXISTS tab_dptos
(
    id_dpto       VARCHAR       NOT NULL CHECK(LENGTH(id_dpto) = 2), --identificador del departamento
    nom_dpto      VARCHAR       NOT NULL CHECK(LENGTH(nom_dpto) >= 4 AND LENGTH(nom_dpto) <= 20), --nombre del departamento
    PRIMARY KEY(id_dpto)
);


-- TABLA DE CIUDADES DE LOS DEPARTAMENTOS
CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad       VARCHAR             NOT NULL CHECK(LENGTH(id_ciudad) = 5), --identificador de la ciudad	
    nom_ciudad      VARCHAR             NOT NULL CHECK(LENGTH(nom_ciudad) >= 3 AND LENGTH(nom_ciudad) <= 30), --nombre de la ciudad
    id_dpto         VARCHAR             NOT NULL CHECK(LENGTH(id_dpto) = 2),	--identidicador del departamento
    val_zip         VARCHAR             NOT NULL CHECK(LENGTH(val_zip) = 6),	--codigo postal
    val_lati        DECIMAL(18,16)      NOT NULL CHECK(val_lati >= -4    AND val_lati<= 80), --valor latitud
    val_long        DECIMAL(18,16)      NOT NULL CHECK(val_long >= -80  AND val_long <= -50), --valor longitud
   PRIMARY KEY(id_ciudad),
    FOREIGN KEY(id_dpto)    REFERENCES tab_dptos(id_dpto)
);


--TABLA PERSONAS
CREATE TABLE IF NOT EXISTS tab_personas
(
    id_persona      DECIMAL(10,0)       NOT NULL CHECK(id_persona >=10000000 AND id_persona<=9999999999), -- numero identificacion persona 
    ind_tipodoc     VARCHAR             NOT NULL CHECK (ind_tipodoc IN ('CC', 'CE', 'TI', 'NIT', 'PAS')),
    nom_persona     VARCHAR             NOT NULL CHECK (LENGTH(TRIM(nom_persona)) BETWEEN 2 AND 25 AND nom_persona ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$'),
    apell_persona   VARCHAR             NOT NULL CHECK (LENGTH(TRIM(apell_persona)) BETWEEN 2 AND 25 AND apell_persona ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$'),
    id_ciudad       VARCHAR             NOT NULL CHECK(LENGTH(id_ciudad) = 5), --identificador de la ciudad	
    dir_persona     VARCHAR             NOT NULL CHECK(LENGTH(TRIM(dir_persona)) >= 5 AND dir_persona ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 #.,\-]+$'),--direccion de persona
    num_telcelu     DECIMAL(10,0)       NOT NULL CHECK (num_telcelu BETWEEN 3000000000 AND 3999999999), --numero de telefono de la persona
    mail_persona    VARCHAR             NOT NULL CHECK(mail_persona ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    ind_estado      BOOLEAN             NOT NULL, -- verdadero = activo, falso = inactivo
    PRIMARY KEY(id_persona),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad)
);


--TABLA MODULOS DEL SISTEMA  
CREATE TABLE IF NOT EXISTS tab_modulos 
(
    id_modulo      DECIMAL(2,0)        NOT NULL CHECK (id_modulo BETWEEN 1 AND 20),
    nom_modulo     VARCHAR             NOT NULL  CHECK (LENGTH(TRIM(nom_modulo)) >= 3 AND nom_modulo ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 ]+$'),
    desc_modulo    VARCHAR             NOT NULL  CHECK (LENGTH(TRIM(desc_modulo)) >= 10),
    PRIMARY KEY(id_modulo)
);

--TABLA ROLES
CREATE TABLE IF NOT EXISTS tab_roles
(
    id_rol           DECIMAL(1,0)        NOT NULL CHECK (id_rol BETWEEN 1 AND 9), 
    nom_rol          VARCHAR             NOT NULL CHECK (LENGTH(TRIM(nom_rol)) >= 3 AND nom_rol ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$'),
    descripcion      VARCHAR             NOT NULL CHECK (LENGTH(TRIM(descripcion)) >= 10),
    PRIMARY KEY(id_rol)
);


--TABLA MODULOS POR ROL
CREATE TABLE IF NOT EXISTS tab_modulos_rol
(
    id_rol      DECIMAL(1,0)        NOT NULL CHECK (id_rol BETWEEN 1 AND 9),
    id_modulo  DECIMAL(2,0)        NOT NULL CHECK (id_modulo BETWEEN 1 AND 20),
    PRIMARY KEY(id_modulo,id_rol),
    FOREIGN KEY(id_rol)         REFERENCES tab_roles(id_rol),
    FOREIGN KEY(id_modulo)     REFERENCES tab_modulos(id_modulo)
);

CREATE TABLE IF NOT EXISTS tab_usuarios 
(
    id_usuario      DECIMAL(10,0)       NOT NULL CHECK(id_usuario >=10000000 AND id_usuario <=9999999999), -- numero identificacion usuario
    contrasena      VARCHAR       		NOT NULL,
    fecha_crea      DATE                NOT NULL CHECK (fecha_crea <= CURRENT_DATE), -- fechas no futuras 
    PRIMARY KEY(id_usuario),
    FOREIGN KEY(id_usuario)     REFERENCES tab_personas(id_persona)
);

--TABLA ROL DE USUARIO
CREATE TABLE IF NOT EXISTS tab_usuario_rol
(
    id_usuario      DECIMAL(10,0)       NOT NULL CHECK(id_usuario >=10000000 AND id_usuario <=9999999999), -- numero identificacion usuario
    id_rol          DECIMAL(1,0)        NOT NULL CHECK (id_rol BETWEEN 1 AND 9),
    PRIMARY KEY(id_usuario, id_rol),
    FOREIGN KEY(id_usuario)     REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_rol)         REFERENCES tab_roles(id_rol)
);


--TABLA TIPO DE CASO / ESPECIALIDAD
CREATE TABLE IF NOT EXISTS tab_tipocasos
(
    id_tipocaso     DECIMAL(2,0)        NOT NULL CHECK (id_tipocaso BETWEEN 1 AND 99),
    nom_tipocaso    VARCHAR             NOT NULL CHECK (LENGTH(TRIM(nom_tipocaso)) >= 3 AND nom_tipocaso ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ ]+$'),
    desc_tip_caso   VARCHAR             NOT NULL  CHECK (LENGTH(TRIM(desc_tip_caso)) >= 10),
    PRIMARY KEY(id_tipocaso)
);


--TABLA ESPECIALIDADES DE ABOGADO
CREATE TABLE IF NOT EXISTS tab_especi_abogado
(
    id_abogado          DECIMAL(10,0)        NOT NULL CHECK(id_abogado >=10000000 AND id_abogado <=9999999999), -- numero identificacion abogado
    id_especialidad     DECIMAL(2,0)        NOT NULL CHECK (id_especialidad BETWEEN 1 AND 99),
    PRIMARY KEY(id_abogado, id_especialidad),
    FOREIGN KEY(id_abogado)        REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_especialidad)   REFERENCES tab_tipocasos(id_tipocaso)
);


--TABLA JUZGADOS 
CREATE TABLE IF NOT EXISTS tab_juzgados
(
    id_juzgado      VARCHAR(23)             NOT NULL CHECK (id_juzgado ~ '^[0-9]{23}$'),
    nom_juzgado     VARCHAR                 NOT NULL CHECK (LENGTH(TRIM(nom_juzgado)) >= 10 AND nom_juzgado ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 ]+$'),
    jurisdiccion    VARCHAR                 NOT NULL CHECK (jurisdiccion IN ('Ordinaria','Contenciosa Administrativa','Constitucional','Especial')),
    especialidad    VARCHAR                 NOT NULL CHECK (especialidad IN ('Civil','Penal','Laboral','Familia','Administrativo','Promiscuo')),
    nivel           VARCHAR                 NOT NULL CHECK (nivel IN ('Municipal','Circuito','Tribunal','Corte')),
    id_ciudad       VARCHAR                 NOT NULL CHECK(LENGTH(id_ciudad) = 5), --identificador de la ciudad
    dir_juzgado     VARCHAR                 NOT NULL CHECK(LENGTH(TRIM(dir_juzgado)) >= 5 AND dir_juzgado ~ '^[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 #.,\-]+$'),--direccion de juzgado
    PRIMARY KEY(id_juzgado),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad)
);


-- TABLA CASOS / EXPEDIENTES
CREATE TABLE IF NOT EXISTS tab_casos
(
    id_caso         VARCHAR                 NOT NULL CHECK ( id_caso ~ '^[0-9]{5}[0-9]{2}[0-9]{2}[0-9]{3}(20[0-9]{2})[0-9]{5}[0-9]{2}$'),--NÚMERO UNICO DE CASO (NUC)
    id_juzgado      VARCHAR                 NOT NULL CHECK (id_juzgado ~ '^[0-9]{23}$'),
    id_tipocaso     DECIMAL(2,0)            NOT NULL CHECK (id_tipocaso BETWEEN 1 AND 99),
    id_ciudad       VARCHAR                 NOT NULL CHECK(LENGTH(id_ciudad) = 5), --identificador de la ciudad
    fech_apertura   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),-- fecha de insertcion
    fech_fin        DATE                    NOT NULL, 
    ind_estado      BOOLEAN                 NOT NULL, --VERDADERO = ACTIVO, FALSO = INACTIVO
    PRIMARY KEY(id_caso),
    FOREIGN KEY(id_juzgado)     REFERENCES tab_juzgados(id_juzgado),
    FOREIGN KEY(id_tipocaso)    REFERENCES tab_tipocasos(id_tipocaso),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad)
);

--TABLA DE CASOS POR ABOGADO 
CREATE TABLE IF NOT EXISTS tab_abogados_casos
(
    id_abogado      DECIMAL(10,0)           NOT NULL CHECK(id_abogado >=10000000 AND id_abogado <=9999999999), -- numero identificacion abogado
    id_caso         VARCHAR                 NOT NULL CHECK ( id_caso ~ '^[0-9]{5}[0-9]{2}[0-9]{2}[0-9]{3}(20[0-9]{2})[0-9]{5}[0-9]{2}$'),--NÚMERO UNICO DE CASO (NUC),--NÚMERO UNICO DE CASO (NUC)
    PRIMARY KEY(id_abogado,id_caso),
    FOREIGN KEY (id_abogado)      REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY (id_caso)         REFERENCES tab_casos(id_caso)
);


--TABLA DE CLIENTES POR ABOGADO 
CREATE TABLE IF NOT EXISTS tab_clientes_abogados
(
    id_abogado      DECIMAL(10,0)           NOT NULL CHECK(id_abogado >=10000000 AND id_abogado <=9999999999), -- numero identificacion abogado
    id_cliente      DECIMAL(10,0)           NOT NULL CHECK(id_cliente >=10000000 AND id_cliente <=9999999999), -- numero identificacion cliente
    PRIMARY KEY(id_abogado,id_cliente),
    FOREIGN KEY (id_abogado)        REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY (id_cliente)        REFERENCES tab_usuarios(id_usuario)
);

--TABLA CASOS POR CLIENTE 
CREATE TABLE IF NOT EXISTS tab_casos_cliente
(
    id_cliente      DECIMAL(10,0)           NOT NULL CHECK(id_cliente >=10000000 AND id_cliente <=9999999999), -- numero identificacion cliente
    id_caso         VARCHAR                 NOT NULL CHECK ( id_caso ~ '^[0-9]{5}[0-9]{2}[0-9]{2}[0-9]{3}(20[0-9]{2})[0-9]{5}[0-9]{2}$'),--NÚMERO UNICO DE CASO (NUC),--NÚMERO UNICO DE CASO (NUC)
    PRIMARY KEY(id_cliente,id_caso),
    FOREIGN KEY(id_cliente)         REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_caso)            REFERENCES tab_casos(id_caso)
);

--TABLA DE VERIFICACION DE FECHAS HABILES PARA LAS ACTIVIDADES 
CREATE TABLE IF NOT EXISTS tab_calendario
(
   fecha             DATE            NOT NULL,
   ind_findesem      BOOLEAN         NOT NULL,-- verdadero = es fin de semana, falso = no es fin de semana 
   ind_festivo       BOOLEAN         NOT NULL,-- verdadero = es festivo, falso = no es festivo 
   nom_festivo       VARCHAR(40)     NOT NULL,
   ind_habil         BOOLEAN         NOT NULL, -- verdadero = dia habil, falso = dia no valido 
   PRIMARY KEY(fecha),
   CONSTRAINT CHK_ind_habil CHECK((ind_habil = TRUE AND ind_findesem = FALSE AND ind_festivo = FALSE) OR(ind_habil = FALSE AND ind_findesem = TRUE AND ind_festivo = TRUE)) --valida que el sistema solo pueda registrar actividades en dias  habiles
);


--TABLA DE ACTIVDADES PARA EL CRONOGRAMA 
CREATE TABLE IF NOT EXISTS tab_actividades 
(
    id_actividad    DECIMAL(2,0)    NOT NULL,
    nom_actividad   VARCHAR         NOT NULL,
    desc_acti       VARCHAR         NOT NULL,
    ind_prioridad   VARCHAR         NOT NULL,
    PRIMARY KEY(id_actividad)
);
--TABLA DE ACTIVIDADES POR FECHA 
CREATE TABLE IF NOT EXISTS tab_fecha_activi
(
    fecha           DATE            NOT NULL,
    id_actividad    DECIMAL(2,0)    NOT NULL,
    PRIMARY KEY(fecha,id_actividad),
    FOREIGN KEY (fecha)           REFERENCES tab_calendario(fecha),
    FOREIGN KEY (id_actividad)     REFERENCES tab_actividades(id_actividad)
);

--TABLA CRONOGRAMA DE ACTIVIDADES DE ABOGADO
CREATE TABLE IF NOT EXISTS tab_act_abogado
(
    id_abogado      DECIMAL(10,0)   NOT NULL,
    id_actividad    DECIMAL(2,0)    NOT NULL,
    fech_progra     DATE            NOT NULL, 
    ind_estado      VARCHAR         NOT NULL,
    PRIMARY KEY(id_actividad,id_abogado,fech_progra),
    FOREIGN KEY(id_actividad)       REFERENCES tab_actividades(id_actividad),
    FOREIGN KEY(id_abogado)         REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(fech_progra)        REFERENCES tab_calendario(fecha)
); 

