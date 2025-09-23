package com.miempresa.ventas.application.dto;

/**
 * DTO para representar información de paginación en requests.
 * Encapsula los parámetros de paginación con validaciones.
 */
public class PageRequest {
    private final int page;
    private final int size;
    
    public PageRequest(int page, int size) {
        if (page < 0) {
            throw new IllegalArgumentException("El número de página no puede ser negativo");
        }
        if (size <= 0) {
            throw new IllegalArgumentException("El tamaño de página debe ser mayor a 0");
        }
        if (size > 100) {
            throw new IllegalArgumentException("El tamaño de página no puede exceder 100 elementos");
        }
        
        this.page = page;
        this.size = size;
    }
    
    public static PageRequest of(int page, int size) {
        return new PageRequest(page, size);
    }
    
    public static PageRequest defaultPage() {
        return new PageRequest(0, 20);
    }
    
    public int getPage() {
        return page;
    }
    
    public int getSize() {
        return size;
    }
    
    public int getOffset() {
        return page * size;
    }
    
    public PageRequest next() {
        return new PageRequest(page + 1, size);
    }
    
    public PageRequest previous() {
        return page == 0 ? this : new PageRequest(page - 1, size);
    }
    
    public PageRequest first() {
        return new PageRequest(0, size);
    }
    
    @Override
    public String toString() {
        return String.format("PageRequest{page=%d, size=%d}", page, size);
    }
}