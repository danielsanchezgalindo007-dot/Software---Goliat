-- BASE DE DATOS LEXMANAGER V-2.1
--_________________________________________
-- SECCION CREACION DE TABLAS
--____________________________________________

--TABLA DE PARAMETROS
CREATE TABLE IF NOT EXISTS tab_parametros
(
    id_empresa      DECIMAL(10,0)       NOT NULL CHECK(id_empresa BETWEEN 10000000 AND 9999999999),
    nom_empresa     VARCHAR(60)         NOT NULL CHECK(LENGTH(TRIM(nom_empresa)) BETWEEN 5 AND 60),
    nom_replegal    VARCHAR(60)         NOT NULL CHECK(LENGTH(TRIM(nom_replegal)) BETWEEN 5 AND 60),
    anio_actual     DECIMAL(4,0)        NOT NULL,
    PRIMARY KEY(id_empresa)
);--tab operacional

-- TABLA DEPARTAMENTOS
CREATE TABLE IF NOT EXISTS tab_dptos
(
    id_dpto         VARCHAR(2)          NOT NULL CHECK(LENGTH(id_dpto) = 2),
    nom_dpto        VARCHAR(40)         NOT NULL CHECK(LENGTH(TRIM(nom_dpto)) BETWEEN 4 AND 40),
    PRIMARY KEY(id_dpto)
);--operativa

-- TABLA CIUDADES
CREATE TABLE IF NOT EXISTS tab_ciudades
(
    id_ciudad       VARCHAR(5)          NOT NULL CHECK(LENGTH(id_ciudad) = 5),
    nom_ciudad      VARCHAR(60)         NOT NULL CHECK(LENGTH(TRIM(nom_ciudad)) BETWEEN 3 AND 60),
    id_dpto         VARCHAR(2)          NOT NULL CHECK(LENGTH(id_dpto) = 2),
    val_zip         VARCHAR(10)         NOT NULL CHECK(LENGTH(TRIM(val_zip)) BETWEEN 4 AND 10),
    val_lati        DECIMAL(18,16)      NOT NULL,
    val_long        DECIMAL(18,16)      NOT NULL,
    PRIMARY KEY(id_ciudad),
    FOREIGN KEY(id_dpto) REFERENCES tab_dptos(id_dpto)
);--transaccional

-- TABLA ROLES
CREATE TABLE IF NOT EXISTS tab_roles
(
    id_rol           DECIMAL(2,0)       NOT NULL CHECK (id_rol BETWEEN 1 AND 99),
    nom_rol          VARCHAR(40)        NOT NULL CHECK (LENGTH(TRIM(nom_rol)) >= 3),
    descripcion      VARCHAR(200)       NOT NULL CHECK (LENGTH(TRIM(descripcion)) >= 10),
    PRIMARY KEY(id_rol)
);--transaccional

-- TABLA PERMISOS 
-- Cada permiso representa una funcionalidad/acción del sistema.
CREATE TABLE IF NOT EXISTS tab_permisos
(
    id_permiso      DECIMAL(3,0)        NOT NULL CHECK (id_permiso BETWEEN 1 AND 999),
    cod_permiso     VARCHAR(60)         NOT NULL CHECK(LENGTH(TRIM(cod_permiso)) BETWEEN 3 AND 60),
    nom_permiso     VARCHAR(120)        NOT NULL CHECK(LENGTH(TRIM(nom_permiso)) BETWEEN 3 AND 120),
    descripcion     VARCHAR(250)        NULL,
    PRIMARY KEY(id_permiso)
);

-- TABLA PERMISOS POR ROL 
CREATE TABLE IF NOT EXISTS tab_rol_permiso
(
    id_rol          DECIMAL(2,0)        NOT NULL,
    id_permiso      DECIMAL(3,0)        NOT NULL,
    PRIMARY KEY(id_rol, id_permiso),
    FOREIGN KEY(id_rol)     REFERENCES tab_roles(id_rol),
    FOREIGN KEY(id_permiso) REFERENCES tab_permisos(id_permiso)
);--transaccional

-- TABLA PRIORIDADES
CREATE TABLE IF NOT EXISTS tab_prioridades
(
    id_prioridad    DECIMAL(1,0)        NOT NULL CHECK (id_prioridad BETWEEN 1 AND 9),
    nom_prioridad   VARCHAR(20)         NOT NULL CHECK (LENGTH(TRIM(nom_prioridad)) >= 3),
    peso            DECIMAL(3,0)        NOT NULL CHECK (peso BETWEEN 1 AND 100),
    PRIMARY KEY(id_prioridad)
);--transaccional

-- TABLA ESTADOS DE TAREA
CREATE TABLE IF NOT EXISTS tab_estado_tarea
(
    id_estado_tarea DECIMAL(2,0)        NOT NULL CHECK (id_estado_tarea BETWEEN 1 AND 99),
    nom_estado      VARCHAR(30)         NOT NULL CHECK (LENGTH(TRIM(nom_estado)) >= 3),
    es_final        BOOLEAN             NOT NULL,
    PRIMARY KEY(id_estado_tarea)
);--operativa

