package com.miempresa.ventas.domain.valueobject;

import java.math.BigDecimal;

public class Precio extends ValueObject {
    private final BigDecimal valor;
    private final Moneda moneda;
    
    public Precio(BigDecimal valor, Moneda moneda) {
        if (valor == null) {
            throw new IllegalArgumentException("El precio no puede ser null");
        }
        if (valor.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El precio no puede ser negativo");
        }
        if (moneda == null) {
            throw new IllegalArgumentException("La moneda no puede ser null");
        }
        this.valor = valor;
        this.moneda = moneda;
    }
    
    public static Precio of(double valor, Moneda moneda) {
        return new Precio(BigDecimal.valueOf(valor), moneda);
    }
    
    public static Precio of(BigDecimal valor, Moneda moneda) {
        return new Precio(valor, moneda);
    }
    
    // Métodos de conveniencia para monedas de Centroamérica
    public static Precio ofUSD(double valor) {
        return new Precio(BigDecimal.valueOf(valor), Moneda.USD);
    }
    
    public static Precio ofGTQ(double valor) {
        return new Precio(BigDecimal.valueOf(valor), Moneda.GTQ);
    }
    
    public static Precio ofCRC(double valor) {
        return new Precio(BigDecimal.valueOf(valor), Moneda.CRC);
    }
    
    public static Precio ofHNL(double valor) {
        return new Precio(BigDecimal.valueOf(valor), Moneda.HNL);
    }
    
    public static Precio ofNIO(double valor) {
        return new Precio(BigDecimal.valueOf(valor), Moneda.NIO);
    }
    
    public BigDecimal getValor() {
        return valor;
    }
    
    public Moneda getMoneda() {
        return moneda;
    }
    
    public Precio multiplicar(int cantidad) {
        return new Precio(valor.multiply(BigDecimal.valueOf(cantidad)), moneda);
    }
    
    public Precio sumar(Precio otroPrecio) {
        if (!this.moneda.isCompatible(otroPrecio.moneda)) {
            throw new IllegalArgumentException(
                "No se pueden sumar precios con monedas diferentes: " + 
                this.moneda + " y " + otroPrecio.moneda
            );
        }
        return new Precio(valor.add(otroPrecio.valor), moneda);
    }
    
    public Precio restar(Precio otroPrecio) {
        if (!this.moneda.isCompatible(otroPrecio.moneda)) {
            throw new IllegalArgumentException(
                "No se pueden restar precios con monedas diferentes: " + 
                this.moneda + " y " + otroPrecio.moneda
            );
        }
        BigDecimal resultado = valor.subtract(otroPrecio.valor);
        if (resultado.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("El resultado de la resta no puede ser negativo");
        }
        return new Precio(resultado, moneda);
    }
    
    public boolean esMayorQue(Precio otroPrecio) {
        if (!this.moneda.isCompatible(otroPrecio.moneda)) {
            throw new IllegalArgumentException(
                "No se pueden comparar precios con monedas diferentes: " + 
                this.moneda + " y " + otroPrecio.moneda
            );
        }
        return this.valor.compareTo(otroPrecio.valor) > 0;
    }
    
    public boolean esMenorQue(Precio otroPrecio) {
        if (!this.moneda.isCompatible(otroPrecio.moneda)) {
            throw new IllegalArgumentException(
                "No se pueden comparar precios con monedas diferentes: " + 
                this.moneda + " y " + otroPrecio.moneda
            );
        }
        return this.valor.compareTo(otroPrecio.valor) < 0;
    }
    
    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (!(obj instanceof Precio)) return false;
        Precio that = (Precio) obj;
        return areEqual(this.valor, that.valor) && areEqual(this.moneda, that.moneda);
    }
    
    @Override
    public int hashCode() {
        return hashOf(valor, moneda);
    }
    
    @Override
    public String toString() {
        return valor.toString() + " " + moneda.getCurrencyCode();
    }
    
    public String toFormattedString() {
        return moneda.getSymbol() + " " + valor.toString();
    }
}