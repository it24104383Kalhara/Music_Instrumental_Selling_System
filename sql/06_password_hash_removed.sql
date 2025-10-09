USE MusicDB
GO

-- Update all users with simple plain text passwords
UPDATE music.[User] SET password_hash = 'password123' WHERE user_id = 1;  -- John Smith
UPDATE music.[User] SET password_hash = 'password123' WHERE user_id = 2;  -- Sarah Johnson
UPDATE music.[User] SET password_hash = 'password123' WHERE user_id = 3;  -- Mike Davis
UPDATE music.[User] SET password_hash = 'password123' WHERE user_id = 4;  -- Emma Wilson
UPDATE music.[User] SET password_hash = 'password123' WHERE user_id = 5;  -- David Brown
UPDATE music.[User] SET password_hash = 'admin123' WHERE user_id = 6;     -- Admin
UPDATE music.[User] SET password_hash = 'manager123' WHERE user_id = 7;   -- Manager

CREATE OR ALTER PROCEDURE music.usp_SimpleAuthenticateUser
    @Email NVARCHAR(255),
    @Password NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        u.user_id,
        u.first_name,
        u.last_name,
        ue.email,
        u.[status],
        CASE 
            WHEN c.user_id IS NOT NULL THEN 'Customer'
            WHEN e.user_id IS NOT NULL THEN 'Employee' 
            ELSE 'User'
        END AS user_type
    FROM music.[User] u
    JOIN music.UserEmail ue ON u.user_id = ue.user_id
    LEFT JOIN music.Customer c ON u.user_id = c.user_id
    LEFT JOIN music.Employee e ON u.user_id = e.user_id
    WHERE ue.email = @Email 
      AND ue.is_primary = 1
      AND u.password_hash = @Password  -- Direct comparison
      AND u.[status] = 'active';
END;
GO