CREATE PROCEDURE spAddINVOICE
@InvDate DATE,
@CustomerCode nvarchar(10),
@WhCode nvarchar(10),
@OrdNumber INTEGER,
@ItemCode NVARCHAR(10),
@ItemQuantity decimal(10,2),
@ItemPrice decimal(15,2)
as 
BEGIN
DECLARE @InvNumber INTEGER
	IF(@InvDate IS NULL OR @InvDate='')
	BEGIN
		Raiserror('Invalid invoice date',16,1)
	END
	ELSE
		IF(@CustomerCode IS NULL OR @CustomerCode='')
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
						IF EXISTS (SELECT * FROM INVOICE_HEADER WHERE CustomerCode=@CustomerCode AND WhCode=@WhCode AND OrdNumber=@OrdNumber)
							BEGIN
								SELECT @InvNumber=InvNumber FROM INVOICE_HEADER WHERE CustomerCode=@CustomerCode AND WhCode=@WhCode AND OrdNumber=@OrdNumber
								EXECUTE spUpdateINVOICE @InvNumber,@CustomerCode,@WhCode,@OrdNumber,@ItemCode,@ItemQuantity,@ItemPrice
							END
						ELSE
							BEGIN
								EXECUTE spInsertINVOICE @InvDate,@CustomerCode ,@WhCode,@OrdNumber,@ItemCode,@ItemQuantity ,@ItemPrice
							END
					END
				END
			END
END
