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
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (201, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 07:45','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 09:15','YYYY-MM-DD HH24:MI'), 1);
INSERT INTO ASISTENCIA (id_asistencia, fecha, hora_entrada, hora_salida, id_socio) VALUES (202, TO_DATE('2024-08-02','YYYY-MM-DD'), TO_DATE('2024-08-02 08:15','YYYY-MM-DD HH24:MI'), TO_DATE('2024-08-02 09:45','YYYY-MM-DD HH24:MI'), 2);









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
VALUES (201, SYSDATE, 50000, 'Efectivo', 'Pagado', 1);

INSERT INTO PAGO (id_pago, fecha_pago, monto, metodo_pago, estado, id_socio_plan)
VALUES (202, SYSDATE, 45000, 'Tarjeta', 'Pagado', 2);




//DROP TRIGGER TRG_KPI_MANTENCIONES;

CREATE OR REPLACE PROCEDURE KPI_MANTENCIONES_SUCURSAL IS
    -- Record con los datos de cada sucursal
    TYPE sucursal_rec IS RECORD (
        id_sucursal        SUCURSAL.id_sucursal%TYPE,
        nombre_sucursal    SUCURSAL.nombre_sucursal%TYPE,
        total_mantenciones NUMBER
    );

    -- Array (tabla PL/SQL indexada) de records
    TYPE mant_array IS TABLE OF sucursal_rec INDEX BY PLS_INTEGER;
    mantenciones mant_array;

    i PLS_INTEGER := 0;
BEGIN
    -- Recorre todas las sucursales
    FOR s IN (SELECT id_sucursal, nombre_sucursal FROM SUCURSAL ORDER BY id_sucursal) LOOP
        i := i + 1;
        mantenciones(i).id_sucursal := s.id_sucursal;
        mantenciones(i).nombre_sucursal := s.nombre_sucursal;

        -- Cuenta las mantenciones de las máquinas de esa sucursal
        SELECT NVL(COUNT(m.id_mantencion), 0)
        INTO mantenciones(i).total_mantenciones
        FROM MANTENCION m
        JOIN MAQUINA maq ON m.id_maquina = maq.id_maquina
        WHERE maq.id_sucursal = s.id_sucursal;

    END LOOP;

    -- Mostrar resultados
    DBMS_OUTPUT.PUT_LINE('===== KPI: MANTENCIONES REALIZADAS POR SUCURSAL =====');
    FOR j IN 1..mantenciones.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || mantenciones(j).nombre_sucursal ||
            ' | Total Mantenciones: ' || mantenciones(j).total_mantenciones
        );
    END LOOP;
END;
/

BEGIN
    KPI_MANTENCIONES_SUCURSAL;
END;
/


CREATE OR REPLACE TRIGGER TRG_KPI_MANTENCIONES_SUCURSAL
AFTER INSERT OR UPDATE OR DELETE ON MANTENCION
DECLARE
    CURSOR c_sucursales IS
        SELECT id_sucursal, nombre_sucursal FROM SUCURSAL ORDER BY id_sucursal;
    v_total NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===== TRIGGER KPI MANTENCIONES POR SUCURSAL =====');
    FOR s IN c_sucursales LOOP
        SELECT NVL(COUNT(m.id_mantencion), 0)
        INTO v_total
        FROM MANTENCION m
        JOIN MAQUINA maq ON m.id_maquina = maq.id_maquina
        WHERE maq.id_sucursal = s.id_sucursal;

        DBMS_OUTPUT.PUT_LINE('Sucursal: ' || s.nombre_sucursal || 
                             ' | Mantenciones Totales: ' || v_total);
    END LOOP;
END;
/

INSERT INTO MANTENCION (id_mantencion, fecha_mantencion, tipo_mantencion, descripcion, id_maquina)
VALUES (44, SYSDATE, 'Preventiva', 'Cambio de piezas menores', 2);


-- EN CASO DE VERIFICAR QUE HAYA MAS DE UN TRIGGER
//SELECT trigger_name, triggering_event
//FROM user_triggers
//WHERE table_name = 'MANTENCION';



// KPI
-- ===============================================
-- KPI: Entrenadores por Sucursal y Carga de Trabajo
-- ===============================================
CREATE OR REPLACE PROCEDURE kpi_entrenadores_sucursal IS
    -- RECORD para manejar datos de un entrenador y su sucursal
    TYPE entrenador_rec IS RECORD (
        id_sucursal       SUCURSAL.id_sucursal%TYPE,
        nombre_sucursal   SUCURSAL.nombre_sucursal%TYPE,
        id_entrenador     ENTRENADOR.id_entrenador%TYPE,
        nombre_entrenador VARCHAR2(200),
        total_rutinas     NUMBER
    );

    -- ARRAY (colección de records)
    TYPE t_resultados IS TABLE OF entrenador_rec INDEX BY PLS_INTEGER;
    v_resultados t_resultados;

    -- Cursor para recorrer entrenadores y sucursales
    CURSOR c_entrenadores IS
        SELECT e.id_entrenador,
               e.nombre || ' ' || e.apellido AS nombre_entrenador,
               s.id_sucursal,
               s.nombre_sucursal
        FROM ENTRENADOR e
        JOIN SUCURSAL s ON e.id_sucursal = s.id_sucursal;

    -- Variables
    v_ent entrenador_rec;
    i NUMBER := 0;

