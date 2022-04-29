CREATE PROCEDURE spDeleteItemCategory
@Code nvarchar(4)
AS
BEGIN
DECLARE @NAME nvarchar(40)
	IF(@Code IS NULL OR @Code='')
		BEGIN
			Raiserror('Item Category code cannot be empty',16,1)
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM ITEM_CATEGORY WHERE ItemCatCode LIKE @Code)
				BEGIN
					Raiserror('Invalid Item Category code',16,1)
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT * FROM ITEM WHERE ItemCatCode LIKE @Code)
						BEGIN
							Raiserror('Category code in use. Deletion denied',16,1)
						END
					ELSE
						BEGIN
						 BEGIN Try
						BEGIN
							BEGIN TRANSACTION
								SELECT @NAME=ItemCatName FROM ITEM_CATEGORY WHERE ItemCatCode=@Code
								DELETE FROM ITEM_CATEGORY WHERE ItemCatCode=@Code
								PRINT 'Item Category DELETED : ' + CAST(@NAME AS VARCHAR(40))
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
