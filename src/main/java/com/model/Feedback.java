package com.model;

import java.time.LocalDateTime;

public class Feedback {
    private long id;
    private int userId;
    private int instrumentId;
    private long orderId;
    private int rating;  // 1-5 stars
    private String comment;
    private boolean isApproved;
    private LocalDateTime createdAt;

    // Additional fields for display
    private String userName;
    private String instrumentName;
    private String orderNumber;

    // Constructors
    public Feedback() {
    }

    public Feedback(int userId, int instrumentId, long orderId, int rating, String comment) {
        this.userId = userId;
        this.instrumentId = instrumentId;
        this.orderId = orderId;
        this.rating = rating;
        this.comment = comment;
        this.isApproved = false; // Default to not approved
    }

    // Getters and Setters
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getInstrumentId() {
        return instrumentId;
    }

    public void setInstrumentId(int instrumentId) {
        this.instrumentId = instrumentId;
    }

    public long getOrderId() {
        return orderId;
    }

    public void setOrderId(long orderId) {
        this.orderId = orderId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public boolean isApproved() {
        return isApproved;
    }

    public void setApproved(boolean approved) {
        isApproved = approved;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getInstrumentName() {
        return instrumentName;
    }

    public void setInstrumentName(String instrumentName) {
        this.instrumentName = instrumentName;
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    // Utility method to get star display
    public String getStarDisplay() {
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("⭐");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }

    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", userId=" + userId +
                ", instrumentId=" + instrumentId +
                ", rating=" + rating +
                ", isApproved=" + isApproved +
                '}';
    }
}