// KPI ASISTENCIA POR SUCURSAL NUMERO 1
CREATE OR REPLACE PROCEDURE kpi_asistencia_sucursal IS
    -- RECORD para manejar datos de una sucursal
    TYPE sucursal_rec IS RECORD (
        id_sucursal   SUCURSAL.id_sucursal%TYPE,
        nombre        SUCURSAL.nombre_sucursal%TYPE,
        total_asist   NUMBER
    );

    -- ARRAY (colección de records)
    TYPE t_resultados IS TABLE OF sucursal_rec INDEX BY PLS_INTEGER;
    v_resultados t_resultados;

    -- Cursor para recorrer sucursales
    CURSOR c_sucursales IS
        SELECT id_sucursal, nombre_sucursal FROM SUCURSAL;

    -- Variables
    v_sucursal sucursal_rec;
    i NUMBER := 0;
BEGIN
    -- Recorremos todas las sucursales con un ciclo
    OPEN c_sucursales;
    LOOP
        FETCH c_sucursales INTO v_sucursal.id_sucursal, v_sucursal.nombre;
        EXIT WHEN c_sucursales%NOTFOUND;

        -- Contamos asistencias de socios en esa sucursal
        SELECT COUNT(a.id_asistencia)
        INTO v_sucursal.total_asist
        FROM ASISTENCIA a
        JOIN SOCIO_SUCURSAL ss ON a.id_socio = ss.id_socio
        WHERE ss.id_sucursal = v_sucursal.id_sucursal;

        -- Guardamos en el array
        i := i + 1;
        v_resultados(i) := v_sucursal;
    END LOOP;
    CLOSE c_sucursales;

    -- Mostramos resultados con un ciclo
    DBMS_OUTPUT.PUT_LINE('===== KPI: Asistencia por Sucursal =====');
    FOR j IN 1 .. v_resultados.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || v_resultados(j).nombre ||
            ' | Asistencias: ' || v_resultados(j).total_asist
        );
    END LOOP;
END;
/

// PARA PROBARLO
SET SERVEROUTPUT ON;
EXEC kpi_asistencia_sucursal;

// creacion de trigger
CREATE OR REPLACE TRIGGER TRG_KPI_ASISTENCIA
AFTER INSERT ON ASISTENCIA
DECLARE
BEGIN
    FOR r IN (
        SELECT s.id_sucursal, su.nombre_sucursal, COUNT(a.id_asistencia) AS total_asistencias
        FROM ASISTENCIA a
        JOIN SOCIO_SUCURSAL s ON a.id_socio = s.id_socio
        JOIN SUCURSAL su ON s.id_sucursal = su.id_sucursal
        GROUP BY s.id_sucursal, su.nombre_sucursal
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || r.nombre_sucursal || ' | Asistencias: ' || r.total_asistencias
        );
    END LOOP;
END;
/


// Probar trigger 
-- ASISTENCIA adicionales (IDs 11–20)
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (11, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 09:15','YYYY-MM-DD HH24:MI'), 1);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (12, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 09:45','YYYY-MM-DD HH24:MI'), 2);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (13, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 10:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 11:30','YYYY-MM-DD HH24:MI'), 3);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (14, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 06:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 08:00','YYYY-MM-DD HH24:MI'), 4);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (15, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 09:00','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 10:30','YYYY-MM-DD HH24:MI'), 5);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (16, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 07:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 08:30','YYYY-MM-DD HH24:MI'), 6);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (17, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 08:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 10:00','YYYY-MM-DD HH24:MI'), 7);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (18, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 09:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 10:45','YYYY-MM-DD HH24:MI'), 8);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (19, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 07:30','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 09:00','YYYY-MM-DD HH24:MI'), 9);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (20, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 10:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 11:30','YYYY-MM-DD HH24:MI'), 10);


// KPI INGRESOS TOTALES POR SUCURSAL NUMERO 5
-- Primero, abrimos DBMS_OUTPUT para mostrar resultados
SET SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE KPI_INGRESOS_SUCURSAL IS
    -- Record para almacenar sucursal y total ingresos
    TYPE sucursal_rec IS RECORD (
        id_sucursal SUCURSAL.id_sucursal%TYPE,
        nombre_sucursal SUCURSAL.nombre_sucursal%TYPE,
        total_ingresos NUMBER
    );

    -- Array (associative array) de records
    TYPE ingresos_array IS TABLE OF sucursal_rec INDEX BY PLS_INTEGER;
    ingresos ingresos_array;

    i PLS_INTEGER := 0;

BEGIN
    -- Inicializar array con los ingresos por sucursal
    FOR s IN (SELECT id_sucursal, nombre_sucursal FROM SUCURSAL ORDER BY id_sucursal) LOOP
        i := i + 1;
        ingresos(i).id_sucursal := s.id_sucursal;
        ingresos(i).nombre_sucursal := s.nombre_sucursal;
        
        -- Sumar pagos de los socios que están asignados a la sucursal
        SELECT NVL(SUM(p.monto),0)
        INTO ingresos(i).total_ingresos
        FROM PAGO p
        JOIN SOCIO_PLAN sp ON p.id_socio_plan = sp.id_socio_plan
        JOIN SOCIO_SUCURSAL ss ON sp.id_socio = ss.id_socio
        WHERE ss.id_sucursal = s.id_sucursal;

    END LOOP;

    -- Mostrar resultados
    DBMS_OUTPUT.PUT_LINE('===== KPI: Ingresos Totales por Sucursal =====');
    FOR j IN 1..ingresos.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || ingresos(j).nombre_sucursal || 
            ' | Total Ingresos: $' || TO_CHAR(ingresos(j).total_ingresos,'9999999.00')
        );
    END LOOP;
END;
/

// PROBARLO
BEGIN
    KPI_INGRESOS_SUCURSAL;
END;
/

// TRIGGER
CREATE OR REPLACE TRIGGER TRG_KPI_INGRESOS
AFTER INSERT OR UPDATE ON PAGO
DECLARE
  CURSOR c_sucursales IS
    SELECT id_sucursal, nombre_sucursal FROM SUCURSAL;
  v_total NUMBER;
BEGIN
  FOR s IN c_sucursales LOOP
    SELECT SUM(p.monto)
    INTO v_total
    FROM PAGO p
         JOIN SOCIO_PLAN sp ON p.id_socio_plan = sp.id_socio_plan
         JOIN SOCIO_SUCURSAL ss ON sp.id_socio = ss.id_socio
    WHERE ss.id_sucursal = s.id_sucursal;

    DBMS_OUTPUT.PUT_LINE('Sucursal: ' || s.nombre_sucursal || ' | Ingresos: ' || NVL(v_total,0));
  END LOOP;
END;
/


// DATOS PARA EL TRIGGER
-- Ejemplo pagos
INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan)
VALUES (11, SYSDATE, 50000, 'Efectivo', 'Pagado', 1);

INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan)
VALUES (12, SYSDATE, 45000, 'Tarjeta', 'Pagado', 2);








