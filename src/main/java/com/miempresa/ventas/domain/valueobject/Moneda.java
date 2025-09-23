package com.miempresa.ventas.domain.valueobject;

import java.util.Currency;

// Value object para moneda - NO persistido en BD, viene de configuración
public class Moneda extends ValueObject {
    private final String currencyCode;
    
    // Monedas de Centroamérica
    public static final Moneda GTQ = new Moneda("GTQ"); // Guatemala - Quetzal
    public static final Moneda BZD = new Moneda("BZD"); // Belice - Dólar de Belice
    public static final Moneda USD = new Moneda("USD"); // El Salvador - Dólar Estadounidense
    public static final Moneda HNL = new Moneda("HNL"); // Honduras - Lempira
    public static final Moneda NIO = new Moneda("NIO"); // Nicaragua - Córdoba
    public static final Moneda CRC = new Moneda("CRC"); // Costa Rica - Colón
    public static final Moneda PAB = new Moneda("PAB"); // Panamá - Balboa (también usan USD)
    
    public Moneda(String currencyCode) {
        if (currencyCode == null || currencyCode.trim().isEmpty()) {
            throw new IllegalArgumentException("El código de moneda no puede estar vacío");
        }
        
        try {
            // Validamos que el código de moneda sea válido
            Currency.getInstance(currencyCode.toUpperCase());
            this.currencyCode = currencyCode.toUpperCase();
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Código de moneda inválido: " + currencyCode);
        }
    }
    
    public Moneda(Currency currency) {
        if (currency == null) {
            throw new IllegalArgumentException("La moneda no puede ser null");
        }
        this.currencyCode = currency.getCurrencyCode();
    }
    
    public static Moneda of(String currencyCode) {
        return new Moneda(currencyCode);
    }
    
    public String getCurrencyCode() {
        return currencyCode;
    }
    
    public String getDisplayName() {
        return getCurrency().getDisplayName();
    }
    
    public String getSymbol() {
        return getCurrency().getSymbol();
    }
    
    public int getDefaultFractionDigits() {
        return getCurrency().getDefaultFractionDigits();
    }
    
    public Currency getCurrency() {
        return Currency.getInstance(currencyCode);
    }
    
    public boolean isCompatible(Moneda otra) {
        return this.equals(otra);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Moneda)) return false;
        Moneda that = (Moneda) obj;
        return areEqual(this.currencyCode, that.currencyCode);
    }
    
    @Override
    public int hashCode() {
        return hashOf(currencyCode);
    }
    
    @Override
    public String toString() {
        return currencyCode;
    }
}