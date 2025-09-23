# Configuración de Monedas - Clean Architecture

## Resumen

Se ha implementado un sistema de configuración de monedas que respeta los principios de Clean Architecture, permitiendo configurar la moneda por defecto y las monedas soportadas a través de `application.properties`.

## 🏗️ Arquitectura Implementada

### **Separación por Capas**

#### 1. **Capa de Dominio** (`domain/`)

```java
// Interfaz que define el contrato (sin dependencias externas)
MonedaConfigurationService
```

#### 2. **Capa de Aplicación** (`application/`)

```java
// Usa la interfaz del dominio
ProductoApplicationService
  ↓ inyecta
MonedaConfigurationService (interfaz)
```

#### 3. **Capa de Infraestructura** (`infrastructure/`)

```java
// Implementación que usa Spring Boot
MonedaConfigurationServiceImpl implements MonedaConfigurationService
  ↓ usa
MonedaConfigurationProperties (@ConfigurationProperties)
```

### **Flujo de Dependencias (Dependency Inversion)**

```
Infrastructure → Application → Domain
      ↑                          ↓
   (implementa)              (define contrato)
```

## ⚙️ Configuración

### **application.properties**

```properties
# Configuración de Monedas
ventas.moneda.por-defecto=USD
ventas.moneda.soportadas=USD,GTQ,BZD,HNL,NIO,CRC,PAB
```

### **Configuraciones Disponibles**

| Propiedad                   | Descripción                                   | Valor por Defecto             | Ejemplo       |
| --------------------------- | --------------------------------------------- | ----------------------------- | ------------- |
| `ventas.moneda.por-defecto` | Moneda que se usa cuando no se especifica una | `USD`                         | `GTQ`         |
| `ventas.moneda.soportadas`  | Lista de monedas válidas en el sistema        | `USD,GTQ,BZD,HNL,NIO,CRC,PAB` | `USD,EUR,GTQ` |

## 🚀 Funcionalidades Implementadas

### **1. Creación de Productos con Moneda por Defecto**

#### DTO Simplificado (Sin campo moneda)

```java
CreateProductoDto {
    nombre: "Laptop Gaming"
    precio: 1599.99
    stock: 5
    // ❌ Sin campo moneda - usa la configurada por defecto
}
```

#### Endpoint

```http
POST /api/productos
{
  "nombre": "Smartphone Samsung",
  "precio": 899.99,
  "stock": 25
}
```

**Resultado**: Producto creado con moneda `USD` (por defecto configurada)

### **2. Creación con Moneda Específica (Método de Conveniencia)**

```java
// Valida que la moneda esté en la lista de soportadas
productoService.create("Tablet", BigDecimal.valueOf(599.99), "GTQ", 10);
```

### **3. Actualización con Validación de Monedas**

```http
PUT /api/productos/{id}
{
  "moneda": "GTQ"  // ✅ Validado contra lista de soportadas
}
```

### **4. Endpoint de Configuración**

```http
GET /api/productos/config/monedas

Response:
{
  "monedaPorDefecto": "USD",
  "monedasSoportadas": ["USD", "GTQ", "BZD", "HNL", "NIO", "CRC", "PAB"]
}
```

## 🔧 Servicios Implementados

### **MonedaConfigurationService (Dominio)**

```java
Moneda getMonedaPorDefecto()           // Obtiene moneda por defecto
boolean isMonedaSoportada(String)      // Valida si moneda es soportada
String[] getMonedasSoportadas()        // Lista todas las soportadas
```

### **ProductoApplicationService (Aplicación)**

```java
ProductoDto create(CreateProductoDto)          // Usa moneda por defecto
ProductoDto create(String, BigDecimal, String, int) // Valida moneda específica
Optional<ProductoDto> update(String, UpdateProductoDto) // Valida moneda en update

// Métodos de configuración expuestos
String getMonedaPorDefecto()
String[] getMonedasSoportadas()
boolean isMonedaSoportada(String)
```