-- TABLA ESTADOS DE CASO
CREATE TABLE IF NOT EXISTS tab_estado_caso
(
    id_estado_caso  DECIMAL(2,0)        NOT NULL CHECK (id_estado_caso BETWEEN 1 AND 99),
    nom_estado      VARCHAR(30)         NOT NULL CHECK (LENGTH(TRIM(nom_estado)) >= 3),
    es_final        BOOLEAN             NOT NULL,
    PRIMARY KEY(id_estado_caso)
);--operativa

-- TABLA PERSONAS
CREATE TABLE IF NOT EXISTS tab_personas
(
    id_persona      DECIMAL(10,0)       NOT NULL CHECK(id_persona BETWEEN 10000000 AND 9999999999),
    ind_tipodoc     VARCHAR(5)          NOT NULL CHECK (ind_tipodoc IN ('CC', 'CE', 'TI', 'NIT', 'PAS')),
    nom_persona     VARCHAR(25)         NOT NULL CHECK (LENGTH(TRIM(nom_persona)) BETWEEN 2 AND 25),
    apell_persona   VARCHAR(25)         NOT NULL CHECK (LENGTH(TRIM(apell_persona)) BETWEEN 2 AND 25),
    id_ciudad       VARCHAR(5)          NOT NULL CHECK(LENGTH(id_ciudad) = 5),
    dir_persona     VARCHAR(120)        NOT NULL CHECK(LENGTH(TRIM(dir_persona)) >= 5),
    num_telcelu     DECIMAL(10,0)       NOT NULL,
    mail_persona    VARCHAR(254)        NOT NULL CHECK(LENGTH(TRIM(mail_persona)) >= 6),
    ind_estado      BOOLEAN             NOT NULL,
    PRIMARY KEY(id_persona),
    FOREIGN KEY(id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);--transaccional

-- TABLA USUARIOS
CREATE TABLE IF NOT EXISTS tab_usuarios
(
    id_usuario      DECIMAL(10,0)       NOT NULL CHECK(id_usuario BETWEEN 10000000 AND 9999999999),
    password_hash   VARCHAR(255)        NOT NULL CHECK(LENGTH(TRIM(password_hash)) >= 20),
    fecha_crea      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    last_login      TIMESTAMP WITH TIME ZONE NULL,
    PRIMARY KEY(id_usuario),
    FOREIGN KEY(id_usuario) REFERENCES tab_personas(id_persona)
);--transaccional

-- TABLA ROL DE USUARIO
CREATE TABLE IF NOT EXISTS tab_usuario_rol
(
    id_usuario      DECIMAL(10,0)       NOT NULL,
    id_rol          DECIMAL(2,0)        NOT NULL,
    PRIMARY KEY(id_usuario, id_rol),
    FOREIGN KEY(id_usuario) REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_rol)     REFERENCES tab_roles(id_rol)
);

-- TABLA TIPO DE CASO / ESPECIALIDAD
CREATE TABLE IF NOT EXISTS tab_tipocasos
(
    id_tipocaso     DECIMAL(3,0)        NOT NULL CHECK (id_tipocaso BETWEEN 1 AND 999),
    nom_tipocaso    VARCHAR(80)         NOT NULL CHECK (LENGTH(TRIM(nom_tipocaso)) >= 3),
    desc_tip_caso   VARCHAR(250)        NOT NULL CHECK (LENGTH(TRIM(desc_tip_caso)) >= 10),
    PRIMARY KEY(id_tipocaso)
);



-- TABLA JUZGADOS
CREATE TABLE IF NOT EXISTS tab_juzgados
(
    id_juzgado      VARCHAR(23)         NOT NULL,
    nom_juzgado     VARCHAR(120)        NOT NULL CHECK(LENGTH(TRIM(nom_juzgado)) >= 10),
    jurisdiccion    VARCHAR(40)         NOT NULL,
    especialidad    VARCHAR(20)         NOT NULL,
    nivel           VARCHAR(20)         NOT NULL,
    id_ciudad       VARCHAR(5)          NOT NULL CHECK(LENGTH(id_ciudad) = 5),
    dir_juzgado     VARCHAR(120)        NOT NULL CHECK(LENGTH(TRIM(dir_juzgado)) >= 5),
    PRIMARY KEY(id_juzgado),
    FOREIGN KEY(id_ciudad) REFERENCES tab_ciudades(id_ciudad)
);

-- TABLA CASOS / EXPEDIENTES
CREATE TABLE IF NOT EXISTS tab_casos
(
    id_caso         VARCHAR(40)         NOT NULL,
    radicado        VARCHAR(40)         NULL,
    id_juzgado      VARCHAR(23)         NOT NULL,
    id_tipocaso     DECIMAL(3,0)        NOT NULL,
    id_ciudad       VARCHAR(5)          NOT NULL CHECK(LENGTH(id_ciudad) = 5),
    fech_apertura   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    fech_fin        DATE                NULL,
    id_estado_caso  DECIMAL(2,0)        NOT NULL,
    ind_estado      BOOLEAN             NOT NULL,
    PRIMARY KEY(id_caso),
    FOREIGN KEY(id_juzgado)     REFERENCES tab_juzgados(id_juzgado),
    FOREIGN KEY(id_tipocaso)    REFERENCES tab_tipocasos(id_tipocaso),
    FOREIGN KEY(id_ciudad)      REFERENCES tab_ciudades(id_ciudad),
    FOREIGN KEY(id_estado_caso) REFERENCES tab_estado_caso(id_estado_caso)
);

