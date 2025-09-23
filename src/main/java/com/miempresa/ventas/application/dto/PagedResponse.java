package com.miempresa.ventas.application.dto;

import java.util.List;
import io.swagger.v3.oas.annotations.media.Schema;

/**
 * DTO genérico para respuestas paginadas siguiendo principios DDD.
 * Encapsula la información de paginación y los datos.
 */
@Schema(description = "Respuesta paginada genérica que contiene datos y metadatos de paginación")
public class PagedResponse<T> {
    
    @Schema(description = "Lista de elementos de la página actual")
    private final List<T> content;
    
    @Schema(description = "Número de página actual (inicia en 0)", example = "0")
    private final int page;
    
    @Schema(description = "Cantidad de elementos por página", example = "10")
    private final int size;
    
    @Schema(description = "Total de elementos en toda la colección", example = "100")
    private final long totalElements;
    
    @Schema(description = "Total de páginas disponibles", example = "10")
    private final int totalPages;
    
    @Schema(description = "Indica si es la primera página", example = "true")
    private final boolean first;
    
    @Schema(description = "Indica si es la última página", example = "false")
    private final boolean last;
    
    @Schema(description = "Indica si hay página siguiente", example = "true")
    private final boolean hasNext;
    
    @Schema(description = "Indica si hay página anterior", example = "false")
    private final boolean hasPrevious;
    
    public PagedResponse(List<T> content, int page, int size, long totalElements) {
        this.content = content;
        this.page = page;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = (int) Math.ceil((double) totalElements / size);
        this.first = page == 0;
        this.last = page >= totalPages - 1;
        this.hasNext = page < totalPages - 1;
        this.hasPrevious = page > 0;
    }
    
    // Getters
    public List<T> getContent() {
        return content;
    }
    
    public int getPage() {
        return page;
    }
    
    public int getSize() {
        return size;
    }
    
    public long getTotalElements() {
        return totalElements;
    }
    
    public int getTotalPages() {
        return totalPages;
    }
    
    public boolean isFirst() {
        return first;
    }
    
    public boolean isLast() {
        return last;
    }
    
    public boolean isHasNext() {
        return hasNext;
    }
    
    public boolean isHasPrevious() {
        return hasPrevious;
    }
    
    public boolean isEmpty() {
        return content.isEmpty();
    }
    
    public int getNumberOfElements() {
        return content.size();
    }
}