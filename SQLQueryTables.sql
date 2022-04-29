create table WAREHOUSE(
WhCode nvarchar(10) PRIMARY KEY,
WhName nvarchar(40) UNIQUE
);

create table ITEM_CATEGORY(
ItemCatCode nvarchar(4) PRIMARY KEY,
ItemCatName nvarchar(40) UNIQUE
);

create table ITEM(
ItemCode nvarchar(10) PRIMARY KEY,
ItemName nvarchar(100) UNIQUE,
ItemCatCode nvarchar(4) references ITEM_CATEGORY(ItemCatCode),
ItemUnit nvarchar(6)
);

create table CUSTOMER(
CustomerCode nvarchar(10) PRIMARY KEY,
CustomerName nvarchar(100) UNIQUE,
CustomerAddress nvarchar(200) NOT NULL default ''
);

create table QUANTITY(
ItemCode nvarchar(10) references ITEM(ItemCode),
WhCode nvarchar(10) references WAREHOUSE(WhCode),
QtyOnHand decimal (10,2) NOT NULL default 0,
CONSTRAINT PK_QUANTITY PRIMARY KEY (ItemCode, WhCode)
);

create table ORDER_HEADER(
OrdNumber integer PRIMARY KEY identity(1,1),
OrdDate date not null,
CustomerCode nvarchar(10) references CUSTOMER(CustomerCode)
);

create table "ORDER"(
CustomerCode nvarchar(10) not null default '' references CUSTOMER(CustomerCode),
ItemCode nvarchar(10) not null default '' references ITEM(ItemCode) ,
OrdNumber integer not null default 0 references ORDER_HEADER(OrdNumber),
QtyOrdered decimal (10,2) not null default 0,
QtyDelivered decimal (10,2) not null default 0,
CONSTRAINT PK_ORDER PRIMARY KEY (CustomerCode, ItemCode, OrdNumber)
);

create table ORDER_DETAILS(
OrdNumber integer references ORDER_HEADER(OrdNumber),
ItemCode nvarchar(10) references ITEM(ItemCode),
ItemQuantity decimal(10,2) not null default 0,
ItemPrice decimal(15,2) not null default 0
);

create table INVOICE_HEADER(
InvNumber integer PRIMARY KEY identity(1,1),
InvDate date not null,
CustomerCode nvarchar(10) references CUSTOMER(CustomerCode),
WhCode nvarchar(10) references WAREHOUSE(WhCode),
OrdNumber integer not null default 0 references ORDER_HEADER(OrdNumber)
);

create table INVOICE_DETAILS(
InvNumber integer references INVOICE_HEADER(InvNumber),
ItemCode nvarchar(10) references ITEM(ItemCode),
ItemQuantity decimal(10,2) not null default 0,
ItemPrice decimal(15,2) not null default 0
);