-- TABLA DE CASOS POR ABOGADO
CREATE TABLE IF NOT EXISTS tab_abogados_casos
(
    id_abogado      DECIMAL(10,0)       NOT NULL,
    id_caso         VARCHAR(40)         NOT NULL,
    PRIMARY KEY(id_abogado, id_caso),
    FOREIGN KEY(id_abogado) REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_caso)    REFERENCES tab_casos(id_caso)
);

-- TABLA DE CLIENTES POR ABOGADO
CREATE TABLE IF NOT EXISTS tab_clientes_abogados
(
    id_abogado      DECIMAL(10,0)       NOT NULL,
    id_cliente      DECIMAL(10,0)       NOT NULL,
    PRIMARY KEY(id_abogado, id_cliente),
    FOREIGN KEY(id_abogado) REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_cliente) REFERENCES tab_usuarios(id_usuario)
);

-- TABLA CASOS POR CLIENTE
CREATE TABLE IF NOT EXISTS tab_casos_cliente
(
    id_cliente      DECIMAL(10,0)       NOT NULL,
    id_caso         VARCHAR(40)         NOT NULL,
    PRIMARY KEY(id_cliente, id_caso),
    FOREIGN KEY(id_cliente) REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_caso)    REFERENCES tab_casos(id_caso)
);

-- TABLA ROL PARTE
CREATE TABLE IF NOT EXISTS tab_rol_parte
(
    id_rol_parte    DECIMAL(2,0)        NOT NULL CHECK (id_rol_parte BETWEEN 1 AND 99),
    nom_rol_parte   VARCHAR(30)         NOT NULL CHECK (LENGTH(TRIM(nom_rol_parte)) >= 3),
    PRIMARY KEY(id_rol_parte)
);

-- TABLA PARTES DEL CASO
CREATE TABLE IF NOT EXISTS tab_caso_partes
(
    id_caso         VARCHAR(40)         NOT NULL,
    id_persona      DECIMAL(10,0)       NOT NULL,
    id_rol_parte    DECIMAL(2,0)        NOT NULL,
    PRIMARY KEY(id_caso, id_persona, id_rol_parte),
    FOREIGN KEY(id_caso)      REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_persona)   REFERENCES tab_personas(id_persona),
    FOREIGN KEY(id_rol_parte) REFERENCES tab_rol_parte(id_rol_parte)
);

-- HISTORIAL DE ESTADOS DEL CASO
CREATE TABLE IF NOT EXISTS tab_hist_estado_caso
(
    id_hist         INT            NOT NULL,
    id_caso         VARCHAR(40)         NOT NULL,
    id_estado_caso  DECIMAL(2,0)        NOT NULL,
    fecha_evento    TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    id_usuario      DECIMAL(10,0)       NULL,
    observacion     VARCHAR(500)        NULL,
    PRIMARY KEY(id_hist),
    FOREIGN KEY(id_caso)        REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_estado_caso) REFERENCES tab_estado_caso(id_estado_caso),
    FOREIGN KEY(id_usuario)     REFERENCES tab_usuarios(id_usuario)
);

-- TABLA CALENDARIO 
CREATE TABLE IF NOT EXISTS tab_calendario
(
   fecha             DATE            NOT NULL,
   ind_findesem      BOOLEAN         NOT NULL,
   ind_festivo       BOOLEAN         NOT NULL,
   nom_festivo       VARCHAR(80)     NULL,
   ind_habil         BOOLEAN         NOT NULL,
   PRIMARY KEY(fecha),
   CONSTRAINT CHK_cal_festivo_nombre CHECK((ind_festivo = TRUE AND nom_festivo IS NOT NULL) OR (ind_festivo = FALSE AND nom_festivo IS NULL)),
   CONSTRAINT CHK_cal_habil_regla CHECK(ind_habil = (NOT ind_findesem AND NOT ind_festivo))
);

-- TABLA ACTIVIDADES 
CREATE TABLE IF NOT EXISTS tab_actividades
(
    id_actividad    DECIMAL(3,0)    NOT NULL,
    nom_actividad   VARCHAR(80)     NOT NULL CHECK(LENGTH(TRIM(nom_actividad)) >= 3),
    desc_acti       VARCHAR(250)    NOT NULL CHECK(LENGTH(TRIM(desc_acti)) >= 5),
    id_prioridad    DECIMAL(1,0)    NOT NULL,
    PRIMARY KEY(id_actividad),
    FOREIGN KEY(id_prioridad) REFERENCES tab_prioridades(id_prioridad)
);

-- TABLA DE ACTIVIDADES POR FECHA
CREATE TABLE IF NOT EXISTS tab_fecha_activi
(
    fecha           DATE            NOT NULL,
    id_actividad    DECIMAL(3,0)    NOT NULL,
    PRIMARY KEY(fecha, id_actividad),
    FOREIGN KEY (fecha)        REFERENCES tab_calendario(fecha),
    FOREIGN KEY (id_actividad) REFERENCES tab_actividades(id_actividad)
);

