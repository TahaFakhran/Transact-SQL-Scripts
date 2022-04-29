CREATE PROCEDURE spAddORDER
@OrdDate DATE,
@CustomerCode nvarchar(10),
@ItemCode nvarchar(10),
@ItemQuantity DECIMAL(10,2),
@ItemPrice DECIMAL(15,2),
@QtyOrdered DECIMAL(10,2), 
@QtyDelivered DECIMAL(10,2)
as 
BEGIN
DECLARE @OrdNumber INTEGER
	IF(@OrdDate IS NULL OR @OrdDate='')
	BEGIN
		Raiserror('Invalid order date',16,1)
	END
	ELSE
		IF(@CustomerCode IS NULL OR @CustomerCode ='')
		BEGIN
			Raiserror('Invalid customer code',16,1)
		END
		ELSE
			BEGIN
				IF NOT EXISTS (SELECT * FROM CUSTOMER WHERE CustomerCode LIKE @CustomerCode)
				BEGIN 
					Raiserror('Invalid customer code',16,1)
				END
				ELSE
					IF EXISTS (SELECT * FROM "ORDER" WHERE CustomerCode=@CustomerCode AND ItemCode=@ItemCode)
							BEGIN
								EXECUTE spUpdateORDER @CustomerCode, @ItemCode ,@QtyOrdered, @QtyDelivered, @ItemQuantity ,@OrdNumber 
							END
							
				ELSE
				  EXECUTE spInsertORDER @OrdDate,@CustomerCode ,@ItemCode ,@ItemQuantity ,@ItemPrice ,@QtyOrdered , @QtyDelivered
		END
END
