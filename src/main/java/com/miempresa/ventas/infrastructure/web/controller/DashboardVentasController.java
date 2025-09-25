package com.miempresa.ventas.infrastructure.web.controller;

import com.miempresa.ventas.application.dto.TopProductoDTO;
import com.miempresa.ventas.application.dto.ClienteIngresosDTO;
import com.miempresa.ventas.application.dto.IngresosMensualesDTO;
import com.miempresa.ventas.application.usecase.ObtenerTopProductosVendidosUseCase;
import com.miempresa.ventas.application.usecase.ObtenerClientesTopIngresosUseCase;
import com.miempresa.ventas.application.usecase.ObtenerIngresosMensualesUseCase;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/dashboard/ventas")
public class DashboardVentasController {

    private final ObtenerTopProductosVendidosUseCase obtenerTopProductosVendidosUseCase;
    private final ObtenerClientesTopIngresosUseCase obtenerClientesTopIngresosUseCase;
    private final ObtenerIngresosMensualesUseCase obtenerIngresosMensualesUseCase;

    public DashboardVentasController(
            ObtenerTopProductosVendidosUseCase obtenerTopProductosVendidosUseCase,
            ObtenerClientesTopIngresosUseCase obtenerClientesTopIngresosUseCase,
            ObtenerIngresosMensualesUseCase obtenerIngresosMensualesUseCase) {
        this.obtenerTopProductosVendidosUseCase = obtenerTopProductosVendidosUseCase;
        this.obtenerClientesTopIngresosUseCase = obtenerClientesTopIngresosUseCase;
        this.obtenerIngresosMensualesUseCase = obtenerIngresosMensualesUseCase;
    }

    @GetMapping("/productos/top")
    public ResponseEntity<List<TopProductoDTO>> obtenerTopProductosVendidos(
            @RequestParam(required = false) Integer limit) {
        return ResponseEntity.ok(limit != null ?
                obtenerTopProductosVendidosUseCase.ejecutar(limit) :
                obtenerTopProductosVendidosUseCase.ejecutar());
    }

    @GetMapping("/clientes/top-ingresos")
    public ResponseEntity<List<ClienteIngresosDTO>> obtenerClientesTopIngresos(
            @RequestParam(required = false) Integer limit) {
        return ResponseEntity.ok(limit != null ?
                obtenerClientesTopIngresosUseCase.ejecutar(limit) :
                obtenerClientesTopIngresosUseCase.ejecutar());
    }

    @GetMapping("/ingresos/por-mes")
    public ResponseEntity<IngresosMensualesDTO> obtenerIngresoPorMes(
         @RequestParam(required = false) Integer anio,
          @RequestParam(required = false) Integer mes
    ) {
        return anio != null && mes != null ? obtenerIngresosMensualesUseCase.obtenerPorAnioYMes(anio, mes)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build()) : obtenerIngresosMensualesUseCase.obtenerUltimoMes()
                        .map(ResponseEntity::ok)
                        .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/ingresos/por-anio/{anio}")
    public ResponseEntity<List<IngresosMensualesDTO>> obtenerIngresosPorAnio(@PathVariable int anio) {
        List<IngresosMensualesDTO> ingresos = obtenerIngresosMensualesUseCase.obtenerPorAnio(anio);
        return ingresos.isEmpty() ? 
                ResponseEntity.notFound().build() :
                ResponseEntity.ok(ingresos);
    }
}