package com.miempresa.ventas.application.service;

import com.miempresa.ventas.domain.repository.ProductoRepository;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Moneda;
import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.application.dto.CreateProductoDto;
import com.miempresa.ventas.application.dto.UpdateProductoDto;
import com.miempresa.ventas.application.mapper.ProductoMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

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
    public ProductoDto create(CreateProductoDto createDto) {
        try {
            // Usar la moneda por defecto configurada
            Moneda monedaPorDefecto = monedaConfigurationService.getMonedaPorDefecto();
            
            // Validar que la moneda por defecto sea válida
            if (!monedaConfigurationService.isMonedaSoportada(monedaPorDefecto.getCurrencyCode())) {
                throw new IllegalStateException("La moneda por defecto configurada no es válida: " + 
                    monedaPorDefecto.getCurrencyCode());
            }
            
            // Crear producto con solo el valor del precio (sin moneda)
            Precio precio = new Precio(createDto.getPrecio());
            Producto producto = new Producto(createDto.getNombre(), precio, createDto.getStock());
            
            Producto savedProducto = productoRepository.save(producto);
            return productoMapper.toDto(savedProducto);
        } catch (Exception e) {
            throw new RuntimeException("Error al crear producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Crea un nuevo producto (método de conveniencia con parámetros individuales)
     */
    public ProductoDto create(String nombre, BigDecimal precio, String moneda, int stock) {
        try {
            // Validar que la moneda sea soportada
            if (!monedaConfigurationService.isMonedaSoportada(moneda)) {
                throw new IllegalArgumentException("Moneda no soportada: " + moneda + 
                    ". Monedas soportadas: " + String.join(", ", monedaConfigurationService.getMonedasSoportadas()));
            }
            
            Producto producto = productoMapper.toNewDomain(nombre, precio, moneda, stock);
            Producto savedProducto = productoRepository.save(producto);
            return productoMapper.toDto(savedProducto);
        } catch (Exception e) {
            throw new RuntimeException("Error al crear producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Crea un nuevo producto usando la moneda por defecto configurada
     */
    public ProductoDto create(String nombre, BigDecimal precio, int stock) {
        CreateProductoDto createDto = new CreateProductoDto(nombre, precio, stock);
        return create(createDto);
    }
    
    /**
     * Obtiene un producto por su ID
     */
    public Optional<ProductoDto> findById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            return productoRepository.findById(productoId)
                    .map(productoMapper::toDto);
        } catch (Exception e) {
            throw new RuntimeException("Error al obtener producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Obtiene todos los productos
     */
    public List<ProductoDto> findAll() {
        try {
            List<Producto> productos = productoRepository.findAll();
            return productoMapper.toDto(productos);
        } catch (Exception e) {
            throw new RuntimeException("Error al obtener productos: " + e.getMessage(), e);
        }
    }
    
    /**
     * Busca productos por nombre
     */
    public List<ProductoDto> findByNombreContaining(String nombre) {
        try {
            List<Producto> productos = productoRepository.findByNombreContaining(nombre);
            return productoMapper.toDto(productos);
        } catch (Exception e) {
            throw new RuntimeException("Error al buscar productos: " + e.getMessage(), e);
        }
    }
    
    /**
     * Actualiza un producto existente
     */
    public Optional<ProductoDto> update(String id, UpdateProductoDto updateDto) {
        try {
            ProductoId productoId = ProductoId.from(id);
            Optional<Producto> productoOpt = productoRepository.findById(productoId);
            
            if (productoOpt.isEmpty()) {
                return Optional.empty();
            }
            
            Producto productoExistente = productoOpt.get();
            
            // Usar valores del DTO si están presentes, sino mantener los valores existentes
            String nombre = updateDto.hasNombre() ? updateDto.getNombre() : productoExistente.getNombre();
            BigDecimal precioValor = updateDto.hasPrecio() ? updateDto.getPrecio() : productoExistente.getPrecio().getValor();
            int stock = updateDto.hasStock() ? updateDto.getStock() : productoExistente.getStock();
            
            // Crear nuevo producto con los datos actualizados
            Precio precio = new Precio(precioValor);
            Producto productoActualizado = new Producto(productoId, nombre, precio, stock);
            
            Producto savedProducto = productoRepository.save(productoActualizado);
            return Optional.of(productoMapper.toDto(savedProducto));
            
        } catch (Exception e) {
            throw new RuntimeException("Error al actualizar producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Actualiza un producto existente (método de conveniencia con parámetros individuales)
     * Nota: La moneda NO se puede actualizar - mantiene la moneda original del producto
     */
    public Optional<ProductoDto> update(String id, String nombre, BigDecimal precioValor, int stock) {
        UpdateProductoDto updateDto = new UpdateProductoDto(nombre, precioValor, stock);
        return update(id, updateDto);
    }
    
    /**
     * Actualiza un producto existente (método legacy - ignora parámetro moneda)
     * @deprecated La moneda no se puede actualizar. Use update(id, nombre, precio, stock)
     */
    @Deprecated
    public Optional<ProductoDto> update(String id, String nombre, BigDecimal precioValor, String moneda, int stock) {
        // Ignorar el parámetro moneda - no se puede actualizar
        return update(id, nombre, precioValor, stock);
    }
    
    /**
     * Elimina un producto por su ID
     */
    public boolean deleteById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            
            if (!productoRepository.existsById(productoId)) {
                return false;
            }
            
            productoRepository.deleteById(productoId);
            return true;
            
        } catch (Exception e) {
            throw new RuntimeException("Error al eliminar producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Verifica si un producto existe
     */
    public boolean existsById(String id) {
        try {
            ProductoId productoId = ProductoId.from(id);
            return productoRepository.existsById(productoId);
        } catch (Exception e) {
            throw new RuntimeException("Error al verificar existencia del producto: " + e.getMessage(), e);
        }
    }
    
    /**
     * Obtiene la moneda por defecto configurada
     */
    public String getMonedaPorDefecto() {
        return monedaConfigurationService.getMonedaPorDefecto().getCurrencyCode();
    }
    
    /**
     * Obtiene las monedas soportadas por el sistema
     */
    public String[] getMonedasSoportadas() {
        return monedaConfigurationService.getMonedasSoportadas();
    }
    
    /**
     * Verifica si una moneda está soportada
     */
    public boolean isMonedaSoportada(String codigoMoneda) {
        return monedaConfigurationService.isMonedaSoportada(codigoMoneda);
    }
}