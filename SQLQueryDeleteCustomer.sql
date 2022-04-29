CREATE PROCEDURE spDeleteCustomer
@Code nvarchar(10)
AS
BEGIN
DECLARE @NAME nvarchar(100)
	IF(@Code IS NULL OR @Code='')
		BEGIN
			Raiserror('Customer code cannot be empty',16,1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CustomerCode LIKE @Code)
				BEGIN
					Raiserror('Invalid customer code',16,1)
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT * FROM "ORDER" WHERE CustomerCode LIKE @Code)
						BEGIN
							Raiserror('Customer code in use. Deletion denied',16,1)
						END
					ELSE
						BEGIN
						 BEGIN Try
						BEGIN
							BEGIN TRANSACTION
								SELECT @NAME=CustomerName FROM CUSTOMER WHERE CustomerCode=@Code
								DELETE FROM CUSTOMER WHERE CustomerCode=@Code
								PRINT 'customer DELETED : ' + CAST(@NAME AS VARCHAR(100))
							COMMIT TRANSACTION
						END
					 END Try
						BEGIN CATCH
						SELECT
							 ERROR_NUMBER() AS ErrorNumber,
							 ERROR_MESSAGE() AS ErrorMessage,
							 ERROR_PROCEDURE() AS ErrorProcedure,
							 ERROR_STATE() AS ErrorState,
							 ERROR_SEVERITY() AS ErrorSeverity,
							 ERROR_LINE() AS ErrorLine
						END CATCH
					END
			END
	END
END