-- TABLA CRONOGRAMA DE ACTIVIDADES DE ABOGADO 
CREATE TABLE IF NOT EXISTS tab_act_abogado
(
    id_abogado      DECIMAL(10,0)   NOT NULL,
    id_actividad    DECIMAL(3,0)    NOT NULL,
    fech_progra     DATE           NOT NULL,
    id_estado_tarea DECIMAL(2,0)   NOT NULL,
    PRIMARY KEY(id_actividad, id_abogado, fech_progra),
    FOREIGN KEY(id_actividad)    REFERENCES tab_actividades(id_actividad),
    FOREIGN KEY(id_abogado)      REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(fech_progra)     REFERENCES tab_calendario(fecha),
    FOREIGN KEY(id_estado_tarea) REFERENCES tab_estado_tarea(id_estado_tarea)
);

-- TABLA TAREAS 
CREATE TABLE IF NOT EXISTS tab_tareas
(
    id_tarea        INT         NOT NULL,
    id_caso         VARCHAR(40)     NULL,
    titulo          VARCHAR(120)    NOT NULL CHECK(LENGTH(TRIM(titulo)) BETWEEN 3 AND 120),
    descripcion     VARCHAR(1000)   NULL,
    id_responsable  DECIMAL(10,0)   NOT NULL,
    id_prioridad    DECIMAL(1,0)    NOT NULL,
    id_estado_tarea DECIMAL(2,0)    NOT NULL,
    fecha_crea      TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    fecha_venc      TIMESTAMP WITH TIME ZONE NULL,
    fecha_cierre    TIMESTAMP WITH TIME ZONE NULL,
    created_by      DECIMAL(10,0)   NULL,
    PRIMARY KEY(id_tarea),
    FOREIGN KEY(id_caso)         REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_responsable)  REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_prioridad)    REFERENCES tab_prioridades(id_prioridad),
    FOREIGN KEY(id_estado_tarea) REFERENCES tab_estado_tarea(id_estado_tarea),
    FOREIGN KEY(created_by)      REFERENCES tab_usuarios(id_usuario)
);

-- TIPO DE ACTUACION
CREATE TABLE IF NOT EXISTS tab_tipo_actuacion
(
    id_tipo_actuacion   DECIMAL(3,0)    NOT NULL CHECK (id_tipo_actuacion BETWEEN 1 AND 999),
    nom_tipo            VARCHAR(60)     NOT NULL CHECK (LENGTH(TRIM(nom_tipo)) >= 3),
    PRIMARY KEY(id_tipo_actuacion)
);

-- ACTUACIONES
CREATE TABLE IF NOT EXISTS tab_actuaciones
(
    id_actuacion        INT             NOT NULL,
    id_caso             VARCHAR(40)     NOT NULL,
    id_tipo_actuacion   DECIMAL(3,0)    NOT NULL,
    fecha_actuacion     TIMESTAMP WITH TIME ZONE NOT NULL,
    descripcion         VARCHAR(1500)   NOT NULL CHECK(LENGTH(TRIM(descripcion)) >= 3),
    fuente              VARCHAR(120)    NULL,
    created_by          DECIMAL(10,0)   NULL,
    PRIMARY KEY(id_actuacion),
    FOREIGN KEY(id_caso)           REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_tipo_actuacion) REFERENCES tab_tipo_actuacion(id_tipo_actuacion),
    FOREIGN KEY(created_by)        REFERENCES tab_usuarios(id_usuario)
);

-- AUDIENCIAS
CREATE TABLE IF NOT EXISTS tab_audiencias
(
    id_audiencia        INT         NOT NULL,
    id_caso             VARCHAR(40)     NOT NULL,
    fecha_inicio        TIMESTAMP WITH TIME ZONE NOT NULL,
    fecha_fin           TIMESTAMP WITH TIME ZONE NULL,
    lugar               VARCHAR(200)    NULL,
    descripcion         VARCHAR(1500)   NULL,
    created_by          DECIMAL(10,0)   NULL,
    PRIMARY KEY(id_audiencia),
    FOREIGN KEY(id_caso)    REFERENCES tab_casos(id_caso),
    FOREIGN KEY(created_by) REFERENCES tab_usuarios(id_usuario)
);



--DOCUMENTOS DE LOS PROCESOS 

-- TIPO DE DOCUMENTO
CREATE TABLE IF NOT EXISTS tab_tipo_documento
(
    id_tipo_documento   DECIMAL(3,0)    NOT NULL CHECK (id_tipo_documento BETWEEN 1 AND 999),
    nom_tipo            VARCHAR(60)     NOT NULL CHECK (LENGTH(TRIM(nom_tipo)) >= 3),
    PRIMARY KEY(id_tipo_documento)
);

-- DOCUMENTOS
CREATE TABLE IF NOT EXISTS tab_documentos
(
    id_documento        INT        NOT NULL,
    id_tipo_documento   DECIMAL(3,0)    NOT NULL,
    nombre              VARCHAR(200)    NOT NULL CHECK(LENGTH(TRIM(nombre)) >= 3),
    mime_type           VARCHAR(100)    NULL,
    url_storage         VARCHAR(500)    NULL,
    sha256_hex          VARCHAR(64)     NULL,
    fecha_carga         TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    cargado_por         DECIMAL(10,0)   NULL,
    PRIMARY KEY(id_documento),
    FOREIGN KEY(id_tipo_documento) REFERENCES tab_tipo_documento(id_tipo_documento),
    FOREIGN KEY(cargado_por)       REFERENCES tab_usuarios(id_usuario)
);

