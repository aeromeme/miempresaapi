package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.application.dto.ClienteIngresosDTO;
import com.miempresa.ventas.application.repository.ClienteIngresosRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public class PostgresClienteIngresosRepository implements ClienteIngresosRepository {

    private final JdbcTemplate jdbcTemplate;

    public PostgresClienteIngresosRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<ClienteIngresosDTO> findClientesTopIngresos(int limit) {
        String sql = """
            SELECT id, nombre, correo, total_ventas, total_ingresos 
            FROM cliente_ingresos 
            LIMIT ?
            """;

        return jdbcTemplate.query(sql,
            (rs, rowNum) -> new ClienteIngresosDTO(
                UUID.fromString(rs.getString("id")),
                rs.getString("nombre"),
                rs.getString("correo"),
                rs.getLong("total_ventas"),
                rs.getBigDecimal("total_ingresos")
            ),
            limit
        );
    }
}