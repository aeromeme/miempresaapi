package com.miempresa.ventas.application.service;

import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.application.dto.ClienteDto;
import com.miempresa.ventas.application.dto.PagedResponse;
import com.miempresa.ventas.application.dto.PageRequest;
import com.miempresa.ventas.application.dto.ClienteFilter;
import com.miempresa.ventas.application.usecase.ObtenerClientesPaginadosUseCase;
import java.util.List;

/**
 * Application Service para operaciones relacionadas con Clientes.
 * Orquesta los use cases y actúa como fachada para la capa de aplicación.
 */
public class ClienteApplicationService {
    
    private final ObtenerClientesPaginadosUseCase obtenerClientesPaginadosUseCase;
    
    public ClienteApplicationService(ClienteRepository clienteRepository) {
        this.obtenerClientesPaginadosUseCase = new ObtenerClientesPaginadosUseCase(clienteRepository);
    }
    
    /**
     * Obtiene una lista paginada de clientes sin filtros
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesPaginados(int page, int size) {
        return Result.success(PageRequest.of(page, size))
            .flatMap(obtenerClientesPaginadosUseCase::execute);
    }
    
    /**
     * Obtiene una lista paginada de clientes con filtros
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesPaginados(
            int page, int size, ClienteFilter filtros) {
        return Result.success(PageRequest.of(page, size))
            .flatMap(pageRequest -> obtenerClientesPaginadosUseCase.execute(pageRequest, filtros));
    }
    
    /**
     * Obtiene una lista paginada de clientes con filtro por nombre
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesPorNombre(
            int page, int size, String filtroNombre) {
        return Result.success(PageRequest.of(page, size))
            .flatMap(pageRequest -> obtenerClientesPaginadosUseCase.executeConFiltroNombre(pageRequest, filtroNombre));
    }
    
    /**
     * Obtiene una lista paginada de clientes con filtro por correo
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesPorCorreo(
            int page, int size, String filtroCorreo) {
        return Result.success(PageRequest.of(page, size))
            .flatMap(pageRequest -> obtenerClientesPaginadosUseCase.executeConFiltroCorreo(pageRequest, filtroCorreo));
    }
    
    /**
     * Obtiene una lista paginada de clientes con filtro por nombre y correo
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesPorNombreYCorreo(
            int page, int size, String nombre, String correo) {
        ClienteFilter filtros = ClienteFilter.porNombreYCorreo(nombre, correo);
        return obtenerClientesPaginados(page, size, filtros);
    }
    
    /**
     * Obtiene la primera página con configuración por defecto
     */
    public Result<PagedResponse<ClienteDto>> obtenerClientesDefault() {
        return obtenerClientesPaginadosUseCase.executeDefault();
    }
    
    /**
     * Busca clientes por nombre (sin paginación - usar con precaución)
     */
    public Result<List<ClienteDto>> buscarClientesPorNombre(String filtroNombre) {
        if (filtroNombre == null || filtroNombre.trim().isEmpty()) {
            return Result.failure("El filtro de búsqueda no puede estar vacío");
        }
        
        // Para búsquedas pequeñas, podemos obtener una página grande
        return obtenerClientesPaginadosUseCase.executeConFiltroNombre(PageRequest.of(0, 100), filtroNombre)
            .map(PagedResponse::getContent);
    }
    
    /**
     * Obtiene todos los clientes (usar solo para casos específicos como reportes)
     */
    public Result<List<ClienteDto>> obtenerTodosLosClientes() {
        return obtenerClientesPaginadosUseCase.obtenerTodosLosClientes();
    }
}