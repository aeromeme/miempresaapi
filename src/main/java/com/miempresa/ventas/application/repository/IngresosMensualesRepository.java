package com.miempresa.ventas.application.repository;

import com.miempresa.ventas.application.dto.IngresosMensualesDTO;
import java.util.List;
import java.util.Optional;

public interface IngresosMensualesRepository {
    Optional<IngresosMensualesDTO> findUltimoMes();
    List<IngresosMensualesDTO> findByAnio(int anio);
    Optional<IngresosMensualesDTO> findByAnioAndMes(int anio, int mes);
    List<IngresosMensualesDTO> findAll();
}