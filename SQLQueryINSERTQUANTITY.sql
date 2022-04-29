CREATE PROCEDURE spAddQUANTITY
@ItemCode nvarchar(10),
@WhCode nvarchar(10),
@QtyOnHand decimal (10,2)
AS
BEGIN
	IF(@ItemCode IS NULL OR @ItemCode='')
		BEGIN
			Raiserror('Invalid item code',16,1)
		END
	ELSE
	BEGIN
		IF NOT EXISTS (SELECT * FROM ITEM WHERE ItemCode LIKE @ItemCode)
			BEGIN 
				Raiserror('Invalid item code',16,1)
			END
		ELSE
			BEGIN
			IF(@WhCode IS NULL OR @WhCode='')
				BEGIN
					Raiserror('Invalid warehouse code',16,1)
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT * FROM WAREHOUSE WHERE WhCode LIKE @WhCode)
						BEGIN 
							Raiserror('Invalid warehouse code',16,1)
						END
					ELSE
					 BEGIN Try
						BEGIN
							BEGIN TRANSACTION
								INSERT INTO QUANTITY(ItemCode,WhCode,QtyOnHand) VALUES(@ItemCode,@WhCode,@QtyOnHand)
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