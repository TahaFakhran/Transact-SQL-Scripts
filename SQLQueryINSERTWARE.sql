CREATE PROCEDURE spAddWarehouse
@Code nvarchar(10),
@Name nvarchar(40)
as 
BEGIN
	IF(@Name IS NULL OR @NAME='')
	BEGIN
		Raiserror('Invalid warehouse name',16,1)
	END
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM WAREHOUSE WHERE WhName LIKE @NAME)
			BEGIN 
				Raiserror('Duplicate warehouse name',16,1)
			END
			ELSE
			  BEGIN Try
				BEGIN
					BEGIN TRANSACTION
						INSERT INTO WAREHOUSE(WhCode, WhName) VALUES(@Code, @Name)
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