-- DOCUMENTO POR CASO
CREATE TABLE IF NOT EXISTS tab_documento_caso
(
    id_caso         VARCHAR(40)     NOT NULL,
    id_documento    INT           NOT NULL,
    PRIMARY KEY(id_caso, id_documento),
    FOREIGN KEY(id_caso)      REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_documento) REFERENCES tab_documentos(id_documento)
);

-- DOCUMENTO POR ACTUACION
CREATE TABLE IF NOT EXISTS tab_documento_actuacion
(
    id_actuacion    INT          NOT NULL,
    id_documento    INT           NOT NULL,
    PRIMARY KEY(id_actuacion, id_documento),
    FOREIGN KEY(id_actuacion) REFERENCES tab_actuaciones(id_actuacion),
    FOREIGN KEY(id_documento) REFERENCES tab_documentos(id_documento)
);


--TABLAS DE LA FACTURACION 

-- TIPO DE TARIFA
CREATE TABLE IF NOT EXISTS tab_tipo_tarifa
(
    id_tipo_tarifa  DECIMAL(2,0)        NOT NULL CHECK (id_tipo_tarifa BETWEEN 1 AND 99),
    nom_tipo        VARCHAR(30)         NOT NULL CHECK (LENGTH(TRIM(nom_tipo)) >= 3),
    PRIMARY KEY(id_tipo_tarifa)
);

-- TARIFAS
CREATE TABLE IF NOT EXISTS tab_tarifas
(
    id_tarifa       INT        NOT NULL,
    id_abogado      DECIMAL(10,0)   NULL,
    id_tipocaso     DECIMAL(3,0)    NULL,
    id_tipo_tarifa  DECIMAL(2,0)    NOT NULL,
    valor_unitario  DECIMAL(14,2)   NOT NULL CHECK(valor_unitario >= 0),
    moneda          VARCHAR(3)      NOT NULL DEFAULT 'COP' CHECK(LENGTH(moneda) = 3),
    vigente_desde   DATE            NOT NULL DEFAULT CURRENT_DATE,
    vigente_hasta   DATE            NULL,
    ind_activa      BOOLEAN         NOT NULL,
    PRIMARY KEY(id_tarifa),
    FOREIGN KEY(id_abogado)     REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_tipocaso)    REFERENCES tab_tipocasos(id_tipocaso),
    FOREIGN KEY(id_tipo_tarifa) REFERENCES tab_tipo_tarifa(id_tipo_tarifa)
);

-- REGISTRO DE TIEMPO
CREATE TABLE IF NOT EXISTS tab_registro_tiempo
(
    id_tiempo       INT        NOT NULL,
    id_caso         VARCHAR(40)     NOT NULL,
    id_abogado      DECIMAL(10,0)   NOT NULL,
    fecha_inicio    TIMESTAMP WITH TIME ZONE NOT NULL,
    minutos         DECIMAL(5,0)    NOT NULL CHECK(minutos > 0),
    descripcion     VARCHAR(500)    NULL,
    id_tarifa       INT           NULL,
    creado_en       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY(id_tiempo),
    FOREIGN KEY(id_caso)    REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_abogado) REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_tarifa)  REFERENCES tab_tarifas(id_tarifa)
);

-- ESTADO FACTURA
CREATE TABLE IF NOT EXISTS tab_estado_factura
(
    id_estado_factura   DECIMAL(2,0)    NOT NULL CHECK (id_estado_factura BETWEEN 1 AND 99),
    nom_estado          VARCHAR(30)     NOT NULL CHECK (LENGTH(TRIM(nom_estado)) >= 3),
    es_final            BOOLEAN         NOT NULL,
    PRIMARY KEY(id_estado_factura)
);

-- FACTURAS
CREATE TABLE IF NOT EXISTS tab_facturas
(
    id_factura      INT             NOT NULL,
    id_caso         VARCHAR(40)     NOT NULL,
    id_cliente      DECIMAL(10,0)   NOT NULL,
    fecha_emision   DATE            NOT NULL DEFAULT CURRENT_DATE,
    fecha_venc      DATE            NULL,
    id_estado_factura DECIMAL(2,0)  NOT NULL,
    moneda          VARCHAR(3)      NOT NULL DEFAULT 'COP' CHECK(LENGTH(moneda) = 3),
    subtotal        DECIMAL(14,2)   NOT NULL DEFAULT 0,
    impuestos       DECIMAL(14,2)   NOT NULL DEFAULT 0,
    total           DECIMAL(14,2)   NOT NULL DEFAULT 0,
    observacion     VARCHAR(500)    NULL,
    creada_en       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY(id_factura),
    FOREIGN KEY(id_caso)          REFERENCES tab_casos(id_caso),
    FOREIGN KEY(id_cliente)       REFERENCES tab_usuarios(id_usuario),
    FOREIGN KEY(id_estado_factura) REFERENCES tab_estado_factura(id_estado_factura)
);

