# Resumen: Moneda Inmutable en Productos

## 🔒 Cambio Implementado

**La moneda de un producto NO se puede actualizar una vez creado**

## ✅ Modificaciones Realizadas

### 1. **UpdateProductoDto Simplificado**

```java
// ANTES (Permitía cambiar moneda)
{
  "nombre": "Nuevo nombre",
  "precio": 1199.99,
  "moneda": "GTQ",    // ❌ YA NO DISPONIBLE
  "stock": 20
}

// AHORA (Moneda inmutable)
{
  "nombre": "Nuevo nombre",
  "precio": 1199.99,
  "stock": 20
  // ✅ Moneda se mantiene la original
}
```

### 2. **ProductoApplicationService Actualizado**

- ✅ **Método update()**: Siempre mantiene la moneda original
- ✅ **Validación eliminada**: No valida moneda en updates (ya no existe el campo)
- ✅ **Método legacy**: Marcado como @Deprecated, ignora parámetro moneda
- ✅ **Comentarios claros**: Documenta que la moneda no se puede cambiar

### 3. **Documentación Mejorada**

- ✅ **Swagger**: Especifica que moneda no se puede cambiar
- ✅ **Comentarios**: Explican la regla de negocio
- ✅ **Guía de migración**: Cómo crear productos con diferente moneda

## 🎯 Beneficios de la Moneda Inmutable

### **1. Integridad de Datos**

- ✅ **Historial consistente**: Precios mantienen su contexto original
- ✅ **Ventas válidas**: Referencias de productos no se rompen
- ✅ **Auditoría limpia**: Trazabilidad de datos financieros

### **2. Simplificación del Negocio**

- ✅ **Sin conversiones**: No necesita lógica de cambio de divisas
- ✅ **Reportes confiables**: Datos financieros consistentes
- ✅ **Menos errores**: Elimina casos edge de conversión

### **3. API más Clara**

- ✅ **Menos confusión**: Cliente sabe que moneda no cambia
- ✅ **DTOs simplificados**: UpdateProductoDto más pequeño
- ✅ **Menos validaciones**: No hay que validar monedas en updates

## 🔄 Proceso para Cambiar Moneda

Si un negocio necesita un producto con diferente moneda:

### **Opción 1: Nuevo Producto**

```http
# Crear producto con nueva moneda
POST /api/productos
{
  "nombre": "Laptop Dell Inspiron (GTQ)",
  "precio": 9750.00,
  "stock": 15
}
```

### **Opción 2: Migración de Stock**

```http
# 1. Reducir stock del producto original
PUT /api/productos/{old-id}
{
  "stock": 0
}

# 2. Crear nuevo producto con nueva moneda
POST /api/productos
{
  "nombre": "Laptop Dell Inspiron (EUR)",
  "precio": 1150.00,
  "stock": 15
}
```

## 📋 Métodos Disponibles

### **Para Crear Productos**

```java
// Usa moneda por defecto configurada
ProductoDto create(CreateProductoDto dto)

// Conveniencia con moneda por defecto
ProductoDto create(String nombre, BigDecimal precio, int stock)

// Específico con moneda (valida que sea soportada)
ProductoDto create(String nombre, BigDecimal precio, String moneda, int stock)
```

### **Para Actualizar Productos**

```java
// Principal - sin moneda
Optional<ProductoDto> update(String id, UpdateProductoDto dto)

// Conveniencia - sin moneda
Optional<ProductoDto> update(String id, String nombre, BigDecimal precio, int stock)

// Legacy - ignora parámetro moneda
@Deprecated
Optional<ProductoDto> update(String id, String nombre, BigDecimal precio, String moneda, int stock)
```

## 🧪 Casos de Prueba

### **✅ Casos que Funcionan**

```http
# Crear con moneda por defecto
POST /api/productos
{
  "nombre": "Mouse",
  "precio": 25.99,
  "stock": 100
}

# Actualizar precio y stock (mantiene moneda)
PUT /api/productos/{id}
{
  "precio": 23.99,
  "stock": 150
}
```

### **❌ Casos que NO Son Posibles**

```http
# NO SE PUEDE: Cambiar moneda en update
PUT /api/productos/{id}
{
  "moneda": "EUR"  // ❌ Campo no existe
}
```

## 🚀 Resultado Final

- ✅ **API más robusta**: Reglas de negocio claras
- ✅ **Menos errores**: No hay updates inválidos de moneda
- ✅ **Documentación clara**: Swagger y comentarios explican restricciones
- ✅ **Backwards compatibility**: Métodos legacy disponibles pero deprecated
- ✅ **Clean Architecture**: Regla de negocio bien definida

La moneda inmutable garantiza la integridad de los datos financieros y simplifica la lógica de negocio del sistema.
