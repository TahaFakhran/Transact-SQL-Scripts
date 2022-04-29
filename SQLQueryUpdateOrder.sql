CREATE PROCEDURE spUpdateORDER
@CustomerCode nvarchar(10),
@ItemCode nvarchar(10),
@QtyOrdered DECIMAL(10,2), 
@QtyDelivered DECIMAL(10,2),
@ItemQuantity DECIMAL(10,2),
@OrdNumber INTEGER
AS
BEGIN
DECLARE @QtyOnHand DECIMAL(10,2)

	BEGIN TRANSACTION
			UPDATE "ORDER" SET QtyOrdered=QtyOrdered+@ItemQuantity WHERE CustomerCode=@CustomerCode AND ItemCode=@ItemCode
	COMMIT TRANSACTION

	SELECT @QtyOnHand=(SELECT QtyOnHand FROM QUANTITY WHERE ItemCode=@ItemCode)
	IF(@QtyOnHand-@ItemQuantity<0)
		BEGIN
			Raiserror('not enough quantity',16,1)
		END
	ELSE
		BEGIN
			BEGIN TRANSACTION
				UPDATE QUANTITY SET QtyOnHand=QtyOnHand-@ItemQuantity where ItemCode=@ItemCode
			COMMIT TRANSACTION
		END
END