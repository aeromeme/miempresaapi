package com.miempresa.ventas.domain.model;

import com.miempresa.ventas.domain.valueobject.VentaId;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.valueobject.EstadoVenta;
import com.miempresa.ventas.domain.exception.DomainException;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Entity
@Table(name = "ventas")
public class Venta extends BaseEntity {
    // Constructor requerido por JPA
    protected Venta() {
        // No-args constructor for JPA
    }

    @EmbeddedId
    private VentaId id;

    @Column(name = "fecha", nullable = false)
    private LocalDateTime fecha;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "cliente_id", columnDefinition = "uniqueidentifier"))
    private ClienteId clienteId;

    @OneToMany(mappedBy = "venta", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LineaVenta> lineasVenta;

    @Convert(converter = com.miempresa.ventas.domain.valueobject.EstadoVentaConverter.class)
    @Column(name = "estado", nullable = false)
    private EstadoVenta estado;

    // Constructor para crear nueva venta
    public Venta(ClienteId clienteId) {
        this.id = VentaId.generate();
        this.fecha = LocalDateTime.now();
        this.clienteId = clienteId;
        this.lineasVenta = new ArrayList<>();
        this.estado = EstadoVenta.EDICION;

        if (clienteId == null) {
            throw new DomainException("El cliente no puede ser null");
        }
    }

    // Constructor para reconstruir desde persistencia
    public Venta(VentaId id, LocalDateTime fecha, ClienteId clienteId, List<LineaVenta> lineasVenta,
            EstadoVenta estado) {
        this.id = id;
        this.fecha = fecha;
        this.clienteId = clienteId;
        this.lineasVenta = new ArrayList<>(lineasVenta != null ? lineasVenta : new ArrayList<>());
        this.estado = estado != null ? estado : EstadoVenta.EDICION;

        if (clienteId == null) {
            throw new DomainException("El cliente no puede ser null");
        }
    }

    public Result<Void> agregarLinea(Producto producto, int cantidad) {
        if (estado == EstadoVenta.APROBADA || estado == EstadoVenta.CANCELADA || estado == EstadoVenta.ANULADA) {
            return Result.failure("No se pueden agregar líneas a una venta ya procesada");
        }
        return validarProducto(producto)
                .flatMap(p -> validarCantidad(cantidad))
                .flatMap(c -> producto.validarParaVenta())
                .flatMap(v -> validarStockSuficiente(producto, cantidad))
                .flatMap(v -> procesarLineaVenta(producto, cantidad));
    }

    private Result<Producto> validarProducto(Producto producto) {
        if (producto == null) {
            return Result.failure("El producto no puede ser null");
        }
        return Result.success(producto);
    }

    private Result<Integer> validarCantidad(int cantidad) {
        if (cantidad <= 0) {
            return Result.failure("La cantidad debe ser mayor a 0");
        }
        return Result.success(cantidad);
    }

    private Result<Void> validarStockSuficiente(Producto producto, int cantidad) {
        LineaVenta lineaExistente = buscarLineaExistente(producto.getId());
        int cantidadTotal = lineaExistente != null ? lineaExistente.getCantidad() + cantidad : cantidad;

        if (!producto.hayStockSuficiente(cantidadTotal)) {
            return Result.failure(
                    String.format("Stock insuficiente para el producto '%s'. Disponible: %d, solicitado: %d",
                            producto.getNombre(), producto.getStock(), cantidadTotal));
        }
        return Result.success();
    }

    private Result<Void> procesarLineaVenta(Producto producto, int cantidad) {
        LineaVenta lineaExistente = buscarLineaExistente(producto.getId());

        if (lineaExistente != null) {
            // Actualizar línea existente
            int nuevaCantidad = lineaExistente.getCantidad() + cantidad;
            return lineaExistente.actualizarCantidad(nuevaCantidad, producto.getPrecio())
                    .flatMap(v -> producto.reducirStock(cantidad));
        } else {
            // Crear nueva línea
            return LineaVenta.crear(producto.getId(), cantidad, producto.getPrecio())
                    .flatMap(nuevaLinea -> {
                        lineasVenta.add(nuevaLinea);
                        return producto.reducirStock(cantidad);
                    });
        }
    }

    public LineaVenta buscarLineaExistente(com.miempresa.ventas.domain.valueobject.ProductoId productoId) {
        return lineasVenta.stream()
                .filter(linea -> linea.getProductoId().equals(productoId))
                .findFirst()
                .orElse(null);
    }

    public Result<Void> actualizarLinea(Producto producto, int cantidad) {
        if (estado == EstadoVenta.APROBADA || estado == EstadoVenta.CANCELADA || estado == EstadoVenta.ANULADA) {
            return Result.failure("No se pueden actualizar líneas de una venta ya procesada");
        }
        LineaVenta linea = buscarLineaExistente(producto.getId());
        if (linea == null) {
            return Result.failure("No existe una línea de venta para el producto especificado");
        }
        if (cantidad <= 0) {
            return Result.failure("La cantidad debe ser mayor a 0");
        }
        if (!producto.hayStockSuficiente(cantidad)) {
            return Result.failure("Stock insuficiente para el producto '" + producto.getNombre() + "'. Disponible: "
                    + producto.getStock() + ", solicitado: " + cantidad);
        }
        return linea.actualizarCantidad(cantidad, producto.getPrecio());
    }

    public Result<Void> removerLinea(com.miempresa.ventas.domain.valueobject.ProductoId productoId) {
        if (estado == EstadoVenta.APROBADA || estado == EstadoVenta.CANCELADA || estado == EstadoVenta.ANULADA) {
            return Result.failure("No se pueden remover líneas de una venta ya procesada");
        }
        LineaVenta linea = buscarLineaExistente(productoId);
        if (linea == null) {
            return Result.failure("No existe una línea de venta para el producto especificado");
        }

        lineasVenta.remove(linea);
        return Result.success();
    }

    public Result<Precio> calcularTotal() {
        if (lineasVenta.isEmpty()) {
            return Result.success(new Precio(BigDecimal.ZERO));
        }

        try {
            BigDecimal totalValor = BigDecimal.ZERO;

            for (LineaVenta linea : lineasVenta) {
                totalValor = totalValor.add(linea.getTotal().getValor());
            }

            return Result.success(new Precio(totalValor));
        } catch (Exception e) {
            return Result.failure("Error al calcular el total: " + e.getMessage());
        }
    }

    public Result<Void> validarParaProcesamiento() {
        if (!tieneLineas()) {
            return Result.failure("La venta debe tener al menos una línea de productos");
        }

        return calcularTotal()
                .flatMap(total -> {
                    if (total.getValor().compareTo(java.math.BigDecimal.ZERO) <= 0) {
                        return Result.failure("El total de la venta debe ser mayor a cero");
                    }
                    return Result.success();
                });
    }

    public boolean tieneLineas() {
        return !lineasVenta.isEmpty();
    }

    /**
     * Establece el cliente de la venta.
     */
    public void setCliente(ClienteId clienteId) {
        this.clienteId = clienteId;
    }

    // Getters
    @Override
    public VentaId getId() {
        return id;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public ClienteId getClienteId() {
        return clienteId;
    }

    public List<LineaVenta> getLineasVenta() {
        return Collections.unmodifiableList(lineasVenta);
    }

    public EstadoVenta getEstado() {
        return estado;
    }

    public Result<Void> marcarComoProcesada() {
        if (estado == EstadoVenta.APROBADA || estado == EstadoVenta.CANCELADA || estado == EstadoVenta.ANULADA) {
            return Result.failure("La venta ya está marcada como procesada");
        }
        return validarParaProcesamiento()
                .flatMap(v -> {
                    estado = EstadoVenta.APROBADA;
                    return Result.success();
                });
    }
}