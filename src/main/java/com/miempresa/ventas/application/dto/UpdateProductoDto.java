package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * DTO para actualizar un producto existente.
 * Todos los campos son opcionales, solo se actualizarán los campos proporcionados.
 * 
 * NOTA IMPORTANTE: La moneda NO se puede actualizar una vez que el producto ha sido creado.
 * Esto es para mantener la integridad de los datos de negocio.
 */
@Schema(description = "Datos para actualizar un producto existente. La moneda no se puede cambiar.")
public class UpdateProductoDto {
    
    @Size(min = 2, max = 200, message = "El nombre debe tener entre 2 y 200 caracteres")
    @Schema(description = "Nuevo nombre del producto", example = "Laptop Dell Inspiron 15")
    private String nombre;
    
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor a 0")
    @Digits(integer = 15, fraction = 4, message = "El precio debe tener máximo 15 dígitos enteros y 4 decimales")
    @Schema(description = "Nuevo precio del producto", example = "1199.99")
    private BigDecimal precio;
    
    @Min(value = 0, message = "El stock no puede ser negativo")
    @Schema(description = "Nueva cantidad en stock", example = "20")
    private Integer stock;
    
    // Constructor por defecto para deserialización
    public UpdateProductoDto() {}
    
    public UpdateProductoDto(String nombre, BigDecimal precio, Integer stock) {
        this.nombre = nombre;
        this.precio = precio;
        this.stock = stock;
    }
    
    // Getters y Setters
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public BigDecimal getPrecio() {
        return precio;
    }
    
    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }
    
    public Integer getStock() {
        return stock;
    }
    
    public void setStock(Integer stock) {
        this.stock = stock;
    }
    
    // Métodos de utilidad para verificar qué campos fueron proporcionados
    public boolean hasNombre() {
        return nombre != null && !nombre.trim().isEmpty();
    }
    
    public boolean hasPrecio() {
        return precio != null;
    }
    
    public boolean hasStock() {
        return stock != null;
    }
    
    @Override
    public String toString() {
        return "UpdateProductoDto{" +
                "nombre='" + nombre + '\'' +
                ", precio=" + precio +
                ", stock=" + stock +
                '}';
    }
}