BEGIN
    OPEN c_entrenadores;
    LOOP
        FETCH c_entrenadores INTO v_ent.id_entrenador, v_ent.nombre_entrenador,
                                v_ent.id_sucursal, v_ent.nombre_sucursal;
        EXIT WHEN c_entrenadores%NOTFOUND;

        -- Contar cuántas rutinas tiene asignadas el entrenador
        SELECT COUNT(r.id_rutina)
        INTO v_ent.total_rutinas
        FROM RUTINA r
        WHERE r.id_entrenador = v_ent.id_entrenador;

        -- Guardamos el resultado en el array
        i := i + 1;
        v_resultados(i) := v_ent;
    END LOOP;
    CLOSE c_entrenadores;

    -- Mostrar resultados
    DBMS_OUTPUT.PUT_LINE('===== KPI: Entrenadores por Sucursal y Carga de Trabajo =====');
    FOR j IN 1 .. v_resultados.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || v_resultados(j).nombre_sucursal ||
            ' | Entrenador: ' || v_resultados(j).nombre_entrenador ||
            ' | Rutinas Asignadas: ' || v_resultados(j).total_rutinas
        );
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
EXEC kpi_entrenadores_sucursal;

CREATE OR REPLACE TRIGGER trg_kpi_entrenadores
AFTER INSERT ON RUTINA
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== Actualización automática del KPI de Entrenadores ===');
    FOR r IN (
        SELECT s.nombre_sucursal,
               e.nombre || ' ' || e.apellido AS nombre_entrenador,
               COUNT(rut.id_rutina) AS total_rutinas
        FROM RUTINA rut
        JOIN ENTRENADOR e ON rut.id_entrenador = e.id_entrenador
        JOIN SUCURSAL s ON e.id_sucursal = s.id_sucursal
        GROUP BY s.nombre_sucursal, e.nombre, e.apellido
        ORDER BY s.nombre_sucursal
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || r.nombre_sucursal ||
            ' | Entrenador: ' || r.nombre_entrenador ||
            ' | Rutinas Asignadas: ' || r.total_rutinas
        );
    END LOOP;
END;
/

INSERT INTO RUTINA (id_rutina, nombre_rutina, descripcion, nivel, id_entrenador)
VALUES (301, 'Fuerza Avanzada', 'Entrenamiento de fuerza de nivel avanzado', 'Avanzado', 1);




// KPI PARA ESTE SE OCUPA UNA TABLA ADICIONAL, YA QUE SE MANIPULAN DATOS DE VARIAS TABLAS 

CREATE TABLE KPI_PLANES_MAS_ACTIVOS (
    id_kpi NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    id_sucursal NUMBER,
    nombre_sucursal VARCHAR2(100),
    id_plan NUMBER,
    nombre_plan VARCHAR2(100),
    cantidad_socios NUMBER,
    fecha_actualizacion DATE
);

CREATE OR REPLACE PROCEDURE sp_kpi_planes_mas_activos IS
    -- RECORD para guardar resultados temporales
    TYPE kpi_rec IS RECORD (
        id_sucursal SUCURSAL.id_sucursal%TYPE,
        nombre_sucursal SUCURSAL.nombre_sucursal%TYPE,
        id_plan PLAN.id_plan%TYPE,
        nombre_plan PLAN.nombre_plan%TYPE,
        cantidad NUMBER
    );

    -- ARRAY de los records
    TYPE t_kpi_array IS TABLE OF kpi_rec INDEX BY PLS_INTEGER;
    v_kpis t_kpi_array;

    v_item kpi_rec;
    i NUMBER := 0;

    -- Cursor para recorrer todas las sucursales y sus planes activos
    CURSOR c_kpi IS
        SELECT s.id_sucursal,
               s.nombre_sucursal,
               p.id_plan,
               p.nombre_plan,
               COUNT(sp.id_socio) AS cantidad_socios
        FROM SUCURSAL s
        JOIN SOCIO_SUCURSAL ss ON s.id_sucursal = ss.id_sucursal
        JOIN SOCIO_PLAN sp ON ss.id_socio = sp.id_socio
        JOIN PLAN p ON sp.id_plan = p.id_plan
        WHERE sp.estado = 'Activo'
        GROUP BY s.id_sucursal, s.nombre_sucursal, p.id_plan, p.nombre_plan
        ORDER BY s.id_sucursal, cantidad_socios DESC;

