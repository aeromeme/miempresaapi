package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;

/**
 * DTO para representar un Cliente en la capa de aplicación.
 * Expone solo la información necesaria para las operaciones de aplicación.
 */
@Schema(description = "Datos de un cliente")
public class ClienteDto {
    
    @Schema(description = "Identificador único del cliente", example = "123e4567-e89b-12d3-a456-426614174000")
    private final String id;
    
    @Schema(description = "Nombre completo del cliente", example = "Juan Pérez Martínez")
    private final String nombre;
    
    @Schema(description = "Correo electrónico del cliente", example = "juan.perez@email.com")
    private final String correo;
    
    public ClienteDto(String id, String nombre, String correo) {
        this.id = id;
        this.nombre = nombre;
        this.correo = correo;
    }
    
    // Getters
    public String getId() {
        return id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public String getCorreo() {
        return correo;
    }
    
    @Override
    public String toString() {
        return String.format("ClienteDto{id='%s', nombre='%s', correo='%s'}", id, nombre, correo);
    }
}