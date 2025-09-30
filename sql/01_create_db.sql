/* Create DB if missing */
IF DB_ID(N'music_store') IS NULL
BEGIN
  CREATE DATABASE music_store;
END
GO

USE music_store;
GO

/* Create a SQL login at the server level */
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'music_user')
BEGIN
  CREATE LOGIN music_user 
    WITH PASSWORD = 'music_pass_123',  -- change for real use
         CHECK_POLICY = OFF;
END
GO

/* Map that login to a database user and grant rights */
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'music_user')
BEGIN
  CREATE USER music_user FOR LOGIN music_user;
  ALTER ROLE db_owner ADD MEMBER music_user; -- full rights for dev/labs
END
GO

/* Optional: set default DB for that login to avoid “default DB” errors */
ALTER LOGIN music_user WITH DEFAULT_DATABASE = music_store;
GO

/* Quick sanity checks */
SELECT 
  DB_NAME()     AS [current_db],
  SUSER_SNAME() AS [server_login],
  SYSTEM_USER   AS [system_user];
GO
SELECT @@VERSION AS [sql_version];
GO