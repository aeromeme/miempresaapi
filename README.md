# Sistema de Ventas - Proyecto Java Spring Boot

## Resumen

Este proyecto es una API REST para la gestión de ventas, desarrollada con Java y Spring Boot siguiendo principios de Clean Architecture y DDD (Domain-Driven Design). Permite la administración de ventas, clientes, productos y autenticación de usuarios.

## Arquitectura

- **Clean Architecture**: Separación clara entre capas de dominio, aplicación, infraestructura y presentación.
- **DDD (Domain-Driven Design)**: Uso de entidades, agregados, value objects y repositorios en la capa de dominio.
- **Spring Boot**: Framework principal para la construcción de la API REST y la gestión de dependencias.
- **JPA/Hibernate**: Persistencia de datos con mapeo de entidades y repositorios.
- **DTOs y Mappers**: Transferencia de datos entre capas y conversión entre entidades y DTOs.
- **Controladores REST**: Endpoints para CRUD de ventas y consultas especializadas.
- **Autenticación JWT**: Seguridad y autenticación de usuarios mediante tokens JWT.

## Puntos Clave

- **Entidades principales**: `Venta`, `LineaVenta`, `Cliente`, `Producto`.
- **Value Objects**: `VentaId`, `ClienteId`, `ProductoId`, `Precio`, `EstadoVenta`.
- **Repositorios**: Interfaces y adaptadores para persistencia, con implementación JPA.
- **Servicios de aplicación**: Lógica de negocio y orquestación de casos de uso.
- **Endpoints REST**:
  - Crear, modificar, consultar y listar ventas
  - Listar ventas por cliente
  - CRUD de clientes y productos (extensible)
- **Configuración de seguridad**: Usuarios autenticados mediante JWT, roles diferenciados.

## Usuarios de Prueba

> **Nota:** Estos usuarios son para pruebas y demostración. No usar en producción.

| Usuario            | Rol      | Email                | Contraseña  |
| ------------------ | -------- | -------------------- | ----------- |
| Administrador      | ADMIN    | admin@example.com    | admin123    |
| Operador de ventas | OPERADOR | operador@example.com | operador123 |

## Ejecución

### Ejecución con Docker Compose

1. Clona el repositorio.

```powershell
  git clone https://github.com/aeromeme/miempresaventa.git
  cd miempresaventa
```

```powershell
   git clone https://github.com/aeromeme/miempresaapi.git
   cd miempresaapi
```

2. Asegúrate de tener Docker y Docker Compose instalados.
3. el backend,bd y frontend van a correr, unico requisito estar ambos proyectos en una misma carpeta
4. Ejecuta el siguiente comando en la raíz del proyecto:

```
docker compose up --build
```

5. Esto levantará la base de datos PostgreSQL y la aplicación en contenedores.
6. La API estará disponible en `http://localhost:8080` y la base de datos en el puerto `5432`.
7. SWAGGER en `http://localhost:8080/swagger-ui/index.html`
8. Accede a la aplicación en `http://localhost`
9. Para detener y eliminar los contenedores:

```
docker compose down
```

### Ejecución local (sin Docker)

1. Configura la base de datos en `application.properties`.
2. Ejecuta el proyecto con:

```
./gradlew bootRun
```

3. Accede a los endpoints REST en `/ventas`, `/clientes`, `/productos`, etc.

## Autenticación

- Obtén un token JWT usando el endpoint de login.
- Usa el token en el header `Authorization: Bearer <token>` para acceder a los endpoints protegidos.

## Contacto

Para dudas o mejoras, contacta al equipo de desarrollo.
