ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;



//CREATE USER gym_user IDENTIFIED BY gym1234567;
//GRANT CONNECT, RESOURCE TO gym_user;

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

-- MAQUINA (10)
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

-- MANTENCION (10)
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

-- ENTRENADOR (5)
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (1, 'Juan', 'Pérez', 'Musculación', '5551111', 'juan.perez@gym.com', 1);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (2, 'María', 'González', 'Cardio', '5552222', 'maria.gonzalez@gym.com', 2);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (3, 'Carlos', 'Ramírez', 'Crossfit', '5553333', 'carlos.ramirez@gym.com', 3);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (4, 'Lucía', 'Vega', 'Yoga', NULL, NULL, 4);
INSERT INTO ENTRENADOR (id_entrenador, nombre, apellido, especialidad, telefono, correo, id_sucursal) VALUES (5, 'Diego', 'Soto', 'Pilates', '5554444', 'diego.soto@gym.com', 5);


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

