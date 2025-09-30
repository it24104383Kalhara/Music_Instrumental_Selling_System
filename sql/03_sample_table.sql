USE music_store;
GO

IF OBJECT_ID('dbo.instrument', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.instrument (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(1000) NULL,
    price DECIMAL(10,2) NOT NULL,
    in_stock BIT NOT NULL DEFAULT 1,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
  );
END
GO

INSERT INTO dbo.instrument (name, description, price) 
VALUES (N'Guitar', N'Acoustic guitar', 199.99);

SELECT * FROM dbo.instrument;