-- DETALLE FACTURA
CREATE TABLE IF NOT EXISTS tab_factura_detalle
(
    id_factura_det  INT             NOT NULL,
    id_factura      INT             NOT NULL,
    concepto        VARCHAR(200)    NOT NULL CHECK(LENGTH(TRIM(concepto)) >= 3),
    cantidad        DECIMAL(14,3)   NOT NULL CHECK(cantidad > 0),
    valor_unitario  DECIMAL(14,2)   NOT NULL CHECK(valor_unitario >= 0),
    total_linea     DECIMAL(14,2)   NOT NULL CHECK(total_linea >= 0),
    id_tiempo       INT           NULL,
    PRIMARY KEY(id_factura_det),
    FOREIGN KEY(id_factura) REFERENCES tab_facturas(id_factura),
    FOREIGN KEY(id_tiempo)  REFERENCES tab_registro_tiempo(id_tiempo)
);

-- METODO PAGO
CREATE TABLE IF NOT EXISTS tab_metodo_pago
(
    id_metodo_pago  DECIMAL(2,0)        NOT NULL CHECK (id_metodo_pago BETWEEN 1 AND 99),
    nom_metodo      VARCHAR(40)         NOT NULL CHECK (LENGTH(TRIM(nom_metodo)) >= 3),
    PRIMARY KEY(id_metodo_pago)
);

-- PAGOS
CREATE TABLE IF NOT EXISTS tab_pagos
(
    id_pago         INT             NOT NULL,
    id_factura      INT             NOT NULL,
    fecha_pago      DATE            NOT NULL DEFAULT CURRENT_DATE,
    valor_pago      DECIMAL(14,2)   NOT NULL CHECK(valor_pago > 0),
    id_metodo_pago  DECIMAL(2,0)    NOT NULL,
    referencia      VARCHAR(120)    NULL,
    observacion     VARCHAR(500)    NULL,
    creado_en       TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    PRIMARY KEY(id_pago),
    FOREIGN KEY(id_factura)     REFERENCES tab_facturas(id_factura),
    FOREIGN KEY(id_metodo_pago) REFERENCES tab_metodo_pago(id_metodo_pago)
);



--INSERSION DE INFORMACION BASE DEL SISTEMA

INSERT INTO tab_roles (id_rol, nom_rol, descripcion) VALUES
(1, 'ADMIN',   'Admin persona con acceso total al sistema'),
(2, 'ABOGADO', 'Abogado acceso a herramientas por funcionales para el abogado'),
(3, 'CLIENTE', 'Cliente acceso a informacion filtrada del caso');

INSERT INTO tab_permisos (id_permiso, cod_permiso, nom_permiso, descripcion) VALUES
(1,  'CASOS_VER',            'Ver casos',                 'Permite listar y consultar casos'),
(2,  'CASOS_CREAR',          'Crear casos',               'Permite crear nuevos casos'),
(3,  'CASOS_EDITAR',         'Editar casos',              'Permite modificar datos del caso'),
(4,  'ACTUACIONES_VER',      'Ver actuaciones',           'Permite ver actuaciones de un caso'),
(5,  'ACTUACIONES_CREAR',    'Crear actuaciones',         'Permite registrar nuevas actuaciones'),
(6,  'TAREAS_VER',           'Ver tareas',                'Permite ver tareas propias o del caso'),
(7,  'TAREAS_CREAR',         'Crear tareas',              'Permite crear tareas y asignarlas'),
(8,  'FACTURAS_VER',         'Ver facturas',              'Permite consultar facturas'),
(9,  'FACTURAS_CREAR',       'Crear facturas',            'Permite generar facturas'),
(10, 'PAGOS_REGISTRAR',      'Registrar pagos',           'Permite registrar pagos de facturas'),
(11, 'ADMIN_USUARIOS',       'Administrar usuarios',      'Permite crear/activar usuarios y asignar roles'),
(12, 'ADMIN_PERMISOS',       'Administrar permisos',      'Permite asignar permisos a roles');

INSERT INTO tab_rol_permiso (id_rol, id_permiso) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12);
-- Rol 2 = ABOGADO
INSERT INTO tab_rol_permiso (id_rol, id_permiso) VALUES
(2,1),(2,2),(2,3),(2,4),(2,5),(2,6),(2,7),(2,8),(2,9),(2,10);
-- Rol 3 = CLIENTE (solo consulta)
INSERT INTO tab_rol_permiso (id_rol, id_permiso) VALUES
(3,1),(3,4),(3,6),(3,8);

