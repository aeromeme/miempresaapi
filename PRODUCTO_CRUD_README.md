# CRUD de Productos - Implementación Completa

## Resumen

Se ha implementado un CRUD completo para la entidad `Producto` siguiendo los principios de Domain-Driven Design (DDD) y arquitectura por capas.

## Arquitectura Implementada

### 🏗️ Capas de la Arquitectura

#### 1. **Capa de Dominio** (`domain/`)

- **`Producto.java`**: Entidad de dominio rica con lógica de negocio
- **`ProductoId.java`**: Value Object para identificación única
- **`ProductoRepository.java`**: Interfaz del repositorio (sin implementación)

#### 2. **Capa de Aplicación** (`application/`)

- **`ProductoApplicationService.java`**: Orquesta los casos de uso CRUD
- **`ProductoDto.java`**: DTO para transferencia de datos con anotaciones Swagger
- **`ProductoMapper.java`**: Convierte entre entidades de dominio y DTOs

#### 3. **Capa de Infraestructura** (`infrastructure/`)

- **`ProductoJpaEntity.java`**: Entidad JPA para persistencia
- **`ProductoJpaRepository.java`**: Repository JPA con Spring Data
- **`ProductoJpaMapper.java`**: Convierte entre dominio y entidades JPA
- **`ProductoRepositoryImpl.java`**: Implementación del repository de dominio
- **`ProductoController.java`**: Controller REST con documentación Swagger

## 📋 Operaciones CRUD Disponibles

### Endpoints REST

| Método   | Endpoint                               | Descripción                   |
| -------- | -------------------------------------- | ----------------------------- |
| `GET`    | `/api/productos`                       | Listar todos los productos    |
| `GET`    | `/api/productos/{id}`                  | Obtener producto por ID       |
| `POST`   | `/api/productos`                       | Crear nuevo producto          |
| `PUT`    | `/api/productos/{id}`                  | Actualizar producto existente |
| `DELETE` | `/api/productos/{id}`                  | Eliminar producto             |
| `GET`    | `/api/productos/buscar?nombre={texto}` | Buscar productos por nombre   |

### Ejemplos de Uso

#### Crear Producto

```bash
POST /api/productos
Content-Type: application/json

{
  "nombre": "Laptop Dell Inspiron",
  "precio": 1250.50,
  "moneda": "USD",
  "stock": 15
}
```

#### Actualizar Producto

```bash
PUT /api/productos/550e8400-e29b-41d4-a716-446655440001
Content-Type: application/json

{
  "nombre": "Laptop Dell Inspiron 15 (Actualizada)",
  "precio": 1199.99,
  "moneda": "USD",
  "stock": 20
}
```

## 🎯 Características Implementadas

### ✅ Funcionalidades de Dominio

- **Value Objects**: `ProductoId`, `Precio`, `Moneda`
- **Validaciones de dominio**: nombre requerido, precio positivo, stock no negativo
- **Lógica de negocio**: operaciones de stock, cálculo de totales
- **Monedas soportadas**: USD, GTQ, BZD, HNL, NIO, CRC, PAB

### ✅ Persistencia JPA

- **Entidad JPA**: `ProductoJpaEntity` con mapeo de tabla `productos`
- **Optimistic Locking**: Control de concurrencia con `@Version`
- **Consultas customizadas**: Búsqueda por nombre, filtro por stock
- **Mapeo de Value Objects**: Precio separado en valor y moneda

### ✅ API REST

- **Documentación Swagger**: Anotaciones OpenAPI completas
- **DTOs documentados**: Esquemas con ejemplos y descripciones
- **Manejo de errores**: Respuestas HTTP apropiadas (200, 201, 404, 400)
- **Request/Response DTOs**: Separación clara entre requests y responses

### ✅ Mapeo de Datos

- **Mapper de aplicación**: Entre dominio y DTOs
- **Mapper de infraestructura**: Entre dominio y entidades JPA
- **Conversión de tipos**: UUID ↔ String, BigDecimal, enums

## 🗄️ Estructura de Base de Datos

### Tabla `productos`

```sql
CREATE TABLE productos (
    id UUID PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    precio_valor DECIMAL(19,4) NOT NULL,
    precio_moneda VARCHAR(3) NOT NULL,
    stock INTEGER NOT NULL,
    version BIGINT -- Para optimistic locking
);
```

### Datos de Prueba

Se incluye un script con datos de prueba en:
`database/ddl/insert_test_data_productos.sql`

## 🚀 Cómo Probar

### 1. Ejecutar la Aplicación

```bash
./gradlew bootRun
```

### 2. Acceder a Swagger UI

```
http://localhost:8080/swagger-ui/index.html
```

### 3. Endpoints Disponibles

- **Base URL**: `http://localhost:8080/api/productos`
- **Documentación**: Disponible en Swagger UI

### 4. Cargar Datos de Prueba

Ejecutar el script SQL incluido después de que las tablas sean creadas automáticamente.

## 📚 Tecnologías Utilizadas

- **Spring Boot 3.x**: Framework principal
- **Spring Data JPA**: Persistencia y repositorios
- **PostgreSQL**: Base de datos principal
- **H2**: Base de datos para tests (opcional)
- **SpringDoc OpenAPI**: Documentación Swagger automática
- **Gradle**: Build tool

## 🔧 Configuración

### Base de Datos

Configurada en `application.properties`:

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/ventas_db
spring.datasource.username=ventas_user
spring.datasource.password=ventas_password
spring.jpa.hibernate.ddl-auto=update
```

### Swagger

Accesible en: `http://localhost:8080/swagger-ui/index.html`

---

## ✨ Beneficios de esta Implementación

1. **Separación de responsabilidades**: Cada capa tiene su propósito específico
2. **Testabilidad**: Interfaces permiten fácil mocking y testing
3. **Documentación automática**: Swagger generado desde anotaciones
4. **Validaciones robustas**: Lógica de dominio en las entidades apropiadas
5. **Flexibilidad**: Fácil extensión y modificación de funcionalidades
6. **Principios DDD**: Rich domain model con value objects y agregados

Esta implementación proporciona una base sólida y escalable para el manejo de productos en el sistema de ventas.
