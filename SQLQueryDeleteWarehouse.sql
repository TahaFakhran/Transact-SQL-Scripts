CREATE PROCEDURE spDeleteWarehouse
@Code nvarchar(10)
AS
BEGIN
DECLARE @NAME nvarchar(40)
	IF(@Code IS NULL OR @Code='')
		BEGIN
			Raiserror('Warehouse code cannot be empty',16,1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM WAREHOUSE WHERE WhCode LIKE @Code)
				BEGIN
					Raiserror('Invalid warehouse code',16,1)
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT * FROM QUANTITY WHERE WhCode LIKE @Code)
						BEGIN
							Raiserror('Warehouse code in use. Deletion denied',16,1)
						END
					ELSE
						BEGIN
						 BEGIN Try
						BEGIN
							BEGIN TRANSACTION
								SELECT @NAME=WhName FROM WAREHOUSE WHERE WhCode=@Code
								DELETE FROM WAREHOUSE WHERE WhCode=@Code
								PRINT 'Warehouse DELETED : ' + CAST(@NAME AS VARCHAR(10))
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
