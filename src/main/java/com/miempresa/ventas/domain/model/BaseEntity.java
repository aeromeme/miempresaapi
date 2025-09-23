package com.miempresa.ventas.domain.model;

/**
 * Base class for all domain entities following DDD principles.
 * Contains common entity behavior and ensures proper identity handling.
 */
public abstract class BaseEntity {
    
    protected abstract Object getId();
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        BaseEntity that = (BaseEntity) obj;
        return getId() != null && getId().equals(that.getId());
    }
    
    @Override
    public int hashCode() {
        return getId() != null ? getId().hashCode() : 0;
    }
}