/*
Given the following tables describing a generic Shop selling products, please write a SQL query that answers the following question:

Tables:
Shop
(PK) shop_id : integer
shop_name : varchar

Salesperson
(PK) salesperson_id : integer
salesperson_name : varchar

WorkShift
(PK) shift_id : integer
(FK) salesperson_id : integer - references Salesperson.salesperson_id
(FK) shop_id : integer - references Shop.shop_id
start_time : DateTime - date and time when work shift starts
end_time : Datetime - date and time when work shift ends

Product
(PK) product_id : integer
product_name : varchar
price : Decimal

Sale
(PK) sale_id : integer
(FK) shift_id : integer - references WorkShift.shift_id
(FK) product_id : integer - references Product.product_id
sale_time : Datetime
quantity_sold : Integer

Question:
“Which two Shops have the highest and the lowest productivity respectively in the last 28 days?”
Shop productivity is measured by monetary value of sales divided by total salesperson work-hours in the same time period

The Objective:
Calculate the productivity for each shop over the last 28 days and then compare them

Thought Process:
 - Calculate total sales value for each shop in the last 28 days
 - Calculate total work hours for each shop in the last 28 day
 - Calculate productivity (sales value / work hours) for each shop
 - Identify the shops with the highest and lowest productivity


Assumption:
This query assumes that the database in use is SQL Server

 */


-- Solution
-- Common Table Expression (CTE) to calculate productivity for each shop
with shop_productivity as (
	select
		s.shop_id
		s.shop_name,
        -- Calculate total sales value
		sum(p.price * sa.quantity_sold) as total_sales,
        -- Calculate total work hours (converting minutes to hours)
        sum(datediff(minute, ws.start_time, ws.end_time)) / 60.0 as total_hours,
        -- Calculate productivity (sales value per work hour)
		sum(p.price * sa.quantity_sold) / (sum(datediff(minute, ws.start_time, ws.end_time)) / 60) as productivity
	from Shop s
        -- Join tables to connect shops, work shifts, sales, and products
		join WorkShift ws on s.shop_id = ws.shop_id
		join Sale sa on ws.shift_id = sa.shift_id
		join Product p on sa.product_id = p.product_id
    -- Filter for sales in the last 28 days
	where sa.sale_time >= dateadd(day, -28, getdate())
		and sa.sale_time <= getdate()
	group by s.shop_id, s.shop_name
	)
    -- Main query to select shops with highest and lowest productivity
	select
		shop_name,
		productivity,
        -- Label shops as 'highest' or 'Lowest' lowest
		case
			when productivity = (select max(productivity) from shop_productivity) then 'highest'
			when productivity = (select min(productivity) from shop_productivity) then 'lowest'
		end as productivity_rank
	from shop_productivity
    -- Filter to include only the shops with the highest and lowest productivity
	where productivity in (select max(productivity) from shop_productivity) 
		or productivity in (select min(productivity) from shop_productivity)
    -- Sort results to show highest productivity first
	order by productivity desc;