## 🛡️ Validaciones Implementadas

### **1. Validación en Creación**

```java
// Si se usa método con moneda específica
if (!monedaConfigurationService.isMonedaSoportada(moneda)) {
    throw new IllegalArgumentException("Moneda no soportada: " + moneda +
        ". Monedas soportadas: " + String.join(", ", getMonedasSoportadas()));
}
```

### **2. Validación en Actualización**

```java
// Solo valida si se proporciona una nueva moneda
if (updateDto.hasMoneda() && !monedaConfigurationService.isMonedaSoportada(updateDto.getMoneda())) {
    throw new IllegalArgumentException("Moneda no soportada...");
}
```

### **3. Validación Personalizada (Bean Validation)**

```java
@MonedaSoportada  // Anotación personalizada
private String moneda;
```

## 📋 Casos de Uso

### **Caso 1: Empresa en Guatemala**

```properties
ventas.moneda.por-defecto=GTQ
ventas.moneda.soportadas=GTQ,USD
```

### **Caso 2: Empresa Multinacional**

```properties
ventas.moneda.por-defecto=USD
ventas.moneda.soportadas=USD,EUR,GTQ,MXN,CAD
```

### **Caso 3: Solo Centroamérica**

```properties
ventas.moneda.por-defecto=USD
ventas.moneda.soportadas=USD,GTQ,BZD,HNL,NIO,CRC,PAB
```

## ✅ Beneficios de esta Implementación

### **1. Clean Architecture**

- ✅ **Dominio independiente**: No conoce Spring ni configuraciones
- ✅ **Inversión de dependencias**: Infraestructura implementa contratos del dominio
- ✅ **Testeable**: Interfaces permiten fácil mocking

### **2. Configurabilidad**

- ✅ **Sin recompilación**: Cambios en `application.properties`
- ✅ **Específico por ambiente**: Diferentes configs para dev/prod
- ✅ **Validación automática**: Rechaza monedas no soportadas

### **3. Flexibilidad**

- ✅ **DTOs simplificados**: CreateProductoDto sin campo moneda
- ✅ **Métodos de conveniencia**: Para casos específicos con moneda
- ✅ **Actualizaciones parciales**: Solo valida campos proporcionados

### **4. Documentación Automática**

- ✅ **Swagger**: Endpoint para obtener configuración
- ✅ **Transparencia**: Cliente puede consultar monedas soportadas
- ✅ **Ejemplos claros**: Documentación con casos reales

## 🔄 Compatibilidad

### **Métodos Disponibles**

```java
// Nuevo (recomendado) - usa moneda por defecto
ProductoDto create(CreateProductoDto dto)

// Conveniencia - usa moneda por defecto
ProductoDto create(String nombre, BigDecimal precio, int stock)

// Específico - valida moneda proporcionada
ProductoDto create(String nombre, BigDecimal precio, String moneda, int stock)
```

## 🧪 Testing

### **Configuración para Tests**

```properties
# application-test.properties
ventas.moneda.por-defecto=USD
ventas.moneda.soportadas=USD,EUR  # Lista reducida para tests
```

### **Test de Validación**

```java
@Test
void shouldRejectUnsupportedCurrency() {
    assertThrows(IllegalArgumentException.class, () ->
        productoService.create("Test", BigDecimal.valueOf(100), "JPY", 10)
    );
}
```

## 🚀 Próximos Pasos

1. **Configuración por perfil**: Diferentes monedas para dev/staging/prod
2. **Cache de configuración**: Optimizar acceso a propiedades
3. **Eventos de dominio**: Notificar cambios de configuración
4. **API de administración**: Endpoints para cambiar configuración en runtime
5. **Auditoría**: Registrar cambios de configuración
6. **Internacionalización**: Nombres de monedas en diferentes idiomas

Esta implementación proporciona una base sólida y flexible para manejar configuraciones de moneda respetando Clean Architecture.
