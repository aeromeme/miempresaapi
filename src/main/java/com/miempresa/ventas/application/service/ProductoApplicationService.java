package com.miempresa.ventas.application.service;

import com.miempresa.ventas.domain.repository.ProductoRepository;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Moneda;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.application.dto.CreateProductoDto;
import com.miempresa.ventas.application.dto.UpdateProductoDto;
import com.miempresa.ventas.application.mapper.ProductoMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

/**
 * Application Service para operaciones CRUD de Productos.
 * Orquesta los use cases básicos y actúa como fachada para la capa de aplicación.
 */
@Service
public class ProductoApplicationService {
    
    private final ProductoRepository productoRepository;
    private final ProductoMapper productoMapper;
    private final MonedaConfigurationService monedaConfigurationService;
    
    public ProductoApplicationService(ProductoRepository productoRepository, 
                                    ProductoMapper productoMapper,
                                    MonedaConfigurationService monedaConfigurationService) {
        this.productoRepository = productoRepository;
        this.productoMapper = productoMapper;
        this.monedaConfigurationService = monedaConfigurationService;
    }
    
    /**
     * Crea un nuevo producto
     */
    public Result<ProductoDto> create(CreateProductoDto createDto) {
        try {
            // Usar la moneda por defecto configurada
            Moneda monedaPorDefecto = monedaConfigurationService.getMonedaPorDefecto();
            
            // Validar que la moneda por defecto sea válida
            if (!monedaConfigurationService.isMonedaSoportada(monedaPorDefecto.getCurrencyCode())) {
                return Result.failure("La moneda por defecto configurada no es válida: " + 
                    monedaPorDefecto.getCurrencyCode());
            }
            
            // Crear producto con solo el valor del precio (sin moneda)
            Precio precio = new Precio(createDto.getPrecio());
            
            return Producto.create(createDto.getNombre(), precio, createDto.getStock())
                .map(producto -> productoMapper.toDto(productoRepository.save(producto)));
        } catch (Exception e) {
            return Result.failure("Error al crear producto: " + e.getMessage());
        }
    }
    
    /**
     * Crea un nuevo producto (método de conveniencia con parámetros individuales)
     */
    public Result<ProductoDto> create(String nombre, BigDecimal precio, String moneda, int stock) {
        // Validar que la moneda sea soportada
        if (!monedaConfigurationService.isMonedaSoportada(moneda)) {
            return Result.failure("Moneda no soportada: " + moneda + 
                ". Monedas soportadas: " + String.join(", ", monedaConfigurationService.getMonedasSoportadas()));
        }
        
        try {
            return productoMapper.toNewDomain(nombre, precio, moneda, stock)
                .map(producto -> productoMapper.toDto(productoRepository.save(producto)));
        } catch (Exception e) {
            return Result.failure("Error al crear producto: " + e.getMessage());
        }
    }
    
    /**
     * Crea un nuevo producto usando la moneda por defecto configurada
     */
    public Result<ProductoDto> create(String nombre, BigDecimal precio, int stock) {
        CreateProductoDto createDto = new CreateProductoDto(nombre, precio, stock);
        return create(createDto);
    }
    
