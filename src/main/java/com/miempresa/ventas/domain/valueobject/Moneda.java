package com.miempresa.ventas.domain.valueobject;

import java.util.Currency;

public class Moneda extends ValueObject {
    private final Currency currency;
    
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
            this.currency = Currency.getInstance(currencyCode.toUpperCase());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Código de moneda inválido: " + currencyCode);
        }
    }
    
    public Moneda(Currency currency) {
        if (currency == null) {
            throw new IllegalArgumentException("La moneda no puede ser null");
        }
        this.currency = currency;
    }
    
    public static Moneda of(String currencyCode) {
        return new Moneda(currencyCode);
    }
    
    public String getCurrencyCode() {
        return currency.getCurrencyCode();
    }
    
    public String getDisplayName() {
        return currency.getDisplayName();
    }
    
    public String getSymbol() {
        return currency.getSymbol();
    }
    
    public int getDefaultFractionDigits() {
        return currency.getDefaultFractionDigits();
    }
    
    public Currency getCurrency() {
        return currency;
    }
    
    public boolean isCompatible(Moneda otra) {
        return this.equals(otra);
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Moneda)) return false;
        Moneda that = (Moneda) obj;
        return areEqual(this.currency, that.currency);
    }
    
    @Override
    public int hashCode() {
        return hashOf(currency);
    }
    
    @Override
    public String toString() {
        return currency.getCurrencyCode();
    }
}