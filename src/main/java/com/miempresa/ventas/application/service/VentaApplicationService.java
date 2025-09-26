package com.miempresa.ventas.application.service;

import com.miempresa.ventas.domain.repository.ClienteRepository;
import com.miempresa.ventas.domain.repository.ProductoRepository;
import com.miempresa.ventas.domain.repository.VentaRepository;
import com.miempresa.ventas.domain.service.VentaService;
import com.miempresa.ventas.domain.service.VentaService.ProductoVentaRequest;
import com.miempresa.ventas.domain.model.Cliente;
import com.miempresa.ventas.domain.model.LineaVenta;
import com.miempresa.ventas.domain.model.Producto;
import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.EstadoVenta;
import com.miempresa.ventas.domain.valueobject.ProductoId;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.valueobject.VentaId;
import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.dto.CreateLineaVentaDTO;
import com.miempresa.ventas.application.dto.CreateVentaDTO;
import com.miempresa.ventas.application.dto.UpdateLineaVentaDTO;
import com.miempresa.ventas.application.dto.UpdateVentaDTO;
import com.miempresa.ventas.application.mapper.VentaMapper;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class VentaApplicationService {
    // Obtener ventas por estado
    public Result<List<VentaDTO>> findByEstado(String estado) {
        try {
            var estadoVenta = EstadoVenta.fromCodigo(estado.charAt(0));
            var ventas = ventaRepository.findByEstado(estadoVenta);
            return Result.success(ventaMapper.toDto(ventas));
        } catch (Exception e) {
            return Result.failure("Error al obtener ventas por estado: " + e.getMessage());
        }
    }

    private final VentaRepository ventaRepository;
    private final VentaMapper ventaMapper;
    private final ClienteRepository clienteRepository;
    private final ProductoRepository productoRepository;
    private final VentaService ventaService;

    public VentaApplicationService(VentaRepository ventaRepository, VentaMapper ventaMapper, ClienteRepository clienteRepository, ProductoRepository productoRepository, VentaService ventaService) {
        this.ventaRepository = ventaRepository;
        this.ventaMapper = ventaMapper;
        this.clienteRepository = clienteRepository;
        this.productoRepository = productoRepository;
        this.ventaService = ventaService;
    }

    // Crear una nueva venta
    public Result<VentaDTO> create(CreateVentaDTO createDto) {
        try {
            //var resultado = ventaMapper.toNewDomain(createDto);
            ClienteId clienteId = ClienteId.from(createDto.getClienteId());
            if (!clienteRepository.existsById(clienteId))
                return Result.failure("Cliente no encontrado");
            Cliente cliente = clienteRepository.findById(clienteId).get();
            List<ProductoVentaRequest> lineaVentas = new ArrayList<>();
            for(CreateLineaVentaDTO linea : createDto.getLineasVenta()) {
                ProductoId productoId = ProductoId.from(linea.getProductoId());
                if (!productoRepository.existsById(productoId)) {
                    return Result.failure("Producto no encontrado con ID: " + linea.getProductoId());
                }
                Producto producto = productoRepository.findById(productoId).get();
                if (linea.getCantidad() <= 0) {
                    return Result.failure("La cantidad del producto con ID '" + linea.getProductoId() + "' debe ser mayor a 0");
                }
                ProductoVentaRequest lineaVenta = new ProductoVentaRequest(producto, linea.getCantidad());
                lineaVentas.add(lineaVenta);
            }
            var resultado = ventaService.crearVenta(cliente, lineaVentas);

            Venta saved = ventaRepository.save(resultado.getValue());
            return Result.success(ventaMapper.toDto(saved));
        } catch (Exception e) {
            return Result.failure("Error al crear venta: " + e.getMessage());
        }
    }

    // Actualizar una venta existente
    public Result<VentaDTO> update(String id, UpdateVentaDTO updateDto) {
        try {
            VentaId ventaId = VentaId.from(id);
            Optional<Venta> ventaOpt = ventaRepository.findById(ventaId);
            if (ventaOpt.isEmpty()) {
                return Result.failure("Venta no encontrada con ID: " + id);
            }
            Venta venta = ventaOpt.get();
            //
             if (venta.getCliente() != null && !venta.getCliente().getId().equals(ClienteId.from(updateDto.getClienteId()))) {
                    ClienteId nuevoClienteId = ClienteId.from(updateDto.getClienteId());
                    if (!clienteRepository.existsById(nuevoClienteId)) {
                        return Result.failure("Cliente no encontrado: " + updateDto.getClienteId());
                    }
                    Cliente cliente = clienteRepository.findById(nuevoClienteId).get();
                    venta.setCliente(cliente);
            }
            // Eliminar líneas que no están en el DTO
             var toDelete = venta.getLineasVenta().stream()
                .filter(linea -> updateDto.getLineasVenta() == null || updateDto.getLineasVenta().stream()
                        .noneMatch(l -> l.getProductoId().equals(linea.getProductoId().getValue().toString())))
                .collect(Collectors.toList());
             toDelete.forEach(linea -> venta.removerLinea(linea.getProductoId()));

             // Actualizar o agregar líneas
             if (updateDto.getLineasVenta() != null) {
                for (UpdateLineaVentaDTO lineaVentaDto : updateDto.getLineasVenta()) {
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
            //Guardar cambios de venta
            Venta saved = ventaRepository.save(venta);
            return Result.success(ventaMapper.toDto(saved));
        } catch (Exception e) {
            return Result.failure("Error al actualizar venta: " + e.getMessage());
        }
    }

    // Obtener una venta por ID
    public Result<VentaDTO> findById(String id) {
        try {
            VentaId ventaId = VentaId.from(id);
            Optional<Venta> ventaOpt = ventaRepository.findById(ventaId);
            return ventaOpt
                    .map(venta -> Result.success(ventaMapper.toDto(venta)))
                    .orElse(Result.failure("Venta no encontrada con ID: " + id));
        } catch (Exception e) {
            return Result.failure("Error al obtener venta: " + e.getMessage());
        }
    }

    // Obtener todas las ventas
    public Result<List<VentaDTO>> findAll() {
        try {
            List<Venta> ventas = ventaRepository.findAll();
            return Result.success(ventaMapper.toDto(ventas));
        } catch (Exception e) {
            return Result.failure("Error al obtener ventas: " + e.getMessage());
        }
    }

    // Obtener ventas por clienteId
    public Result<List<VentaDTO>> findByClienteId(String clienteId) {
        try {
            var ventas = ventaRepository
                    .findByClienteId(ClienteId.from(clienteId));
            return Result.success(ventaMapper.toDto(ventas));
        } catch (Exception e) {
            return Result.failure("Error al obtener ventas por cliente: " + e.getMessage());
        }
    }

    // Eliminar una venta por ID
    public Result<Boolean> deleteById(String id) {
        try {
            VentaId ventaId = VentaId.from(id);
            if (!ventaRepository.existsById(ventaId)) {
                return Result.failure("Venta no encontrada con ID: " + id);
            }
            Venta venta = ventaRepository.findById(ventaId).get();
            if (!venta.sePuedeEliminar()) {
                return Result.failure("La venta no puede ser eliminada en su estado actual: " + venta.getEstado().getCodigo());
            }
            ventaRepository.deleteById(ventaId);
            return Result.success(true);
        } catch (Exception e) {
            return Result.failure("Error al eliminar venta: " + e.getMessage());
        }
    }

    // Verificar si una venta existe
    public Result<Boolean> existsById(String id) {
        try {
            VentaId ventaId = VentaId.from(id);
            return Result.success(ventaRepository.existsById(ventaId));
        } catch (Exception e) {
            return Result.failure("Error al verificar existencia de la venta: " + e.getMessage());
        }
    }
}
