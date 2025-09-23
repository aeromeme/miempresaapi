package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import java.math.BigDecimal;

/**
 * DTO para representar un Producto en la capa de aplicación.
 * Expone la información necesaria para las operaciones CRUD.
 */
@Schema(description = "Datos de un producto")
public class ProductoDto {
    
    @Schema(description = "Identificador único del producto", example = "123e4567-e89b-12d3-a456-426614174000")
    private final String id;
    
    @Schema(description = "Nombre del producto", example = "Laptop Dell Inspiron")
    private final String nombre;
    
    @Schema(description = "Precio del producto", example = "1250.50")
    private final BigDecimal precio;
    
    @Schema(description = "Moneda del precio", example = "USD")
    private final String moneda;
    
    @Schema(description = "Cantidad en stock", example = "10")
    private final int stock;
    
    public ProductoDto(String id, String nombre, BigDecimal precio, String moneda, int stock) {
        this.id = id;
        this.nombre = nombre;
        this.precio = precio;
        this.moneda = moneda;
        this.stock = stock;
    }
    
    public String getId() {
        return id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public BigDecimal getPrecio() {
        return precio;
    }
    
    public String getMoneda() {
        return moneda;
    }
    
    public int getStock() {
        return stock;
    }
    
    @Override
    public String toString() {
        return "ProductoDto{" +
                "id='" + id + '\'' +
                ", nombre='" + nombre + '\'' +
                ", precio=" + precio +
                ", moneda='" + moneda + '\'' +
                ", stock=" + stock +
                '}';
    }
}