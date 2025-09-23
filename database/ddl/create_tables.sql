-- =====================================================
-- DDL Script para Sistema de Ventas DDD
-- Base de datos: PostgreSQL
-- Entidades: Cliente, Producto, Venta, LineaVenta
-- =====================================================

-- Extensión para UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- Tabla: clientes
-- =====================================================
CREATE TABLE clientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(100) NOT NULL CHECK (LENGTH(TRIM(nombre)) >= 2),
    correo VARCHAR(255) NOT NULL UNIQUE CHECK (correo ~* '^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para clientes
CREATE INDEX idx_clientes_correo ON clientes(correo);
CREATE INDEX idx_clientes_nombre ON clientes(nombre);

-- =====================================================
-- Tabla: productos
-- =====================================================
CREATE TABLE productos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre VARCHAR(200) NOT NULL CHECK (LENGTH(TRIM(nombre)) > 0),
    precio_valor DECIMAL(12,2) NOT NULL CHECK (precio_valor >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para productos
CREATE INDEX idx_productos_nombre ON productos(nombre);
CREATE INDEX idx_productos_stock ON productos(stock);


-- =====================================================
-- Tabla: ventas
-- =====================================================
CREATE TABLE ventas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    fecha TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cliente_id UUID NOT NULL REFERENCES clientes(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para ventas
CREATE INDEX idx_ventas_cliente_id ON ventas(cliente_id);
CREATE INDEX idx_ventas_fecha ON ventas(fecha);

-- =====================================================
-- Tabla: lineas_venta
-- =====================================================
CREATE TABLE lineas_venta (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    venta_id UUID NOT NULL REFERENCES ventas(id) ON DELETE CASCADE,
    producto_id UUID NOT NULL REFERENCES productos(id) ON DELETE RESTRICT,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario_valor DECIMAL(12,2) NOT NULL CHECK (precio_unitario_valor >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para lineas_venta
CREATE INDEX idx_lineas_venta_venta_id ON lineas_venta(venta_id);
CREATE INDEX idx_lineas_venta_producto_id ON lineas_venta(producto_id);
CREATE UNIQUE INDEX idx_lineas_venta_unique ON lineas_venta(venta_id, producto_id);

-- =====================================================
-- Triggers para updated_at
-- =====================================================

-- Función para actualizar timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para clientes
CREATE TRIGGER update_clientes_updated_at 
    BEFORE UPDATE ON clientes 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Triggers para productos
CREATE TRIGGER update_productos_updated_at 
    BEFORE UPDATE ON productos 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Triggers para ventas
CREATE TRIGGER update_ventas_updated_at 
    BEFORE UPDATE ON ventas 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();


-- =====================================================
-- Comentarios en las tablas
-- =====================================================

COMMENT ON TABLE clientes IS 'Tabla de clientes del sistema de ventas';
COMMENT ON COLUMN clientes.id IS 'Identificador único del cliente (UUID)';
COMMENT ON COLUMN clientes.nombre IS 'Nombre completo del cliente';
COMMENT ON COLUMN clientes.correo IS 'Correo electrónico único del cliente';

COMMENT ON TABLE productos IS 'Tabla de productos disponibles para venta';
COMMENT ON COLUMN productos.id IS 'Identificador único del producto (UUID)';
COMMENT ON COLUMN productos.nombre IS 'Nombre del producto';
COMMENT ON COLUMN productos.precio_valor IS 'Valor del precio del producto';
COMMENT ON COLUMN productos.stock IS 'Cantidad disponible en inventario';

COMMENT ON TABLE ventas IS 'Tabla de ventas realizadas';
COMMENT ON COLUMN ventas.id IS 'Identificador único de la venta (UUID)';
COMMENT ON COLUMN ventas.fecha IS 'Fecha y hora de la venta';
COMMENT ON COLUMN ventas.cliente_id IS 'Referencia al cliente que realizó la compra';


COMMENT ON TABLE lineas_venta IS 'Tabla de líneas de detalle de cada venta';
COMMENT ON COLUMN lineas_venta.id IS 'Identificador único de la línea de venta (UUID)';
COMMENT ON COLUMN lineas_venta.venta_id IS 'Referencia a la venta';
COMMENT ON COLUMN lineas_venta.producto_id IS 'Referencia al producto vendido';
COMMENT ON COLUMN lineas_venta.cantidad IS 'Cantidad del producto vendido';
COMMENT ON COLUMN lineas_venta.precio_unitario_valor IS 'Precio unitario al momento de la venta';

-- =====================================================
-- Datos de ejemplo para testing
-- =====================================================

-- Insertar clientes de ejemplo
INSERT INTO clientes (nombre, correo) VALUES 
('Juan Pérez', 'juan.perez@email.com'),
('María González', 'maria.gonzalez@email.com'),
('Carlos Rodríguez', 'carlos.rodriguez@email.com');

-- Insertar productos de ejemplo
INSERT INTO productos (nombre, precio_valor, stock) VALUES 
('Laptop Dell Inspiron', 15000.00,  10),
('Mouse Inalámbrico', 250.00, 50),
('Teclado Mecánico', 800.00, 25),
('Monitor 24 pulgadas', 2500.00, 15),
('Auriculares Bluetooth', 500.00, 30);

-- =====================================================
-- Fin del script DDL
-- =====================================================