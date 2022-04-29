CREATE PROCEDURE spAddITEMCATEGORY
@Code nvarchar(4),
@Name nvarchar(40)
as 
BEGIN
	IF(@Name IS NULL OR @NAME='')
	BEGIN
		Raiserror('Invalid item category name',16,1)
	END
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM ITEM_CATEGORY WHERE ItemCatName LIKE @NAME)
			BEGIN 
				Raiserror('Duplicate item category name',16,1)
			END
			ELSE
			  BEGIN Try
				BEGIN		
					BEGIN TRANSACTION
						INSERT INTO ITEM_CATEGORY(ItemCatCode, ItemCatName) VALUES(@Code, @Name)
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
