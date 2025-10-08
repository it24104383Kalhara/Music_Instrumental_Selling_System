package com.util;

/**
 * Central place to hash and check passwords
 * DEVELOPMENT MODE: Using plain text comparison
 */
public final class PasswordUtil {

    // Set to true for BCrypt, false for plain text
    private static final boolean USE_BCRYPT = false;

    private PasswordUtil() {
    }

    /**
     * Hash a plain text password
     * Currently returns plain text for development
     */
    public static String hash(String plain) {
        if (USE_BCRYPT) {
            // Uncomment when switching to BCrypt
            // return BCrypt.hashpw(plain, BCrypt.gensalt(10));
            return plain; // This won't be reached
        }
        // Plain text mode (development only)
        return plain;
    }

    /**
     * Verify a plain text password against stored hash
     * Currently does simple string comparison for development
     */
    public static boolean verify(String plain, String storedPassword) {
        if (plain == null || storedPassword == null) {
            return false;
        }

        if (USE_BCRYPT) {
            // Uncomment when switching to BCrypt
            // return BCrypt.checkpw(plain, storedPassword);
            return false; // This won't be reached
        }

        // Plain text mode (development only)
        return plain.equals(storedPassword);
    }
}