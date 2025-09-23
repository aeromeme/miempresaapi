-- =====================================================
-- Funciones y Procedimientos para Sistema de Ventas
-- Base de datos: PostgreSQL
-- =====================================================

-- =====================================================
-- Función: Verificar stock disponible
-- =====================================================
CREATE OR REPLACE FUNCTION verificar_stock_disponible(
    p_producto_id UUID,
    p_cantidad_solicitada INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    stock_actual INTEGER;
BEGIN
    SELECT stock INTO stock_actual 
    FROM productos 
    WHERE id = p_producto_id;
    
    IF stock_actual IS NULL THEN
        RETURN FALSE; -- Producto no encontrado
    END IF;
    
    RETURN stock_actual >= p_cantidad_solicitada;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Función: Reducir stock de producto
-- =====================================================
CREATE OR REPLACE FUNCTION reducir_stock_producto(
    p_producto_id UUID,
    p_cantidad INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    stock_actual INTEGER;
BEGIN
    -- Verificar stock actual
    SELECT stock INTO stock_actual 
    FROM productos 
    WHERE id = p_producto_id;
    
    IF stock_actual IS NULL OR stock_actual < p_cantidad THEN
        RETURN FALSE; -- No hay suficiente stock
    END IF;
    
    -- Reducir stock
    UPDATE productos 
    SET stock = stock - p_cantidad,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = p_producto_id;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Función: Obtener ventas de un cliente en un período
-- =====================================================
CREATE OR REPLACE FUNCTION obtener_ventas_cliente(
    p_cliente_id UUID,
    p_fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_fecha_fin TIMESTAMP WITH TIME ZONE DEFAULT NULL
) RETURNS TABLE (
    venta_id UUID,
    fecha TIMESTAMP WITH TIME ZONE,
    total_valor DECIMAL(12,2),
    total_moneda VARCHAR(3),
    cantidad_productos BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id as venta_id,
        v.fecha,
        v.total_valor,
        v.total_moneda,
        COUNT(lv.id) as cantidad_productos
    FROM ventas v
    LEFT JOIN lineas_venta lv ON v.id = lv.venta_id
    WHERE v.cliente_id = p_cliente_id
        AND (p_fecha_inicio IS NULL OR v.fecha >= p_fecha_inicio)
        AND (p_fecha_fin IS NULL OR v.fecha <= p_fecha_fin)
    GROUP BY v.id, v.fecha, v.total_valor, v.total_moneda
    ORDER BY v.fecha DESC;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Función: Productos más vendidos
-- =====================================================
CREATE OR REPLACE FUNCTION productos_mas_vendidos(
    p_fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_fecha_fin TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_limite INTEGER DEFAULT 10
) RETURNS TABLE (
    producto_id UUID,
    nombre_producto VARCHAR(200),
    cantidad_vendida BIGINT,
    total_ingresos DECIMAL(12,2),
    moneda VARCHAR(3)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id as producto_id,
        p.nombre as nombre_producto,
        SUM(lv.cantidad) as cantidad_vendida,
        SUM(lv.total_valor) as total_ingresos,
        lv.total_moneda as moneda
    FROM productos p
    INNER JOIN lineas_venta lv ON p.id = lv.producto_id
    INNER JOIN ventas v ON lv.venta_id = v.id
    WHERE (p_fecha_inicio IS NULL OR v.fecha >= p_fecha_inicio)
        AND (p_fecha_fin IS NULL OR v.fecha <= p_fecha_fin)
    GROUP BY p.id, p.nombre, lv.total_moneda
    ORDER BY cantidad_vendida DESC
    LIMIT p_limite;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Función: Reporte de ventas por moneda
-- =====================================================
CREATE OR REPLACE FUNCTION reporte_ventas_por_moneda(
    p_fecha_inicio TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    p_fecha_fin TIMESTAMP WITH TIME ZONE DEFAULT NULL
) RETURNS TABLE (
    moneda VARCHAR(3),
    total_ventas BIGINT,
    total_ingresos DECIMAL(12,2),
    promedio_venta DECIMAL(12,2)
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.total_moneda as moneda,
        COUNT(v.id) as total_ventas,
        SUM(v.total_valor) as total_ingresos,
        AVG(v.total_valor) as promedio_venta
    FROM ventas v
    WHERE (p_fecha_inicio IS NULL OR v.fecha >= p_fecha_inicio)
        AND (p_fecha_fin IS NULL OR v.fecha <= p_fecha_fin)
    GROUP BY v.total_moneda
    ORDER BY total_ingresos DESC;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Procedimiento: Procesar venta completa
-- =====================================================
CREATE OR REPLACE FUNCTION procesar_venta_completa(
    p_cliente_id UUID,
    p_productos JSONB -- Formato: [{"producto_id": "uuid", "cantidad": 2}]
) RETURNS TABLE (
    success BOOLEAN,
    venta_id UUID,
    mensaje TEXT
) AS $$
DECLARE
    nueva_venta_id UUID;
    producto_item JSONB;
    producto_id_item UUID;
    cantidad_item INTEGER;
    precio_producto DECIMAL(12,2);
    moneda_producto VARCHAR(3);
    stock_suficiente BOOLEAN;
BEGIN
    -- Crear nueva venta
    INSERT INTO ventas (cliente_id) 
    VALUES (p_cliente_id) 
    RETURNING id INTO nueva_venta_id;
    
    -- Procesar cada producto
    FOR producto_item IN SELECT * FROM jsonb_array_elements(p_productos)
    LOOP
        producto_id_item := (producto_item->>'producto_id')::UUID;
        cantidad_item := (producto_item->>'cantidad')::INTEGER;
        
        -- Obtener precio y verificar stock
        SELECT precio_valor, precio_moneda, verificar_stock_disponible(id, cantidad_item)
        INTO precio_producto, moneda_producto, stock_suficiente
        FROM productos 
        WHERE id = producto_id_item;
        
        IF NOT stock_suficiente THEN
            -- Eliminar venta creada
            DELETE FROM ventas WHERE id = nueva_venta_id;
            RETURN QUERY SELECT FALSE, NULL::UUID, 'Stock insuficiente para producto: ' || producto_id_item::TEXT;
            RETURN;
        END IF;
        
        -- Reducir stock
        IF NOT reducir_stock_producto(producto_id_item, cantidad_item) THEN
            -- Eliminar venta creada
            DELETE FROM ventas WHERE id = nueva_venta_id;
            RETURN QUERY SELECT FALSE, NULL::UUID, 'Error al reducir stock para producto: ' || producto_id_item::TEXT;
            RETURN;
        END IF;
        
        -- Agregar línea de venta
        INSERT INTO lineas_venta (venta_id, producto_id, cantidad, precio_unitario_valor, precio_unitario_moneda)
        VALUES (nueva_venta_id, producto_id_item, cantidad_item, precio_producto, moneda_producto);
    END LOOP;
    
    RETURN QUERY SELECT TRUE, nueva_venta_id, 'Venta procesada exitosamente';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- Vista: Resumen de inventario
-- =====================================================
CREATE OR REPLACE VIEW vista_resumen_inventario AS
SELECT 
    p.id,
    p.nombre,
    p.precio_valor,
    p.precio_moneda,
    p.stock,
    p.stock * p.precio_valor as valor_inventario,
    CASE 
        WHEN p.stock = 0 THEN 'Sin Stock'
        WHEN p.stock <= 5 THEN 'Stock Bajo'
        WHEN p.stock <= 20 THEN 'Stock Normal'
        ELSE 'Stock Alto'
    END as estado_stock
FROM productos p
ORDER BY p.nombre;

-- =====================================================
-- Vista: Ventas del día
-- =====================================================
CREATE OR REPLACE VIEW vista_ventas_hoy AS
SELECT 
    v.id as venta_id,
    v.fecha,
    c.nombre as cliente_nombre,
    c.correo as cliente_correo,
    v.total_valor,
    v.total_moneda,
    COUNT(lv.id) as cantidad_productos
FROM ventas v
INNER JOIN clientes c ON v.cliente_id = c.id
LEFT JOIN lineas_venta lv ON v.id = lv.venta_id
WHERE DATE(v.fecha) = CURRENT_DATE
GROUP BY v.id, v.fecha, c.nombre, c.correo, v.total_valor, v.total_moneda
ORDER BY v.fecha DESC;

-- =====================================================
-- Ejemplos de uso de las funciones
-- =====================================================

-- Ejemplo 1: Verificar stock
-- SELECT verificar_stock_disponible('producto-uuid-aqui', 5);

-- Ejemplo 2: Obtener ventas de un cliente
-- SELECT * FROM obtener_ventas_cliente('cliente-uuid-aqui', '2024-01-01', '2024-12-31');

-- Ejemplo 3: Productos más vendidos del mes
-- SELECT * FROM productos_mas_vendidos(DATE_TRUNC('month', CURRENT_DATE), CURRENT_DATE, 5);

-- Ejemplo 4: Procesar venta completa
-- SELECT * FROM procesar_venta_completa(
--     'cliente-uuid-aqui',
--     '[{"producto_id": "producto-uuid-1", "cantidad": 2}, {"producto_id": "producto-uuid-2", "cantidad": 1}]'::jsonb
-- );

-- Ejemplo 5: Ver resumen de inventario
-- SELECT * FROM vista_resumen_inventario WHERE estado_stock = 'Stock Bajo';

-- Ejemplo 6: Ver ventas de hoy
-- SELECT * FROM vista_ventas_hoy;