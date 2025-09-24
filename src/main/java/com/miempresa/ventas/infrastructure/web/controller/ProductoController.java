package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.application.dto.CreateProductoDto;
import com.miempresa.ventas.application.dto.UpdateProductoDto;
import com.miempresa.ventas.application.service.ProductoApplicationService;
import com.miempresa.ventas.domain.valueobject.Result;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controlador REST para gestión de productos.
 */
@RestController
@RequestMapping("/api/productos")
@Tag(name = "Productos", description = "API para gestión de productos")
public class ProductoController {
    
    private final ProductoApplicationService productoService;
    
    public ProductoController(ProductoApplicationService productoService) {
        this.productoService = productoService;
    }
    
    @GetMapping
    @Operation(summary = "Listar todos los productos", 
               description = "Obtiene una lista de todos los productos disponibles")
    @ApiResponses({
        @ApiResponse(responseCode = "200", 
                    description = "Lista de productos obtenida exitosamente",
                    content = @Content(schema = @Schema(implementation = ProductoDto.class))),
        @ApiResponse(responseCode = "500", 
                    description = "Error interno al obtener los productos",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> listarTodos() {
        return productoService.findAll()
            .match(
                ResponseEntity::ok,
                error -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "Error al obtener la lista de productos: " + error.get(0)))
            );
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Obtener producto por ID", 
               description = "Busca y retorna un producto específico por su identificador único")
    @ApiResponses({
        @ApiResponse(responseCode = "200", 
                    description = "Producto encontrado exitosamente",
                    content = @Content(schema = @Schema(implementation = ProductoDto.class))),
        @ApiResponse(responseCode = "404", 
                    description = "Producto no encontrado",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> obtenerPorId(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id) {
        
        return productoService.findById(id)
            .match(
                ResponseEntity::ok,
                error -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.NOT_FOUND,
                        "Producto no encontrado con ID: " + id))
            );
    }
    
    @PostMapping
    @Operation(summary = "Crear nuevo producto", 
               description = "Crea un nuevo producto en el sistema")
    @ApiResponses({
        @ApiResponse(responseCode = "201", 
                    description = "Producto creado exitosamente",
                    content = @Content(schema = @Schema(implementation = ProductoDto.class))),
        @ApiResponse(responseCode = "400", 
                    description = "Datos de entrada inválidos",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> crear(@Valid @RequestBody CreateProductoDto createDto) {
        return productoService.create(createDto)
            .match(
                producto -> ResponseEntity.status(HttpStatus.CREATED).body(producto),
                error -> ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.BAD_REQUEST,
                        "Error al crear el producto: " + error.get(0)))
            );
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Actualizar producto", 
               description = "Actualiza un producto existente")
    @ApiResponses({
        @ApiResponse(responseCode = "200", 
                    description = "Producto actualizado exitosamente",
                    content = @Content(schema = @Schema(implementation = ProductoDto.class))),
        @ApiResponse(responseCode = "404", 
                    description = "Producto no encontrado",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class))),
        @ApiResponse(responseCode = "400", 
                    description = "Datos de entrada inválidos",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> actualizar(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id,
            @Valid @RequestBody UpdateProductoDto updateDto) {
        
        return productoService.update(id, updateDto)
            .match(
                ResponseEntity::ok,
                error -> {
                    if (error.get(0).contains("no encontrado")) {
                        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                            .body(ProblemDetail.forStatusAndDetail(
                                HttpStatus.NOT_FOUND,
                                "Producto no encontrado con ID: " + id));
                    }
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(ProblemDetail.forStatusAndDetail(
                            HttpStatus.BAD_REQUEST,
                            "Error al actualizar el producto: " + error.get(0)));
                });
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar producto", 
               description = "Elimina un producto del sistema")
    @ApiResponses({
        @ApiResponse(responseCode = "204", 
                    description = "Producto eliminado exitosamente"),
        @ApiResponse(responseCode = "404", 
                    description = "Producto no encontrado",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> eliminar(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id) {
        
        return productoService.deleteById(id)
            .match(
                deleted -> ResponseEntity.noContent().build(),
                error -> ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.NOT_FOUND,
                        "Producto no encontrado con ID: " + id))
            );
    }
    
    @GetMapping("/buscar")
    @Operation(summary = "Buscar productos por nombre", 
               description = "Busca productos que contengan el texto especificado en el nombre")
    @ApiResponses({
        @ApiResponse(responseCode = "200", 
                    description = "Búsqueda realizada exitosamente",
                    content = @Content(schema = @Schema(implementation = ProductoDto.class))),
        @ApiResponse(responseCode = "500", 
                    description = "Error interno al realizar la búsqueda",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> buscarPorNombre(
            @Parameter(description = "Texto a buscar en el nombre del producto", required = true)
            @RequestParam String nombre) {
        
        return productoService.findByNombreContaining(nombre)
            .match(
                ResponseEntity::ok,
                error -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "Error al buscar productos por nombre: " + error.get(0)))
            );
    }
    
    @GetMapping("/config/monedas")
    @Operation(summary = "Obtener configuración de monedas", 
               description = "Obtiene la moneda por defecto y las monedas soportadas")
    @ApiResponses({
        @ApiResponse(responseCode = "200", 
                    description = "Configuración obtenida exitosamente",
                    content = @Content(schema = @Schema(implementation = MonedaConfigDto.class))),
        @ApiResponse(responseCode = "500", 
                    description = "Error al obtener la configuración",
                    content = @Content(schema = @Schema(implementation = ProblemDetail.class)))
    })
    public ResponseEntity<?> obtenerConfiguracionMonedas() {
        Result<String> monedaPorDefectoResult = productoService.getMonedaPorDefecto();
        Result<String[]> monedasSupportadasResult = productoService.getMonedasSoportadas();
        
        return Result.combine(
            monedaPorDefectoResult,
            monedasSupportadasResult,
            monedaPorDefecto -> monedasSoportadas -> new MonedaConfigDto(monedaPorDefecto, monedasSoportadas)
        )
        .match(
            ResponseEntity::ok,
            error -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(ProblemDetail.forStatusAndDetail(
                        HttpStatus.INTERNAL_SERVER_ERROR,
                        "Error al obtener la configuración de monedas: " + error.get(0)))
        );
    }
    
    // DTO para la configuración de monedas
    @Schema(description = "Configuración de monedas del sistema")
    public static class MonedaConfigDto {
        
        @Schema(description = "Código de la moneda por defecto", example = "USD")
        private final String monedaPorDefecto;
        
        @Schema(description = "Lista de códigos de monedas soportadas")
        private final String[] monedasSoportadas;
        
        public MonedaConfigDto(String monedaPorDefecto, String[] monedasSoportadas) {
            this.monedaPorDefecto = monedaPorDefecto;
            this.monedasSoportadas = monedasSoportadas;
        }
        
        public String getMonedaPorDefecto() {
            return monedaPorDefecto;
        }
        
        public String[] getMonedasSoportadas() {
            return monedasSoportadas;
        }
    }
}