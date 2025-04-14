--CREATE PRODUCT TABLE

CREATE TABLE janvii.Products(
ProductID SERIAL PRIMARY KEY,
Name VARCHAR(100)NOT NULL,
Category VARCHAR(50),
Price NUMERIC(10,2),
Stock INT
);

--INSERT PRODUCT DATA

INSERT INTO janvii.Products(ProductID,Name,Category,Price,Stock)
VALUES
(1, 'Smartphone', 'Electronics', 699.99, 150),
(2, 'Laptop', 'Electronics', 999.99, 100),
(3, 'Headphones', 'Electronics', 199.99, 200),
(4, 'Dining Table', 'Furniture', 499.99, 50),
(5, 'Office Chair', 'Furniture', 249.99, 75),
(6, 'Running Shoes', 'Clothing', 79.99, 300),
(7, 'T-Shirt', 'Clothing', 19.99, 500),
(8, 'Backpack', 'Accessories', 49.99, 180),
(9, 'Watch', 'Accessories', 149.99, 90),
(10, 'Gaming Console', 'Electronics', 399.99, 120);

--RETREIVE DATA

select * from janvii.Products

--CREATE CUSTOMER TABLE

CREATE TABLE janvii.Customers(
CustomerID SERIAL PRIMARY KEY,
Name VARCHAR(100)NOT NULL,
EmailID VARCHAR(100)UNIQUE,
JoinDate DATE,
Country VARCHAR(50)
);

--INSERT CUSTOMER DATA

INSERT INTO janvii.Customers (CustomerID, Name, EmailID, JoinDate, Country) 
VALUES
(1, 'John Doe', 'john.doe@example.com', '2022-01-15', 'USA'),
(2, 'Jane Smith', 'jane.smith@example.com', '2021-11-10', 'UK'),
(3, 'Carlos Gomez', 'carlos.gomez@example.com', '2023-02-20', 'Spain'),
(4, 'Emily Johnson', 'emily.johnson@example.com', '2022-06-25', 'Canada'),
(5, 'Ahmed Ali', 'ahmed.ali@example.com', '2023-01-05', 'UAE'),
(6, 'Sophia Wang', 'sophia.wang@example.com', '2021-12-18', 'China'),
(7, 'Liam Brown', 'liam.brown@example.com', '2022-09-12', 'Australia'),
(8, 'Olivia Davis', 'olivia.davis@example.com', '2023-03-03', 'USA'),
(9, 'Noah Wilson', 'noah.wilson@example.com', '2022-04-07', 'Germany'),
(10, 'Ava Martinez', 'ava.martinez@example.com', '2023-02-01', 'Mexico');

--RETRIEVE DATA

select * from janvii.Customers

--CREATE ORDER TABLE

CREATE TABLE janvii.Orders(
OrderID SERIAL PRIMARY KEY,
FOREIGN KEY(CustomerID) REFERENCES janvii.Customers (CustomerID),
CustomerID INT,
OrderDate DATE,
TotalAmount NUMERIC(10,2)
);

--INSERT ORDER DATA

INSERT INTO janvii.Orders(OrderID, CustomerID, OrderDate, TotalAmount) 
VALUES
(1, 1, '2023-11-01', 899.97),
(2, 2, '2023-10-25', 1399.98),
(3, 3, '2023-11-10', 799.98),
(4, 4, '2023-10-15', 249.99),
(5, 5, '2023-11-12', 149.98),
(6, 6, '2023-11-20', 1999.95),
(7, 7, '2023-09-05', 129.97),
(8, 8, '2023-08-30', 399.98),
(9, 9, '2023-07-18', 479.97),
(10, 10, '2023-06-22', 1099.95);

--RETRIEVE DATA

select * from janvii.Orders

--CREATE ORDER DETAILS TABLE

CREATE TABLE janvii.OrderDetails (
OrderDetailID SERIAL PRIMARY KEY,
OrderID INT,
ProductID INT,
Quantity INT,
Subtotal NUMERIC(10, 2),
FOREIGN KEY (OrderID) REFERENCES janvii.Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES janvii.Products(ProductID)
);

--INSERT ORDER DETAILS DATA

INSERT INTO janvii.OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, Subtotal) 
VALUES
(1, 1, 1, 3, 2099.97),
(2, 1, 3, 1, 199.99),
(3, 2, 2, 2, 1999.98),
(4, 2, 4, 1, 499.99),
(5, 3, 6, 10, 799.98),
(6, 4, 5, 1, 249.99),
(7, 5, 9, 2, 299.98),
(8, 6, 7, 25, 499.75),
(9, 7, 8, 3, 149.97),
(10, 8, 10, 1, 399.98),
(11, 9, 1, 2, 1399.98),
(12, 10, 2, 1, 999.99);

--RETRIEVE DATA

select * from janvii.OrderDetails

--CREATE SHIPPING TABLE

CREATE TABLE janvii.Shipping(
ShippingID SERIAL PRIMARY KEY,
FOREIGN KEY(OrderID) REFERENCES janvii.Orders(OrderID),
OrderID INT,
Address VARCHAR(100),
ShippingStatus VARCHAR(50),
ShippingDate DATE
);

--INSERT SHIPPING DATA

