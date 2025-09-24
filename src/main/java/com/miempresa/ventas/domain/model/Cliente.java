package com.miempresa.ventas.domain.model;

import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Email;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.exception.DomainException;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(name = "clientes")
public class Cliente extends BaseEntity {
    
    @EmbeddedId
    private ClienteId id;
    
    @Column(name = "nombre", nullable = false, length = 100)
    private String nombre;
    
    @Column(name = "correo", nullable = false, unique = true, length = 255)
    private String correo;
    
    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;
    
    // Constructor para JPA (protegido para que solo lo use el ORM)
    protected Cliente() {
        // Los timestamps son manejados por la BD
    }
    
    // Constructor para crear nuevo cliente (dominio)
    public Cliente(String nombre, Email correo) {
        this(); // Llama al constructor de JPA
        this.id = ClienteId.generate();
        this.setNombre(nombre);
        this.setCorreo(correo);
    }
    
    // Constructor para reconstruir desde persistencia (dominio)
    public Cliente(ClienteId id, String nombre, Email correo) {
        this(); // Llama al constructor de JPA
        this.id = id;
        this.setNombre(nombre);
        this.setCorreo(correo);
    }
    
    // ===== LÓGICA DE DOMINIO (PURA) =====
    
    public Result<Void> actualizarInformacion(String nuevoNombre, Email nuevoCorreo) {
        return validarNombre(nuevoNombre)
            .flatMap(n -> validarCorreo(nuevoCorreo))
            .map(c -> {
                this.nombre = nuevoNombre.trim();
                this.correo = nuevoCorreo.getValor();
                return null;
            });
    }
    
    public Result<Void> cambiarNombre(String nuevoNombre) {
        return validarNombre(nuevoNombre)
            .map(n -> {
                this.nombre = n;
                return null;
            });
    }
    
    public Result<Void> cambiarCorreo(Email nuevoCorreo) {
        return validarCorreo(nuevoCorreo)
            .map(c -> {
                this.correo = c.getValor();
                return null;
            });
    }
    
    private Result<String> validarNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            return Result.failure("El nombre del cliente no puede estar vacío");
        }
        if (nombre.trim().length() < 2) {
            return Result.failure("El nombre debe tener al menos 2 caracteres");
        }
        if (nombre.trim().length() > 100) {
            return Result.failure("El nombre no puede exceder 100 caracteres");
        }
        return Result.success(nombre.trim());
    }
    
    private Result<Email> validarCorreo(Email correo) {
        if (correo == null) {
            return Result.failure("El correo no puede ser null");
        }
        return Result.success(correo);
    }
    
    public Result<Void> validarParaVenta() {
        // Validaciones adicionales que podrían ser necesarias para procesar una venta
        return Result.success();
    }
    
    // ===== MÉTODOS PRIVADOS PARA CONSTRUCTORES =====
    
    private void setNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new DomainException("El nombre del cliente no puede estar vacío");
        }
        this.nombre = nombre.trim();
    }
    
    private void setCorreo(Email correo) {
        if (correo == null) {
            throw new DomainException("El correo no puede ser null");
        }
        this.correo = correo.getValor();
    }
    
    // ===== GETTERS (DOMINIO + JPA) =====
    
    @Override
    public ClienteId getId() {
        return id;
    }
    
    // Getter para JPA/Infraestructura
    public UUID getIdValue() {
        return id.getValue();
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public Email getCorreo() {
        return new Email(correo);
    }
    
    // Getter para JPA/Infraestructura  
    public String getCorreoValue() {
        return correo;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
}