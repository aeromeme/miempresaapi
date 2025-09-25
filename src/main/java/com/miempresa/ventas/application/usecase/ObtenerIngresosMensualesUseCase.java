package com.miempresa.ventas.application.usecase;

import com.miempresa.ventas.application.dto.IngresosMensualesDTO;
import com.miempresa.ventas.application.repository.IngresosMensualesRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ObtenerIngresosMensualesUseCase {
    
    private final IngresosMensualesRepository ingresosMensualesRepository;

    public ObtenerIngresosMensualesUseCase(IngresosMensualesRepository ingresosMensualesRepository) {
        this.ingresosMensualesRepository = ingresosMensualesRepository;
    }

    public Optional<IngresosMensualesDTO> obtenerUltimoMes() {
        return ingresosMensualesRepository.findUltimoMes();
    }

    public List<IngresosMensualesDTO> obtenerPorAnio(int anio) {
        return ingresosMensualesRepository.findByAnio(anio);
    }

    public Optional<IngresosMensualesDTO> obtenerPorAnioYMes(int anio, int mes) {
        return ingresosMensualesRepository.findByAnioAndMes(anio, mes);
    }

    public List<IngresosMensualesDTO> obtenerTodos() {
        return ingresosMensualesRepository.findAll();
    }
}