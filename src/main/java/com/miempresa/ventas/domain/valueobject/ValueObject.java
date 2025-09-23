package com.miempresa.ventas.domain.valueobject;

import java.util.Objects;

/**
 * Base class for Value Objects following DDD principles.
 * Value objects are immutable and compared by value, not identity.
 */
public abstract class ValueObject {
    
    @Override
    public abstract boolean equals(Object obj);
    
    @Override
    public abstract int hashCode();
    
    protected boolean areEqual(Object a, Object b) {
        return Objects.equals(a, b);
    }
    
    protected int hashOf(Object... values) {
        return Objects.hash(values);
    }
}