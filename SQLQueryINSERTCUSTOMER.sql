CREATE PROCEDURE spAddCUSTOMER
@Code nvarchar(10),
@Name nvarchar(100),
@Address nvarchar(200)
as 
BEGIN
	IF(@Name IS NULL OR @NAME='')
	BEGIN
		Raiserror('Invalid customer name',16,1)
	END
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM CUSTOMER WHERE CustomerName LIKE @NAME)
			BEGIN 
				Raiserror('Duplicate customer name',16,1)
			END
			ELSE
			  BEGIN Try
				BEGIN		
					BEGIN TRANSACTION
						INSERT INTO CUSTOMER(CustomerCode,CustomerName,CustomerAddress) VALUES(@Code,@Name,@Address)
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
