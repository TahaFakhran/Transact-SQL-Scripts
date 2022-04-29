-- EXECUTE spAddWarehouse 50,'Old Warehouse' ;

-- EXECUTE spAddITEMCATEGORY 5,'PC' ;

-- EXECUTE spAddITEM 250, 'ADIDAS', 1, 80 ;

-- EXECUTE spAddCUSTOMER 760, 'MAJED','TRIPOLI' ;

-- EXECUTE spAddORDER @OrdDate='2008-11-11', @CustomerCode=720,@ItemCode=220,@ItemQuantity=2,@ItemPrice=50, @QtyOrdered=3, @QtyDelivered=1 ;
-- EXECUTE spAddORDER @OrdDate='2009-12-11', @CustomerCode=730,@ItemCode=240,@ItemQuantity=1,@ItemPrice=10, @QtyOrdered=2, @QtyDelivered=0 ;
-- EXECUTE spAddORDER @OrdDate='2010-06-11', @CustomerCode=750,@ItemCode=210,@ItemQuantity=5,@ItemPrice=100, @QtyOrdered=1, @QtyDelivered=0 ;

-- EXECUTE spAddINVOICE @InvDate='2008-12-12', @CustomerCode=720, @WhCode=20,@OrdNumber=4,@ItemCode=210,@ItemQuantity=1,@ItemPrice=50
-- EXECUTE spAddINVOICE @InvDate='2010-11-12', @CustomerCode=730, @WhCode=30,@OrdNumber=8,@ItemCode=240,@ItemQuantity=1,@ItemPrice=10
-- EXECUTE spAddINVOICE @InvDate='2011-10-09', @CustomerCode=750, @WhCode=40,@OrdNumber=9,@ItemCode=210,@ItemQuantity=1,@ItemPrice=100

-- EXECUTE spAddQUANTITY @ItemCode=240,@WhCode=40,@QtyOnHand=90

-- EXECUTE spDeleteWarehouse 30
-- EXECUTE spDeleteWarehouse 50

-- EXECUTE spDeleteItemCategory 1
-- EXECUTE spDeleteItemCategory 5

-- EXECUTE spDeleteItem 210
-- EXECUTE spDeleteItem 250

-- EXECUTE spDeleteCustomer 720
-- EXECUTE spDeleteCustomer 760