package com.miempresa.ventas.application.mapper;

import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.domain.repository.ProductoRepository;
import com.miempresa.ventas.domain.service.MonedaConfigurationService;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.Precio;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.model.LineaVenta;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.dto.CreateLineaVentaDTO;
import com.miempresa.ventas.application.dto.CreateVentaDTO;
import com.miempresa.ventas.application.dto.UpdateVentaDTO;
import com.miempresa.ventas.application.dto.LineaVentaDTO;
import com.miempresa.ventas.application.dto.UpdateLineaVentaDTO;

import java.util.List;
import java.util.Optional;
import java.time.LocalDateTime;
import java.math.BigDecimal;
import java.util.stream.Collectors;
import org.springframework.stereotype.Component;

@Component
public class VentaMapper {

    private final ProductoRepository productoRepository;
    private final ClienteRepository clienteRepository;

    public VentaMapper(ProductoRepository productoRepository, ClienteRepository clienteRepository) {
        this.productoRepository = productoRepository;
        this.clienteRepository = clienteRepository;
    }

    public Result<Venta> toNewDomain(CreateVentaDTO dto) {
        if (dto == null)
            return Result.failure("Invalid DTO");
        ClienteId clienteId = ClienteId.from(dto.getClienteId());
        if (!clienteRepository.existsById(clienteId))
            return Result.failure("Cliente no encontrado");

        Venta venta = new Venta(clienteId);

        if (dto.getLineasVenta() != null) {

            for (CreateLineaVentaDTO lineaVentaDto : dto.getLineasVenta()) {
                ProductoId productoId = ProductoId.from(lineaVentaDto.getProductoId());
                Optional<Producto> productoOpt = productoRepository.findById(productoId);
                if (productoOpt.isEmpty()) {
                    return Result.failure("Producto no encontrado: " + lineaVentaDto.getProductoId());
                }
                Producto producto = productoOpt.get();

                var result = venta.agregarLinea(producto, lineaVentaDto.getCantidad());
                if (result.isFailure()) {
                    return Result.failure("Error al agregar línea de venta: " + result.getFirstError());
                }
            }

        }
        return Result.success(venta);

    }

    public Result<Venta> updateDomain(Venta venta, UpdateVentaDTO dto) {
        if (venta.getClienteId() != ClienteId.from(dto.getClienteId())) {
            ClienteId nuevoClienteId = ClienteId.from(dto.getClienteId());
            if (!clienteRepository.existsById(nuevoClienteId)) {
                return Result.failure("Cliente no encontrado: " + dto.getClienteId());
            }
            venta.setCliente(nuevoClienteId);
        }
        var toDelete = venta.getLineasVenta().stream()
                .filter(linea -> dto.getLineasVenta() == null || dto.getLineasVenta().stream()
                        .noneMatch(l -> l.getProductoId().equals(linea.getProductoId().getValue().toString())))
                .collect(Collectors.toList());
        toDelete.forEach(linea -> venta.removerLinea(linea.getProductoId()));
        if (dto.getLineasVenta() != null) {

            for (UpdateLineaVentaDTO lineaVentaDto : dto.getLineasVenta()) {
                ProductoId productoId = ProductoId.from(lineaVentaDto.getProductoId());
                Optional<Producto> productoOpt = productoRepository.findById(productoId);
                if (productoOpt.isEmpty()) {
                    return Result.failure("Producto no encontrado: " + lineaVentaDto.getProductoId());
                }
                Producto producto = productoOpt.get();
                var existingLine = venta.buscarLineaExistente(productoId);
                if (existingLine != null) {
                    var result = venta.actualizarLinea(producto, lineaVentaDto.getCantidad());
                    if (result.isFailure()) {
                        return Result.failure("Error al actualizar línea de venta: " + result.getFirstError());
                    }
                } else {
                    var result = venta.agregarLinea(producto, lineaVentaDto.getCantidad());
                    if (result.isFailure()) {
                        return Result.failure("Error al agregar línea de venta: " + result.getFirstError());
                    }
                }
            }

        }

        return Result.success(venta);
    }

    public VentaDTO toDto(Venta venta) {
        if (venta == null)
            return null;

        String id = venta.getId() != null ? venta.getId().getValue().toString() : null;
        String clienteId = venta.getClienteId() != null ? venta.getClienteId().getValue().toString() : null;
        LocalDateTime fechaVenta = venta.getFecha();
        BigDecimal total = venta.calcularTotal().isSuccess() ? venta.calcularTotal().getValue().getValor() : null;
        String estado = venta.getEstado() != null ? venta.getEstado().name() : null;
        List<LineaVentaDTO> lineasVenta = toDtoLineas(venta.getLineasVenta());

        return new VentaDTO(id, clienteId, fechaVenta, total, estado, lineasVenta);
    }

    public List<VentaDTO> toDto(List<Venta> ventas) {
        return ventas.stream().map(this::toDto).collect(Collectors.toList());
    }

    public LineaVentaDTO toDto(LineaVenta lineaVenta) {
        if (lineaVenta == null)
            return null;
        String productoId = lineaVenta.getProductoId() != null ? lineaVenta.getProductoId().getValue().toString()
                : null;
        Integer cantidad = lineaVenta.getCantidad();
        BigDecimal precioUnitario = lineaVenta.getPrecioUnitario() != null ? lineaVenta.getPrecioUnitario().getValor()
                : null;
        BigDecimal subtotal = lineaVenta.getTotal() != null ? lineaVenta.getTotal().getValor() : null;

        return new LineaVentaDTO(productoId, cantidad, precioUnitario, subtotal);
    }

    public List<LineaVentaDTO> toDtoLineas(List<LineaVenta> lineas) {
        return lineas.stream().map(this::toDto).collect(Collectors.toList());
    }
}
