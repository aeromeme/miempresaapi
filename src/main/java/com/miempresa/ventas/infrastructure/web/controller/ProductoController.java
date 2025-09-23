package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.application.dto.CreateProductoDto;
import com.miempresa.ventas.application.dto.UpdateProductoDto;
import com.miempresa.ventas.application.service.ProductoApplicationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
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
        @ApiResponse(responseCode = "200", description = "Lista de productos obtenida exitosamente")
    })
    public ResponseEntity<List<ProductoDto>> listarTodos() {
        List<ProductoDto> productos = productoService.findAll();
        return ResponseEntity.ok(productos);
    }
    
    @GetMapping("/{id}")
    @Operation(summary = "Obtener producto por ID", 
               description = "Busca y retorna un producto específico por su identificador único")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Producto encontrado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Producto no encontrado")
    })
    public ResponseEntity<ProductoDto> obtenerPorId(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id) {
        
        return productoService.findById(id)
                .map(producto -> ResponseEntity.ok(producto))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @Operation(summary = "Crear nuevo producto", 
               description = "Crea un nuevo producto en el sistema")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Producto creado exitosamente"),
        @ApiResponse(responseCode = "400", description = "Datos de entrada inválidos")
    })
    public ResponseEntity<ProductoDto> crear(@Valid @RequestBody CreateProductoDto createDto) {
        try {
            ProductoDto nuevoProducto = productoService.create(createDto);
            return ResponseEntity.status(HttpStatus.CREATED).body(nuevoProducto);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @PutMapping("/{id}")
    @Operation(summary = "Actualizar producto", 
               description = "Actualiza un producto existente. NOTA: La moneda NO se puede cambiar.")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Producto actualizado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Producto no encontrado"),
        @ApiResponse(responseCode = "400", description = "Datos de entrada inválidos")
    })
    public ResponseEntity<ProductoDto> actualizar(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id,
            @Valid @RequestBody UpdateProductoDto updateDto) {
        
        try {
            return productoService.update(id, updateDto)
                    .map(producto -> ResponseEntity.ok(producto))
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar producto", 
               description = "Elimina un producto del sistema")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Producto eliminado exitosamente"),
        @ApiResponse(responseCode = "404", description = "Producto no encontrado")
    })
    public ResponseEntity<Void> eliminar(
            @Parameter(description = "ID único del producto", required = true)
            @PathVariable String id) {
        
        boolean eliminado = productoService.deleteById(id);
        return eliminado ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
    
    @GetMapping("/buscar")
    @Operation(summary = "Buscar productos por nombre", 
               description = "Busca productos que contengan el texto especificado en el nombre")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Búsqueda realizada exitosamente")
    })
    public ResponseEntity<List<ProductoDto>> buscarPorNombre(
            @Parameter(description = "Texto a buscar en el nombre del producto", required = true)
            @RequestParam String nombre) {
        
        List<ProductoDto> productos = productoService.findByNombreContaining(nombre);
        return ResponseEntity.ok(productos);
    }
    
    @GetMapping("/config/monedas")
    @Operation(summary = "Obtener configuración de monedas", 
               description = "Obtiene la moneda por defecto y las monedas soportadas")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Configuración obtenida exitosamente")
    })
    public ResponseEntity<MonedaConfigDto> obtenerConfiguracionMonedas() {
        MonedaConfigDto config = new MonedaConfigDto(
            productoService.getMonedaPorDefecto(),
            productoService.getMonedasSoportadas()
        );
        return ResponseEntity.ok(config);
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