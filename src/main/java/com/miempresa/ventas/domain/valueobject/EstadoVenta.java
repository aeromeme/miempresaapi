package com.miempresa.ventas.domain.valueobject;

public enum EstadoVenta {
    APROBADA('A'),
    CANCELADA('C'),
    ANULADA('X'),
    EDICION('E');

    private final char codigo;

    EstadoVenta(char codigo) {
        this.codigo = codigo;
    }

    public char getCodigo() {
        return codigo;
    }

    public static EstadoVenta fromCodigo(char codigo) {
        for (EstadoVenta estado : EstadoVenta.values()) {
            if (estado.getCodigo() == codigo) {
                return estado;
            }
        }
        throw new IllegalArgumentException("Código de estado inválido: " + codigo);
    }
}