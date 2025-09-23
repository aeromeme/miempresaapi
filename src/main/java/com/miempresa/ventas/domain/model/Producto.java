package com.miempresa.ventas.domain.model;

import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.exception.DomainException;
import jakarta.persistence.*;

@Entity
@Table(name = "productos")
public class Producto extends BaseEntity {
    @EmbeddedId
    private ProductoId id;
    
    @Column(name = "nombre", nullable = false, length = 255)
    private String nombre;
    
    @Embedded
    private Precio precio;
    
    @Column(name = "stock", nullable = false)
    private int stock;
    
    // Constructor para JPA
    protected Producto() {
        // Constructor requerido por JPA
    }
    
    // Constructor para crear nuevo producto
    public Producto(String nombre, Precio precio, int stock) {
        this.id = ProductoId.generate();
        this.setNombre(nombre);
        this.setPrecio(precio);
        this.setStock(stock);
    }
    
    // Constructor para reconstruir desde persistencia
    public Producto(ProductoId id, String nombre, Precio precio, int stock) {
        this.id = id;
        this.setNombre(nombre);
        this.setPrecio(precio);
        this.setStock(stock);
    }
    
    public Result<Void> actualizarPrecio(Precio nuevoPrecio) {
        if (nuevoPrecio == null) {
            return Result.failure("El precio no puede ser null");
        }
        this.precio = nuevoPrecio;
        return Result.success();
    }
    
    public Result<Void> ajustarStock(int nuevoStock) {
        if (nuevoStock < 0) {
            return Result.failure("El stock no puede ser negativo");
        }
        this.stock = nuevoStock;
        return Result.success();
    }
    
    public Result<Void> reducirStock(int cantidad) {
        return validarCantidad(cantidad)
            .flatMap(c -> validarStockSuficiente(c))
            .map(c -> {
                this.stock -= c;
                return null;
            });
    }
    
    public Result<Void> aumentarStock(int cantidad) {
        return validarCantidad(cantidad)
            .map(c -> {
                this.stock += c;
                return null;
            });
    }
    
    private Result<Integer> validarCantidad(int cantidad) {
        if (cantidad <= 0) {
            return Result.failure("La cantidad debe ser mayor a 0");
        }
        return Result.success(cantidad);
    }
    
    private Result<Integer> validarStockSuficiente(int cantidad) {
        if (!hayStockSuficiente(cantidad)) {
            return Result.failure(
                String.format("Stock insuficiente para el producto '%s'. Disponible: %d, solicitado: %d", 
                    nombre, stock, cantidad)
            );
        }
        return Result.success(cantidad);
    }
    
    public boolean hayStockSuficiente(int cantidad) {
        return this.stock >= cantidad;
    }
    
    public Result<Precio> calcularTotal(int cantidad) {
        return validarCantidad(cantidad)
            .map(c -> precio.multiplicar(c));
    }
    
    public Result<Void> validarParaVenta() {
        if (stock <= 0) {
            return Result.failure("El producto '" + nombre + "' no tiene stock disponible");
        }
        return Result.success();
    }
    
    private void setNombre(String nombre) {
        if (nombre == null || nombre.trim().isEmpty()) {
            throw new DomainException("El nombre del producto no puede estar vacío");
        }
        this.nombre = nombre.trim();
    }
    
    private void setPrecio(Precio precio) {
        if (precio == null) {
            throw new DomainException("El precio no puede ser null");
        }
        this.precio = precio;
    }
    
    private void setStock(int stock) {
        if (stock < 0) {
            throw new DomainException("El stock no puede ser negativo");
        }
        this.stock = stock;
    }
    
    // Getters
    @Override
    public ProductoId getId() {
        return id;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public Precio getPrecio() {
        return precio;
    }
    
    public int getStock() {
        return stock;
    }
}