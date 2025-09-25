package com.miempresa.ventas.domain.valueobject;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.util.UUID;

@Embeddable
public class VentaId extends ValueObject {
     @Column(name = "id", nullable = false)
    private UUID value;

    protected VentaId() {
        // Requerido por JPA
    }

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
        if (this == obj)
            return true;
        if (!(obj instanceof VentaId))
            return false;
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