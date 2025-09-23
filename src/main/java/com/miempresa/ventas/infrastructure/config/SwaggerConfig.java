package com.miempresa.ventas.infrastructure.config;

import org.springframework.context.annotation.Configuration;

/**
 * Configuración de OpenAPI/Swagger para la documentación de la API.
 * 
 * Con la dependencia springdoc-openapi-starter-webmvc-ui, la documentación
 * se genera automáticamente y estará disponible en:
 * 
 * - Swagger UI: http://localhost:8080/swagger-ui.html
 * - OpenAPI JSON: http://localhost:8080/v3/api-docs
 * 
 * Las anotaciones en los controladores y DTOs proporcionan información adicional
 * para enriquecer la documentación automática.
 */
@Configuration
public class SwaggerConfig {
    
    // La configuración automática de springdoc-openapi-starter-webmvc-ui
    // maneja toda la configuración básica de OpenAPI/Swagger.
    // 
    // Si se necesita personalización adicional, se puede agregar un bean
    // OpenAPI aquí cuando las dependencias estén correctamente cargadas.
    
}