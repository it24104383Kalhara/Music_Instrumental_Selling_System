package com.tools;

import com.util.PasswordUtil;

public class HashTool {
    public static void main(String[] args) {
        String pw = args.length > 0 ? args[0] : "pass123";
        System.out.println(PasswordUtil.hash(pw));
    }
}