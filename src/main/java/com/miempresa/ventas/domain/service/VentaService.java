package com.miempresa.ventas.domain.service;

import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Result;
import java.util.List;

import org.springframework.stereotype.Component;

/**
 * Domain service for managing sales business logic that doesn't belong 
 * to any specific entity following DDD principles.
 */
@Component
public class VentaService {
    
    /**
     * Creates a new sale with the specified products and quantities
     */
    public Result<Venta> crearVenta(Cliente cliente, List<ProductoVentaRequest> productos) {
        return validarClienteId(cliente != null ? cliente.getId() : null)
            .flatMap(cId -> validarProductos(productos))
            .flatMap(prods -> procesarVenta(cliente, productos));
    }
    
    private Result<ClienteId> validarClienteId(ClienteId clienteId) {
        if (clienteId == null) {
            return Result.failure("El cliente no puede ser null");
        }
        return Result.success(clienteId);
    }
    
    private Result<List<ProductoVentaRequest>> validarProductos(List<ProductoVentaRequest> productos) {
        if (productos == null || productos.isEmpty()) {
            return Result.failure("Debe especificar al menos un producto");
        }
        
        // Validar cada producto
        for (int i = 0; i < productos.size(); i++) {
            ProductoVentaRequest request = productos.get(i);
            if (request == null) {
                return Result.failure("El producto en la posición " + i + " no puede ser null");
            }
            if (request.getProducto() == null) {
                return Result.failure("El producto en la posición " + i + " no puede ser null");
            }
            if (request.getCantidad() <= 0) {
                return Result.failure("La cantidad del producto '" + request.getProducto().getNombre() + "' debe ser mayor a 0");
            }
        }
        
        return Result.success(productos);
    }
    
    private Result<Venta> procesarVenta(Cliente cliente, List<ProductoVentaRequest> productos) {
        Venta venta = new Venta(cliente);

        for (ProductoVentaRequest request : productos) {
            Result<Void> resultado = venta.agregarLinea(request.getProducto(), request.getCantidad());
            if (resultado.isFailure()) {
                return Result.failure("Error al agregar producto '" + request.getProducto().getNombre() + "': " + resultado.getFirstError());
            }
        }
        
        return venta.validarParaProcesamiento()
            .map(v -> venta);
    }
    
    /**
     * Validates that a sale can be processed
     */
    public Result<Void> validarVenta(Venta venta, Cliente cliente, List<Producto> productos) {
        return validarVentaNoNull(venta)
            .flatMap(v -> validarClienteNoNull(cliente))
            .flatMap(c -> validarClienteCoincide(venta, cliente))
            .flatMap(v -> validarVentaTieneLineas(venta))
            .flatMap(v -> validarStockProductos(venta, productos));
    }
    
    private Result<Venta> validarVentaNoNull(Venta venta) {
        if (venta == null) {
            return Result.failure("La venta no puede ser null");
        }
        return Result.success(venta);
    }
    
    private Result<Cliente> validarClienteNoNull(Cliente cliente) {
        if (cliente == null) {
            return Result.failure("El cliente no puede ser null");
        }
        return Result.success(cliente);
    }
    
    private Result<Void> validarClienteCoincide(Venta venta, Cliente cliente) {
        if (!venta.getCliente().getId().equals(cliente.getId())) {
            return Result.failure("El cliente de la venta no coincide");
        }
        return Result.success();
    }
    
    private Result<Void> validarVentaTieneLineas(Venta venta) {
        if (!venta.tieneLineas()) {
            return Result.failure("La venta debe tener al menos una línea");
        }
        return Result.success();
    }
    
    private Result<Void> validarStockProductos(Venta venta, List<Producto> productos) {
        try {
            venta.getLineasVenta().forEach(linea -> {
                Producto producto = productos.stream()
                    .filter(p -> p.getId().equals(linea.getProductoId()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Producto no encontrado: " + linea.getProductoId()));
                    
                if (!producto.hayStockSuficiente(linea.getCantidad())) {
                    throw new RuntimeException("Stock insuficiente para el producto: " + producto.getNombre());
                }
            });
            return Result.success();
        } catch (RuntimeException e) {
            return Result.failure(e.getMessage());
        }
    }
    
    /**
     * Processes a complete sale operation
     */
    public Result<Venta> procesarVentaCompleta(Cliente cliente, List<ProductoVentaRequest> productos) {
        return cliente.validarParaVenta()
            .flatMap(v -> crearVenta(cliente, productos))
            .flatMap(venta -> validarVenta(venta, cliente, productos.stream().map(ProductoVentaRequest::getProducto).toList())
                .map(validation -> venta));
    }
    
    /**
     * Helper class for product-quantity requests
     */
    public static class ProductoVentaRequest {
        private final Producto producto;
        private final int cantidad;
        
        public ProductoVentaRequest(Producto producto, int cantidad) {
            this.producto = producto;
            this.cantidad = cantidad;
        }
        
        public Producto getProducto() {
            return producto;
        }
        
        public int getCantidad() {
            return cantidad;
        }
    }
}