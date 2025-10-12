ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

// Se necesita crear a este usuario para poder utilizar los kpi
CREATE USER gym_user IDENTIFIED BY gym1234567
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;
-- Asignar roles básicos
GRANT CONNECT, RESOURCE TO gym_user;
-- Asignar cuota de espacio
ALTER USER gym_user QUOTA UNLIMITED ON USERS;

-- Eliminar usuario
//DROP USER gym_user CASCADE;
-- ========================
-- ELIMINAR TABLAS SI EXISTEN
-- ========================
DROP TABLE RUTINA_EJERCICIO CASCADE CONSTRAINTS;
DROP TABLE SOCIO_RUTINA CASCADE CONSTRAINTS;
DROP TABLE EJERCICIO CASCADE CONSTRAINTS;
DROP TABLE RUTINA CASCADE CONSTRAINTS;
DROP TABLE ASISTENCIA CASCADE CONSTRAINTS;
DROP TABLE PAGO CASCADE CONSTRAINTS;
DROP TABLE SOCIO_SUCURSAL CASCADE CONSTRAINTS;
DROP TABLE SOCIO_PLAN CASCADE CONSTRAINTS;
DROP TABLE SOCIO CASCADE CONSTRAINTS;
DROP TABLE PLAN CASCADE CONSTRAINTS;
DROP TABLE ENTRENADOR CASCADE CONSTRAINTS;
DROP TABLE MANTENCION CASCADE CONSTRAINTS;
DROP TABLE MAQUINA CASCADE CONSTRAINTS;
DROP TABLE SUCURSAL CASCADE CONSTRAINTS;

-- ========================
-- CREACIÓN DE TABLAS
-- ========================

CREATE TABLE SUCURSAL (
    id_sucursal      NUMBER PRIMARY KEY,
    nombre_sucursal  VARCHAR2(100) NOT NULL,
    direccion        VARCHAR2(150) NOT NULL,
    telefono         VARCHAR2(20),
    correo           VARCHAR2(100),
    capacidad        NUMBER
);

CREATE TABLE MAQUINA (
    id_maquina        NUMBER PRIMARY KEY,
    nombre_maquina    VARCHAR2(100) NOT NULL,
    descripcion       VARCHAR2(200),
    estado            VARCHAR2(50) NOT NULL,
    fecha_adquisicion DATE,
    id_sucursal       NUMBER NOT NULL,
    CONSTRAINT fk_maquina_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal)
);

CREATE TABLE MANTENCION (
    id_mantencion   NUMBER PRIMARY KEY,
    fecha_mantencion DATE,
    tipo_mantencion  VARCHAR2(100),
    descripcion      VARCHAR2(200),
    id_maquina       NUMBER NOT NULL,
    CONSTRAINT fk_mantencion_maquina FOREIGN KEY (id_maquina)
        REFERENCES MAQUINA(id_maquina)
);

CREATE TABLE ENTRENADOR (
    id_entrenador NUMBER PRIMARY KEY,
    nombre        VARCHAR2(100) NOT NULL,
    apellido      VARCHAR2(100) NOT NULL,
    especialidad  VARCHAR2(100),
    telefono      VARCHAR2(20),
    correo        VARCHAR2(100),
    id_sucursal   NUMBER NOT NULL,
    CONSTRAINT fk_entrenador_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal)
);

CREATE TABLE PLAN (
    id_plan        NUMBER PRIMARY KEY,
    nombre_plan    VARCHAR2(100) NOT NULL,
    descripcion    VARCHAR2(200),
    duracion_meses NUMBER,
    precio_mensual NUMBER NOT NULL
);

CREATE TABLE SOCIO (
    id_socio         NUMBER PRIMARY KEY,
    rut              VARCHAR2(15) NOT NULL UNIQUE,
    nombre           VARCHAR2(100) NOT NULL,
    apellido         VARCHAR2(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    telefono         VARCHAR2(20),
    correo           VARCHAR2(100),
    fecha_inscripcion DATE,
    estado           VARCHAR2(50) NOT NULL
);

CREATE TABLE SOCIO_PLAN (
    id_socio_plan NUMBER PRIMARY KEY,
    fecha_inicio  DATE NOT NULL,
    fecha_fin     DATE NOT NULL,
    estado        VARCHAR2(50) NOT NULL,
    id_socio      NUMBER NOT NULL,
    id_plan       NUMBER NOT NULL,
    CONSTRAINT fk_socioplan_socio FOREIGN KEY (id_socio)
        REFERENCES SOCIO(id_socio),
    CONSTRAINT fk_socioplan_plan FOREIGN KEY (id_plan)
        REFERENCES PLAN(id_plan)
);

CREATE TABLE SOCIO_SUCURSAL (
    id_socio_sucursal NUMBER PRIMARY KEY,
    tipo_acceso       VARCHAR2(50),
    id_socio          NUMBER NOT NULL,
    id_sucursal       NUMBER NOT NULL,
    CONSTRAINT fk_sociosucursal_socio FOREIGN KEY (id_socio)
        REFERENCES SOCIO(id_socio),
    CONSTRAINT fk_sociosucursal_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES SUCURSAL(id_sucursal)
);

CREATE TABLE PAGO (
    id_pago      NUMBER PRIMARY KEY,
    fecha_pago   DATE,
    monto        NUMBER,
    metodo_pago  VARCHAR2(50),
    estado       VARCHAR2(50),
    id_socio_plan NUMBER NOT NULL,
    CONSTRAINT fk_pago_socioplan FOREIGN KEY (id_socio_plan)
        REFERENCES SOCIO_PLAN(id_socio_plan)
);

CREATE TABLE ASISTENCIA (
    id_asistencia NUMBER PRIMARY KEY,
    fecha         DATE,
    hora_entrada  DATE,
    hora_salida   DATE,
    id_socio      NUMBER NOT NULL,
    CONSTRAINT fk_asistencia_socio FOREIGN KEY (id_socio)
        REFERENCES SOCIO(id_socio)
);

CREATE TABLE RUTINA (
    id_rutina     NUMBER PRIMARY KEY,
    nombre_rutina VARCHAR2(100) NOT NULL,
    descripcion   VARCHAR2(200),
    nivel         VARCHAR2(50),
    id_entrenador NUMBER NOT NULL,
    CONSTRAINT fk_rutina_entrenador FOREIGN KEY (id_entrenador)
        REFERENCES ENTRENADOR(id_entrenador)
);

CREATE TABLE SOCIO_RUTINA (
    id_socio_rutina NUMBER PRIMARY KEY,
    fecha_asignacion DATE,
    estado           VARCHAR2(50),
    id_socio         NUMBER NOT NULL,
    id_rutina        NUMBER NOT NULL,
    CONSTRAINT fk_sociorutina_socio FOREIGN KEY (id_socio)
        REFERENCES SOCIO(id_socio),
    CONSTRAINT fk_sociorutina_rutina FOREIGN KEY (id_rutina)
        REFERENCES RUTINA(id_rutina)
);

CREATE TABLE EJERCICIO (
    id_ejercicio    NUMBER PRIMARY KEY,
    nombre_ejercicio VARCHAR2(100) NOT NULL,
    grupo_muscular   VARCHAR2(100) NOT NULL,
    descripcion      VARCHAR2(200)
);

CREATE TABLE RUTINA_EJERCICIO (
    id_rutina     NUMBER NOT NULL,
    id_ejercicio  NUMBER NOT NULL,
    repeticiones  NUMBER,
    series        NUMBER,
    tiempo_descanso NUMBER,
    CONSTRAINT pk_rutinaejercicio PRIMARY KEY (id_rutina, id_ejercicio),
    CONSTRAINT fk_rutinaejercicio_rutina FOREIGN KEY (id_rutina)
        REFERENCES RUTINA(id_rutina),
    CONSTRAINT fk_rutinaejercicio_ejercicio FOREIGN KEY (id_ejercicio)
        REFERENCES EJERCICIO(id_ejercicio)
);
-- ========================
-- 100 INSERTS PARA TODAS LAS TABLAS EN ORACLE SQL
-- Todos los atributos, uno por uno (no múltiple VALUES)
-- ========================

-- SUCURSAL (5)
INSERT INTO SUCURSAL (id_sucursal, nombre_sucursal, direccion, telefono, correo, capacidad) VALUES (1, 'Sucursal Central', 'Av. Principal 123', '22223333', 'central@gym.com', 150);
INSERT INTO SUCURSAL (id_sucursal, nombre_sucursal, direccion, telefono, correo, capacidad) VALUES (2, 'Sucursal Norte', 'Calle Norte 456', '22224444', 'norte@gym.com', 100);
INSERT INTO SUCURSAL (id_sucursal, nombre_sucursal, direccion, telefono, correo, capacidad) VALUES (3, 'Sucursal Sur', 'Av. Sur 789', '22225555', 'sur@gym.com', 120);
INSERT INTO SUCURSAL (id_sucursal, nombre_sucursal, direccion, telefono, correo, capacidad) VALUES (4, 'Sucursal Oriente', 'Calle Oriente 101', '22226666', 'oriente@gym.com', 80);
INSERT INTO SUCURSAL (id_sucursal, nombre_sucursal, direccion, telefono, correo, capacidad) VALUES (5, 'Sucursal Poniente', 'Av. Poniente 202', '22227777', 'poniente@gym.com', 90);

-- MAQUINA (15)
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (1, 'Cinta de correr', 'Cinta de alta resistencia', 'Disponible', TO_DATE('2022-01-10','YYYY-MM-DD'), 1);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (2, 'Bicicleta fija', 'Bicicleta estática', 'Mantenimiento', TO_DATE('2021-05-22','YYYY-MM-DD'), 1);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (3, 'Máquina de pesas', 'Conjunto de pesas variadas', 'Disponible', TO_DATE('2023-03-15','YYYY-MM-DD'), 2);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (4, 'Elíptica', 'Máquina elíptica con monitor', 'Disponible', TO_DATE('2022-11-05','YYYY-MM-DD'), 2);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (5, 'Remo', 'Máquina de remo', 'Mantenimiento', TO_DATE('2021-09-12','YYYY-MM-DD'), 3);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (6, 'Prensa de piernas', 'Prensa con peso ajustable', 'Disponible', TO_DATE('2023-01-08','YYYY-MM-DD'), 3);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (7, 'Banco de pesas', 'Banco ajustable', 'Disponible', TO_DATE('2022-02-20','YYYY-MM-DD'), 4);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (8, 'Stepper', 'Máquina cardiovascular', 'Disponible', TO_DATE('2023-06-11','YYYY-MM-DD'), 4);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (9, 'Polea alta', 'Máquina para espalda y bíceps', 'Mantenimiento', TO_DATE('2022-09-30','YYYY-MM-DD'), 5);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (10, 'Banco plano', 'Banco para press de pecho', 'Disponible', TO_DATE('2023-03-25','YYYY-MM-DD'), 5);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (11, 'Escaladora vertical', 'Máquina para entrenamiento de piernas y glúteos', 'Disponible', TO_DATE('2023-07-14','YYYY-MM-DD'), 1);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (12, 'Máquina de abdominales', 'Equipo para fortalecimiento del core', 'Disponible', TO_DATE('2022-12-01','YYYY-MM-DD'), 2);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (13, 'Máquina de extensión de piernas', 'Equipo de aislamiento para cuádriceps', 'Mantenimiento', TO_DATE('2021-08-17','YYYY-MM-DD'), 3);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (14, 'Máquina de pecho', 'Equipo de empuje para pectorales y tríceps', 'Disponible', TO_DATE('2023-04-22','YYYY-MM-DD'), 4);
INSERT INTO MAQUINA (id_maquina, nombre_maquina, descripcion, estado, fecha_adquisicion, id_sucursal) VALUES (15, 'Máquina de dorsales', 'Máquina para trabajar la espalda y los hombros', 'Disponible', TO_DATE('2022-10-09','YYYY-MM-DD'), 5);




-- MANTENCION (40)
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (1, TO_DATE('2024-08-01','YYYY-MM-DD'), 'Preventiva', 'Cambio de rodillos y engranajes', 1);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (2, TO_DATE('2024-07-20','YYYY-MM-DD'), 'Correctiva', 'Reparación del panel de control', 2);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (3, TO_DATE('2024-06-15','YYYY-MM-DD'), 'Preventiva', 'Lubricación general', 3);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (4, TO_DATE('2024-05-10','YYYY-MM-DD'), 'Correctiva', 'Cambio de monitor', 4);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (5, TO_DATE('2024-04-12','YYYY-MM-DD'), 'Preventiva', 'Revisión de resistencia', 5);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (6, TO_DATE('2024-03-05','YYYY-MM-DD'), 'Preventiva', 'Inspección general', 6);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (7, TO_DATE('2024-02-10','YYYY-MM-DD'), 'Correctiva', 'Reparación de engranajes', 7);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (8, TO_DATE('2024-01-15','YYYY-MM-DD'), 'Preventiva', 'Lubricación de cadena', 8);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (9, TO_DATE('2024-03-20','YYYY-MM-DD'), 'Correctiva', 'Cambio de rodillos', 9);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (10, TO_DATE('2024-04-25','YYYY-MM-DD'), 'Preventiva', 'Revisión de pesos', 10);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (11, TO_DATE('2024-09-10','YYYY-MM-DD'), 'Correctiva', 'Reemplazo de cableado interno', 1);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (12, TO_DATE('2024-10-02','YYYY-MM-DD'), 'Preventiva', 'Limpieza de rodillos', 2);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (13, TO_DATE('2024-08-22','YYYY-MM-DD'), 'Preventiva', 'Verificación de peso máximo', 3);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (14, TO_DATE('2024-07-12','YYYY-MM-DD'), 'Correctiva', 'Reparación del sistema eléctrico', 4);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (15, TO_DATE('2024-09-03','YYYY-MM-DD'), 'Preventiva', 'Revisión de poleas', 5);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (16, TO_DATE('2024-10-18','YYYY-MM-DD'), 'Correctiva', 'Cambio de pantalla LCD', 6);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (17, TO_DATE('2024-08-28','YYYY-MM-DD'), 'Preventiva', 'Ajuste de pernos', 7);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (18, TO_DATE('2024-09-14','YYYY-MM-DD'), 'Correctiva', 'Reparación del motor principal', 8);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (19, TO_DATE('2024-11-01','YYYY-MM-DD'), 'Preventiva', 'Cambio de aceite en engranajes', 9);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (20, TO_DATE('2024-12-05','YYYY-MM-DD'), 'Correctiva', 'Sustitución de resortes', 10);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (21, TO_DATE('2024-12-20','YYYY-MM-DD'), 'Preventiva', 'Limpieza de sensores de movimiento', 11);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (22, TO_DATE('2024-11-28','YYYY-MM-DD'), 'Correctiva', 'Reemplazo de correas elásticas', 12);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (23, TO_DATE('2025-01-10','YYYY-MM-DD'), 'Preventiva', 'Lubricación de rodillos laterales', 13);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (24, TO_DATE('2025-02-04','YYYY-MM-DD'), 'Correctiva', 'Reparación de estructura metálica', 14);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (25, TO_DATE('2025-03-12','YYYY-MM-DD'), 'Preventiva', 'Revisión de cables y poleas', 15);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (26, TO_DATE('2025-04-08','YYYY-MM-DD'), 'Correctiva', 'Cambio de motor de tracción', 1);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (27, TO_DATE('2025-05-15','YYYY-MM-DD'), 'Preventiva', 'Ajuste de pedales', 2);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (28, TO_DATE('2025-06-10','YYYY-MM-DD'), 'Correctiva', 'Reparación de sistema de pesas', 3);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (29, TO_DATE('2025-07-05','YYYY-MM-DD'), 'Preventiva', 'Cambio de rodamientos', 4);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (30, TO_DATE('2025-08-02','YYYY-MM-DD'), 'Correctiva', 'Sustitución de pantalla táctil', 5);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (31, TO_DATE('2025-08-18','YYYY-MM-DD'), 'Preventiva', 'Limpieza profunda de sistema hidráulico', 6);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (32, TO_DATE('2025-09-12','YYYY-MM-DD'), 'Correctiva', 'Reparación de estructura de soporte', 7);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (33, TO_DATE('2025-09-25','YYYY-MM-DD'), 'Preventiva', 'Revisión y ajuste de tornillos', 8);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (34, TO_DATE('2025-10-06','YYYY-MM-DD'), 'Correctiva', 'Cambio de poleas desgastadas', 9);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (35, TO_DATE('2025-10-22','YYYY-MM-DD'), 'Preventiva', 'Lubricación general y limpieza', 10);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (36, TO_DATE('2025-09-08','YYYY-MM-DD'), 'Preventiva', 'Revisión de mecanismos de resistencia', 11);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (37, TO_DATE('2025-07-28','YYYY-MM-DD'), 'Correctiva', 'Sustitución de piezas plásticas rotas', 12);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (38, TO_DATE('2025-05-19','YYYY-MM-DD'), 'Preventiva', 'Calibración del sistema de pesas', 13);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (39, TO_DATE('2025-03-22','YYYY-MM-DD'), 'Correctiva', 'Reparación del pistón hidráulico', 14);
INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina) VALUES (40, TO_DATE('2025-02-10','YYYY-MM-DD'), 'Preventiva', 'Revisión de seguridad general', 15);





