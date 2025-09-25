package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.application.dto.IngresosMensualesDTO;
import com.miempresa.ventas.application.repository.IngresosMensualesRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public class PostgresIngresosMensualesRepository implements IngresosMensualesRepository {
    
    private final JdbcTemplate jdbcTemplate;

    public PostgresIngresosMensualesRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public Optional<IngresosMensualesDTO> findUltimoMes() {
        return jdbcTemplate.query(
            "SELECT * FROM ingresos_mensuales ORDER BY anio DESC, mes DESC LIMIT 1",
            (rs, rowNum) -> new IngresosMensualesDTO(
                rs.getTimestamp("periodo").toLocalDateTime(),
                rs.getInt("anio"),
                rs.getInt("mes"),
                rs.getLong("total_ventas"),
                rs.getLong("total_clientes"),
                rs.getBigDecimal("ingreso_total")
            )
        ).stream().findFirst();
    }

    @Override
    public List<IngresosMensualesDTO> findByAnio(int anio) {
        return jdbcTemplate.query(
            "SELECT * FROM ingresos_mensuales WHERE anio = ? ORDER BY mes",
            (rs, rowNum) -> new IngresosMensualesDTO(
                rs.getTimestamp("periodo").toLocalDateTime(),
                rs.getInt("anio"),
                rs.getInt("mes"),
                rs.getLong("total_ventas"),
                rs.getLong("total_clientes"),
                rs.getBigDecimal("ingreso_total")
            ),
            anio
        );
    }

    @Override
    public Optional<IngresosMensualesDTO> findByAnioAndMes(int anio, int mes) {
        return jdbcTemplate.query(
            "SELECT * FROM ingresos_mensuales WHERE anio = ? AND mes = ?",
            (rs, rowNum) -> new IngresosMensualesDTO(
                rs.getTimestamp("periodo").toLocalDateTime(),
                rs.getInt("anio"),
                rs.getInt("mes"),
                rs.getLong("total_ventas"),
                rs.getLong("total_clientes"),
                rs.getBigDecimal("ingreso_total")
            ),
            anio,
            mes
        ).stream().findFirst();
    }

    @Override
    public List<IngresosMensualesDTO> findAll() {
        return jdbcTemplate.query(
            "SELECT * FROM ingresos_mensuales ORDER BY anio DESC, mes DESC",
            (rs, rowNum) -> new IngresosMensualesDTO(
                rs.getTimestamp("periodo").toLocalDateTime(),
                rs.getInt("anio"),
                rs.getInt("mes"),
                rs.getLong("total_ventas"),
                rs.getLong("total_clientes"),
                rs.getBigDecimal("ingreso_total")
            )
        );
    }
}