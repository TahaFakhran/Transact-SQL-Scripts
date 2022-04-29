CREATE PROCEDURE spUpdateINVOICE
@InvNumber INTEGER,
@CustomerCode nvarchar(10),
@WhCode nvarchar(10),
@OrdNumber INTEGER,
@ItemCode NVARCHAR(10),
@ItemQuantity decimal(10,2),
@ItemPrice decimal(15,2)
as 
BEGIN
DECLARE @QtyOnHand decimal(10,2)
SELECT @QtyOnHand=(SELECT QtyOnHand FROM QUANTITY WHERE ItemCode=@ItemCode AND WhCode=WhCode)
		BEGIN Try
			BEGIN
				BEGIN TRANSACTION
					UPDATE "ORDER" SET QtyDelivered=QtyDelivered+@ItemQuantity WHERE CustomerCode=@CustomerCode AND ItemCode=@ItemCode AND OrdNumber=@OrdNumber
				COMMIT TRANSACTION
				IF(@QtyOnHand-@ItemQuantity<0)
		BEGIN
			Raiserror('not enough quantity',16,1)
		END
	ELSE
		BEGIN
			BEGIN TRANSACTION
				UPDATE QUANTITY SET QtyOnHand=QtyOnHand-@ItemQuantity WHERE ItemCode=@ItemCode AND WhCode=@WhCode
			COMMIT TRANSACTION
		END
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