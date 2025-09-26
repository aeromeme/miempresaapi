package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.service.ClienteApplicationService;
import com.miempresa.ventas.application.dto.ClienteDto;
import com.miempresa.ventas.application.dto.PagedResponse;
import com.miempresa.ventas.application.dto.ClienteFilter;
import com.miempresa.ventas.domain.valueobject.Result;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.Map;

/**
 * Controlador REST para operaciones relacionadas con Clientes.
 * Expone endpoints para consultas paginadas y filtradas de clientes.
 * 
 * Swagger UI estará disponible en: http://localhost:8080/swagger-ui.html
 */
@RestController
@RequestMapping("/api/clientes")
@Tag(name = "Clientes", description = "API para gestión de clientes")
public class ClienteController {
    
    private final ClienteApplicationService clienteApplicationService;
    
    public ClienteController(ClienteApplicationService clienteApplicationService) {
        this.clienteApplicationService = clienteApplicationService;
    }
    
    /**
     * Obtiene clientes paginados sin filtros
     * GET /api/v1/clientes?page=0&size=10
     */
    @GetMapping
    @Operation(
        summary = "Obtener clientes paginados",
        description = "Obtiene una lista paginada de todos los clientes registrados en el sistema"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200", 
            description = "Lista de clientes obtenida exitosamente",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = PagedResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "Parámetros de paginación inválidos",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ProblemDetail.class)
            )
        )
    })
    public ResponseEntity<?> obtenerClientes(
            @Parameter(description = "Número de página (inicia en 0)", example = "0")
            @RequestParam(defaultValue = "0") int page,
            
            @Parameter(description = "Cantidad de elementos por página", example = "10")
            @RequestParam(defaultValue = "10") int size) {
        
        Result<PagedResponse<ClienteDto>> result = clienteApplicationService
            .obtenerClientesPaginados(page, size);
        
        if (result.isSuccess()) {
            return ResponseEntity.ok(result.getValue());
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "Error en la paginación: " + result.getFirstError()));
        }
    }
    
    /**
     * Obtiene clientes filtrados por nombre
     * GET /api/v1/clientes/buscar-por-nombre?nombre=Juan&page=0&size=10
     */
    @GetMapping("/buscar-por-nombre")
    @Operation(
        summary = "Buscar clientes por nombre",
        description = "Obtiene una lista paginada de clientes cuyo nombre contenga el texto especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200", 
            description = "Lista de clientes filtrada obtenida exitosamente",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = PagedResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "Parámetros inválidos o filtro de nombre requerido",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ProblemDetail.class)
            )
        )
    })
    public ResponseEntity<?> obtenerClientesPorNombre(
            @Parameter(description = "Texto a buscar en el nombre del cliente", example = "Juan", required = true)
            @RequestParam String nombre,
            
            @Parameter(description = "Número de página (inicia en 0)", example = "0")
            @RequestParam(defaultValue = "0") int page,
            
            @Parameter(description = "Cantidad de elementos por página", example = "10")
            @RequestParam(defaultValue = "10") int size) {
        
        if (nombre == null || nombre.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "El parámetro 'nombre' es requerido"));
        }
        
        Result<PagedResponse<ClienteDto>> result = clienteApplicationService
            .obtenerClientesPorNombre(page, size, nombre);
        
        if (result.isSuccess()) {
            return ResponseEntity.ok(result.getValue());
        } else {
            return ResponseEntity.badRequest().body(Map.of("error", result.getFirstError()));
        }
    }
    
    /**
     * Obtiene clientes filtrados por correo
     * GET /api/v1/clientes/buscar-por-correo?correo=gmail.com&page=0&size=10
     */
    @GetMapping("/buscar-por-correo")
    @Operation(
        summary = "Buscar clientes por correo electrónico",
        description = "Obtiene una lista paginada de clientes cuyo correo electrónico contenga el texto especificado"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200", 
            description = "Lista de clientes filtrada por correo obtenida exitosamente",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = PagedResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "Parámetros inválidos o filtro de correo requerido",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ProblemDetail.class)
            )
        )
    })
    public ResponseEntity<?> obtenerClientesPorCorreo(
            @Parameter(description = "Texto a buscar en el correo electrónico", example = "gmail.com", required = true)
            @RequestParam String correo,
            
            @Parameter(description = "Número de página (inicia en 0)", example = "0")
            @RequestParam(defaultValue = "0") int page,
            
            @Parameter(description = "Cantidad de elementos por página", example = "10")
            @RequestParam(defaultValue = "10") int size) {
        
        if (correo == null || correo.trim().isEmpty()) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "El parámetro 'correo' es requerido"));
        }
        
        Result<PagedResponse<ClienteDto>> result = clienteApplicationService
            .obtenerClientesPorCorreo(page, size, correo);
        
        if (result.isSuccess()) {
            return ResponseEntity.ok(result.getValue());
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "Error al buscar clientes por correo: " + result.getFirstError()));
        }
    }
    
    /**
     * Obtiene clientes filtrados por nombre Y correo
     * GET /api/v1/clientes/buscar?nombre=Juan&correo=gmail.com&page=0&size=10
     */
    @GetMapping("/buscar")
    @Operation(
        summary = "Buscar clientes con filtros combinados",
        description = "Obtiene una lista paginada de clientes aplicando filtros por nombre y/o correo electrónico"
    )
    @ApiResponses(value = {
        @ApiResponse(
            responseCode = "200", 
            description = "Lista de clientes con filtros aplicados obtenida exitosamente",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = PagedResponse.class)
            )
        ),
        @ApiResponse(
            responseCode = "400", 
            description = "Parámetros inválidos o al menos un filtro es requerido",
            content = @Content(
                mediaType = "application/json",
                schema = @Schema(implementation = ProblemDetail.class)
            )
        )
    })
    public ResponseEntity<?> obtenerClientesFiltrados(
            @Parameter(description = "Texto a buscar en el nombre o correo del cliente", example = "Juan o juan@gmail.com")
            @RequestParam(required = false) String query,
            
            @Parameter(description = "Número de página (inicia en 0)", example = "0")
            @RequestParam(defaultValue = "0") int page,
            
            @Parameter(description = "Cantidad de elementos por página", example = "10")
            @RequestParam(defaultValue = "10") int size) {
        
        
        Result<PagedResponse<ClienteDto>> result;

        if (query != null && !query.trim().isEmpty()) {
            // Ambos filtros
            result = clienteApplicationService.obtenerClientesPorNombreYCorreo(page, size, query);
        } else {
            // Asignar un resultado de error si no hay filtro
            result = Result.failure("El parámetro 'query' es requerido");
        }
        
        if (result.isSuccess()) {
            return ResponseEntity.ok(result.getValue());
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ProblemDetail.forStatusAndDetail(
                    HttpStatus.BAD_REQUEST,
                    "Error al buscar clientes con los filtros especificados: " + result.getFirstError()));
        }
    }
}