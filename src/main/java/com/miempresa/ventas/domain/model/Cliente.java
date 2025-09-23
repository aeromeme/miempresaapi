package com.miempresa.ventas.domain.model;

import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Email;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.exception.DomainException;

public class Cliente extends BaseEntity {
    private ClienteId id;
    private String nombre;
    private Email correo;
    
    // Constructor para crear nuevo cliente
    public Cliente(String nombre, Email correo) {
        this.id = ClienteId.generate();
        this.setNombre(nombre);
        this.setCorreo(correo);
    }
    
    // Constructor para reconstruir desde persistencia
    public Cliente(ClienteId id, String nombre, Email correo) {
        this.id = id;
        this.setNombre(nombre);
        this.setCorreo(correo);
    }
    
    public Result<Void> actualizarInformacion(String nuevoNombre, Email nuevoCorreo) {
        return validarNombre(nuevoNombre)
            .flatMap(n -> validarCorreo(nuevoCorreo))
            .map(c -> {
                this.nombre = nuevoNombre.trim();
                this.correo = nuevoCorreo;
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
                this.correo = c;
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
        this.correo = correo;
    }
    
    // Getters
    @Override
    public ClienteId getId() {
        return id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public Email getCorreo() {
        return correo;
    }
}