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

-- PAGO (10)
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (1, TO_DATE('2024-01-01','YYYY-MM-DD'), 20000, 'Tarjeta', 'Pagado', 1);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (2, TO_DATE('2024-02-01','YYYY-MM-DD'), 45000, 'Efectivo', 'Pagado', 2);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (3, TO_DATE('2024-03-01','YYYY-MM-DD'), 90000, 'Transferencia', 'Pagado', 3);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (4, TO_DATE('2024-04-01','YYYY-MM-DD'), 30000, 'Tarjeta', 'Pendiente', 4);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (5, TO_DATE('2024-05-01','YYYY-MM-DD'), 35000, 'Efectivo', 'Pagado', 5);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (6, TO_DATE('2024-06-01','YYYY-MM-DD'), 20000, 'Transferencia', 'Pagado', 6);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (7, TO_DATE('2024-07-01','YYYY-MM-DD'), 45000, 'Tarjeta', 'Pendiente', 7);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (8, TO_DATE('2024-08-01','YYYY-MM-DD'), 90000, 'Efectivo', 'Pagado', 8);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (9, TO_DATE('2024-09-01','YYYY-MM-DD'), 30000, 'Transferencia', 'Pagado', 9);
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan) VALUES (10, TO_DATE('2024-10-01','YYYY-MM-DD'), 35000, 'Tarjeta', 'Pagado', 10);

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

