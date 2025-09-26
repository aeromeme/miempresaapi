package com.miempresa.ventas.application.service;

import com.miempresa.ventas.domain.repository.VentaRepository;
import com.miempresa.ventas.domain.model.Venta;
import com.miempresa.ventas.domain.valueobject.ClienteId;
import com.miempresa.ventas.domain.valueobject.EstadoVenta;
import com.miempresa.ventas.domain.valueobject.Result;
import com.miempresa.ventas.domain.valueobject.VentaId;
import com.miempresa.ventas.application.dto.VentaDTO;
import com.miempresa.ventas.application.dto.CreateVentaDTO;
import com.miempresa.ventas.application.dto.UpdateVentaDTO;
import com.miempresa.ventas.application.mapper.VentaMapper;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

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

    public VentaApplicationService(VentaRepository ventaRepository, VentaMapper ventaMapper) {
        this.ventaRepository = ventaRepository;
        this.ventaMapper = ventaMapper;
    }

    // Crear una nueva venta
    public Result<VentaDTO> create(CreateVentaDTO createDto) {
        try {
            var resultado = ventaMapper.toNewDomain(createDto);
            if (resultado.isFailure()) {
                return Result.failure(resultado.getFirstError());
            }
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
            var resultado = ventaMapper.updateDomain(ventaOpt.get(), updateDto);
            if (resultado.isFailure()) {
                return Result.failure(resultado.getFirstError());
            }
            Venta saved = ventaRepository.save(resultado.getValue());
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
