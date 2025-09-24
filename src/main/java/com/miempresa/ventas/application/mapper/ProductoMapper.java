package com.miempresa.ventas.application.mapper;

import com.miempresa.ventas.application.dto.ProductoDto;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Moneda;
import com.miempresa.ventas.domain.valueobject.Result;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapper para convertir entre entidades de dominio Producto y ProductoDto.
 * La moneda se obtiene de la configuración y se incluye en los DTOs,
 * pero no se persiste en la entidad de dominio.
 */
@Component
public class ProductoMapper {
    
    private final MonedaConfigurationService monedaConfigurationService;
    
    public ProductoMapper(MonedaConfigurationService monedaConfigurationService) {
        this.monedaConfigurationService = monedaConfigurationService;
    }
    
    /**
     * Convierte una entidad de dominio Producto a ProductoDto.
     * La moneda se obtiene de la configuración.
     */
    public ProductoDto toDto(Producto producto) {
        if (producto == null) {
            return null;
        }
        
        // Obtener moneda de configuración
        Moneda monedaConfiguracion = monedaConfigurationService.getMonedaPorDefecto();
        
        return new ProductoDto(
            producto.getId().getValue().toString(),
            producto.getNombre(),
            producto.getPrecio().getValor(),
            monedaConfiguracion.getCurrencyCode(),
            producto.getStock()
        );
    }
    
    /**
     * Convierte una lista de entidades de dominio Producto a lista de ProductoDto.
     */
    public List<ProductoDto> toDto(List<Producto> productos) {
        if (productos == null) {
            return null;
        }
        
        return productos.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Convierte un ProductoDto a entidad de dominio Producto.
     * Se asume que es un producto existente (con ID).
     * Nota: La moneda del DTO se ignora, solo se persiste el valor del precio.
     */
    public Result<Producto> toDomain(ProductoDto dto) {
        if (dto == null) {
            return Result.failure("El DTO no puede ser null");
        }
        
        ProductoId id = ProductoId.from(dto.getId());
        Precio precio = new Precio(dto.getPrecio());
        
        return Producto.reconstruct(id, dto.getNombre(), precio, dto.getStock());
    }
    
    /**
     * Crea una nueva entidad de dominio Producto a partir de parámetros.
     * Para productos nuevos (sin ID).
     * Nota: La moneda se valida pero no se persiste, solo el valor del precio.
     */
    public Result<Producto> toNewDomain(String nombre, BigDecimal valor, String moneda, int stock) {
        // Validar que la moneda sea soportada (aunque no se persista)
        if (!monedaConfigurationService.isMonedaSoportada(moneda)) {
            return Result.failure("Moneda no soportada: " + moneda + 
                ". Monedas soportadas: " + String.join(", ", monedaConfigurationService.getMonedasSoportadas()));
        }
        
        Precio precio = new Precio(valor);
        return Producto.create(nombre, precio, stock);
    }
}