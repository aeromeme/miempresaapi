package com.miempresa.ventas.domain.valueobject;

import jakarta.persistence.AttributeConverter;
import jakarta.persistence.Converter;

@Converter(autoApply = true)
public class EstadoVentaConverter implements AttributeConverter<EstadoVenta, String> {
    @Override
    public String convertToDatabaseColumn(EstadoVenta estado) {
        if (estado == null)
            return null;
        return String.valueOf(estado.getCodigo());
    }

    @Override
    public EstadoVenta convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty())
            return null;
        return EstadoVenta.fromCodigo(dbData.charAt(0));
    }
}
