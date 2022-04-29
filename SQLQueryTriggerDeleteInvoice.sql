CREATE TRIGGER tr_invoice_deleted
ON INVOICE_DETAILS
FOR DELETE
AS
BEGIN
	DECLARE	@ItemQuantity decimal(10,2)
	DECLARE	@CustomerCode nvarchar(10)
	DECLARE @ItemCode nvarchar(10)
	DECLARE @OrdNumber integer
	DECLARE @QtyOnHand decimal(10,2)
	DECLARE @InvNumber INTEGER
	DECLARE @QtyDelivered decimal (10,2)
	DECLARE @WhCode nvarchar(10)

	SELECT @ItemCode=ItemCode, @InvNumber=InvNumber, @ItemQuantity=ItemQuantity FROM DELETED
	SELECT @OrdNumber=OrdNumber, @CustomerCode=CustomerCode, @WhCode=WhCode FROM INVOICE_HEADER WHERE InvNumber=@InvNumber
	SELECT @QtyOnHand=(SELECT QtyOnHand FROM QUANTITY WHERE ItemCode=@ItemCode AND WhCode=WhCode)
	SELECT @QtyDelivered=(SELECT QtyDelivered FROM "ORDER" WHERE OrdNumber=@OrdNumber)

	BEGIN TRANSACTION
		UPDATE "ORDER" SET QtyDelivered=QtyDelivered-@ItemQuantity WHERE CustomerCode=@CustomerCode AND ItemCode=@ItemCode AND OrdNumber=@OrdNumber
	COMMIT TRANSACTION

	BEGIN TRANSACTION
		UPDATE QUANTITY SET QtyOnHand=QtyOnHand+@ItemQuantity WHERE ItemCode=@ItemCode AND WhCode=@WhCode
	COMMIT TRANSACTION

	BEGIN TRANSACTION
		DELETE FROM INVOICE_HEADER WHERE InvNumber=@InvNumber
	COMMIT TRANSACTION

END