package com.miempresa.ventas.domain.valueobject;

import java.util.UUID;

public class ProductoId extends ValueObject {
    private final UUID value;
    
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