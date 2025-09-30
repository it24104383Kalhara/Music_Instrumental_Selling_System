package com.util;
// Cental place to hash and check passwords

import org.mindrot.jbcrypt.BCrypt;

public final class PasswordUtil {
    private PasswordUtil() {
    }
    public static String hash(String plain){
        return BCrypt.hashpw(plain, BCrypt.gensalt(10));
    }

    public static boolean verify(String plain, String hash){
        if (plain == null || hash == null) return false;
        return BCrypt.checkpw(plain, hash);
    }
}
