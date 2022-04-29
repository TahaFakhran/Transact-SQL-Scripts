CREATE TRIGGER tr_order_inserted
ON "ORDER"
FOR INSERT
AS
BEGIN
	DECLARE @QtyOrdered decimal(10,2)
	DECLARE	@ItemQuantity decimal(10,2)
	DECLARE	@CustomerCode nvarchar(10)
	DECLARE @ItemCode nvarchar(10)
	DECLARE @OrdNumber integer
	DECLARE @QtyOnHand decimal(10,2)

	SELECT @QtyOrdered=QtyOrdered, @ItemCode=ItemCode, @OrdNumber=OrdNumber, @CustomerCode=CustomerCode FROM INSERTED
	SELECT @ItemQuantity=(SELECT ItemQuantity FROM ORDER_DETAILS WHERE ItemCode=@ItemCode AND OrdNumber=@OrdNumber)
	SELECT @QtyOnHand=(SELECT QtyOnHand FROM QUANTITY WHERE ItemCode=@ItemCode)

	BEGIN TRANSACTION
		UPDATE "ORDER" SET QtyOrdered=@QtyOrdered+@ItemQuantity WHERE CustomerCode=@CustomerCode AND ItemCode=@ItemCode AND OrdNumber=@OrdNumber
	COMMIT TRANSACTION

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