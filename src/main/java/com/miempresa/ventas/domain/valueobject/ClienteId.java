package com.miempresa.ventas.domain.valueobject;

import java.util.UUID;

public class ClienteId extends ValueObject {
    private final UUID value;
    
    public ClienteId(UUID value) {
        if (value == null) {
            throw new IllegalArgumentException("ClienteId no puede ser null");
        }
        this.value = value;
    }
    
    public static ClienteId generate() {
        return new ClienteId(UUID.randomUUID());
    }
    
    public static ClienteId from(String value) {
        return new ClienteId(UUID.fromString(value));
    }
    
    public UUID getValue() {
        return value;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof ClienteId)) return false;
        ClienteId that = (ClienteId) obj;
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