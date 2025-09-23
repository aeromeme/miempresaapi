package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * DTO para crear un nuevo producto.
 * No incluye ID ya que será generado automáticamente.
 */
@Schema(description = "Datos para crear un nuevo producto")
public class CreateProductoDto {
    
    @NotBlank(message = "El nombre del producto es obligatorio")
    @Size(min = 2, max = 200, message = "El nombre debe tener entre 2 y 200 caracteres")
    @Schema(description = "Nombre del producto", example = "Laptop Dell Inspiron", required = true)
    private String nombre;
    
    @NotNull(message = "El precio es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor a 0")
    @Digits(integer = 15, fraction = 4, message = "El precio debe tener máximo 15 dígitos enteros y 4 decimales")
    @Schema(description = "Precio del producto", example = "1250.50", required = true)
    private BigDecimal precio;
    
    
    @Min(value = 0, message = "El stock no puede ser negativo")
    @Schema(description = "Cantidad inicial en stock", example = "10", required = true)
    private int stock;
    
    // Constructor por defecto para deserialización
    public CreateProductoDto() {}

    public CreateProductoDto(String nombre, BigDecimal precio, int stock) {
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
      
    public int getStock() {
        return stock;
    }
    
    public void setStock(int stock) {
        this.stock = stock;
    }
    
    @Override
    public String toString() {
        return "CreateProductoDto{" +
                "nombre='" + nombre + '\'' +
                ", precio=" + precio +
                ", stock=" + stock +
                '}';
    }
}