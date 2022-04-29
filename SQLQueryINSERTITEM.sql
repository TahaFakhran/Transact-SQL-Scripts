CREATE PROCEDURE spAddITEM
@Code nvarchar(10),
@Name nvarchar(100),
@CatCode nvarchar(4),
@Unit nvarchar(6)
AS
BEGIN
	IF(@Name IS NULL OR @NAME='')
	BEGIN
		Raiserror('Invalid item name',16,1)
	END
	ELSE
		BEGIN
			IF EXISTS (SELECT * FROM ITEM WHERE ItemName LIKE @NAME)
			BEGIN 
				Raiserror('Duplicate item name',16,1)
			END
			ELSE
				IF(@CatCode IS NULL OR @CatCode='')
				BEGIN
					Raiserror('Invalid item category code',16,1)
				END
				ELSE
					IF NOT EXISTS (SELECT * FROM ITEM_CATEGORY WHERE ItemCatCode=@CatCode)
					BEGIN
						Raiserror('Invalid item category code',16,1)
					END
					ELSE
						IF (@Unit IS NULL OR @Unit='')
						BEGIN
							Raiserror('Invalid item unit',16,1)
						END
						ELSE
							BEGIN Try
								BEGIN		
									BEGIN TRANSACTION
										INSERT INTO ITEM(ItemCode, ItemName, ItemCatCode, ItemUnit) VALUES(@Code,@Name,@CatCode,@Unit)
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