-- PRIORIDADES
INSERT INTO tab_prioridades (id_prioridad, nom_prioridad, peso) VALUES
(1, 'BAJA',    20),
(2, 'MEDIA',   50),
(3, 'ALTA',    80),
(4, 'URGENTE', 100);
-- ESTADOS DE TAREA
INSERT INTO tab_estado_tarea (id_estado_tarea, nom_estado, es_final) VALUES
(1, 'PENDIENTE',    FALSE),
(2, 'EN_PROGRESO',  FALSE),
(3, 'CERRADA',      TRUE),
(4, 'CANCELADA',    TRUE);
-- ESTADOS DE CASO
INSERT INTO tab_estado_caso (id_estado_caso, nom_estado, es_final) VALUES
(1, 'ABIERTO',     FALSE),
(2, 'EN_TRAMITE',  FALSE),
(3, 'SUSPENDIDO',  FALSE),
(4, 'CERRADO',     TRUE);
-- ROL DE PARTE (partes del caso)
INSERT INTO tab_rol_parte (id_rol_parte, nom_rol_parte) VALUES
(1, 'DEMANDANTE'),
(2, 'DEMANDADO'),
(3, 'APODERADO'),
(4, 'TERCERO');
-- TIPOS DE ACTUACION
INSERT INTO tab_tipo_actuacion (id_tipo_actuacion, nom_tipo) VALUES
(1, 'AUTO'),
(2, 'SENTENCIA'),
(3, 'MEMORIAL'),
(4, 'NOTIFICACION'),
(5, 'AUDIENCIA');
-- TIPOS DE DOCUMENTO
INSERT INTO tab_tipo_documento (id_tipo_documento, nom_tipo) VALUES
(1, 'PODER'),
(2, 'DEMANDA'),
(3, 'CONTESTACION'),
(4, 'PRUEBA'),
(5, 'OTRO');
-- TIPOS DE TARIFA
INSERT INTO tab_tipo_tarifa (id_tipo_tarifa, nom_tipo) VALUES
(1, 'HORA'),
(2, 'FIJA'),
(3, 'ETAPA');
-- ESTADOS DE FACTURA
INSERT INTO tab_estado_factura (id_estado_factura, nom_estado, es_final) VALUES
(1, 'BORRADOR', FALSE),
(2, 'EMITIDA',  FALSE),
(3, 'PAGADA',   TRUE),
(4, 'ANULADA',  TRUE);
-- METODOS DE PAGO
INSERT INTO tab_metodo_pago (id_metodo_pago, nom_metodo) VALUES
(1, 'EFECTIVO'),
(2, 'TRANSFERENCIA'),
(3, 'TARJETA'),
(4, 'PSE'),
(5, 'OTRO');



-- =======================
-- MODELO ENTIDAD RELACIÓN (ER) - DESCRIPCIÓN RELACIONAL
-- =======================

