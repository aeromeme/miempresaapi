package com.miempresa.ventas.domain.valueobject;

public class Email extends ValueObject {
    private final String valor;
    
    public Email(String valor) {
        if (valor == null || valor.trim().isEmpty()) {
            throw new IllegalArgumentException("El email no puede estar vacío");
        }
        if (!isValidEmail(valor)) {
            throw new IllegalArgumentException("El formato del email es inválido");
        }
        this.valor = valor.toLowerCase().trim();
    }
    
    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
    
    public String getValor() {
        return valor;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Email)) return false;
        Email that = (Email) obj;
        return areEqual(this.valor, that.valor);
    }
    
    @Override
    public int hashCode() {
        return hashOf(valor);
    }
    
    @Override
    public String toString() {
        return valor;
    }
}