BEGIN
    -- Limpiar la tabla de resultados antes de insertar los nuevos datos
    DELETE FROM KPI_PLANES_MAS_ACTIVOS;

    -- Recorremos con un ciclo
    OPEN c_kpi;
    LOOP
        FETCH c_kpi INTO v_item;
        EXIT WHEN c_kpi%NOTFOUND;

        -- Guardamos cada fila en el array
        i := i + 1;
        v_kpis(i) := v_item;
    END LOOP;
    CLOSE c_kpi;

    -- Insertamos el plan más activo por cada sucursal
    DECLARE
        v_sucursal_actual NUMBER := NULL;
        v_max NUMBER := 0;
    BEGIN
        FOR j IN 1 .. v_kpis.COUNT LOOP
            IF v_sucursal_actual IS NULL OR v_kpis(j).id_sucursal != v_sucursal_actual THEN
                -- Primer registro de la sucursal → Insertar el más alto
                INSERT INTO KPI_PLANES_MAS_ACTIVOS (
                    id_sucursal, nombre_sucursal, id_plan, nombre_plan, cantidad_socios, fecha_actualizacion
                ) VALUES (
                    v_kpis(j).id_sucursal, v_kpis(j).nombre_sucursal,
                    v_kpis(j).id_plan, v_kpis(j).nombre_plan,
                    v_kpis(j).cantidad, SYSDATE
                );
                v_sucursal_actual := v_kpis(j).id_sucursal;
            END IF;
        END LOOP;
    END;

    

    -- Mostrar resultados por consola
    DBMS_OUTPUT.PUT_LINE('===== KPI: Planes más activos por sucursal =====');
    FOR k IN 1 .. v_kpis.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Sucursal: ' || v_kpis(k).nombre_sucursal ||
            ' | Plan: ' || v_kpis(k).nombre_plan ||
            ' | Socios activos: ' || v_kpis(k).cantidad
        );
    END LOOP;
END;
/


// PROBAR EL KPI DE PLANES MAS ACTIVOS POR SUCURSAL
SET SERVEROUTPUT ON;
EXEC sp_kpi_planes_mas_activos;

SELECT * FROM KPI_PLANES_MAS_ACTIVOS;

// En este caso el trigger no es confiable ya que la tabla se muta lo que errores, mejor ejecutar el imprimir procedimiento almacenado








-- Tipo RECORD (objeto) para almacenar información de cada plan
CREATE OR REPLACE TYPE tipo_plan_info AS OBJECT (
  id_plan NUMBER,
  nombre_plan VARCHAR2(100),
  ingresos_totales NUMBER
);
/

-- Tipo TABLE (array PL/SQL) para manejar una lista de planes
CREATE OR REPLACE TYPE lista_planes AS TABLE OF tipo_plan_info;
/

CREATE OR REPLACE PROCEDURE calcular_ingresos_por_plan IS
  v_lista lista_planes := lista_planes();  -- ARRAY para guardar los resultados
  v_registro tipo_plan_info;               -- RECORD temporal
BEGIN
  FOR plan_rec IN (
    SELECT p.id_plan,
           p.nombre_plan,
           NVL(SUM(pg.monto), 0) AS total_ingresos
    FROM plan p
    LEFT JOIN socio_plan sp ON p.id_plan = sp.id_plan
    LEFT JOIN pago pg ON sp.id_socio_plan = pg.id_socio_plan
    WHERE pg.estado = 'Pagado'
    GROUP BY p.id_plan, p.nombre_plan
    ORDER BY p.id_plan
  ) LOOP
    -- Guardar en el RECORD
    v_registro := tipo_plan_info(plan_rec.id_plan, plan_rec.nombre_plan, plan_rec.total_ingresos);
    v_lista.EXTEND;
    v_lista(v_lista.LAST) := v_registro;

    -- Mostrar resultados en consola
    DBMS_OUTPUT.PUT_LINE('Plan: ' || plan_rec.nombre_plan || ' | Ingresos totales: $' || plan_rec.total_ingresos);
  END LOOP;
END;
/




// probar kpi
SET SERVEROUTPUT ON;
EXEC calcular_ingresos_por_plan;


// Razones para no implementar trigger en este kpi 
// Oracle no permite consultar la misma tabla dentro de un trigger “fila a fila” mientras se está modificando → errores ORA-04091 (tabla mutante).

//Usar triggers “a nivel de fila” + agregaciones como SUM() y GROUP BY casi siempre da problemas.

//Los triggers no muestran DBMS_OUTPUT de manera confiable cuando se dispara por insert masivo → no ves nada en consola.

//Resultado: casi siempre terminas haciendo “paquetes y triggers dobles” solo para que funcione, lo que complica más que ayuda.



