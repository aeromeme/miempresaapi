package com.miempresa.ventas.infrastructure.repository;

import com.miempresa.ventas.application.dto.TopProductoDTO;
import com.miempresa.ventas.application.repository.ProductoVentaRepository;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;
import java.math.BigDecimal;

@Repository
public class PostgresProductoVentaRepository implements ProductoVentaRepository {

    private final JdbcTemplate jdbcTemplate;

    public PostgresProductoVentaRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<TopProductoDTO> findTopProductosVendidos(int limit) {
        String sql = """
            SELECT id, nombre, total_vendido, total_ingresos
            FROM top_productos_vendidos 
            LIMIT ?
            """;

        return jdbcTemplate.query(sql,
            (rs, rowNum) -> new TopProductoDTO(
                UUID.fromString(rs.getString("id")),
                rs.getString("nombre"),
                rs.getLong("total_vendido"),
                rs.getBigDecimal("total_ingresos")
            ),
            limit
        );
    }
}