INSERT INTO janvii.Shipping (ShippingID, OrderID, Address, ShippingStatus, ShippingDate) 
VALUES
(1, 1, '123 Elm St, Springfield, USA', 'Delivered', '2023-11-05'),
(2, 2, '456 Oak St, London, UK', 'Shipped', '2023-10-28'),
(3, 3, '789 Pine St, Madrid, Spain', 'Pending', NULL),
(4, 4, '101 Maple Ave, Toronto, Canada', 'Delivered', '2023-10-20'),
(5, 5, '202 Birch Dr, Dubai, UAE', 'Shipped', '2023-11-15'),
(6, 6, '303 Cedar St, Beijing, China', 'Delivered', '2023-11-25'),
(7, 7, '404 Walnut Rd, Sydney, Australia', 'Delivered', '2023-09-08'),
(8, 8, '505 Cherry Blvd, New York, USA', 'Delivered', '2023-09-03'),
(9, 9, '606 Spruce Ln, Berlin, Germany', 'Delivered', '2023-07-22'),
(10, 10, '707 Willow St, Mexico City, Mexico', 'Shipped', '2023-06-25');

--RETRIEVE DATA

select * from janvii.Shipping

--Retrieve all orders for a specific customer.
select * from janvii.Orders o join janvii.Customers c on o.CustomerID = c.CustomerID where c.CustomerID = 4;

--Find products that are out of stock.
select * from janvii.Products where stock = 0;

--List orders placed within the last 30 days.
select OrderID, CustomerID, OrderDate, TotalAmount from janvii.Orders 
where OrderDate between '2023-11-12' and '2023-11-20';

--Calculate the total revenue generated from all orders.
select sum(TotalAmount) as TotalRevenue from janvii.Orders;

--Find the average order total for each customer.
SELECT CustomerID, AVG(TotalAmount) AS Average_Order_Total
FROM janvii.orders GROUP BY CustomerID ORDER BY CustomerID;

--Identify the top 5 best-selling products.
select p.ProductID,p.Name,sum(od.Quantity) as TotalSold from janvii.products p
join janvii.OrderDetails od on p.ProductID=od.ProductID
group by p.ProductID,p.name
order by totalsold  desc limit 5;

--Sort customers by their registration date.
select CustomerID,Name,JoinDate 
from janvii.Customers 
order by JoinDate desc limit 5; 


--List products with a Price range between $50 and $500.
select ProductID,Name,Price from janvii.Products where Price between 50 and 500;

--Find orders where the total amount exceeds $1,000.
select OrderID,TotalAmount from janvii.Orders where TotalAmount >= 1000;

--Group orders by customer and calculate their total spending.
select CustomerID,sum(TotalAmount) as TotalSpending from janvii.Orders 
group by CustomerID order by TotalSpending desc;

--Group products by category and find the total stock for each category.
select category,sum(stock) from janvii.Products group by category;

--Identify customers who have placed more than 5 orders.
select CustomerID, count(OrderID) as OrderCount from janvii.Orders 
group by CustomerID having count(OrderID)>5 order by OrderCount asc;

--Customers with an average order value greater than $200
select CustomerID, avg(TotalAmount) as AvgOrderValue from janvii.Orders 
group by CustomerID having avg(TotalAmount)>200 order by AvgOrderValue asc;

--Products with total sales (across all orders) exceeding $10,000.
SELECT od.ProductID, p.Name, 
SUM(od.SubTotal) AS TotalSales
FROM janvii.OrderDetails od
JOIN janvii.Products p 
ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.Name
HAVING SUM(od.SubTotal) > 10000
ORDER BY TotalSales DESC;

select * from janvii.Customers c
join janvii.Orders o
on c.CustomerID = o.CustomerID

select c.Name, c.Country, o.OrderDate from janvii.Customers c
inner join janvii.Orders o
on c.CustomerID = o.CustomerID

--retreive orders along with the customer details who placed them
select o.orderID,c.Name,o.OrderDate from janvii.Customers c
inner join janvii.Orders o
on c.CustomerID = o.CustomerID

--list all order details along with product name and price for each order
select od.OrderDetailID,p.Name,p.Price,od.Quantity from janvii.OrderDetails od
join janvii.Products p
on od.ProductID = p.ProductID

--find all shipping records with their corresponding order Details
select o.OrderID,o.TotalAmount,s.ShippingStatus,s.ShippingDate from janvii.Orders o
left join janvii.Shipping s
on o.OrderID = s.OrderID
where ShippingStatus in ('Delivered')

--list all the customer and their orders including customer who have not placed any orders
select name from janvii.Customers where CustomerID in
(select o.CustomerID from janvii.Orders o inner join janvii.OrderDetails od
on o.OrderID = od.OrderID where od.ProductID in
(select ProductID from janvii.Products where Price > (select avg(price)from janvii.Products)))

self join 
--identify customer who joined after another specific customer
select c1.Name as NewCustomer,c1.JoinDate as NewJoinDate,c2.Name as OldCustomer,c2.JoinDate as OldJoinDate
 from janvii.Customers c1
 inner join janvii. Customers c2
on c1.JoinDate > c2.JoinDate

--find the customer who placed order with the highest total amount
select * from janvii.Customers where CustomerID in 
(select CustomerID from janvii.Orders order by TotalAmount desc limit 1) 

--Retrieve the names of all customers along with their order IDs.
select o.orderID,c.Name from janvii.Customers c
inner join janvii.Orders o
on c.CustomerID = o.CustomerID

--List all products ordered along with the quantity ordered and order date.
select od.OrderDetailID,p.Name,o.OrderDate,od.Quantity from janvii.OrderDetails od
join janvii.Products p
on od.ProductID = p.ProductID
Join janvii.Orders o ON od.OrderID = o.OrderID;

--Find the total amount spent by each customer.
--List all orders and the corresponding shipping addresses.
select o.OrderID,s.Address from janvii.Orders o
inner join janvii.Shipping s
on o.OrderID = s.OrderID





















