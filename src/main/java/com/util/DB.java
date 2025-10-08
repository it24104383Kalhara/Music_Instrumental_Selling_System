package com.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public final class DB {
    private static final HikariDataSource dataSource;

    static {
        try {
            Properties props = loadProps();

            HikariConfig cfg = new HikariConfig();
            cfg.setJdbcUrl(required(props, "db.url"));
            cfg.setUsername(required(props, "db.username"));
            cfg.setPassword(required(props, "db.password"));

            // SQL Server driver
            cfg.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            cfg.setConnectionTimeout(10000);        // 10 seconds to get connection
            cfg.setIdleTimeout(300000);             // 5 minutes idle timeout
            cfg.setMaxLifetime(600000);             // 10 minutes max lifetime
            cfg.setLeakDetectionThreshold(60000);   // Detect leaks after 60 seconds

            // Pool settings
            cfg.setPoolName("MusicStorePool");
            cfg.setMaximumPoolSize(10);
            cfg.setMinimumIdle(2);
            cfg.setAutoCommit(true);
            cfg.setConnectionTestQuery("SELECT 1");

            dataSource = new HikariDataSource(cfg);
        } catch (Exception e) {
            throw new ExceptionInInitializerError("Failed to initialize DB pool: " + e.getMessage());
        }
    }

    private DB() {}

    private static Properties loadProps() throws IOException {
        try (InputStream in = DB.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in == null) throw new IOException("db.properties not found (put it in src/main/resources)");
            Properties p = new Properties();
            p.load(in);
            return p;
        }
    }

    private static String required(Properties p, String key) {
        String v = p.getProperty(key);
        if (v == null || v.isBlank()) {
            throw new IllegalStateException("Missing property: " + key + " in db.properties");
        }
        return v.trim();
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    public static DataSource getDataSource() {
        return dataSource;
    }
}