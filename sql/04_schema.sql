USE music_store;
GO

-- Users table
IF OBJECT_ID('dbo.app_user', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.app_user (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(200) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
  );
END
GO

-- Orders table
IF OBJECT_ID('dbo.customer_order', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.customer_order (
    id BIGINT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    order_number NVARCHAR(40) NOT NULL UNIQUE,
    status NVARCHAR(20) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_order_user FOREIGN KEY (user_id) REFERENCES dbo.app_user(id) ON DELETE CASCADE,
    CONSTRAINT CK_status CHECK (status IN (N'Processing', N'Shipped', N'Delivered'))
  );
END
GO

select * from dbo.app_user;
select * from dbo.customer_order;
select * from dbo.instrument;

