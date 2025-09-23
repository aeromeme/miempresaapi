package com.miempresa.ventas.domain.valueobject;

import java.util.UUID;

public class VentaId extends ValueObject {
    private final UUID value;
    
    public VentaId(UUID value) {
        if (value == null) {
            throw new IllegalArgumentException("VentaId no puede ser null");
        }
        this.value = value;
    }
    
    public static VentaId generate() {
        return new VentaId(UUID.randomUUID());
    }
    
    public static VentaId from(String value) {
        return new VentaId(UUID.fromString(value));
    }
    
    public UUID getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof VentaId)) return false;
        VentaId that = (VentaId) obj;
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