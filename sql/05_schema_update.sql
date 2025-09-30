INSERT INTO dbo.app_user (email, full_name, password_hash)
VALUES (N'student@example.com', N'Student', N'$2a$10$WNOTm8hixDNIMlklK1ZYCuIDVv.Ynby8AxJyogMqUg93DAJQ5fA/q');

UPDATE dbo.app_user
SET full_name = N'Student',
    password_hash = N'$2a$10$WNOTm8hixDNIMlklK1ZYCuIDVv.Ynby8AxJyogMqUg93DAJQ5fA/q'
WHERE email = N'student@example.com';

select * from dbo.app_user;
select * from dbo.customer_order;
select * from dbo.instrument;

-- Assumes you're already connected to music_store
DECLARE @uid INT = 1;

INSERT INTO dbo.customer_order (user_id, order_number, status)
VALUES
  (@uid, N'ORD-' + RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8), N'Processing'),
  (@uid, N'ORD-' + RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8), N'Shipped'),
  (@uid, N'ORD-' + RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8), N'Delivered'),
  (@uid, N'ORD-' + RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8), N'Processing'),
  (@uid, N'ORD-' + RIGHT(CONVERT(NVARCHAR(36), NEWID()), 8), N'Shipped');

SELECT id, user_id, order_number, status, created_at
FROM dbo.customer_order
WHERE user_id = 1
ORDER BY created_at DESC;