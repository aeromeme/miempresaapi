package com.miempresa.ventas.domain.model;

import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.exception.DomainException;
import jakarta.persistence.*;

@Entity
@Table(name = "lineas_venta")
public class LineaVenta {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id", columnDefinition = "uniqueidentifier")
    private java.util.UUID id;

    @Embedded
    @AttributeOverride(name = "value", column = @Column(name = "producto_id", columnDefinition = "uniqueidentifier"))
    private ProductoId productoId;

    @Column(name = "cantidad", nullable = false)
    private int cantidad;

    @Embedded
    @AttributeOverride(name = "valor", column = @Column(name = "precio_unitario_valor", columnDefinition = "decimal(12,2)"))
    private Precio precioUnitario;
    
    @Transient
    private Precio total;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "venta_id")
    private Venta venta;

    // Constructor para JPA
    protected LineaVenta() {
        // Constructor requerido por JPA
    }

    public LineaVenta(ProductoId productoId, int cantidad, Precio precioUnitario) {
        if (productoId == null) {
            throw new DomainException("El producto no puede ser null");
        }
        if (cantidad <= 0) {
            throw new DomainException("La cantidad debe ser mayor a 0");
        }
        if (precioUnitario == null) {
            throw new DomainException("El precio unitario no puede ser null");
        }

        this.productoId = productoId;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
        this.total = precioUnitario.multiplicar(cantidad);
    }

    public static Result<LineaVenta> crear(ProductoId productoId, int cantidad, Precio precioUnitario) {
        return validarProductoId(productoId)
                .flatMap(pid -> validarCantidad(cantidad))
                .flatMap(c -> validarPrecioUnitario(precioUnitario))
                .map(p -> new LineaVenta(productoId, cantidad, precioUnitario));
    }

    private static Result<ProductoId> validarProductoId(ProductoId productoId) {
        if (productoId == null) {
            return Result.failure("El producto no puede ser null");
        }
        return Result.success(productoId);
    }

    private static Result<Integer> validarCantidad(int cantidad) {
        if (cantidad <= 0) {
            return Result.failure("La cantidad debe ser mayor a 0");
        }
        return Result.success(cantidad);
    }

    private static Result<Precio> validarPrecioUnitario(Precio precioUnitario) {
        if (precioUnitario == null) {
            return Result.failure("El precio unitario no puede ser null");
        }
        return Result.success(precioUnitario);
    }

    public Result<Void> actualizarCantidad(int nuevaCantidad, Precio nuevoPrecioUnitario) {
        return validarCantidad(nuevaCantidad)
                .flatMap(c -> validarPrecioUnitario(nuevoPrecioUnitario))
                .map(p -> {
                    this.cantidad = nuevaCantidad;
                    this.precioUnitario = nuevoPrecioUnitario;
                    this.total = precioUnitario.multiplicar(cantidad);
                    return null;
                });
    }

    public Result<Void> cambiarCantidad(int nuevaCantidad) {
        return validarCantidad(nuevaCantidad)
                .map(c -> {
                    this.cantidad = c;
                    this.total = precioUnitario.multiplicar(cantidad);
                    return null;
                });
    }

    public Result<Void> cambiarPrecio(Precio nuevoPrecio) {
        return validarPrecioUnitario(nuevoPrecio)
                .map(p -> {
                    this.precioUnitario = p;
                    this.total = precioUnitario.multiplicar(cantidad);
                    return null;
                });
    }

    public Venta getVenta() { return venta; }
    public void setVenta(Venta venta) { this.venta = venta; }
    // Getters
    public ProductoId getProductoId() {
        return productoId;
    }

    public int getCantidad() {
        return cantidad;
    }

    public Precio getPrecioUnitario() {
        return precioUnitario;
    }

    public Precio getTotal() {
        return  total != null ? total : precioUnitario.multiplicar(cantidad);
    }
}