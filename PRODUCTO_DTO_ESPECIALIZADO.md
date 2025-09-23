# DTOs Especializados para Producto

## Resumen de Cambios

Se han creado DTOs específicos para diferentes operaciones CRUD de productos, mejorando la separación de responsabilidades y la validación de datos.

## DTOs Implementados

### 1. `CreateProductoDto`

**Propósito**: Crear nuevos productos
**Características**:

- ❌ **No incluye ID** (se genera automáticamente)
- ❌ **No incluye moneda** (usa la configurada por defecto)
- ✅ **Campos esenciales obligatorios**
- ✅ **Validaciones completas** con Bean Validation

```java
{
  "nombre": "Laptop Dell Inspiron",     // @NotBlank, @Size(2-200)
  "precio": 1250.50,                   // @NotNull, @DecimalMin(0.01)
  "stock": 15                          // @Min(0)
  // ❌ NO incluye moneda - usa la por defecto configurada
}
```

### 2. `UpdateProductoDto`

**Propósito**: Actualizar productos existentes
**Características**:

- ✅ **Todos los campos son opcionales**
- ✅ **Solo actualiza campos proporcionados**
- ❌ **NO permite cambiar la moneda** (regla de negocio)
- ✅ **Validaciones cuando se proporcionan valores**

```java
{
  "nombre": "Nuevo nombre",            // Opcional, @Size(2-200)
  "precio": 1199.99,                  // Opcional, @DecimalMin(0.01)
  "stock": 20                         // Opcional, @Min(0)
  // ❌ NO incluye moneda - no se puede cambiar después de creado
}
```

### 3. `ProductoDto` (Response)

**Propósito**: Respuestas de la API
**Características**:

- ✅ **Incluye ID generado**
- ✅ **Datos completos del producto**
- ✅ **Solo lectura** (sin validaciones de entrada)

```java
{
  "id": "550e8400-e29b-41d4-a716-446655440001",
  "nombre": "Laptop Dell Inspiron",
  "precio": 1250.50,
  "moneda": "USD",
  "stock": 15
}
```

## Ejemplos de Uso

### Crear Producto

```http
POST /api/productos
Content-Type: application/json

{
  "nombre": "Smartphone Samsung Galaxy S24",
  "precio": 899.99,
  "moneda": "USD",
  "stock": 25
}
```

**Respuesta (201 Created):**

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "nombre": "Smartphone Samsung Galaxy S24",
  "precio": 899.99,
  "moneda": "USD",
  "stock": 25
}
```

### Actualizar Producto (Parcial)

```http
PUT /api/productos/123e4567-e89b-12d3-a456-426614174000
Content-Type: application/json

{
  "precio": 849.99,
  "stock": 30
}
```

**Respuesta (200 OK):**

```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "nombre": "Smartphone Samsung Galaxy S24", // ← Mantiene valor anterior
  "precio": 849.99, // ← Actualizado
  "moneda": "USD", // ← Mantiene valor anterior
  "stock": 30 // ← Actualizado
}
```

## 🔒 Regla de Negocio: Moneda Inmutable

### **¿Por qué la moneda no se puede actualizar?**

Una vez que un producto es creado con una moneda específica, **NO se puede cambiar** por las siguientes razones de negocio:

1. **Integridad de Historial**: Los precios históricos perderían su contexto si se cambia la moneda
2. **Ventas Existentes**: Las ventas ya realizadas referencian el producto con su moneda original
3. **Reportes Financieros**: Los reportes de ingresos dependen de monedas consistentes
4. **Auditoría**: Mantiene la trazabilidad de los datos financieros
5. **Simplicidad**: Evita conversiones complejas de divisas en el sistema

### **¿Cómo cambiar la moneda de un producto?**

Si necesitas un producto con diferente moneda, debes:

1. **Crear un nuevo producto** con la moneda deseada
2. **Desactivar/eliminar** el producto anterior (si es necesario)
3. **Migrar stock** del producto anterior al nuevo (proceso manual)

### **Ejemplo de Migración**

```http
# 1. Crear nuevo producto con moneda GTQ
POST /api/productos
{
  "nombre": "Laptop Dell Inspiron (GTQ)",
  "precio": 9750.00,
  "stock": 0
}

# 2. Transferir stock manualmente del producto USD al GTQ
PUT /api/productos/{old-product-id}
{
  "stock": 0
}

PUT /api/productos/{new-product-id}
{
  "stock": 15
}
```

## Validaciones Implementadas

### Bean Validation Annotations

| Campo    | Crear                        | Actualizar      | Validaciones                                     |
| -------- | ---------------------------- | --------------- | ------------------------------------------------ |
| `nombre` | ✅ Obligatorio               | ⚪ Opcional     | `@NotBlank`, `@Size(2-200)`                      |
| `precio` | ✅ Obligatorio               | ⚪ Opcional     | `@NotNull`, `@DecimalMin(0.01)`, `@Digits(15,4)` |
| `moneda` | ❌ No incluido (por defecto) | ❌ No permitido | Configurada por defecto, inmutable               |
| `stock`  | ✅ Obligatorio               | ⚪ Opcional     | `@Min(0)`                                        |

### Mensajes de Error Personalizados

- **Nombre vacío**: "El nombre del producto es obligatorio"
- **Precio inválido**: "El precio debe ser mayor a 0"
- **Moneda inválida**: "Moneda no válida. Debe ser una de: USD, GTQ, BZD, HNL, NIO, CRC, PAB"
- **Stock negativo**: "El stock no puede ser negativo"

## Beneficios de esta Implementación

### 🎯 **Separación de Responsabilidades**

- DTOs específicos para cada operación
- Validaciones apropiadas para cada contexto
- Campos obligatorios vs opcionales claramente definidos

### 🛡️ **Seguridad y Validación**

- No se puede proporcionar ID al crear (evita ataques de manipulación)
- Validaciones automáticas con Bean Validation
- Mensajes de error claros y específicos

### 📚 **Documentación Automática**

- Swagger UI muestra esquemas diferentes para crear vs actualizar
- Ejemplos específicos para cada operación
- Campos marcados como requeridos/opcionales correctamente

### 🔄 **Flexibilidad en Updates**

- Actualizaciones parciales (solo campos proporcionados)
- Mantiene valores existentes para campos no especificados
- Métodos de utilidad para verificar qué campos fueron proporcionados

### 🧪 **Facilidad de Testing**

- DTOs específicos facilitan la creación de tests
- Validaciones pueden probarse independientemente
- Casos de uso claros y separados

## Compatibilidad con Versiones Anteriores

Se mantienen métodos de conveniencia en `ProductoApplicationService` que aceptan parámetros individuales para compatibilidad:

```java
// Método nuevo (recomendado)
ProductoDto create(CreateProductoDto createDto)

// Método de conveniencia (compatibilidad)
ProductoDto create(String nombre, BigDecimal precio, String moneda, int stock)
```

## Próximos Pasos Sugeridos

1. **Tests unitarios** para validaciones de DTOs
2. **Tests de integración** para endpoints actualizados
3. **Documentación de ejemplos** en Swagger con casos reales
4. **Middleware de manejo de errores** para respuestas consistentes de validación
5. **Aplicar el mismo patrón** a otras entidades (Cliente, Venta, etc.)