-- ENTRENADOR (25)
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (1, 'Juan', 'Pérez', 'Musculación', '5551111', 'juan.perez@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (2, 'María', 'González', 'Cardio', '5552222', 'maria.gonzalez@gym.com', 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (3, 'Carlos', 'Ramírez', 'Crossfit', '5553333', 'carlos.ramirez@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (4, 'Lucía', 'Vega', 'Yoga', NULL, NULL, 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (5, 'Diego', 'Soto', 'Pilates', '5554444', 'diego.soto@gym.com', 5);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (6, 'Fernanda', 'Muñoz', 'Zumba', '5555555', 'fernanda.munoz@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (7, 'Ricardo', 'Herrera', 'Spinning', '5556666', 'ricardo.herrera@gym.com', 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (8, 'Camila', 'Araya', 'Entrenamiento Funcional', '5557777', 'camila.araya@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (9, 'Javier', 'López', 'Boxeo', '5558888', 'javier.lopez@gym.com', 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (10, 'Patricia', 'Rojas', 'Stretching', NULL, 'patricia.rojas@gym.com', 5);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (11, 'Matías', 'Silva', 'Musculación', '5559999', 'matias.silva@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (12, 'Valentina', 'Cortés', 'Cardio Dance', '5551010', 'valentina.cortes@gym.com', 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (13, 'Andrés', 'Fuentes', 'Crossfit', '5551212', 'andres.fuentes@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (14, 'Paula', 'Reyes', 'Yoga', '5551313', NULL, 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (15, 'Cristian', 'Torres', 'Pilates', '5551414', 'cristian.torres@gym.com', 5);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (16, 'Alejandra', 'Campos', 'Aeróbica', '5551515', 'alejandra.campos@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (17, 'Sergio', 'Navarro', 'Spinning', '5551616', 'sergio.navarro@gym.com', 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (18, 'Daniela', 'Pizarro', 'Body Combat', NULL, 'daniela.pizarro@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (19, 'Francisco', 'Mora', 'Powerlifting', '5551717', 'francisco.mora@gym.com', 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (20, 'Tamara', 'Leiva', 'Entrenamiento Funcional', '5551818', 'tamara.leiva@gym.com', 5);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (21, 'Eduardo', 'Carvajal', 'Musculación', '5551919', 'eduardo.carvajal@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (22, 'Gabriela', 'Sandoval', 'Pilates', '5552020', NULL, 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (23, 'Rodrigo', 'Vidal', 'Crossfit', '5552121', 'rodrigo.vidal@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (24, 'Natalia', 'Contreras', 'Zumba', '5552223', 'natalia.contreras@gym.com', 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (25, 'Felipe', 'Castro', 'Cardio', '5552323', 'felipe.castro@gym.com', 5);


-- PLAN (5)
INSERT INTO PLAN (id_plan, nombre_plan, descripcion, duracion_meses, precio_mensual) VALUES (1, 'Plan Básico', 'Acceso a máquinas', 1, 20000);
INSERT INTO PLAN (id_plan, nombre_plan, descripcion, duracion_meses, precio_mensual) VALUES (2, 'Plan Premium', 'Máquinas y clases grupales', 6, 45000);
INSERT INTO PLAN (id_plan, nombre_plan, descripcion, duracion_meses, precio_mensual) VALUES (3, 'Plan Elite', 'Todo incluido + entrenador personal', 12, 90000);
INSERT INTO PLAN (id_plan, nombre_plan, descripcion, duracion_meses, precio_mensual) VALUES (4, 'Plan Yoga', 'Clases de yoga y pilates', 3, 30000);
INSERT INTO PLAN (id_plan, nombre_plan, descripcion, duracion_meses, precio_mensual) VALUES (5, 'Plan Cardio', 'Clases de cardio intensivo', 3, 35000);






-- SOCIO (15)
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (1, '11111111-1', 'Pedro', 'Gómez', TO_DATE('1990-05-12','YYYY-MM-DD'), '5551010', 'pedro.gomez@mail.com', TO_DATE('2024-01-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (2, '22222222-2', 'Ana', 'Martínez', TO_DATE('1985-07-22','YYYY-MM-DD'), '5552020', 'ana.martinez@mail.com', TO_DATE('2024-02-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (3, '33333333-3', 'Luis', 'Pérez', TO_DATE('1992-03-15','YYYY-MM-DD'), '5553030', 'luis.perez@mail.com', TO_DATE('2024-03-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (4, '44444444-4', 'Carla', 'Santos', TO_DATE('1995-12-05','YYYY-MM-DD'), '5554040', 'carla.santos@mail.com', TO_DATE('2024-04-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (5, '55555555-5', 'Diego', 'Rojas', TO_DATE('1988-11-11','YYYY-MM-DD'), '5555050', 'diego.rojas@mail.com', TO_DATE('2024-05-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (6, '66666666-6', 'Sofía', 'Vargas', TO_DATE('1993-02-25','YYYY-MM-DD'), '5556060', 'sofia.vargas@mail.com', TO_DATE('2024-06-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (7, '77777777-7', 'Andrés', 'Torres', TO_DATE('1991-08-18','YYYY-MM-DD'), '5557070', 'andres.torres@mail.com', TO_DATE('2024-07-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (8, '88888888-8', 'Valentina', 'Castro', TO_DATE('1994-09-30','YYYY-MM-DD'), '5558080', 'valentina.castro@mail.com', TO_DATE('2024-08-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (9, '99999999-9', 'Fernando', 'Morales', TO_DATE('1987-10-10','YYYY-MM-DD'), '5559090', 'fernando.morales@mail.com', TO_DATE('2024-09-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (10, '10101010-1', 'Paula', 'Ríos', TO_DATE('1990-01-20','YYYY-MM-DD'), '5551011', 'paula.rios@mail.com', TO_DATE('2024-10-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (11, '11111112-2', 'Javier', 'Silva', TO_DATE('1992-04-14','YYYY-MM-DD'), '5551112', 'javier.silva@mail.com', TO_DATE('2024-11-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (12, '12121212-3', 'Camila', 'Ortiz', TO_DATE('1993-06-06','YYYY-MM-DD'), '5551212', 'camila.ortiz@mail.com', TO_DATE('2024-12-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (13, '13131313-4', 'Ricardo', 'Fuentes', TO_DATE('1989-07-19','YYYY-MM-DD'), '5551313', 'ricardo.fuentes@mail.com', TO_DATE('2024-01-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (14, '14141414-5', 'Natalia', 'Mena', TO_DATE('1991-08-23','YYYY-MM-DD'), '5551414', 'natalia.mena@mail.com', TO_DATE('2024-02-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (15, '15151515-6', 'Santiago', 'Leiva', TO_DATE('1986-12-02','YYYY-MM-DD'), '5551515', 'santiago.leiva@mail.com', TO_DATE('2024-03-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (16, '16161616-7', 'Marcela', 'Jiménez', TO_DATE('1990-09-12','YYYY-MM-DD'), '5551616', 'marcela.jimenez@mail.com', TO_DATE('2024-04-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (17, '17171717-8', 'Héctor', 'Campos', TO_DATE('1987-02-17','YYYY-MM-DD'), '5551717', 'hector.campos@mail.com', TO_DATE('2024-04-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (18, '18181818-9', 'Daniela', 'Herrera', TO_DATE('1995-11-21','YYYY-MM-DD'), '5551818', 'daniela.herrera@mail.com', TO_DATE('2024-05-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (19, '19191919-0', 'Felipe', 'Carrasco', TO_DATE('1989-03-28','YYYY-MM-DD'), '5551919', 'felipe.carrasco@mail.com', TO_DATE('2024-05-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (20, '20202020-1', 'Romina', 'Saavedra', TO_DATE('1994-10-05','YYYY-MM-DD'), '5552021', 'romina.saavedra@mail.com', TO_DATE('2024-05-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (21, '21212121-2', 'Claudio', 'Reyes', TO_DATE('1992-06-14','YYYY-MM-DD'), '5552121', 'claudio.reyes@mail.com', TO_DATE('2024-06-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (22, '22222223-3', 'Tamara', 'Figueroa', TO_DATE('1990-01-25','YYYY-MM-DD'), '5552223', 'tamara.figueroa@mail.com', TO_DATE('2024-06-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (23, '23232323-4', 'Cristian', 'Salazar', TO_DATE('1988-09-11','YYYY-MM-DD'), '5552323', 'cristian.salazar@mail.com', TO_DATE('2024-07-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (24, '24242424-5', 'Antonia', 'Paredes', TO_DATE('1996-12-07','YYYY-MM-DD'), '5552424', 'antonia.paredes@mail.com', TO_DATE('2024-07-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (25, '25252525-6', 'Sebastián', 'Navarro', TO_DATE('1985-05-30','YYYY-MM-DD'), '5552525', 'sebastian.navarro@mail.com', TO_DATE('2024-08-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (26, '26262626-7', 'Isidora', 'Romero', TO_DATE('1993-04-18','YYYY-MM-DD'), '5552626', 'isidora.romero@mail.com', TO_DATE('2024-08-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (27, '27272727-8', 'Matías', 'Maldonado', TO_DATE('1991-03-12','YYYY-MM-DD'), '5552727', 'matias.maldonado@mail.com', TO_DATE('2024-08-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (28, '28282828-9', 'Constanza', 'Gallardo', TO_DATE('1997-02-09','YYYY-MM-DD'), '5552828', 'constanza.gallardo@mail.com', TO_DATE('2024-09-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (29, '29292929-0', 'Tomás', 'Araya', TO_DATE('1989-06-22','YYYY-MM-DD'), '5552929', 'tomas.araya@mail.com', TO_DATE('2024-09-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (30, '30303030-1', 'Pamela', 'Cáceres', TO_DATE('1994-01-19','YYYY-MM-DD'), '5553030', 'pamela.caceres@mail.com', TO_DATE('2024-09-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (31, '31313131-2', 'Mauricio', 'Garrido', TO_DATE('1988-08-05','YYYY-MM-DD'), '5553131', 'mauricio.garrido@mail.com', TO_DATE('2024-09-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (32, '32323232-3', 'Carolina', 'Ibáñez', TO_DATE('1992-02-02','YYYY-MM-DD'), '5553232', 'carolina.ibanez@mail.com', TO_DATE('2024-09-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (33, '33333334-4', 'Rodrigo', 'Muñoz', TO_DATE('1986-07-11','YYYY-MM-DD'), '5553334', 'rodrigo.munoz@mail.com', TO_DATE('2024-10-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (34, '34343434-5', 'Francisca', 'León', TO_DATE('1995-10-27','YYYY-MM-DD'), '5553434', 'francisca.leon@mail.com', TO_DATE('2024-10-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (35, '35353535-6', 'Esteban', 'Rivas', TO_DATE('1987-11-13','YYYY-MM-DD'), '5553535', 'esteban.rivas@mail.com', TO_DATE('2024-10-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (36, '36363636-7', 'Beatriz', 'Cordero', TO_DATE('1991-04-08','YYYY-MM-DD'), '5553636', 'beatriz.cordero@mail.com', TO_DATE('2024-10-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (37, '37373737-8', 'Gabriel', 'Fierro', TO_DATE('1989-09-09','YYYY-MM-DD'), '5553737', 'gabriel.fierro@mail.com', TO_DATE('2024-10-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (38, '38383838-9', 'Josefa', 'Vergara', TO_DATE('1996-03-30','YYYY-MM-DD'), '5553838', 'josefa.vergara@mail.com', TO_DATE('2024-10-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (39, '39393939-0', 'Ignacio', 'Vidal', TO_DATE('1990-12-16','YYYY-MM-DD'), '5553939', 'ignacio.vidal@mail.com', TO_DATE('2024-10-30','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (40, '40404040-1', 'Lorena', 'Riquelme', TO_DATE('1985-05-02','YYYY-MM-DD'), '5554040', 'lorena.riquelme@mail.com', TO_DATE('2024-11-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (41, '41414141-2', 'Pablo', 'Escobar', TO_DATE('1992-07-19','YYYY-MM-DD'), '5554141', 'pablo.escobar@mail.com', TO_DATE('2024-11-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (42, '42424242-3', 'Andrea', 'Rojas', TO_DATE('1993-01-10','YYYY-MM-DD'), '5554242', 'andrea.rojas@mail.com', TO_DATE('2024-11-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (43, '43434343-4', 'Simón', 'Correa', TO_DATE('1988-04-26','YYYY-MM-DD'), '5554343', 'simon.correa@mail.com', TO_DATE('2024-11-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (44, '44444445-5', 'Renata', 'Peña', TO_DATE('1996-11-07','YYYY-MM-DD'), '5554445', 'renata.pena@mail.com', TO_DATE('2024-11-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (45, '45454545-6', 'Maximiliano', 'Mora', TO_DATE('1990-08-22','YYYY-MM-DD'), '5554545', 'maximiliano.mora@mail.com', TO_DATE('2024-11-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (46, '46464646-7', 'Bárbara', 'Tapia', TO_DATE('1989-02-11','YYYY-MM-DD'), '5554646', 'barbara.tapia@mail.com', TO_DATE('2024-12-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (47, '47474747-8', 'Joaquín', 'López', TO_DATE('1994-06-25','YYYY-MM-DD'), '5554747', 'joaquin.lopez@mail.com', TO_DATE('2024-12-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (48, '48484848-9', 'Cecilia', 'Rivas', TO_DATE('1992-09-09','YYYY-MM-DD'), '5554848', 'cecilia.rivas@mail.com', TO_DATE('2024-12-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (49, '49494949-0', 'Alejandro', 'Ortega', TO_DATE('1987-10-29','YYYY-MM-DD'), '5554949', 'alejandro.ortega@mail.com', TO_DATE('2024-12-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (50, '50505050-1', 'Carla', 'Acuña', TO_DATE('1995-01-02','YYYY-MM-DD'), '5555051', 'carla.acuna@mail.com', TO_DATE('2024-12-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (51, '51515151-2', 'Matilde', 'Rebolledo', TO_DATE('1993-02-14','YYYY-MM-DD'), '5555151', 'matilde.rebolledo@mail.com', TO_DATE('2024-12-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (52, '52525252-3', 'José', 'Contreras', TO_DATE('1991-03-18','YYYY-MM-DD'), '5555252', 'jose.contreras@mail.com', TO_DATE('2025-01-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (53, '53535353-4', 'Ignacia', 'Bustamante', TO_DATE('1997-09-15','YYYY-MM-DD'), '5555353', 'ignacia.bustamante@mail.com', TO_DATE('2025-01-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (54, '54545454-5', 'Vicente', 'Espinoza', TO_DATE('1988-06-23','YYYY-MM-DD'), '5555454', 'vicente.espinoza@mail.com', TO_DATE('2025-01-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (55, '55555556-6', 'Emilia', 'Gómez', TO_DATE('1994-04-04','YYYY-MM-DD'), '5555556', 'emilia.gomez@mail.com', TO_DATE('2025-01-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (56, '56565656-7', 'Benjamín', 'Sepúlveda', TO_DATE('1989-07-08','YYYY-MM-DD'), '5555656', 'benjamin.sepulveda@mail.com', TO_DATE('2025-01-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (57, '57575757-8', 'Florencia', 'Troncoso', TO_DATE('1993-12-19','YYYY-MM-DD'), '5555757', 'florencia.troncoso@mail.com', TO_DATE('2025-01-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO (id_socio, rut, nombre, apellido, fecha_nacimiento, telefono, correo, fecha_inscripcion, estado) VALUES (58, '58585858-9', 'Cristóbal', 'Pino', TO_DATE('1990-09-14','YYYY-MM-DD'), '5555858', 'cristobal.pino@mail.com', TO_DATE('2025-02-01','YYYY-MM--DD'), 'Activo');


-- SOCIO (200)
INSERT INTO SOCIO VALUES (59, '59595959-1', 'Matías', 'Torres', TO_DATE('1998-03-12','YYYY-MM-DD'), '5555959', 'matias.torres@mail.com', TO_DATE('2025-02-03','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (60, '60606060-2', 'Valentina', 'Rojas', TO_DATE('1995-07-19','YYYY-MM-DD'), '5556060', 'valentina.rojas@mail.com', TO_DATE('2025-02-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (61, '61616161-3', 'Felipe', 'Navarro', TO_DATE('1992-05-11','YYYY-MM-DD'), '5556161', 'felipe.navarro@mail.com', TO_DATE('2025-02-07','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (62, '62626262-4', 'Camila', 'López', TO_DATE('1999-01-22','YYYY-MM-DD'), '5556262', 'camila.lopez@mail.com', TO_DATE('2025-02-08','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (63, '63636363-5', 'Ignacio', 'Fuentes', TO_DATE('1991-06-30','YYYY-MM-DD'), '5556363', 'ignacio.fuentes@mail.com', TO_DATE('2025-02-09','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (64, '64646464-6', 'Francisca', 'Cáceres', TO_DATE('1994-11-17','YYYY-MM-DD'), '5556464', 'francisca.caceres@mail.com', TO_DATE('2025-02-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (65, '65656565-7', 'Tomás', 'Muñoz', TO_DATE('2000-04-04','YYYY-MM-DD'), '5556565', 'tomas.munoz@mail.com', TO_DATE('2025-02-12','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (66, '66666666-8', 'Fernanda', 'Vargas', TO_DATE('1997-09-09','YYYY-MM-DD'), '5556666', 'fernanda.vargas@mail.com', TO_DATE('2025-02-13','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (67, '67676767-9', 'Javier', 'Herrera', TO_DATE('1993-12-24','YYYY-MM-DD'), '5556767', 'javier.herrera@mail.com', TO_DATE('2025-02-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (68, '68686868-0', 'Antonia', 'Reyes', TO_DATE('1996-08-02','YYYY-MM-DD'), '5556868', 'antonia.reyes@mail.com', TO_DATE('2025-02-17','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (69, '69696969-1', 'Sebastián', 'Morales', TO_DATE('1990-10-28','YYYY-MM-DD'), '5556969', 'sebastian.morales@mail.com', TO_DATE('2025-02-18','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (70, '70707070-2', 'Isidora', 'Pérez', TO_DATE('1998-02-15','YYYY-MM-DD'), '5557070', 'isidora.perez@mail.com', TO_DATE('2025-02-19','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (71, '71717171-3', 'Lucas', 'Jiménez', TO_DATE('1999-03-06','YYYY-MM-DD'), '5557171', 'lucas.jimenez@mail.com', TO_DATE('2025-02-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (72, '72727272-4', 'Trinidad', 'Salazar', TO_DATE('1995-05-25','YYYY-MM-DD'), '5557272', 'trinidad.salazar@mail.com', TO_DATE('2025-02-21','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (73, '73737373-5', 'Nicolás', 'Campos', TO_DATE('1991-01-19','YYYY-MM-DD'), '5557373', 'nicolas.campos@mail.com', TO_DATE('2025-02-23','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (74, '74747474-6', 'Catalina', 'Méndez', TO_DATE('1997-06-08','YYYY-MM-DD'), '5557474', 'catalina.mendez@mail.com', TO_DATE('2025-02-24','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (75, '75757575-7', 'Rodrigo', 'Carrasco', TO_DATE('1993-09-21','YYYY-MM-DD'), '5557575', 'rodrigo.carrasco@mail.com', TO_DATE('2025-02-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (76, '76767676-8', 'Paula', 'Silva', TO_DATE('1990-02-07','YYYY-MM-DD'), '5557676', 'paula.silva@mail.com', TO_DATE('2025-02-26','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (77, '77777777-9', 'Cristian', 'Leiva', TO_DATE('1996-10-30','YYYY-MM-DD'), '5557777', 'cristian.leiva@mail.com', TO_DATE('2025-02-27','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (78, '78787878-0', 'Daniela', 'Figueroa', TO_DATE('1998-11-03','YYYY-MM-DD'), '5557878', 'daniela.figueroa@mail.com', TO_DATE('2025-03-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (79, '79797979-1', 'Simón', 'Gallardo', TO_DATE('1995-04-29','YYYY-MM-DD'), '5557979', 'simon.gallardo@mail.com', TO_DATE('2025-03-02','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (80, '80808080-2', 'Constanza', 'Riquelme', TO_DATE('1992-07-11','YYYY-MM-DD'), '5558080', 'constanza.riquelme@mail.com', TO_DATE('2025-03-03','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (81, '81818181-3', 'Álvaro', 'Peña', TO_DATE('1999-09-17','YYYY-MM-DD'), '5558181', 'alvaro.pena@mail.com', TO_DATE('2025-03-04','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (82, '82828282-4', 'Josefa', 'Bravo', TO_DATE('1994-02-23','YYYY-MM-DD'), '5558282', 'josefa.bravo@mail.com', TO_DATE('2025-03-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (83, '83838383-5', 'Benjamín', 'Araya', TO_DATE('1997-12-01','YYYY-MM-DD'), '5558383', 'benjamin.araya@mail.com', TO_DATE('2025-03-06','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (84, '84848484-6', 'Valeria', 'Godoy', TO_DATE('1996-08-18','YYYY-MM-DD'), '5558484', 'valeria.godoy@mail.com', TO_DATE('2025-03-07','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (85, '85858585-7', 'Leonardo', 'Bustamante', TO_DATE('1993-03-14','YYYY-MM-DD'), '5558585', 'leonardo.bustamante@mail.com', TO_DATE('2025-03-08','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (86, '86868686-8', 'Gabriela', 'Urra', TO_DATE('1991-01-25','YYYY-MM-DD'), '5558686', 'gabriela.urra@mail.com', TO_DATE('2025-03-09','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (87, '87878787-9', 'Esteban', 'Rebolledo', TO_DATE('1998-10-09','YYYY-MM-DD'), '5558787', 'esteban.rebolledo@mail.com', TO_DATE('2025-03-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (88, '88888888-0', 'Paz', 'Acuña', TO_DATE('1994-06-22','YYYY-MM-DD'), '5558888', 'paz.acuna@mail.com', TO_DATE('2025-03-11','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (89, '89898989-1', 'Mauricio', 'Delgado', TO_DATE('1990-05-08','YYYY-MM-DD'), '5558989', 'mauricio.delgado@mail.com', TO_DATE('2025-03-12','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (90, '90909090-2', 'Amanda', 'Vidal', TO_DATE('1992-09-16','YYYY-MM-DD'), '5559090', 'amanda.vidal@mail.com', TO_DATE('2025-03-13','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (91, '91919191-3', 'Vicente', 'Espinoza', TO_DATE('1999-07-19','YYYY-MM-DD'), '5559191', 'vicente.espinoza@mail.com', TO_DATE('2025-03-14','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (92, '92929292-4', 'Isabel', 'Orellana', TO_DATE('1997-01-09','YYYY-MM-DD'), '5559292', 'isabel.orellana@mail.com', TO_DATE('2025-03-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (93, '93939393-5', 'Joaquín', 'Alvarado', TO_DATE('1994-11-11','YYYY-MM-DD'), '5559393', 'joaquin.alvarado@mail.com', TO_DATE('2025-03-16','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (94, '94949494-6', 'Emilia', 'Zúñiga', TO_DATE('1991-04-03','YYYY-MM-DD'), '5559494', 'emilia.zuniga@mail.com', TO_DATE('2025-03-17','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (95, '95959595-7', 'Renato', 'Saavedra', TO_DATE('1998-06-12','YYYY-MM-DD'), '5559595', 'renato.saavedra@mail.com', TO_DATE('2025-03-18','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (96, '96969696-8', 'Martina', 'Arancibia', TO_DATE('1996-10-05','YYYY-MM-DD'), '5559696', 'martina.arancibia@mail.com', TO_DATE('2025-03-19','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (97, '97979797-9', 'Diego', 'Vergara', TO_DATE('1993-02-18','YYYY-MM-DD'), '5559797', 'diego.vergara@mail.com', TO_DATE('2025-03-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (98, '98989898-0', 'Sara', 'Torrealba', TO_DATE('1995-12-29','YYYY-MM-DD'), '5559898', 'sara.torrealba@mail.com', TO_DATE('2025-03-21','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (99, '99999999-1', 'Pedro', 'Mora', TO_DATE('1990-08-07','YYYY-MM-DD'), '5559999', 'pedro.mora@mail.com', TO_DATE('2025-03-22','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (100, '10101010-2', 'Rocío', 'Contreras', TO_DATE('1997-09-25','YYYY-MM-DD'), '5551010', 'rocio.contreras@mail.com', TO_DATE('2025-03-23','YYYY-MM-DD'), 'Activo');
-- SOCIO (del 101 al 150)
INSERT INTO SOCIO VALUES (101, '11111111-3', 'Camilo', 'Espina', TO_DATE('1998-03-15','YYYY-MM-DD'), '5551112', 'camilo.espina@mail.com', TO_DATE('2025-03-24','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (102, '12121212-4', 'Florencia', 'Medina', TO_DATE('1997-07-09','YYYY-MM-DD'), '5551212', 'florencia.medina@mail.com', TO_DATE('2025-03-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (103, '13131313-5', 'Alonso', 'Sanhueza', TO_DATE('1995-02-19','YYYY-MM-DD'), '5551313', 'alonso.sanhueza@mail.com', TO_DATE('2025-03-26','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (104, '14141414-6', 'Emilia', 'Donoso', TO_DATE('1999-04-22','YYYY-MM-DD'), '5551414', 'emilia.donoso@mail.com', TO_DATE('2025-03-27','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (105, '15151515-7', 'Ricardo', 'Olivares', TO_DATE('1993-09-12','YYYY-MM-DD'), '5551515', 'ricardo.olivares@mail.com', TO_DATE('2025-03-28','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (106, '16161616-8', 'Sofía', 'Yáñez', TO_DATE('1992-06-03','YYYY-MM-DD'), '5551616', 'sofia.yanez@mail.com', TO_DATE('2025-03-29','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (107, '17171717-9', 'Jorge', 'Venegas', TO_DATE('1990-10-25','YYYY-MM-DD'), '5551717', 'jorge.venegas@mail.com', TO_DATE('2025-03-30','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (108, '18181818-0', 'Anaís', 'Carvajal', TO_DATE('1998-12-17','YYYY-MM-DD'), '5551818', 'anais.carvajal@mail.com', TO_DATE('2025-04-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (109, '19191919-1', 'Claudio', 'Sepúlveda', TO_DATE('1995-01-06','YYYY-MM-DD'), '5551919', 'claudio.sepulveda@mail.com', TO_DATE('2025-04-02','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (110, '20202020-2', 'Tamara', 'Vergara', TO_DATE('1996-09-14','YYYY-MM-DD'), '5552020', 'tamara.vergara@mail.com', TO_DATE('2025-04-03','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (111, '21212121-3', 'Patricio', 'Escobar', TO_DATE('1999-02-09','YYYY-MM-DD'), '5552121', 'patricio.escobar@mail.com', TO_DATE('2025-04-04','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (112, '22222222-4', 'Josefina', 'Lagos', TO_DATE('1997-07-28','YYYY-MM-DD'), '5552222', 'josefina.lagos@mail.com', TO_DATE('2025-04-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (113, '23232323-5', 'Cristian', 'Toro', TO_DATE('1991-05-11','YYYY-MM-DD'), '5552323', 'cristian.toro@mail.com', TO_DATE('2025-04-06','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (114, '24242424-6', 'Renata', 'Henríquez', TO_DATE('1994-08-21','YYYY-MM-DD'), '5552424', 'renata.henriquez@mail.com', TO_DATE('2025-04-07','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (115, '25252525-7', 'Marcelo', 'Palma', TO_DATE('1990-03-03','YYYY-MM-DD'), '5552525', 'marcelo.palma@mail.com', TO_DATE('2025-04-08','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (116, '26262626-8', 'María José', 'Fierro', TO_DATE('1998-05-30','YYYY-MM-DD'), '5552626', 'mariajose.fierro@mail.com', TO_DATE('2025-04-09','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (117, '27272727-9', 'Cristóbal', 'Moya', TO_DATE('1996-10-02','YYYY-MM-DD'), '5552727', 'cristobal.moya@mail.com', TO_DATE('2025-04-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (118, '28282828-0', 'Antonia', 'Retamal', TO_DATE('1995-12-08','YYYY-MM-DD'), '5552828', 'antonia.retamal@mail.com', TO_DATE('2025-04-11','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (119, '29292929-1', 'Felipe', 'Garrido', TO_DATE('1992-11-16','YYYY-MM-DD'), '5552929', 'felipe.garrido@mail.com', TO_DATE('2025-04-12','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (120, '30303030-2', 'Carla', 'Astudillo', TO_DATE('1997-09-05','YYYY-MM-DD'), '5553030', 'carla.astudillo@mail.com', TO_DATE('2025-04-13','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (121, '31313131-3', 'Vicente', 'Aravena', TO_DATE('1999-08-22','YYYY-MM-DD'), '5553131', 'vicente.aravena@mail.com', TO_DATE('2025-04-14','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (122, '32323232-4', 'Ignacia', 'Vega', TO_DATE('1996-07-11','YYYY-MM-DD'), '5553232', 'ignacia.vega@mail.com', TO_DATE('2025-04-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (123, '33333333-5', 'Rodrigo', 'Alarcón', TO_DATE('1993-05-09','YYYY-MM-DD'), '5553333', 'rodrigo.alarcon@mail.com', TO_DATE('2025-04-16','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (124, '34343434-6', 'Cecilia', 'Bustos', TO_DATE('1998-02-18','YYYY-MM-DD'), '5553434', 'cecilia.bustos@mail.com', TO_DATE('2025-04-17','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (125, '35353535-7', 'Benjamín', 'Farias', TO_DATE('1994-01-12','YYYY-MM-DD'), '5553535', 'benjamin.farias@mail.com', TO_DATE('2025-04-18','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (126, '36363636-8', 'Valentina', 'Campos', TO_DATE('1995-04-06','YYYY-MM-DD'), '5553636', 'valentina.campos@mail.com', TO_DATE('2025-04-19','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (127, '37373737-9', 'Mauricio', 'Cordero', TO_DATE('1990-10-30','YYYY-MM-DD'), '5553737', 'mauricio.cordero@mail.com', TO_DATE('2025-04-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (128, '38383838-0', 'Daniela', 'Loayza', TO_DATE('1997-11-25','YYYY-MM-DD'), '5553838', 'daniela.loayza@mail.com', TO_DATE('2025-04-21','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (129, '39393939-1', 'Joaquín', 'Meza', TO_DATE('1991-07-03','YYYY-MM-DD'), '5553939', 'joaquin.meza@mail.com', TO_DATE('2025-04-22','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (130, '40404040-2', 'Camila', 'Sandoval', TO_DATE('1999-05-17','YYYY-MM-DD'), '5554040', 'camila.sandoval@mail.com', TO_DATE('2025-04-23','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (131, '41414141-3', 'Gonzalo', 'Maldonado', TO_DATE('1996-03-11','YYYY-MM-DD'), '5554141', 'gonzalo.maldonado@mail.com', TO_DATE('2025-04-24','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (132, '42424242-4', 'Francisca', 'Godoy', TO_DATE('1998-09-21','YYYY-MM-DD'), '5554242', 'francisca.godoy@mail.com', TO_DATE('2025-04-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (133, '43434343-5', 'Pablo', 'Donoso', TO_DATE('1993-06-07','YYYY-MM-DD'), '5554343', 'pablo.donoso@mail.com', TO_DATE('2025-04-26','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (134, '44444444-6', 'Isidora', 'Salas', TO_DATE('1997-08-08','YYYY-MM-DD'), '5554444', 'isidora.salas@mail.com', TO_DATE('2025-04-27','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (135, '45454545-7', 'Tomás', 'Baeza', TO_DATE('1990-01-14','YYYY-MM-DD'), '5554545', 'tomas.baeza@mail.com', TO_DATE('2025-04-28','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (136, '46464646-8', 'Marta', 'Lira', TO_DATE('1992-10-10','YYYY-MM-DD'), '5554646', 'marta.lira@mail.com', TO_DATE('2025-04-29','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (137, '47474747-9', 'Pedro', 'Vidal', TO_DATE('1995-11-19','YYYY-MM-DD'), '5554747', 'pedro.vidal@mail.com', TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (138, '48484848-0', 'Carolina', 'Moreno', TO_DATE('1998-07-02','YYYY-MM-DD'), '5554848', 'carolina.moreno@mail.com', TO_DATE('2025-05-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (139, '49494949-1', 'Álvaro', 'Peñailillo', TO_DATE('1996-01-24','YYYY-MM-DD'), '5554949', 'alvaro.penailillo@mail.com', TO_DATE('2025-05-02','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (140, '50505050-2', 'Laura', 'Cuevas', TO_DATE('1993-12-30','YYYY-MM-DD'), '5555050', 'laura.cuevas@mail.com', TO_DATE('2025-05-03','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (141, '51515151-3', 'Andrés', 'Pizarro', TO_DATE('1991-09-04','YYYY-MM-DD'), '5555151', 'andres.pizarro@mail.com', TO_DATE('2025-05-04','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (142, '52525252-4', 'Constanza', 'Mora', TO_DATE('1994-11-28','YYYY-MM-DD'), '5555252', 'constanza.mora@mail.com', TO_DATE('2025-05-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (143, '53535353-5', 'Martín', 'Saez', TO_DATE('1999-03-02','YYYY-MM-DD'), '5555353', 'martin.saez@mail.com', TO_DATE('2025-05-06','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (144, '54545454-6', 'Daniela', 'Acuña', TO_DATE('1996-02-15','YYYY-MM-DD'), '5555454', 'daniela.acuna@mail.com', TO_DATE('2025-05-07','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (145, '55555555-7', 'Francisco', 'Urrutia', TO_DATE('1995-06-10','YYYY-MM-DD'), '5555556', 'francisco.urrutia@mail.com', TO_DATE('2025-05-08','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (146, '56565656-8', 'Josefa', 'Zapata', TO_DATE('1992-04-27','YYYY-MM-DD'), '5555656', 'josefa.zapata@mail.com', TO_DATE('2025-05-09','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (147, '57575757-9', 'Felipe', 'Castillo', TO_DATE('1998-08-12','YYYY-MM-DD'), '5555757', 'felipe.castillo@mail.com', TO_DATE('2025-05-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (148, '58585858-0', 'Victoria', 'Méndez', TO_DATE('1993-10-06','YYYY-MM-DD'), '5555859', 'victoria.mendez@mail.com', TO_DATE('2025-05-11','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (149, '59597959-1', 'Gabriel', 'Ríos', TO_DATE('1990-12-13','YYYY-MM-DD'), '5555959', 'gabriel.rios@mail.com', TO_DATE('2025-05-12','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (150, '60606030-2', 'Amanda', 'León', TO_DATE('1997-07-23','YYYY-MM-DD'), '5556061', 'amanda.leon@mail.com', TO_DATE('2025-05-13','YYYY-MM-DD'), 'Activo');
-- SOCIO (151–200) // revisar algunos datos repetidos
INSERT INTO SOCIO VALUES (151, '67617161-3', 'Benjamín', 'Moya', TO_DATE('1996-01-15','YYYY-MM-DD'), '5556161', 'benjamin.moya@mail.com', TO_DATE('2025-05-14','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (152, '62226262-4', 'Valentina', 'Pérez', TO_DATE('1995-02-18','YYYY-MM-DD'), '5556262', 'valentina.perez@mail.com', TO_DATE('2025-05-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (153, '67636363-5', 'Santiago', 'González', TO_DATE('1994-03-20','YYYY-MM-DD'), '5556363', 'santiago.gonzalez@mail.com', TO_DATE('2025-05-16','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (154, '64676462-6', 'Isidora', 'Fuentes', TO_DATE('1997-04-25','YYYY-MM-DD'), '5556464', 'isidora.fuentes@mail.com', TO_DATE('2025-05-17','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (155, '65156565-7', 'Matías', 'Cáceres', TO_DATE('1993-05-30','YYYY-MM-DD'), '5556565', 'matias.caceres@mail.com', TO_DATE('2025-05-18','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (156, '66166666-8', 'Antonia', 'Sanhueza', TO_DATE('1998-06-12','YYYY-MM-DD'), '5556666', 'antonia.sanhueza@mail.com', TO_DATE('2025-05-19','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (157, '67671767-9', 'José', 'Vargas', TO_DATE('1992-07-03','YYYY-MM-DD'), '5556767', 'jose.vargas@mail.com', TO_DATE('2025-05-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (158, '61686868-0', 'Francisca', 'Lagos', TO_DATE('1999-08-08','YYYY-MM-DD'), '5556868', 'francisca.lagos@mail.com', TO_DATE('2025-05-21','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (159, '61696969-1', 'Cristóbal', 'Molina', TO_DATE('1995-09-15','YYYY-MM-DD'), '5556969', 'cristobal.molina@mail.com', TO_DATE('2025-05-22','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (160, '75707070-2', 'Camila', 'Herrera', TO_DATE('1996-10-10','YYYY-MM-DD'), '5557070', 'camila.herrera@mail.com', TO_DATE('2025-05-23','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (161, '75717171-3', 'Andrés', 'Bravo', TO_DATE('1994-11-01','YYYY-MM-DD'), '5557171', 'andres.bravo@mail.com', TO_DATE('2025-05-24','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (162, '72729272-4', 'Ignacia', 'Aguirre', TO_DATE('1997-12-21','YYYY-MM-DD'), '5557272', 'ignacia.aguirre@mail.com', TO_DATE('2025-05-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (163, '73797373-5', 'Felipe', 'Contreras', TO_DATE('1993-01-09','YYYY-MM-DD'), '5557373', 'felipe.contreras@mail.com', TO_DATE('2025-05-26','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (164, '74797474-6', 'Isabel', 'Vera', TO_DATE('1998-02-14','YYYY-MM-DD'), '5557474', 'isabel.vera@mail.com', TO_DATE('2025-05-27','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (165, '79757575-7', 'Mauricio', 'Olivares', TO_DATE('1992-03-30','YYYY-MM-DD'), '5557575', 'mauricio.olivares@mail.com', TO_DATE('2025-05-28','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (166, '76967676-8', 'María', 'Rojas', TO_DATE('1995-04-05','YYYY-MM-DD'), '5557676', 'maria.rojas@mail.com', TO_DATE('2025-05-29','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (167, '77779777-9', 'Gabriel', 'Leiva', TO_DATE('1996-05-20','YYYY-MM-DD'), '5557777', 'gabriel.leiva@mail.com', TO_DATE('2025-05-30','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (168, '78987878-0', 'Paula', 'Soto', TO_DATE('1994-06-15','YYYY-MM-DD'), '5557878', 'paula.soto@mail.com', TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (169, '70790979-1', 'Ricardo', 'Salazar', TO_DATE('1993-07-10','YYYY-MM-DD'), '5557979', 'ricardo.salazar@mail.com', TO_DATE('2025-06-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (170, '89808080-2', 'Natalia', 'Pizarro', TO_DATE('1997-08-22','YYYY-MM-DD'), '5558080', 'natalia.pizarro@mail.com', TO_DATE('2025-06-02','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (171, '89818181-3', 'Claudio', 'Miranda', TO_DATE('1995-09-13','YYYY-MM-DD'), '5558181', 'claudio.miranda@mail.com', TO_DATE('2025-06-03','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (172, '86828282-4', 'Emilia', 'Campos', TO_DATE('1994-10-08','YYYY-MM-DD'), '5558282', 'emilia.campos@mail.com', TO_DATE('2025-06-04','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (173, '87838383-5', 'Joaquín', 'Rojas', TO_DATE('1996-11-21','YYYY-MM-DD'), '5558383', 'joaquin.rojas@mail.com', TO_DATE('2025-06-05','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (174, '88848484-6', 'Isidora', 'Muñoz', TO_DATE('1993-12-30','YYYY-MM-DD'), '5558484', 'isidora.munoz@mail.com', TO_DATE('2025-06-06','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (175, '87857585-7', 'Alonso', 'Cruz', TO_DATE('1997-01-25','YYYY-MM-DD'), '5558585', 'alonso.cruz@mail.com', TO_DATE('2025-06-07','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (176, '87868686-8', 'Renata', 'Valdés', TO_DATE('1995-02-18','YYYY-MM-DD'), '5558686', 'renata.valdes@mail.com', TO_DATE('2025-06-08','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (177, '88878787-9', 'Tomás', 'Carrasco', TO_DATE('1994-03-12','YYYY-MM-DD'), '5558787', 'tomas.carrasco@mail.com', TO_DATE('2025-06-09','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (178, '83888888-0', 'Carolina', 'Mena', TO_DATE('1996-04-20','YYYY-MM-DD'), '5558888', 'carolina.mena@mail.com', TO_DATE('2025-06-10','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (179, '84898989-1', 'Mauricio', 'Pinto', TO_DATE('1997-05-14','YYYY-MM-DD'), '5558989', 'mauricio.pinto@mail.com', TO_DATE('2025-06-11','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (180, '95909090-2', 'Antonia', 'Reyes', TO_DATE('1995-06-28','YYYY-MM-DD'), '5559090', 'antonia.reyes@mail.com', TO_DATE('2025-06-12','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (181, '96919191-3', 'Javier', 'Salinas', TO_DATE('1994-07-19','YYYY-MM-DD'), '5559191', 'javier.salinas@mail.com', TO_DATE('2025-06-13','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (182, '95979292-4', 'Renata', 'Cárdenas', TO_DATE('1996-08-15','YYYY-MM-DD'), '5559292', 'renata.cardenas@mail.com', TO_DATE('2025-06-14','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (183, '96939393-5', 'Rodrigo', 'Poblete', TO_DATE('1993-09-10','YYYY-MM-DD'), '5559393', 'rodrigo.poblete@mail.com', TO_DATE('2025-06-15','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (184, '97949494-6', 'Isidora', 'Cordero', TO_DATE('1997-10-05','YYYY-MM-DD'), '5559494', 'isidora.cordero@mail.com', TO_DATE('2025-06-16','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (185, '98959595-7', 'Felipe', 'Vidal', TO_DATE('1995-11-12','YYYY-MM-DD'), '5559595', 'felipe.vidal@mail.com', TO_DATE('2025-06-17','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (186, '92969696-8', 'María', 'Riquelme', TO_DATE('1994-12-01','YYYY-MM-DD'), '5559696', 'maria.riquelme@mail.com', TO_DATE('2025-06-18','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (187, '92979797-9', 'Claudio', 'Valenzuela', TO_DATE('1996-01-23','YYYY-MM-DD'), '5559797', 'claudio.valenzuela@mail.com', TO_DATE('2025-06-19','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (188, '92989898-0', 'Renata', 'Espinoza', TO_DATE('1995-02-28','YYYY-MM-DD'), '5559898', 'renata.espinoza@mail.com', TO_DATE('2025-06-20','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (189, '92090909-1', 'Ricardo', 'Orellana', TO_DATE('1994-03-15','YYYY-MM-DD'), '5559909', 'ricardo.orellana@mail.com', TO_DATE('2025-06-21','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (190, '29191919-2', 'Isabel', 'Vega', TO_DATE('1996-04-10','YYYY-MM-DD'), '5559919', 'isabel.vega@mail.com', TO_DATE('2025-06-22','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (191, '29292929-3', 'Sergio', 'Mardones', TO_DATE('1995-05-01','YYYY-MM-DD'), '5559929', 'sergio.mardones@mail.com', TO_DATE('2025-06-23','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (192, '99323939-4', 'Camila', 'Figueroa', TO_DATE('1994-06-05','YYYY-MM-DD'), '5559939', 'camila.figueroa@mail.com', TO_DATE('2025-06-24','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (193, '99424949-5', 'Rodrigo', 'Luna', TO_DATE('1996-07-12','YYYY-MM-DD'), '5559949', 'rodrigo.luna@mail.com', TO_DATE('2025-06-25','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (194, '99525959-6', 'Isidora', 'Ahumada', TO_DATE('1995-08-19','YYYY-MM-DD'), '5559959', 'isidora.ahumada@mail.com', TO_DATE('2025-06-26','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (195, '99626969-7', 'Felipe', 'Cisternas', TO_DATE('1994-09-23','YYYY-MM-DD'), '5559969', 'felipe.cisternas@mail.com', TO_DATE('2025-06-27','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (196, '99727979-8', 'María', 'Carrillo', TO_DATE('1996-10-15','YYYY-MM-DD'), '5559979', 'maria.carrillo@mail.com', TO_DATE('2025-06-28','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (197, '99828989-9', 'Joaquín', 'Pizarro', TO_DATE('1995-11-10','YYYY-MM-DD'), '5559989', 'joaquin.pizarro@mail.com', TO_DATE('2025-06-29','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (198, '99929090-0', 'Antonia', 'Rojas', TO_DATE('1994-12-05','YYYY-MM-DD'), '5559990', 'antonia.rojas@mail.com', TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (199, '10020101-1', 'Claudio', 'Vargas', TO_DATE('1996-01-08','YYYY-MM-DD'), '5560101', 'claudio.vargas@mail.com', TO_DATE('2025-07-01','YYYY-MM-DD'), 'Activo');
INSERT INTO SOCIO VALUES (200, '10121010-3', 'Valentina', 'Rojas', TO_DATE('1995-02-02','YYYY-MM-DD'), '5560110', 'valentina.rojas@mail.com', TO_DATE('2025-07-02','YYYY-MM-DD'), 'Activo');




-- SOCIO_PLAN (10)
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (1, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-01-31','YYYY-MM-DD'), 'Activo', 1, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (2, TO_DATE('2024-02-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 2, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (3, TO_DATE('2024-03-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 3, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (4, TO_DATE('2024-04-01','YYYY-MM-DD'), TO_DATE('2024-06-30','YYYY-MM-DD'), 'Activo', 4, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (5, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 5, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (6, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-06-30','YYYY-MM-DD'), 'Activo', 6, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (7, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 7, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (8, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 8, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (9, TO_DATE('2024-09-01','YYYY-MM-DD'), TO_DATE('2024-11-30','YYYY-MM-DD'), 'Activo', 9, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (10, TO_DATE('2024-10-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 10, 5);

-- SOCIO_PLAN (50 registros adicionales)
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (11, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 11, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (12, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 12, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (13, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 13, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (14, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 14, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (15, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 15, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (16, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 16, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (17, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 17, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (18, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 18, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (19, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 19, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (20, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 20, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (21, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 21, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (22, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 22, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (23, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 23, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (24, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 24, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (25, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 25, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (26, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 26, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (27, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 27, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (28, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 28, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (29, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 29, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (30, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 30, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (31, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 31, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (32, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 32, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (33, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 33, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (34, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 34, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (35, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 35, 5);
-- Continúan más registros con la misma lógica:
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (36, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 36, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (37, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 37, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (38, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 38, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (39, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 39, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (40, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 40, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (41, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 41, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (42, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 42, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (43, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 43, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (44, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 44, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (45, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 45, 2);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (46, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 46, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (47, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 47, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (48, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 48, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (49, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 49, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (50, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 50, 3);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (51, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 51, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (52, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 52, 4);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (53, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 53, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (54, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 54, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (55, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 55, 5);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (56, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 56, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (57, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 57, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (58, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 58, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (59, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 59, 1);
INSERT INTO SOCIO_PLAN (id_socio_plan, fecha_inicio, fecha_fin, estado, id_socio, id_plan) VALUES (60, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 60, 1);
-- SOCIO_PLAN (registros del 61 al 110)
INSERT INTO SOCIO_PLAN VALUES (61, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 61, 1);
INSERT INTO SOCIO_PLAN VALUES (62, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 62, 1);
INSERT INTO SOCIO_PLAN VALUES (63, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 63, 1);
INSERT INTO SOCIO_PLAN VALUES (64, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 64, 1);
INSERT INTO SOCIO_PLAN VALUES (65, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 65, 1);
INSERT INTO SOCIO_PLAN VALUES (66, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 66, 2);
INSERT INTO SOCIO_PLAN VALUES (67, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 67, 2);
INSERT INTO SOCIO_PLAN VALUES (68, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 68, 2);
INSERT INTO SOCIO_PLAN VALUES (69, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 69, 2);
INSERT INTO SOCIO_PLAN VALUES (70, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 70, 2);
INSERT INTO SOCIO_PLAN VALUES (71, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 71, 3);
INSERT INTO SOCIO_PLAN VALUES (72, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 72, 3);
INSERT INTO SOCIO_PLAN VALUES (73, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 73, 3);
INSERT INTO SOCIO_PLAN VALUES (74, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 74, 3);
INSERT INTO SOCIO_PLAN VALUES (75, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 75, 3);
INSERT INTO SOCIO_PLAN VALUES (76, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 76, 4);
INSERT INTO SOCIO_PLAN VALUES (77, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 77, 4);
INSERT INTO SOCIO_PLAN VALUES (78, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 78, 4);
INSERT INTO SOCIO_PLAN VALUES (79, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 79, 4);
INSERT INTO SOCIO_PLAN VALUES (80, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 80, 4);
INSERT INTO SOCIO_PLAN VALUES (81, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 81, 5);
INSERT INTO SOCIO_PLAN VALUES (82, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 82, 5);
INSERT INTO SOCIO_PLAN VALUES (83, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 83, 5);
INSERT INTO SOCIO_PLAN VALUES (84, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 84, 5);
INSERT INTO SOCIO_PLAN VALUES (85, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 85, 5);
INSERT INTO SOCIO_PLAN VALUES (86, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 86, 1);
INSERT INTO SOCIO_PLAN VALUES (87, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 87, 1);
INSERT INTO SOCIO_PLAN VALUES (88, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 88, 1);
INSERT INTO SOCIO_PLAN VALUES (89, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 89, 1);
INSERT INTO SOCIO_PLAN VALUES (90, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 90, 1);
INSERT INTO SOCIO_PLAN VALUES (91, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 91, 2);
INSERT INTO SOCIO_PLAN VALUES (92, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 92, 2);
INSERT INTO SOCIO_PLAN VALUES (93, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 93, 2);
INSERT INTO SOCIO_PLAN VALUES (94, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 94, 2);
INSERT INTO SOCIO_PLAN VALUES (95, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 95, 2);
INSERT INTO SOCIO_PLAN VALUES (96, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 96, 3);
INSERT INTO SOCIO_PLAN VALUES (97, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 97, 3);
INSERT INTO SOCIO_PLAN VALUES (98, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 98, 3);
INSERT INTO SOCIO_PLAN VALUES (99, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 99, 3);
INSERT INTO SOCIO_PLAN VALUES (100, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 100, 3);
INSERT INTO SOCIO_PLAN VALUES (101, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 101, 4);
INSERT INTO SOCIO_PLAN VALUES (102, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 102, 4);
INSERT INTO SOCIO_PLAN VALUES (103, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 103, 4);
INSERT INTO SOCIO_PLAN VALUES (104, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 104, 4);
INSERT INTO SOCIO_PLAN VALUES (105, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 105, 4);
INSERT INTO SOCIO_PLAN VALUES (106, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 106, 5);
INSERT INTO SOCIO_PLAN VALUES (107, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 107, 5);
INSERT INTO SOCIO_PLAN VALUES (108, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 108, 5);
INSERT INTO SOCIO_PLAN VALUES (109, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 109, 5);
INSERT INTO SOCIO_PLAN VALUES (110, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 110, 5);

-- Plan Premium (10)
INSERT INTO SOCIO_PLAN VALUES (111, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 111, 2);
INSERT INTO SOCIO_PLAN VALUES (112, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 112, 2);
INSERT INTO SOCIO_PLAN VALUES (113, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 113, 2);
INSERT INTO SOCIO_PLAN VALUES (114, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 114, 2);
INSERT INTO SOCIO_PLAN VALUES (115, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 115, 2);
INSERT INTO SOCIO_PLAN VALUES (116, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 116, 2);
INSERT INTO SOCIO_PLAN VALUES (117, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 117, 2);
INSERT INTO SOCIO_PLAN VALUES (118, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 118, 2);
INSERT INTO SOCIO_PLAN VALUES (119, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 119, 2);
INSERT INTO SOCIO_PLAN VALUES (120, TO_DATE('2024-07-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 120, 2);

-- Plan Elite (10)
INSERT INTO SOCIO_PLAN VALUES (121, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 121, 3);
INSERT INTO SOCIO_PLAN VALUES (122, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 122, 3);
INSERT INTO SOCIO_PLAN VALUES (123, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 123, 3);
INSERT INTO SOCIO_PLAN VALUES (124, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 124, 3);
INSERT INTO SOCIO_PLAN VALUES (125, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 125, 3);
INSERT INTO SOCIO_PLAN VALUES (126, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 126, 3);
INSERT INTO SOCIO_PLAN VALUES (127, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 127, 3);
INSERT INTO SOCIO_PLAN VALUES (128, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 128, 3);
INSERT INTO SOCIO_PLAN VALUES (129, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 129, 3);
INSERT INTO SOCIO_PLAN VALUES (130, TO_DATE('2024-01-01','YYYY-MM-DD'), TO_DATE('2024-12-31','YYYY-MM-DD'), 'Activo', 130, 3);

-- Plan Yoga (10)
INSERT INTO SOCIO_PLAN VALUES (131, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 131, 4);
INSERT INTO SOCIO_PLAN VALUES (132, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 132, 4);
INSERT INTO SOCIO_PLAN VALUES (133, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 133, 4);
INSERT INTO SOCIO_PLAN VALUES (134, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 134, 4);
INSERT INTO SOCIO_PLAN VALUES (135, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 135, 4);
INSERT INTO SOCIO_PLAN VALUES (136, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 136, 4);
INSERT INTO SOCIO_PLAN VALUES (137, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 137, 4);
INSERT INTO SOCIO_PLAN VALUES (138, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 138, 4);
INSERT INTO SOCIO_PLAN VALUES (139, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 139, 4);
INSERT INTO SOCIO_PLAN VALUES (140, TO_DATE('2024-05-01','YYYY-MM-DD'), TO_DATE('2024-07-31','YYYY-MM-DD'), 'Activo', 140, 4);

INSERT INTO SOCIO_PLAN VALUES (141, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 141, 5);
INSERT INTO SOCIO_PLAN VALUES (142, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 142, 5);
INSERT INTO SOCIO_PLAN VALUES (143, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 143, 5);
INSERT INTO SOCIO_PLAN VALUES (144, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 144, 5);
INSERT INTO SOCIO_PLAN VALUES (145, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 145, 5);
INSERT INTO SOCIO_PLAN VALUES (146, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 146, 5);
INSERT INTO SOCIO_PLAN VALUES (147, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 147, 5);
INSERT INTO SOCIO_PLAN VALUES (148, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 148, 5);
INSERT INTO SOCIO_PLAN VALUES (149, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 149, 5);
INSERT INTO SOCIO_PLAN VALUES (150, TO_DATE('2024-06-01','YYYY-MM-DD'), TO_DATE('2024-08-31','YYYY-MM-DD'), 'Activo', 150, 5);

-- SOCIO_PLAN (151–200)
-- Plan Básico (20)
INSERT INTO SOCIO_PLAN VALUES (151, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 151, 1);
INSERT INTO SOCIO_PLAN VALUES (152, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 152, 1);
INSERT INTO SOCIO_PLAN VALUES (153, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 153, 1);
INSERT INTO SOCIO_PLAN VALUES (154, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 154, 1);
INSERT INTO SOCIO_PLAN VALUES (155, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 155, 1);
INSERT INTO SOCIO_PLAN VALUES (156, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 156, 1);
INSERT INTO SOCIO_PLAN VALUES (157, TO_DATE('2025-07-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 157, 1);
INSERT INTO SOCIO_PLAN VALUES (158, TO_DATE('2025-08-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 158, 1);
INSERT INTO SOCIO_PLAN VALUES (159, TO_DATE('2025-09-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 159, 1);
INSERT INTO SOCIO_PLAN VALUES (160, TO_DATE('2025-10-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 160, 1);
INSERT INTO SOCIO_PLAN VALUES (161, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-01-31','YYYY-MM-DD'), 'Activo', 161, 1);
INSERT INTO SOCIO_PLAN VALUES (162, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-02-28','YYYY-MM-DD'), 'Activo', 162, 1);
INSERT INTO SOCIO_PLAN VALUES (163, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 163, 1);
INSERT INTO SOCIO_PLAN VALUES (164, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 164, 1);
INSERT INTO SOCIO_PLAN VALUES (165, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 165, 1);
INSERT INTO SOCIO_PLAN VALUES (166, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 166, 1);
INSERT INTO SOCIO_PLAN VALUES (167, TO_DATE('2025-07-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 167, 1);
INSERT INTO SOCIO_PLAN VALUES (168, TO_DATE('2025-08-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 168, 1);
INSERT INTO SOCIO_PLAN VALUES (169, TO_DATE('2025-09-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 169, 1);
INSERT INTO SOCIO_PLAN VALUES (170, TO_DATE('2025-10-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 170, 1);

-- Plan Premium (10)
INSERT INTO SOCIO_PLAN VALUES (171, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 171, 2);
INSERT INTO SOCIO_PLAN VALUES (172, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 172, 2);
INSERT INTO SOCIO_PLAN VALUES (173, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 173, 2);
INSERT INTO SOCIO_PLAN VALUES (174, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-09-30','YYYY-MM-DD'), 'Activo', 174, 2);
INSERT INTO SOCIO_PLAN VALUES (175, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-10-31','YYYY-MM-DD'), 'Activo', 175, 2);
INSERT INTO SOCIO_PLAN VALUES (176, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-11-30','YYYY-MM-DD'), 'Activo', 176, 2);
INSERT INTO SOCIO_PLAN VALUES (177, TO_DATE('2025-07-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 177, 2);
INSERT INTO SOCIO_PLAN VALUES (178, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 178, 2);
INSERT INTO SOCIO_PLAN VALUES (179, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 179, 2);
INSERT INTO SOCIO_PLAN VALUES (180, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 180, 2);

-- Plan Elite (8)
INSERT INTO SOCIO_PLAN VALUES (181, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-12-31','YYYY-MM-DD'), 'Activo', 181, 3);
INSERT INTO SOCIO_PLAN VALUES (182, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2026-01-31','YYYY-MM-DD'), 'Activo', 182, 3);
INSERT INTO SOCIO_PLAN VALUES (183, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2026-02-28','YYYY-MM-DD'), 'Activo', 183, 3);
INSERT INTO SOCIO_PLAN VALUES (184, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2026-03-31','YYYY-MM-DD'), 'Activo', 184, 3);
INSERT INTO SOCIO_PLAN VALUES (185, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2026-04-30','YYYY-MM-DD'), 'Activo', 185, 3);
INSERT INTO SOCIO_PLAN VALUES (186, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2026-05-31','YYYY-MM-DD'), 'Activo', 186, 3);
INSERT INTO SOCIO_PLAN VALUES (187, TO_DATE('2025-07-01','YYYY-MM-DD'), TO_DATE('2026-06-30','YYYY-MM-DD'), 'Activo', 187, 3);
INSERT INTO SOCIO_PLAN VALUES (188, TO_DATE('2025-08-01','YYYY-MM-DD'), TO_DATE('2026-07-31','YYYY-MM-DD'), 'Activo', 188, 3);

-- Plan Yoga (6)
INSERT INTO SOCIO_PLAN VALUES (189, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 189, 4);
INSERT INTO SOCIO_PLAN VALUES (190, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 190, 4);
INSERT INTO SOCIO_PLAN VALUES (191, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 191, 4);
INSERT INTO SOCIO_PLAN VALUES (192, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 192, 4);
INSERT INTO SOCIO_PLAN VALUES (193, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 193, 4);
INSERT INTO SOCIO_PLAN VALUES (194, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 194, 4);

-- Plan Cardio (6)
INSERT INTO SOCIO_PLAN VALUES (195, TO_DATE('2025-01-01','YYYY-MM-DD'), TO_DATE('2025-03-31','YYYY-MM-DD'), 'Activo', 195, 5);
INSERT INTO SOCIO_PLAN VALUES (196, TO_DATE('2025-02-01','YYYY-MM-DD'), TO_DATE('2025-04-30','YYYY-MM-DD'), 'Activo', 196, 5);
INSERT INTO SOCIO_PLAN VALUES (197, TO_DATE('2025-03-01','YYYY-MM-DD'), TO_DATE('2025-05-31','YYYY-MM-DD'), 'Activo', 197, 5);
INSERT INTO SOCIO_PLAN VALUES (198, TO_DATE('2025-04-01','YYYY-MM-DD'), TO_DATE('2025-06-30','YYYY-MM-DD'), 'Activo', 198, 5);
INSERT INTO SOCIO_PLAN VALUES (199, TO_DATE('2025-05-01','YYYY-MM-DD'), TO_DATE('2025-07-31','YYYY-MM-DD'), 'Activo', 199, 5);
INSERT INTO SOCIO_PLAN VALUES (200, TO_DATE('2025-06-01','YYYY-MM-DD'), TO_DATE('2025-08-31','YYYY-MM-DD'), 'Activo', 200, 5);


-- SOCIO_SUCURSAL (10)
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (1, 'Completo', 1, 1);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (2, 'Limitado', 2, 2);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (3, 'Completo', 3, 3);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (4, 'Limitado', 4, 4);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (5, 'Completo', 5, 5);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (6, 'Completo', 6, 1);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (7, 'Limitado', 7, 2);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (8, 'Completo', 8, 3);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (9, 'Limitado', 9, 4);
INSERT INTO SOCIO_SUCURSAL (id_socio_sucursal, tipo_acceso, id_socio, id_sucursal) VALUES (10, 'Completo', 10, 5);
-- SOCIO_SUCURSAL (desde 11 hasta 60) — Distribución equilibrada
-- 🏢 Sucursal Central (25 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (11, 'Completo', 11, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (12, 'Limitado', 12, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (13, 'Completo', 13, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (14, 'Limitado', 14, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (15, 'Completo', 15, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (16, 'Limitado', 16, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (17, 'Completo', 17, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (18, 'Limitado', 18, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (19, 'Completo', 19, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (20, 'Limitado', 20, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (21, 'Completo', 21, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (22, 'Limitado', 22, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (23, 'Completo', 23, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (24, 'Limitado', 24, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (25, 'Completo', 25, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (26, 'Limitado', 26, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (27, 'Completo', 27, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (28, 'Limitado', 28, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (29, 'Completo', 29, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (30, 'Limitado', 30, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (31, 'Completo', 31, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (32, 'Limitado', 32, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (33, 'Completo', 33, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (34, 'Limitado', 34, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (35, 'Completo', 35, 1);

-- 🧭 Sucursal Norte (10 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (36, 'Completo', 36, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (37, 'Limitado', 37, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (38, 'Completo', 38, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (39, 'Limitado', 39, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (40, 'Completo', 40, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (41, 'Limitado', 41, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (42, 'Completo', 42, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (43, 'Limitado', 43, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (44, 'Completo', 44, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (45, 'Limitado', 45, 2);

-- 🌅 Sucursal Sur (7 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (46, 'Completo', 46, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (47, 'Limitado', 47, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (48, 'Completo', 48, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (49, 'Limitado', 49, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (50, 'Completo', 50, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (51, 'Limitado', 51, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (52, 'Completo', 52, 3);

-- 🌄 Sucursal Oriente (5 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (53, 'Completo', 53, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (54, 'Limitado', 54, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (55, 'Completo', 55, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (56, 'Limitado', 56, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (57, 'Completo', 57, 4);

-- 🌇 Sucursal Poniente (3 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (58, 'Limitado', 58, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (59, 'Completo', 59, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (60, 'Limitado', 60, 5);

-- SOCIO_SUCURSAL (desde 61 hasta 110)
-- 🏢 Sucursal Central (continuación hasta 70 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (61, 'Completo', 61, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (62, 'Limitado', 62, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (63, 'Completo', 63, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (64, 'Limitado', 64, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (65, 'Completo', 65, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (66, 'Limitado', 66, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (67, 'Completo', 67, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (68, 'Limitado', 68, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (69, 'Completo', 69, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (70, 'Limitado', 70, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (71, 'Completo', 71, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (72, 'Limitado', 72, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (73, 'Completo', 73, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (74, 'Limitado', 74, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (75, 'Completo', 75, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (76, 'Limitado', 76, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (77, 'Completo', 77, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (78, 'Limitado', 78, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (79, 'Completo', 79, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (80, 'Limitado', 80, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (81, 'Completo', 81, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (82, 'Limitado', 82, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (83, 'Completo', 83, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (84, 'Limitado', 84, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (85, 'Completo', 85, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (86, 'Limitado', 86, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (87, 'Completo', 87, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (88, 'Limitado', 88, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (89, 'Completo', 89, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (90, 'Limitado', 90, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (91, 'Completo', 91, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (92, 'Limitado', 92, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (93, 'Completo', 93, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (94, 'Limitado', 94, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (95, 'Completo', 95, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (96, 'Limitado', 96, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (97, 'Completo', 97, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (98, 'Limitado', 98, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (99, 'Completo', 99, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (100, 'Limitado', 100, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (101, 'Completo', 101, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (102, 'Limitado', 102, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (103, 'Completo', 103, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (104, 'Limitado', 104, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (105, 'Completo', 105, 1);

-- 🧭 Sucursal Norte (5 nuevos socios)
INSERT INTO SOCIO_SUCURSAL VALUES (106, 'Limitado', 106, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (107, 'Completo', 107, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (108, 'Limitado', 108, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (109, 'Completo', 109, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (110, 'Limitado', 110, 2);

-- 🔸 Sucursal Oriente (25 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (111, 'Completo', 161, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (112, 'Limitado', 162, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (113, 'Completo', 163, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (114, 'Limitado', 164, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (115, 'Completo', 165, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (116, 'Limitado', 166, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (117, 'Completo', 167, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (118, 'Limitado', 168, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (119, 'Completo', 169, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (120, 'Limitado', 170, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (121, 'Completo', 171, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (122, 'Limitado', 172, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (123, 'Completo', 173, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (124, 'Limitado', 174, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (125, 'Completo', 175, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (126, 'Limitado', 176, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (127, 'Completo', 177, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (128, 'Limitado', 178, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (129, 'Completo', 179, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (130, 'Limitado', 180, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (131, 'Completo', 181, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (132, 'Limitado', 182, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (133, 'Completo', 183, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (134, 'Limitado', 184, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (135, 'Completo', 185, 4);

-- 🔸 Sucursal Poniente (15 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (136, 'Completo', 186, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (137, 'Limitado', 187, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (138, 'Completo', 188, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (139, 'Limitado', 189, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (140, 'Completo', 190, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (141, 'Limitado', 191, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (142, 'Completo', 192, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (143, 'Limitado', 193, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (144, 'Completo', 194, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (145, 'Limitado', 195, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (146, 'Completo', 196, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (147, 'Limitado', 197, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (148, 'Completo', 198, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (149, 'Limitado', 199, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (150, 'Completo', 200, 5);

-- 🔸 Sucursal Central (15 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (151, 'Completo', 151, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (152, 'Limitado', 152, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (153, 'Completo', 153, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (154, 'Limitado', 154, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (155, 'Completo', 155, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (156, 'Limitado', 156, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (157, 'Completo', 157, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (158, 'Limitado', 158, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (159, 'Completo', 159, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (160, 'Limitado', 160, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (161, 'Completo', 161, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (162, 'Limitado', 162, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (163, 'Completo', 163, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (164, 'Limitado', 164, 1);
INSERT INTO SOCIO_SUCURSAL VALUES (165, 'Completo', 165, 1);

-- 🔸 Sucursal Norte (10 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (166, 'Completo', 166, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (167, 'Limitado', 167, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (168, 'Completo', 168, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (169, 'Limitado', 169, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (170, 'Completo', 170, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (171, 'Limitado', 171, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (172, 'Completo', 172, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (173, 'Limitado', 173, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (174, 'Completo', 174, 2);
INSERT INTO SOCIO_SUCURSAL VALUES (175, 'Limitado', 175, 2);

-- 🔸 Sucursal Sur (10 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (176, 'Completo', 176, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (177, 'Limitado', 177, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (178, 'Completo', 178, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (179, 'Limitado', 179, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (180, 'Completo', 180, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (181, 'Limitado', 181, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (182, 'Completo', 182, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (183, 'Limitado', 183, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (184, 'Completo', 184, 3);
INSERT INTO SOCIO_SUCURSAL VALUES (185, 'Limitado', 185, 3);

-- 🔸 Sucursal Oriente (10 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (186, 'Completo', 186, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (187, 'Limitado', 187, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (188, 'Completo', 188, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (189, 'Limitado', 189, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (190, 'Completo', 190, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (191, 'Limitado', 191, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (192, 'Completo', 192, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (193, 'Limitado', 193, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (194, 'Completo', 194, 4);
INSERT INTO SOCIO_SUCURSAL VALUES (195, 'Limitado', 195, 4);

-- 🔸 Sucursal Poniente (5 socios)
INSERT INTO SOCIO_SUCURSAL VALUES (196, 'Completo', 196, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (197, 'Limitado', 197, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (198, 'Completo', 198, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (199, 'Limitado', 199, 5);
INSERT INTO SOCIO_SUCURSAL VALUES (200, 'Completo', 200, 5);

-- PAGO (10)
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (1, TO_DATE('2024-01-01','YYYY-MM-DD'), 20000, 'Tarjeta', 'Pagado', 1);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (2, TO_DATE('2024-02-01','YYYY-MM-DD'), 45000, 'Efectivo', 'Pagado', 2);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (3, TO_DATE('2024-03-01','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 3);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (4, TO_DATE('2024-04-01','YYYY-MM-DD'), 30000, 'Tarjeta', 'Pagado', 4);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (5, TO_DATE('2024-05-01','YYYY-MM-DD'), 35000, 'Efectivo', 'Pagado', 5);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (6, TO_DATE('2024-06-01','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 6);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (7, TO_DATE('2024-07-01','YYYY-MM-DD'), 45000, 'Tarjeta', 'Pagado', 7);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (8, TO_DATE('2024-08-01','YYYY-MM-DD'), 90000, 'Efectivo', 'Pagado', 8);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (9, TO_DATE('2024-09-01','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 9);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (10, TO_DATE('2024-10-01','YYYY-MM-DD'), 35000, 'Tarjeta', 'Pagado', 10);

INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (11, TO_DATE('2024-10-27','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 11);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (12, TO_DATE('2024-11-26','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 12);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (13, TO_DATE('2024-12-26','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 13);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (14, TO_DATE('2025-01-25','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 14);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (15, TO_DATE('2025-02-24','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 15);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (16, TO_DATE('2025-03-26','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 16);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (17, TO_DATE('2025-04-25','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 17);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (18, TO_DATE('2025-05-25','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 18);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (19, TO_DATE('2025-06-24','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 19);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (20, TO_DATE('2025-07-24','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 20);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (21, TO_DATE('2025-08-23','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 21);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (22, TO_DATE('2025-09-22','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 22);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (23, TO_DATE('2025-10-22','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 23);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (24, TO_DATE('2025-11-21','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 24);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (25, TO_DATE('2025-12-21','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 25);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (26, TO_DATE('2026-01-20','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 26);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (27, TO_DATE('2026-02-19','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 27);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (28, TO_DATE('2026-03-21','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 28);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (29, TO_DATE('2026-04-20','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 29);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (30, TO_DATE('2026-05-20','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 30);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (31, TO_DATE('2026-06-19','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 31);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (32, TO_DATE('2026-07-19','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 32);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (33, TO_DATE('2026-08-18','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 33);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (34, TO_DATE('2026-09-17','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 34);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (35, TO_DATE('2026-10-17','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 35);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (36, TO_DATE('2026-11-16','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 36);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (37, TO_DATE('2026-12-16','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 37);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (38, TO_DATE('2027-01-15','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 38);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (39, TO_DATE('2027-02-14','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 39);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (40, TO_DATE('2027-03-16','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 40);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (41, TO_DATE('2027-04-15','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 41);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (42, TO_DATE('2027-05-15','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 42);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (43, TO_DATE('2027-06-14','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 43);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (44, TO_DATE('2027-07-14','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 44);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (45, TO_DATE('2027-08-13','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 45);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (46, TO_DATE('2027-09-12','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 46);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (47, TO_DATE('2027-10-12','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 47);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (48, TO_DATE('2027-11-11','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 48);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (49, TO_DATE('2027-12-11','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 49);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (50, TO_DATE('2028-01-10','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 50);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (51, TO_DATE('2028-02-09','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 51);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (52, TO_DATE('2028-03-10','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 52);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (53, TO_DATE('2028-04-09','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 53);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (54, TO_DATE('2028-05-09','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 54);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (55, TO_DATE('2028-06-08','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 55);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (56, TO_DATE('2028-07-08','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 56);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (57, TO_DATE('2028-08-07','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 57);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (58, TO_DATE('2028-09-06','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 58);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (59, TO_DATE('2028-10-06','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 59);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (60, TO_DATE('2028-11-05','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 60);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (61, TO_DATE('2028-12-05','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 61);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (62, TO_DATE('2029-01-04','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 62);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (63, TO_DATE('2029-02-03','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 63);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (64, TO_DATE('2029-03-05','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 64);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (65, TO_DATE('2029-04-04','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 65);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (66, TO_DATE('2029-05-04','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 66);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (67, TO_DATE('2029-06-03','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 67);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (68, TO_DATE('2029-07-03','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 68);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (69, TO_DATE('2029-08-02','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 69);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (70, TO_DATE('2029-09-01','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 70);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (71, TO_DATE('2029-10-01','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 71);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (72, TO_DATE('2029-10-31','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 72);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (73, TO_DATE('2029-11-30','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 73);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (74, TO_DATE('2029-12-30','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 74);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (75, TO_DATE('2030-01-29','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 75);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (76, TO_DATE('2030-02-28','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 76);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (77, TO_DATE('2030-03-30','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 77);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (78, TO_DATE('2030-04-29','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 78);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (79, TO_DATE('2030-05-29','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 79);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (80, TO_DATE('2030-06-28','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 80);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (81, TO_DATE('2030-07-28','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 81);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (82, TO_DATE('2030-08-27','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 82);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (83, TO_DATE('2030-09-26','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 83);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (84, TO_DATE('2030-10-26','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 84);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (85, TO_DATE('2030-11-25','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 85);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (86, TO_DATE('2030-12-25','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 86);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (87, TO_DATE('2031-01-24','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 87);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (88, TO_DATE('2031-02-23','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 88);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (89, TO_DATE('2031-03-25','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 89);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (90, TO_DATE('2031-04-24','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 90);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (91, TO_DATE('2031-05-24','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 91);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (92, TO_DATE('2031-06-23','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 92);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (93, TO_DATE('2031-07-23','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 93);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (94, TO_DATE('2031-08-22','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 94);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (95, TO_DATE('2031-09-21','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 95);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (96, TO_DATE('2031-10-21','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 96);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (97, TO_DATE('2031-11-20','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 97);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (98, TO_DATE('2031-12-20','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 98);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (99, TO_DATE('2032-01-19','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 99);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (100, TO_DATE('2032-02-18','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 100);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (101, TO_DATE('2032-03-19','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 101);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (102, TO_DATE('2032-04-18','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 102);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (103, TO_DATE('2032-05-18','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 103);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (104, TO_DATE('2032-06-17','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 104);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (105, TO_DATE('2032-07-17','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 105);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (106, TO_DATE('2032-08-16','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 106);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (107, TO_DATE('2032-09-15','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 107);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (108, TO_DATE('2032-10-15','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 108);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (109, TO_DATE('2032-11-14','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 109);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (110, TO_DATE('2032-12-14','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 110);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (111, TO_DATE('2033-01-13','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 111);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (112, TO_DATE('2033-02-12','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 112);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (113, TO_DATE('2033-03-14','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 113);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (114, TO_DATE('2033-04-13','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 114);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (115, TO_DATE('2033-05-13','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 115);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (116, TO_DATE('2033-06-12','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 116);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (117, TO_DATE('2033-07-12','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 117);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (118, TO_DATE('2033-08-11','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 118);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (119, TO_DATE('2033-09-10','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 119);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (120, TO_DATE('2033-10-10','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 120);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (121, TO_DATE('2033-11-09','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 121);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (122, TO_DATE('2033-12-09','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 122);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (123, TO_DATE('2034-01-08','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 123);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (124, TO_DATE('2034-02-07','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 124);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (125, TO_DATE('2034-03-09','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 125);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (126, TO_DATE('2034-04-08','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 126);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (127, TO_DATE('2034-05-08','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 127);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (128, TO_DATE('2034-06-07','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 128);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (129, TO_DATE('2034-07-07','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 129);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (130, TO_DATE('2034-08-06','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 130);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (131, TO_DATE('2034-09-05','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 131);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (132, TO_DATE('2034-10-05','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 132);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (133, TO_DATE('2034-11-04','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 133);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (134, TO_DATE('2034-12-04','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 134);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (135, TO_DATE('2035-01-03','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 135);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (136, TO_DATE('2035-02-02','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 136);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (137, TO_DATE('2035-03-04','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 137);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (138, TO_DATE('2035-04-03','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 138);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (139, TO_DATE('2035-05-03','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 139);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (140, TO_DATE('2035-06-02','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 140);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (141, TO_DATE('2035-07-02','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 141);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (142, TO_DATE('2035-08-01','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 142);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (143, TO_DATE('2035-08-31','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 143);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (144, TO_DATE('2035-09-30','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 144);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (145, TO_DATE('2035-10-30','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 145);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (146, TO_DATE('2035-11-29','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 146);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (147, TO_DATE('2035-12-29','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 147);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (148, TO_DATE('2036-01-28','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 148);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (149, TO_DATE('2036-02-27','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 149);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (150, TO_DATE('2036-03-28','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 150);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (151, TO_DATE('2036-04-27','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 151);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (152, TO_DATE('2036-05-27','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 152);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (153, TO_DATE('2036-06-26','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 153);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (154, TO_DATE('2036-07-26','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 154);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (155, TO_DATE('2036-08-25','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 155);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (156, TO_DATE('2036-09-24','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 156);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (157, TO_DATE('2036-10-24','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 157);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (158, TO_DATE('2036-11-23','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 158);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (159, TO_DATE('2036-12-23','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 159);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (160, TO_DATE('2037-01-22','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 160);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (161, TO_DATE('2037-02-21','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 161);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (162, TO_DATE('2037-03-23','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 162);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (163, TO_DATE('2037-04-22','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 163);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (164, TO_DATE('2037-05-22','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 164);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (165, TO_DATE('2037-06-21','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 165);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (166, TO_DATE('2037-07-21','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 166);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (167, TO_DATE('2037-08-20','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 167);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (168, TO_DATE('2037-09-19','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 168);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (169, TO_DATE('2037-10-19','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 169);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (170, TO_DATE('2037-11-18','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 170);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (171, TO_DATE('2037-12-18','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 171);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (172, TO_DATE('2038-01-17','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 172);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (173, TO_DATE('2038-02-16','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 173);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (174, TO_DATE('2038-03-18','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 174);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (175, TO_DATE('2038-04-17','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 175);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (176, TO_DATE('2038-05-17','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 176);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (177, TO_DATE('2038-06-16','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 177);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (178, TO_DATE('2038-07-16','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 178);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (179, TO_DATE('2038-08-15','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 179);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (180, TO_DATE('2038-09-14','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 180);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (181, TO_DATE('2038-10-14','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 181);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (182, TO_DATE('2038-11-13','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 182);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (183, TO_DATE('2038-12-13','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 183);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (184, TO_DATE('2039-01-12','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 184);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (185, TO_DATE('2039-02-11','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 185);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (186, TO_DATE('2039-03-13','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 186);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (187, TO_DATE('2039-04-12','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 187);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (188, TO_DATE('2039-05-12','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 188);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (189, TO_DATE('2039-06-11','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 189);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (190, TO_DATE('2039-07-11','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 190);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (191, TO_DATE('2039-08-10','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 191);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (192, TO_DATE('2039-09-09','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 192);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (193, TO_DATE('2039-10-09','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 193);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (194, TO_DATE('2039-11-08','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 194);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (195, TO_DATE('2039-12-08','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 195);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (196, TO_DATE('2040-01-07','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 196);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (197, TO_DATE('2040-02-06','YYYY-MM-DD'), 45000, 'Transferencia', 'Pagado', 197);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (198, TO_DATE('2040-03-07','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 198);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (199, TO_DATE('2040-04-06','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 199);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (200, TO_DATE('2040-05-06','YYYY-MM-DD'), 35000, 'Transferencia', 'Pagado', 200);


-- ASISTENCIA (10)
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (1, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), 1);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (2, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), 2);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (3, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), 3);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (4, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:00','YYYY-MM-DD HH24:MI'), 4);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (5, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), 5);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (6, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), 6);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (7, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:00','YYYY-MM-DD HH24:MI'), 7);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (8, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), 8);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (9, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:45','YYYY-MM-DD HH24:MI'), 9);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (10, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), 10);

INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (11, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:56','YYYY-MM-DD HH24:MI'), 11);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (12, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:42','YYYY-MM-DD HH24:MI'), 12);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (13, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:28','YYYY-MM-DD HH24:MI'), 13);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (14, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:14','YYYY-MM-DD HH24:MI'), 14);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (15, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), 15);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (16, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:46','YYYY-MM-DD HH24:MI'), 16);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (17, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:32','YYYY-MM-DD HH24:MI'), 17);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (18, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:18','YYYY-MM-DD HH24:MI'), 18);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (19, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:04','YYYY-MM-DD HH24:MI'), 19);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (20, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:50','YYYY-MM-DD HH24:MI'), 20);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (21, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:36','YYYY-MM-DD HH24:MI'), 21);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (22, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:22','YYYY-MM-DD HH24:MI'), 22);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (23, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:08','YYYY-MM-DD HH24:MI'), 23);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (24, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:54','YYYY-MM-DD HH24:MI'), 24);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (25, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:40','YYYY-MM-DD HH24:MI'), 25);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (26, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:26','YYYY-MM-DD HH24:MI'), 26);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (27, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:12','YYYY-MM-DD HH24:MI'), 27);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (28, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:58','YYYY-MM-DD HH24:MI'), 28);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (29, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:44','YYYY-MM-DD HH24:MI'), 29);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (30, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), 30);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (31, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:46','YYYY-MM-DD HH24:MI'), 31);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (32, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:32','YYYY-MM-DD HH24:MI'), 32);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (33, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:18','YYYY-MM-DD HH24:MI'), 33);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (34, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:04','YYYY-MM-DD HH24:MI'), 34);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (35, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:50','YYYY-MM-DD HH24:MI'), 35);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (36, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:36','YYYY-MM-DD HH24:MI'), 36);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (37, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:22','YYYY-MM-DD HH24:MI'), 37);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (38, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:08','YYYY-MM-DD HH24:MI'), 38);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (39, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:54','YYYY-MM-DD HH24:MI'), 39);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (40, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:40','YYYY-MM-DD HH24:MI'), 40);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (41, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:26','YYYY-MM-DD HH24:MI'), 41);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (42, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:12','YYYY-MM-DD HH24:MI'), 42);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (43, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:58','YYYY-MM-DD HH24:MI'), 43);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (44, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:44','YYYY-MM-DD HH24:MI'), 44);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (45, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:30','YYYY-MM-DD HH24:MI'), 45);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (46, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:16','YYYY-MM-DD HH24:MI'), 46);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (47, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:02','YYYY-MM-DD HH24:MI'), 47);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (48, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:48','YYYY-MM-DD HH24:MI'), 48);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (49, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:34','YYYY-MM-DD HH24:MI'), 49);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (50, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:20','YYYY-MM-DD HH24:MI'), 50);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (51, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:06','YYYY-MM-DD HH24:MI'), 51);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (52, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:52','YYYY-MM-DD HH24:MI'), 52);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (53, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:38','YYYY-MM-DD HH24:MI'), 53);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (54, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:24','YYYY-MM-DD HH24:MI'), 54);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (55, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:10','YYYY-MM-DD HH24:MI'), 55);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (56, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:56','YYYY-MM-DD HH24:MI'), 56);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (57, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:42','YYYY-MM-DD HH24:MI'), 57);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (58, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:28','YYYY-MM-DD HH24:MI'), 58);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (59, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:14','YYYY-MM-DD HH24:MI'), 59);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (60, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), 60);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (61, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:16','YYYY-MM-DD HH24:MI'), 61);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (62, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:02','YYYY-MM-DD HH24:MI'), 62);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (63, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:48','YYYY-MM-DD HH24:MI'), 63);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (64, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:34','YYYY-MM-DD HH24:MI'), 64);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (65, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:20','YYYY-MM-DD HH24:MI'), 65);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (66, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:06','YYYY-MM-DD HH24:MI'), 66);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (67, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:52','YYYY-MM-DD HH24:MI'), 67);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (68, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:38','YYYY-MM-DD HH24:MI'), 68);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (69, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:24','YYYY-MM-DD HH24:MI'), 69);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (70, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:10','YYYY-MM-DD HH24:MI'), 70);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (71, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:56','YYYY-MM-DD HH24:MI'), 71);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (72, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:42','YYYY-MM-DD HH24:MI'), 72);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (73, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:28','YYYY-MM-DD HH24:MI'), 73);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (74, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:14','YYYY-MM-DD HH24:MI'), 74);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (75, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:00','YYYY-MM-DD HH24:MI'), 75);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (76, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:46','YYYY-MM-DD HH24:MI'), 76);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (77, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:32','YYYY-MM-DD HH24:MI'), 77);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (78, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:18','YYYY-MM-DD HH24:MI'), 78);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (79, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:04','YYYY-MM-DD HH24:MI'), 79);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (80, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:50','YYYY-MM-DD HH24:MI'), 80);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (81, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:36','YYYY-MM-DD HH24:MI'), 81);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (82, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:22','YYYY-MM-DD HH24:MI'), 82);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (83, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:08','YYYY-MM-DD HH24:MI'), 83);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (84, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:54','YYYY-MM-DD HH24:MI'), 84);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (85, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:40','YYYY-MM-DD HH24:MI'), 85);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (86, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:26','YYYY-MM-DD HH24:MI'), 86);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (87, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:12','YYYY-MM-DD HH24:MI'), 87);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (88, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:58','YYYY-MM-DD HH24:MI'), 88);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (89, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:44','YYYY-MM-DD HH24:MI'), 89);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (90, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), 90);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (91, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:46','YYYY-MM-DD HH24:MI'), 91);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (92, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:32','YYYY-MM-DD HH24:MI'), 92);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (93, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:18','YYYY-MM-DD HH24:MI'), 93);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (94, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:04','YYYY-MM-DD HH24:MI'), 94);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (95, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:50','YYYY-MM-DD HH24:MI'), 95);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (96, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:36','YYYY-MM-DD HH24:MI'), 96);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (97, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:22','YYYY-MM-DD HH24:MI'), 97);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (98, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:08','YYYY-MM-DD HH24:MI'), 98);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (99, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:54','YYYY-MM-DD HH24:MI'), 99);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (100, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:40','YYYY-MM-DD HH24:MI'), 100);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (101, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:26','YYYY-MM-DD HH24:MI'), 101);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (102, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:12','YYYY-MM-DD HH24:MI'), 102);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (103, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:58','YYYY-MM-DD HH24:MI'), 103);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (104, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:44','YYYY-MM-DD HH24:MI'), 104);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (105, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:30','YYYY-MM-DD HH24:MI'), 105);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (106, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:16','YYYY-MM-DD HH24:MI'), 106);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (107, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:02','YYYY-MM-DD HH24:MI'), 107);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (108, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:48','YYYY-MM-DD HH24:MI'), 108);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (109, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:34','YYYY-MM-DD HH24:MI'), 109);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (110, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:20','YYYY-MM-DD HH24:MI'), 110);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (111, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:06','YYYY-MM-DD HH24:MI'), 111);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (112, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:52','YYYY-MM-DD HH24:MI'), 112);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (113, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:38','YYYY-MM-DD HH24:MI'), 113);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (114, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:24','YYYY-MM-DD HH24:MI'), 114);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (115, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:10','YYYY-MM-DD HH24:MI'), 115);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (116, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:56','YYYY-MM-DD HH24:MI'), 116);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (117, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:42','YYYY-MM-DD HH24:MI'), 117);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (118, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:28','YYYY-MM-DD HH24:MI'), 118);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (119, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:14','YYYY-MM-DD HH24:MI'), 119);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (120, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), 120);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (121, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:16','YYYY-MM-DD HH24:MI'), 121);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (122, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:02','YYYY-MM-DD HH24:MI'), 122);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (123, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:48','YYYY-MM-DD HH24:MI'), 123);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (124, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:34','YYYY-MM-DD HH24:MI'), 124);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (125, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:20','YYYY-MM-DD HH24:MI'), 125);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (126, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:06','YYYY-MM-DD HH24:MI'), 126);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (127, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:52','YYYY-MM-DD HH24:MI'), 127);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (128, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:38','YYYY-MM-DD HH24:MI'), 128);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (129, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:24','YYYY-MM-DD HH24:MI'), 129);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (130, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:10','YYYY-MM-DD HH24:MI'), 130);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (131, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:56','YYYY-MM-DD HH24:MI'), 131);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (132, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:42','YYYY-MM-DD HH24:MI'), 132);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (133, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:28','YYYY-MM-DD HH24:MI'), 133);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (134, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:14','YYYY-MM-DD HH24:MI'), 134);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (135, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), 135);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (136, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:46','YYYY-MM-DD HH24:MI'), 136);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (137, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:32','YYYY-MM-DD HH24:MI'), 137);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (138, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:18','YYYY-MM-DD HH24:MI'), 138);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (139, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:04','YYYY-MM-DD HH24:MI'), 139);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (140, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:50','YYYY-MM-DD HH24:MI'), 140);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (141, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:36','YYYY-MM-DD HH24:MI'), 141);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (142, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:22','YYYY-MM-DD HH24:MI'), 142);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (143, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:08','YYYY-MM-DD HH24:MI'), 143);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (144, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:54','YYYY-MM-DD HH24:MI'), 144);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (145, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:40','YYYY-MM-DD HH24:MI'), 145);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (146, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:26','YYYY-MM-DD HH24:MI'), 146);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (147, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:12','YYYY-MM-DD HH24:MI'), 147);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (148, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:58','YYYY-MM-DD HH24:MI'), 148);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (149, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:44','YYYY-MM-DD HH24:MI'), 149);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (150, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), 150);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (151, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:46','YYYY-MM-DD HH24:MI'), 151);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (152, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:32','YYYY-MM-DD HH24:MI'), 152);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (153, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:18','YYYY-MM-DD HH24:MI'), 153);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (154, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:04','YYYY-MM-DD HH24:MI'), 154);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (155, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:50','YYYY-MM-DD HH24:MI'), 155);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (156, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:36','YYYY-MM-DD HH24:MI'), 156);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (157, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:22','YYYY-MM-DD HH24:MI'), 157);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (158, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:08','YYYY-MM-DD HH24:MI'), 158);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (159, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:54','YYYY-MM-DD HH24:MI'), 159);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (160, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:40','YYYY-MM-DD HH24:MI'), 160);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (161, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:26','YYYY-MM-DD HH24:MI'), 161);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (162, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:12','YYYY-MM-DD HH24:MI'), 162);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (163, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:58','YYYY-MM-DD HH24:MI'), 163);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (164, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:44','YYYY-MM-DD HH24:MI'), 164);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (165, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), 165);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (166, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:16','YYYY-MM-DD HH24:MI'), 166);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (167, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:02','YYYY-MM-DD HH24:MI'), 167);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (168, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:48','YYYY-MM-DD HH24:MI'), 168);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (169, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:34','YYYY-MM-DD HH24:MI'), 169);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (170, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:20','YYYY-MM-DD HH24:MI'), 170);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (171, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:06','YYYY-MM-DD HH24:MI'), 171);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (172, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:52','YYYY-MM-DD HH24:MI'), 172);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (173, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:38','YYYY-MM-DD HH24:MI'), 173);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (174, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:24','YYYY-MM-DD HH24:MI'), 174);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (175, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:10','YYYY-MM-DD HH24:MI'), 175);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (176, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:56','YYYY-MM-DD HH24:MI'), 176);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (177, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:42','YYYY-MM-DD HH24:MI'), 177);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (178, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:28','YYYY-MM-DD HH24:MI'), 178);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (179, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:14','YYYY-MM-DD HH24:MI'), 179);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (180, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:30','YYYY-MM-DD HH24:MI'), 180);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (181, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:16','YYYY-MM-DD HH24:MI'), 181);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (182, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:02','YYYY-MM-DD HH24:MI'), 182);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (183, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:48','YYYY-MM-DD HH24:MI'), 183);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (184, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:34','YYYY-MM-DD HH24:MI'), 184);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (185, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:20','YYYY-MM-DD HH24:MI'), 185);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (186, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:06','YYYY-MM-DD HH24:MI'), 186);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (187, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:52','YYYY-MM-DD HH24:MI'), 187);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (188, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:38','YYYY-MM-DD HH24:MI'), 188);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (189, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:24','YYYY-MM-DD HH24:MI'), 189);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (190, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:10','YYYY-MM-DD HH24:MI'), 190);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (191, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:56','YYYY-MM-DD HH24:MI'), 191);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (192, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 07:42','YYYY-MM-DD HH24:MI'), 192);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (193, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:28','YYYY-MM-DD HH24:MI'), 193);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (194, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 11:14','YYYY-MM-DD HH24:MI'), 194);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (195, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), 195);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (196, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:46','YYYY-MM-DD HH24:MI'), 196);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (197, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:32','YYYY-MM-DD HH24:MI'), 197);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (198, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 10:18','YYYY-MM-DD HH24:MI'), 198);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (199, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 08:04','YYYY-MM-DD HH24:MI'), 199);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (200, TO_DATE('2024-08-01','YYYY-MM-DD'), TO_DATE('2024-08-01 08:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-01 09:50','YYYY-MM-DD HH24:MI'), 200);
-- RUTINA (5)
INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador) VALUES (1, 'Full Body', 'Rutina completa para todo el cuerpo', 'Intermedio', 1);
INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador) VALUES (2, 'Cardio', 'Rutina enfocada en cardio', 'Principiante', 2);
INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador) VALUES (3, 'Fuerza', 'Rutina para aumentar fuerza', 'Avanzado', 3);
INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador) VALUES (4, 'Flexibilidad', 'Rutina de estiramientos y flexibilidad', 'Principiante', 4);
INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador) VALUES (5, 'HIIT', 'Entrenamiento de alta intensidad', 'Intermedio', 5);

-- SOCIO_RUTINA (5)
INSERT INTO SOCIO_RUTINA (id_socio_rutina, fecha_asignacion, estado, id_socio, id_rutina) VALUES (1, TO_DATE('2024-08-01','YYYY-MM-DD'), 'Activo', 1, 1);
INSERT INTO SOCIO_RUTINA (id_socio_rutina, fecha_asignacion, estado, id_socio, id_rutina) VALUES (2, TO_DATE('2024-08-02','YYYY-MM-DD'), 'Activo', 2, 2);
INSERT INTO SOCIO_RUTINA (id_socio_rutina, fecha_asignacion, estado, id_socio, id_rutina) VALUES (3, TO_DATE('2024-08-03','YYYY-MM-DD'), 'Activo', 3, 3);
INSERT INTO SOCIO_RUTINA (id_socio_rutina, fecha_asignacion, estado, id_socio, id_rutina) VALUES (4, TO_DATE('2024-08-04','YYYY-MM-DD'), 'Activo', 4, 4);
INSERT INTO SOCIO_RUTINA (id_socio_rutina, fecha_asignacion, estado, id_socio, id_rutina) VALUES (5, TO_DATE('2024-08-05','YYYY-MM-DD'), 'Activo', 5, 5);

-- EJERCICIO (5)
INSERT INTO EJERCICIO (id_ejercicio, nombre_ejercicio, grupo_muscular, descripcion) VALUES (1, 'Sentadilla', 'Piernas', 'Sentadilla con barra');
INSERT INTO EJERCICIO (id_ejercicio, nombre_ejercicio, grupo_muscular, descripcion) VALUES (2, 'Press de banca', 'Pecho', 'Press de banca con barra');
INSERT INTO EJERCICIO (id_ejercicio, nombre_ejercicio, grupo_muscular, descripcion) VALUES (3, 'Curl de bíceps', 'Brazos', 'Curl con mancuernas');
INSERT INTO EJERCICIO (id_ejercicio, nombre_ejercicio, grupo_muscular, descripcion) VALUES (4, 'Plancha', 'Abdominales', 'Mantener posición de plancha');
INSERT INTO EJERCICIO (id_ejercicio, nombre_ejercicio, grupo_muscular, descripcion) VALUES (5, 'Burpee', 'Cuerpo completo', 'Ejercicio de alta intensidad');

-- RUTINA_EJERCICIO (5)
INSERT INTO RUTINA_EJERCICIO (id_rutina, id_ejercicio, repeticiones, series, tiempo_descanso) VALUES (1, 1, 15, 3, 60);
INSERT INTO RUTINA_EJERCICIO (id_rutina, id_ejercicio, repeticiones, series, tiempo_descanso) VALUES (1, 2, 12, 3, 60);
INSERT INTO RUTINA_EJERCICIO (id_rutina, id_ejercicio, repeticiones, series, tiempo_descanso) VALUES (2, 4, 60, 4, 30);
INSERT INTO RUTINA_EJERCICIO (id_rutina, id_ejercicio, repeticiones, series, tiempo_descanso) VALUES (3, 3, 10, 4, 90);
INSERT INTO RUTINA_EJERCICIO (id_rutina, id_ejercicio, repeticiones, series, tiempo_descanso) VALUES (5, 5, 20, 3, 45);

