CREATE PROCEDURE spInsertINVOICE
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
			BEGIN Try
				BEGIN
				BEGIN TRANSACTION
					INSERT INTO INVOICE_HEADER(InvDate,CustomerCode,WhCode,OrdNumber) VALUES(@InvDate,@CustomerCode,@WhCode,@OrdNumber)
						COMMIT TRANSACTION
						SELECT @InvNumber=(SELECT TOP 1 InvNumber FROM INVOICE_HEADER ORDER BY OrdNumber DESC)
						BEGIN TRANSACTION
							INSERT INTO INVOICE_DETAILS(InvNumber,ItemCode,ItemQuantity,ItemPrice) VALUES(@InvNumber,@ItemCode,@ItemQuantity,@ItemPrice)
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
	 

