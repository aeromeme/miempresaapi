package com.miempresa.ventas.application.dto;

/**
 * DTO para filtros de búsqueda de clientes.
 * Value Object que encapsula los criterios de filtrado.
 */
public class ClienteFilter {
    
    private final String nombre;
    private final String correo;
    
    public ClienteFilter(String nombre, String correo) {
        this.nombre = nombre;
        this.correo = correo;
    }
    
    // Constructor para filtro solo por nombre
    public static ClienteFilter porNombre(String nombre) {
        return new ClienteFilter(nombre, null);
    }
    
    // Constructor para filtro solo por correo
    public static ClienteFilter porCorreo(String correo) {
        return new ClienteFilter(null, correo);
    }
    
    // Constructor para ambos filtros
    public static ClienteFilter porNombreYCorreo(String nombre, String correo) {
        return new ClienteFilter(nombre, correo);
    }
    
    // Constructor vacío (sin filtros)
    public static ClienteFilter sinFiltros() {
        return new ClienteFilter(null, null);
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public String getCorreo() {
        return correo;
    }
    
    public boolean hasNombreFilter() {
        return nombre != null && !nombre.trim().isEmpty();
    }
    
    public boolean hasCorreoFilter() {
        return correo != null && !correo.trim().isEmpty();
    }
    
    public boolean hasAnyFilter() {
        return hasNombreFilter() || hasCorreoFilter();
    }
    
    public boolean hasBothFilters() {
        return hasNombreFilter() && hasCorreoFilter();
    }
    
    public String getNombreLimpio() {
        return hasNombreFilter() ? nombre.trim() : null;
    }
    
    public String getCorreoLimpio() {
        return hasCorreoFilter() ? correo.trim() : null;
    }
    
    @Override
    public String toString() {
        return "ClienteFilter{" +
                "nombre='" + nombre + '\'' +
                ", correo='" + correo + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        
        ClienteFilter that = (ClienteFilter) obj;
        
        if (nombre != null ? !nombre.equals(that.nombre) : that.nombre != null) return false;
        return correo != null ? correo.equals(that.correo) : that.correo == null;
    }
    
    @Override
    public int hashCode() {
        int result = nombre != null ? nombre.hashCode() : 0;
        result = 31 * result + (correo != null ? correo.hashCode() : 0);
        return result;
    }
}