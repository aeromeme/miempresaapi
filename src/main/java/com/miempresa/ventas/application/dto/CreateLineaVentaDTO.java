package com.miempresa.ventas.application.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;
import java.math.BigDecimal;

/**
 * DTO para crear una nueva línea de venta.
 */
@Schema(description = "Datos para crear una línea de venta")
public class CreateLineaVentaDTO {

    @NotNull(message = "El ID del producto es obligatorio")
    @Schema(description = "ID del producto", example = "1", required = true)
    private String productoId;

    @NotNull(message = "La cantidad es obligatoria")
    @Min(value = 1, message = "La cantidad debe ser al menos 1")
    @Schema(description = "Cantidad de productos", example = "2", required = true)
    private Integer cantidad;

    @NotNull(message = "El precio unitario es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio unitario debe ser mayor a 0")
    @Digits(integer = 15, fraction = 4, message = "El precio unitario debe tener máximo 15 dígitos enteros y 4 decimales")
    @Schema(description = "Precio unitario del producto", example = "100.00", required = true)
    private BigDecimal precioUnitario;

    // Constructor por defecto para deserialización
    public CreateLineaVentaDTO() {}

    public CreateLineaVentaDTO(String productoId, Integer cantidad, BigDecimal precioUnitario) {
        this.productoId = productoId;
        this.cantidad = cantidad;
        this.precioUnitario = precioUnitario;
    }

    public String getProductoId() {
        return productoId;
    }

    public void setProductoId(String productoId) {
        this.productoId = productoId;
    }

    public Integer getCantidad() {
        return cantidad;
    }

    public void setCantidad(Integer cantidad) {
        this.cantidad = cantidad;
    }

    public BigDecimal getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(BigDecimal precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    @Override
    public String toString() {
        return "CreateLineaVentaDTO{" +
                "productoId=" + productoId +
                ", cantidad=" + cantidad +
                ", precioUnitario=" + precioUnitario +
                '}';
    }
}
