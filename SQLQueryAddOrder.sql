CREATE PROCEDURE spInsertORDER
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
BEGIN Try
					BEGIN		
						BEGIN TRANSACTION
							INSERT INTO ORDER_HEADER(OrdDate,CustomerCode) VALUES (@OrdDate,@CustomerCode)
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
				SELECT @OrdNumber=(SELECT TOP 1 OrdNumber FROM ORDER_HEADER ORDER BY OrdNumber DESC)
				IF(@ItemCode IS NULL OR @ItemCode ='')
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
					 BEGIN Try
					 BEGIN		
					 	BEGIN TRANSACTION
					 		INSERT INTO ORDER_DETAILS(OrdNumber,ItemCode,ItemQuantity,ItemPrice) VALUES(@OrdNumber,@ItemCode,@ItemQuantity,@ItemPrice)
					 	COMMIT TRANSACTION
						BEGIN TRANSACTION
					 		INSERT INTO "ORDER"(CustomerCode, ItemCode, OrdNumber, QtyOrdered, QtyDelivered )VALUES(@CustomerCode,@ItemCode,@OrdNumber,@QtyOrdered, @QtyDelivered)
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