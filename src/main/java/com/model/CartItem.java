package com.model;

import java.math.BigDecimal;

public class CartItem {
    private int instrumentId;
    private String instrumentName;
    private BigDecimal price;
    private int quantity;

    public CartItem() {
    }

    public CartItem(int instrumentId, String instrumentName, BigDecimal price, int quantity) {
        this.instrumentId = instrumentId;
        this.instrumentName = instrumentName;
        this.price = price;
        this.quantity = quantity;
    }


    public int getInstrumentId() {
        return instrumentId;
    }

    public void setInstrumentId(int instrumentId) {
        this.instrumentId = instrumentId;
    }

    public String getInstrumentName() {
        return instrumentName;
    }

    public void setInstrumentName(String instrumentName) {
        this.instrumentName = instrumentName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Calculated field: subtotal
    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "instrumentId=" + instrumentId +
                ", instrumentName='" + instrumentName + '\'' +
                ", price=" + price +
                ", quantity=" + quantity +
                ", subtotal=" + getSubtotal() +
                '}';
    }
}