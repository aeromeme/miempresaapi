package com.miempresa.ventas.domain.valueobject;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.util.UUID;

@Embeddable
public class ProductoId extends ValueObject {
    @Column(name = "id", nullable = false)
    private UUID value;
    
    // Constructor para JPA
    protected ProductoId() {
        // Constructor requerido por JPA
    }
    
    public ProductoId(UUID value) {
        if (value == null) {
            throw new IllegalArgumentException("ProductoId no puede ser null");
        }
        this.value = value;
    }
    
    public static ProductoId generate() {
        return new ProductoId(UUID.randomUUID());
    }
    
    public static ProductoId from(String value) {
        return new ProductoId(UUID.fromString(value));
    }
    
    public UUID getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof ProductoId)) return false;
        ProductoId that = (ProductoId) obj;
        return areEqual(this.value, that.value);
    }
    
    @Override
    public int hashCode() {
        return hashOf(value);
    }
    
    @Override
    public String toString() {
        return value.toString();
    }
}