CREATE VIEW top_productos_vendidos AS
SELECT 
    p.id,
    p.nombre,
    SUM(lv.cantidad) as total_vendido,
    SUM(lv.cantidad * p.precio_valor) as total_ingresos
FROM productos p
INNER JOIN lineas_venta lv ON p.id = lv.producto_id
INNER JOIN ventas v ON v.id = lv.venta_id
WHERE v.estado = 'A'  -- solo ventas vendidas
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC;

CREATE VIEW cliente_ingresos AS
SELECT 
    c.id,
    c.nombre,
    c.correo,
    COUNT(DISTINCT v.id) as total_ventas,
    SUM(lv.cantidad * lv.precio_unitario_valor) as total_ingresos
FROM clientes c
INNER JOIN ventas v ON c.id = v.cliente_id
INNER JOIN lineas_venta lv ON v.id = lv.venta_id
WHERE v.estado = 'A'  -- solo ventas aprobadas
GROUP BY c.id, c.nombre, c.correo
ORDER BY total_ingresos DESC;

CREATE VIEW ingresos_mensuales AS
SELECT 
    DATE_TRUNC('month', v.fecha) as periodo,
    EXTRACT(YEAR FROM v.fecha) as anio,
    EXTRACT(MONTH FROM v.fecha) as mes,
    COUNT(DISTINCT v.id) as total_ventas,
    COUNT(DISTINCT v.cliente_id) as total_clientes,
    SUM(lv.cantidad * lv.precio_unitario_valor) as ingreso_total
FROM ventas v
INNER JOIN lineas_venta lv ON v.id = lv.venta_id
WHERE v.estado = 'A'  -- solo ventas aprobadas
GROUP BY 
    DATE_TRUNC('month', v.fecha),
    EXTRACT(YEAR FROM v.fecha),
    EXTRACT(MONTH FROM v.fecha)
ORDER BY anio DESC, mes DESC;