    /**
     * Obtiene un producto por su ID
     */
    public Result<ProductoDto> findById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            return Result.success(productoRepository.findById(productoId))
                .flatMap(productoOpt -> productoOpt
                    .map(producto -> Result.success(productoMapper.toDto(producto)))
                    .orElse(Result.failure("Producto no encontrado con ID: " + id)));
        } catch (Exception e) {
            return Result.failure("Error al obtener producto: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene todos los productos
     */
    public Result<List<ProductoDto>> findAll() {
        try {
            List<Producto> productos = productoRepository.findAll();
            return Result.success(productoMapper.toDto(productos));
        } catch (Exception e) {
            return Result.failure("Error al obtener productos: " + e.getMessage());
        }
    }
    
    /**
     * Busca productos por nombre
     */
    public Result<List<ProductoDto>> findByNombreContaining(String nombre) {
        try {
            List<Producto> productos = productoRepository.findByNombreContaining(nombre);
            return Result.success(productoMapper.toDto(productos));
        } catch (Exception e) {
            return Result.failure("Error al buscar productos: " + e.getMessage());
        }
    }
    
    /**
     * Actualiza un producto existente
     */
    public Result<ProductoDto> update(String id, UpdateProductoDto updateDto) {
        try {
            ProductoId productoId = ProductoId.from(id);
            
            return Result.success(productoRepository.findById(productoId))
                .flatMap(productoOpt -> productoOpt
                    .map(productoExistente -> {
                        // Usar valores del DTO si están presentes, sino mantener los valores existentes
                        String nombre = updateDto.hasNombre() ? updateDto.getNombre() : productoExistente.getNombre();
                        BigDecimal precioValor = updateDto.hasPrecio() ? updateDto.getPrecio() : productoExistente.getPrecio().getValor();
                        int stock = updateDto.hasStock() ? updateDto.getStock() : productoExistente.getStock();
                        
                        // Crear nuevo producto con los datos actualizados
                        Precio precio = new Precio(precioValor);
                        
                        return Producto.reconstruct(productoId, nombre, precio, stock);
                    })
                    .orElse(Result.failure("Producto no encontrado con ID: " + id)))
                .map(producto -> productoMapper.toDto(productoRepository.save(producto)));
        } catch (Exception e) {
            return Result.failure("Error al actualizar producto: " + e.getMessage());
        }
    }
    
    /**
     * Actualiza un producto existente (método de conveniencia con parámetros individuales)
     * Nota: La moneda NO se puede actualizar - mantiene la moneda original del producto
     */
    public Result<ProductoDto> update(String id, String nombre, BigDecimal precioValor, int stock) {
        UpdateProductoDto updateDto = new UpdateProductoDto(nombre, precioValor, stock);
        return update(id, updateDto);
    }
    
    /**
     * Actualiza un producto existente (método legacy - ignora parámetro moneda)
     * @deprecated La moneda no se puede actualizar. Use update(id, nombre, precio, stock)
     */
    @Deprecated
    public Result<ProductoDto> update(String id, String nombre, BigDecimal precioValor, String moneda, int stock) {
        // Ignorar el parámetro moneda - no se puede actualizar
        return update(id, nombre, precioValor, stock);
    }
    
    /**
     * Elimina un producto por su ID
     */
    public Result<Boolean> deleteById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            
            if (!productoRepository.existsById(productoId)) {
                return Result.failure("Producto no encontrado con ID: " + id);
            }
            
            productoRepository.deleteById(productoId);
            return Result.success(true);
            
        } catch (Exception e) {
            return Result.failure("Error al eliminar producto: " + e.getMessage());
        }
    }
    
    /**
     * Verifica si un producto existe
     */
    public Result<Boolean> existsById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            return Result.success(productoRepository.existsById(productoId));
        } catch (Exception e) {
            return Result.failure("Error al verificar existencia del producto: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene la moneda por defecto configurada
     */
    public Result<String> getMonedaPorDefecto() {
        try {
            return Result.success(monedaConfigurationService.getMonedaPorDefecto().getCurrencyCode());
        } catch (Exception e) {
            return Result.failure("Error al obtener moneda por defecto: " + e.getMessage());
        }
    }
    
    /**
     * Obtiene las monedas soportadas por el sistema
     */
    public Result<String[]> getMonedasSoportadas() {
        try {
            return Result.success(monedaConfigurationService.getMonedasSoportadas());
        } catch (Exception e) {
            return Result.failure("Error al obtener monedas soportadas: " + e.getMessage());
        }
    }
    
    /**
     * Verifica si una moneda está soportada
     */
    public Result<Boolean> isMonedaSoportada(String codigoMoneda) {
        try {
            return Result.success(monedaConfigurationService.isMonedaSoportada(codigoMoneda));
        } catch (Exception e) {
            return Result.failure("Error al verificar moneda soportada: " + e.getMessage());
        }
    }
}