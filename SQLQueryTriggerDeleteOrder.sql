CREATE TRIGGER tr_order_deleted
ON "ORDER"
FOR DELETE
AS
BEGIN
DECLARE @QtyOrdered decimal(10,2)
	DECLARE	@ItemQuantity decimal(10,2)
	DECLARE	@CustomerCode nvarchar(10)
	DECLARE @ItemCode nvarchar(10)
	DECLARE @OrdNumber integer

	SELECT @QtyOrdered=QtyOrdered, @ItemCode=ItemCode, @OrdNumber=OrdNumber, @CustomerCode=CustomerCode FROM DELETED
	SELECT @ItemQuantity=(SELECT ItemQuantity FROM ORDER_DETAILS WHERE ItemCode=@ItemCode AND OrdNumber=@OrdNumber)

	BEGIN TRANSACTION
		UPDATE QUANTITY SET QtyOnHand=QtyOnHand+@QtyOrdered where ItemCode=@ItemCode
	COMMIT TRANSACTION

END