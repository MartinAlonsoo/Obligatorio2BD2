CREATE OR REPLACE PROCEDURE PRC_TOP_ITEMS_EQUIPADOS (
    p_categoria IN VARCHAR2 DEFAULT NULL
)
IS
    CURSOR c_top_items IS
        SELECT
            i.nombre,
            i.categoria,
            COUNT(ppi.nombreItem) AS cantidad_equipado
        FROM
            Personaje_Posee_Items ppi
        JOIN
            Items i ON ppi.nombreItem = i.nombre
        WHERE
            ppi.equipado = 'S'
            AND (p_categoria IS NULL OR i.categoria = p_categoria)
        GROUP BY
            i.nombre, i.categoria
        ORDER BY
            cantidad_equipado DESC
        FETCH FIRST 10 ROWS ONLY;

BEGIN
    IF p_categoria IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('--- Top 10 Items Más Equipados (Todas las Categorías) ---');
    ELSE
        DBMS_OUTPUT.PUT_LINE('--- Top 10 Items Más Equipados (Categoría: ' || p_categoria || ') ---');
    END IF;
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');

    FOR item_rec IN c_top_items LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Item: ' || RPAD(item_rec.nombre, 25) || 
            'Categoría: ' || RPAD(item_rec.categoria, 15) || 
            'Equipado: ' || item_rec.cantidad_equipado || ' veces'
        );
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al generar el reporte: ' || SQLERRM);
        RAISE;
END PRC_TOP_ITEMS_EQUIPADOS;