/*
A continuación se presenta el modelo entidad relación correspondiente a las tablas principales del sistema.

ENTIDADES PRINCIPALES:
----------------------------

[tab_parametros]
    - id_empresa (PK)
    - nom_empresa
    - nom_replegal
    - anio_actual

[tab_dptos]
    - id_dpto (PK)
    - nom_dpto

[tab_ciudades]
    - id_ciudad (PK)
    - nom_ciudad
    - id_dpto (FK a tab_dptos)
    - val_zip, val_lati, val_long

[tab_roles]
    - id_rol (PK)
    - nom_rol
    - descripcion

[tab_permisos]
    - id_permiso (PK)
    - cod_permiso
    - nom_permiso
    - descripcion

[tab_rol_permiso]
    - id_rol (PK, FK a tab_roles)
    - id_permiso (PK, FK a tab_permisos)

[tab_prioridades]
    - id_prioridad (PK)
    - nom_prioridad
    - peso

[tab_estado_tarea]
    - id_estado_tarea (PK)
    - nom_estado
    - es_final

[tab_estado_caso]
    - id_estado_caso (PK)
    - nom_estado
    - es_final

[tab_personas]
    - id_persona (PK)
    - ind_tipodoc, nom_persona, apell_persona, 
    - id_ciudad (FK a tab_ciudades)
    - dir_persona, num_telcelu, mail_persona, ind_estado

[tab_usuarios]
    - id_usuario (PK, FK a tab_personas)
    - password_hash, fecha_crea, last_login

[tab_usuario_rol]
    - id_usuario (PK, FK a tab_usuarios)
    - id_rol     (PK, FK a tab_roles)

[tab_tipocasos]
    - id_tipocaso (PK)
    - nom_tipocaso, desc_tip_caso

[tab_juzgados]
    - id_juzgado (PK)
    - nom_juzgado, jurisdiccion, especialidad, nivel
    - id_ciudad (FK a tab_ciudades)
    - dir_juzgado

[tab_casos]
    - id_caso (PK)
    - radicado, id_juzgado (FK a tab_juzgados)
    - id_tipocaso (FK a tab_tipocasos)
    - id_ciudad (FK a tab_ciudades)
    - fech_apertura, fech_fin
    - id_estado_caso (FK a tab_estado_caso)
    - ind_estado

[tab_abogados_casos]
    - id_abogado (PK, FK a tab_usuarios)
    - id_caso    (PK, FK a tab_casos)

[tab_clientes_abogados]
    - id_abogado (PK, FK a tab_usuarios)
    - id_cliente (PK, FK a tab_usuarios)

[tab_casos_cliente]
    - id_cliente (PK, FK a tab_usuarios)
    - id_caso    (PK, FK a tab_casos)

[tab_rol_parte]
    - id_rol_parte (PK)
    - nom_rol_parte

[tab_caso_partes]
    - id_caso      (PK, FK a tab_casos)
    - id_persona   (PK, FK a tab_personas)
    - id_rol_parte (PK, FK a tab_rol_parte)

[tab_hist_estado_caso]
    - id_hist    (PK)
    - id_caso    (FK a tab_casos)
    - id_estado_caso (FK a tab_estado_caso)
    - fecha_evento, id_usuario (FK a tab_usuarios)
    - observacion

[tab_calendario]
    - fecha (PK)
    - ind_findesem
    - ind_festivo, nom_festivo
    - ind_habil

[tab_actividades]
    - id_actividad (PK)
    - nom_actividad, desc_acti
    - id_prioridad (FK a tab_prioridades)

[tab_fecha_activi]
    - fecha (PK, FK a tab_calendario)
    - id_actividad (PK, FK a tab_actividades)

[tab_act_abogado]
    - id_actividad (PK, FK a tab_actividades)
    - id_abogado   (PK, FK a tab_usuarios)
    - fech_progra  (PK, FK a tab_calendario)
    - id_estado_tarea (FK a tab_estado_tarea)

[tab_tareas]
    - id_tarea (PK)
    - id_caso (FK a tab_casos)
    - titulo
    - descripcion
    - id_responsable (FK a tab_usuarios)
    - id_prioridad (FK a tab_prioridades)
    - id_estado_tarea (FK a tab_estado_tarea)
    - fecha_crea, fecha_venc, fecha_cierre
    - created_by (FK a tab_usuarios)

[tab_tipo_actuacion]
    - id_tipo_actuacion (PK)
    - nom_tipo

[tab_actuaciones]
    - id_actuacion (PK)
    - id_caso (FK a tab_casos)
    - id_tipo_actuacion (FK a tab_tipo_actuacion)
    - fecha_actuacion
    - descripcion
    - fuente, created_by (FK a tab_usuarios)

[tab_audiencias]
    - id_audiencia (PK)
    - id_caso     (FK a tab_casos)
    - fecha_inicio, fecha_fin, lugar, descripcion
    - created_by (FK a tab_usuarios)

[tab_tipo_documento]
    - id_tipo_documento (PK)
    - nom_tipo

[tab_documentos]
    - id_documento (PK)
    - id_tipo_documento (FK a tab_tipo_documento)
    - nombre, mime_type, url_storage, sha256_hex
    - fecha_carga, cargado_por (FK a tab_usuarios)

[tab_documento_caso]
    - id_caso (PK, FK a tab_casos)
    - id_documento (PK, FK a tab_documentos)

[tab_documento_actuacion]
    - id_actuacion (PK, FK a tab_actuaciones)
    - id_documento (PK, FK a tab_documentos)

[tab_tipo_tarifa]
    - id_tipo_tarifa (PK)
    - nom_tipo

[tab_tarifas]
    - id_tarifa   (PK)
    - id_abogado (FK a tab_usuarios)
    - id_tipocaso (FK a tab_tipocasos)
    - id_tipo_tarifa (FK a tab_tipo_tarifa)
    - valor_unitario
    - moneda, vigente_desde, vigente_hasta
    - ind_activa

[tab_registro_tiempo]
    - id_tiempo (PK)
    - id_caso (FK a tab_casos)
    - id_abogado (FK a tab_usuarios)
    - fecha_inicio, minutos, descripcion
    - id_tarifa (FK a tab_tarifas)
    - creado_en

[tab_estado_factura]
    - id_estado_factura (PK)
    - nom_estado
    - es_final

[tab_facturas]
    - id_factura (PK)
    - id_caso (FK a tab_casos)
    - id_cliente (FK a tab_usuarios)
    - fecha_emision, fecha_venc
    - id_estado_factura (FK a tab_estado_factura)
    - moneda, subtotal, impuestos, total, observacion, creada_en

[tab_factura_detalle]
    - id_factura_det (PK)
    - id_factura (FK a tab_facturas)
    - concepto, cantidad, valor_unitario, total_linea
    - id_tiempo (FK a tab_registro_tiempo)

[tab_metodo_pago]
    - id_metodo_pago (PK)
    - nom_metodo

[tab_pagos]
    - id_pago (PK)
    - id_factura (FK a tab_facturas)
    - fecha_pago, valor_pago
    - id_metodo_pago (FK a tab_metodo_pago)
    - referencia, observacion, creado_en

-------------------------
RELACIONES (principalmente de cardinalidad N-1 y N-N):

- Una ciudad pertenece a un departamento.
- Una persona está asociada a una ciudad y puede ser usuario del sistema.
- Un usuario puede tener uno o varios roles (N:N tab_usuario_rol).
- Un rol posee múltiples permisos (N:N tab_rol_permiso).
- Un caso se relaciona con juzgado, tipo de caso, ciudad y estado.
- Un caso puede tener varios abogados, clientes y partes (N:N por las tablas tab_abogados_casos, tab_clientes_abogados, tab_casos_cliente, tab_caso_partes).
- Se registran actividades, actuaciones, audiencias, tareas y documentos de los casos, cada uno relacionado a las entidades principales.
- Las tarifas se pueden asociar a abogados, tipos de caso y clasificaciones.
- Las facturas se asocian a los casos, clientes, y estado de las facturas, y se detallan en la tabla detalle (con posible relación a tiempos registrados).
- Los pagos de facturas vinculan método de pago.
*/
