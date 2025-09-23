package com.miempresa.ventas.application.usecase;

import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.application.dto.ClienteDto;
import com.miempresa.ventas.application.dto.PagedResponse;
import com.miempresa.ventas.application.dto.PageRequest;
import com.miempresa.ventas.application.dto.ClienteFilter;
import com.miempresa.ventas.application.mapper.ClienteMapper;
import java.util.List;

/**
 * Use Case para obtener listado paginado de clientes.
 * Encapsula la lógica de aplicación para consultas paginadas siguiendo DDD.
 */
public class ObtenerClientesPaginadosUseCase {
    
    private final ClienteRepository clienteRepository;
    
    public ObtenerClientesPaginadosUseCase(ClienteRepository clienteRepository) {
        this.clienteRepository = clienteRepository;
    }
    
    /**
     * Ejecuta el caso de uso para obtener clientes paginados sin filtros
     */
    public Result<PagedResponse<ClienteDto>> execute(PageRequest pageRequest) {
        return execute(pageRequest, ClienteFilter.sinFiltros());
    }
    
    /**
     * Ejecuta el caso de uso para obtener clientes paginados con filtros
     */
    public Result<PagedResponse<ClienteDto>> execute(PageRequest pageRequest, ClienteFilter filtros) {
        return validarPageRequest(pageRequest)
            .flatMap(pr -> validarFiltros(filtros))
            .flatMap(f -> obtenerClientesPaginadosConFiltros(pageRequest, f));
    }
    
    /**
     * Método de conveniencia para filtrar solo por nombre
     */
    public Result<PagedResponse<ClienteDto>> executeConFiltroNombre(PageRequest pageRequest, String nombre) {
        return execute(pageRequest, ClienteFilter.porNombre(nombre));
    }
    
    /**
     * Método de conveniencia para filtrar solo por correo
     */
    public Result<PagedResponse<ClienteDto>> executeConFiltroCorreo(PageRequest pageRequest, String correo) {
        return execute(pageRequest, ClienteFilter.porCorreo(correo));
    }
    
    private Result<PageRequest> validarPageRequest(PageRequest pageRequest) {
        if (pageRequest == null) {
            return Result.failure("Los parámetros de paginación son requeridos");
        }
        return Result.success(pageRequest);
    }
    
    private Result<ClienteFilter> validarFiltros(ClienteFilter filtros) {
        if (filtros == null) {
            return Result.failure("Los filtros no pueden ser null");
        }
        
        if (filtros.hasNombreFilter() && filtros.getNombreLimpio().length() < 2) {
            return Result.failure("El filtro de nombre debe tener al menos 2 caracteres");
        }
        
        if (filtros.hasCorreoFilter() && filtros.getCorreoLimpio().length() < 3) {
            return Result.failure("El filtro de correo debe tener al menos 3 caracteres");
        }
        
        return Result.success(filtros);
    }
    
    private Result<PagedResponse<ClienteDto>> obtenerClientesPaginadosConFiltros(
            PageRequest pageRequest, ClienteFilter filtros) {
        try {
            List<Cliente> clientes;
            long totalElements;
            
            if (!filtros.hasAnyFilter()) {
                // Sin filtros - búsqueda normal
                clientes = clienteRepository.findAll(
                    pageRequest.getOffset(), 
                    pageRequest.getSize()
                );
                totalElements = clienteRepository.count();
                
            } else if (filtros.hasBothFilters()) {
                // Filtro por nombre Y correo
                clientes = clienteRepository.findByNombreContainingAndCorreoContaining(
                    filtros.getNombreLimpio(),
                    filtros.getCorreoLimpio(),
                    pageRequest.getOffset(), 
                    pageRequest.getSize()
                );
                totalElements = clienteRepository.countByNombreContainingAndCorreoContaining(
                    filtros.getNombreLimpio(), 
                    filtros.getCorreoLimpio()
                );
                
            } else if (filtros.hasNombreFilter()) {
                // Solo filtro por nombre
                clientes = clienteRepository.findByNombreContaining(
                    filtros.getNombreLimpio(),
                    pageRequest.getOffset(), 
                    pageRequest.getSize()
                );
                totalElements = clienteRepository.countByNombreContaining(filtros.getNombreLimpio());
                
            } else {
                // Solo filtro por correo
                clientes = clienteRepository.findByCorreoContaining(
                    filtros.getCorreoLimpio(),
                    pageRequest.getOffset(), 
                    pageRequest.getSize()
                );
                totalElements = clienteRepository.countByCorreoContaining(filtros.getCorreoLimpio());
            }
            
            // Convertir a DTOs
            List<ClienteDto> clientesDto = ClienteMapper.toDto(clientes);
            
            // Crear respuesta paginada
            PagedResponse<ClienteDto> response = new PagedResponse<>(
                clientesDto, 
                pageRequest.getPage(), 
                pageRequest.getSize(), 
                totalElements
            );
            
            return Result.success(response);
            
        } catch (Exception e) {
            return Result.failure("Error al obtener clientes con filtros: " + e.getMessage());
        }
    }
    
    /**
     * Versión simplificada que retorna la primera página con tamaño por defecto
     */
    public Result<PagedResponse<ClienteDto>> executeDefault() {
        return execute(PageRequest.defaultPage());
    }
    
    /**
     * Obtiene todos los clientes sin paginación (usar con cuidado)
     */
    public Result<List<ClienteDto>> obtenerTodosLosClientes() {
        try {
            List<Cliente> clientes = clienteRepository.findAll();
            List<ClienteDto> clientesDto = ClienteMapper.toDto(clientes);
            return Result.success(clientesDto);
        } catch (Exception e) {
            return Result.failure("Error al obtener todos los clientes: " + e.getMessage());
        }
    }
}