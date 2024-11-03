set search_path to exercise_week6_number_1_5;

-- Case 1 : The Manager need your help to develop database design 
-- The application currently comprises a single main store. However, the manager wants to develop a feature that 
-- allows the application to open additional new stores. 
-- It means the application should store information about the list of shops that will be opened 
-- and the product related to each store. 
-- So, the application can manage and display products correctly for each shop
-- Additionally, there is currently no shopping cart feature in this application. 
-- The manager wants to add a shopping cart functionality. 
-- Enabling customers to store items they intend to purchase.
-- Can you also suggest any other features that should be considered?

-- Create List of Area Store Manager Table
create table list_area_store_manager(
	area_manager_id serial primary key, -- Surrogate Primary Key (SPK)
	manager_name varchar(255) not null unique, -- Candidate key (CK)
	hire_date date,
	tenure_days int not null check(tenure_days > 0),
	email varchar(100) not null unique, -- Candidate Key (CK)
	asm_contact_person varchar(15) not null unique -- Candidate Key (CK)
);

-- Create List of Store Manager Table
create table list_store_manager(
	store_manager_id serial primary key, -- Surrogate Primary Key (SPK)
	store_manager_name varchar(255) not null unique, -- Candidate Key (CK)
	hire_date date,
	tenure_days int not null check(tenure_days > 0),
	email varchar(100) not null unique, -- Candidate Key (CK)
	sm_contact_person varchar(15) not null unique -- Candidate Key (CK)
);

-- Create Table Store Territory
create table store_territory(
	territory_id varchar(10) primary key, -- ID : 1A, 1B, etc. (Primary Key)
	province varchar(50) not null,
	city varchar(200) not null,
	sub_district varchar(200),
	postal_code varchar(10)	not null
);

-- Create Table Stores (Parent Table : List Area Store Manager and List Store Manager Table)
create table if not exists stores(
		store_id serial primary key,-- Surrogate Primary Key (SPK)
		store_name varchar(100) not null unique, -- Candidate Key (CK)
		opening_date date,
		open_hours time,
		close_hours time,
		address text,
		territory_id varchar(20) not null, 
		official_store_phone_no varchar(15) not null,
		store_email varchar(100) not null unique, -- Candidate Key (CK) -> have email account (must unique) is mandatory in each stores
		area_manager_id int not null check(area_manager_id > 0), -- Foreign Key (FK) --> Area Sales Manager can manage more than one stores
		store_manager_id int not null unique check(store_manager_id > 0), -- Candidate Key (CK) / Foreign Key (FK) --> Store Manager only managed a store
		store_description text,
		is_active smallint default 1,
		create_at timestamp default current_timestamp,
		update_at timestamp default current_timestamp,
		constraint fk_area_manager
			foreign key(area_manager_id) references list_area_store_manager(area_manager_id) on delete restrict,
		constraint fk_store_manager
			foreign key(store_manager_id) references list_store_manager(store_manager_id) on delete restrict,
		constraint fk_store_territory
			foreign key(territory_id) references store_territory(territory_id) on delete restrict
);

-- Create a Linking Table that links the Products and Stores Tables 
-- This Table Link is a Alternative Table with some consideration 
-- Assuming that 2 different stores have product with similar product_id 
create table if not exists linking_store_products (
    product_id int check(product_id >= 0), -- Composite Primary Key (CPK) / Foreign Key (FK)
	store_id int check(store_id > 0), -- Composite Primary Key (CPK) / Foreign Key (FK)
	primary key(product_id, store_id),
    constraint fk_store
    	foreign key(store_id) references stores(store_id) on delete cascade,
    constraint fk_product
    	foreign key(product_id) references products(product_id) on delete cascade
);

-- Create Shopping Cart Feature (Parent Table : Products)
create table if not exists shopping_cart(
    cart_id int primary key, -- Primary Key (PK)
	product_id int not null check(product_id >= 0), -- Foreign Key (FK)
    product_quantity_in_shopping_cart int not null check(product_quantity_in_shopping_cart > 0),
	last_added_at timestamp default current_timestamp,
	constraint fk_cart_product
    	foreign key(product_id) references products(product_id) on delete restrict
);

--Create Transaction Status Type
create table transaction_status_type(
	status_type_id serial primary key,
	status_type_name varchar(10) not null check(status_type_name in ('Cancelled', 'Pending', 'Paid', 'Returned', 'Delivered', 'Shipped'))
);

-- Additional Feature: Transaction Status (Transaction Journey) -> Table and Single Index (Parent Table: Orders)
-- Track Customer Transaction Order Status
create table if not exists transaction_status(
	status_order_id serial primary key, -- Primary key (PK)
	status_type_id int check(status_type_id > 0), -- Foreign Key (FK)
	order_id int check(order_id > 0), -- Foreign Key (FK)
	status_description text,
	status_update_date date,
	constraint fk_order_transaction_status
		foreign key(order_id) references orders(order_id),
	constraint fk_status_type_id
		foreign key(status_type_id) references transaction_status_type(status_type_id)
);

-- Create Linking Table for Payment Method and Orders
create table if not exists payment_type_table (
	payment_type_id int primary key, -- Primary Key (PK)
	payment_type varchar(50)not null unique check(payment_type in ('BCA','Mandiri','PayLater','BRI','BNI','BSI'))
);

-- Additional Feature: Customer Payment Method (Parent Table: Customers | Linking Table : Payment Type Table)
-- Track Customer Payment Method
create table if not exists customer_payment_method(
	payment_order_id int primary key check(payment_order_id > 0), -- Primary Key (PK)
	customer_id int not null check(customer_id > 0), -- Foreign Key (FK)
	order_date date,
	payment_type_id int not null check(payment_type_id > 0), -- Foreign Key (FK) 
    payment_type varchar(50) not null check(payment_type in ('BCA','Mandiri','PayLater','BRI','BNI','BSI')),
	payment_amount numeric not null check(payment_amount > 0),
    constraint fk_cust_payment
		foreign key(customer_id) references customers(customer_id) on delete restrict,
	constraint fk_payment_type
		foreign key(payment_type_id) references payment_type_table(payment_type_id) on delete restrict
);

-- Add New Column Payment Type ID in Table Orders
alter table orders
add column payment_type_id int;

-- Add Constraint for Table Orders to Payment Type Table (Linking Table : Payment Type Table)
alter table orders
add constraint fk_payment_type_order
foreign key(payment_type_id) references payment_type_table(payment_type_id) on delete restrict; 

-- Additional Feature: Customer Review (Parent Table : Customers)
-- Customers can leave reviews and ratings for the products they buy.
create table if not exists customer_review(
	review_id serial primary key, -- Primary Key (PK)
	order_id int not null check(order_id > 0),
	customer_id int not null check(customer_id > 0), -- Foreign Key (FK)
	rating int check(rating between 1 and 5),
	review_text text,
	review_date timestamp default current_timestamp,
	constraint fk_cust_review
		foreign key(customer_id) references customers(customer_id) on delete restrict
);

-- Additional Feature: Loyalty Points (Parent Table: Customers) 
-- Giving customers loyalty points for every purchase that can be used as discounts in the future.
create table if not exists loyalty_points(
	loyalty_id serial primary key, -- Surrogate Primary Key (PK)
	customer_id int not null check(customer_id > 0), -- Foreign Key (FK)
	points int default 0 check (points >= 0),
	last_updated timestamp default current_timestamp,
	constraint fk_cust_loyalty
		foreign key(customer_id) references customers(customer_id)
);

-- Additional Feature: Product Search History (Parent Table: Customers)
-- Store products that customers have viewed, so that they can be recommended again.
create table if not exists product_views (
    view_id serial primary key, -- Primary Key (PK)
    customer_id int not null check(customer_id > 0), -- Foreign Key (FK)
    product_id int not null check (product_id >= 0), -- Foreign Key (FK)
    view_date timestamp default current_timestamp,
    constraint fk_cust_views
    	foreign key(customer_id) references customers(customer_id) on delete cascade,
	constraint fk_cust_product
    	foreign key(product_id) references products(product_id) on delete cascade
);

-- Additional Feature: Security Settings (Parent Table: Customers)
-- Store security settings such as two-factor authentication.
create table if not exists security_settings(
	setting_id serial primary key, -- Primary Key (PK)
	customer_id int not null check(customer_id > 0), -- Foreign Key (FK)
	two_factor_enabled boolean default false,
	recovery_email varchar(100),
	constraint fk_cust_security
		foreign key(customer_id) references customers(customer_id) on delete cascade
);

-- Additional Feature : Customer Preferences (Parent Table : Customers)
-- Store customer preferences such as favorite product categories or newsletter subscriptions.
create table if not exists customer_preferences(
	preference_id serial primary key, -- Primary Key (PK)
	customer_id int not null check (customer_id > 0), -- Foreign Key (FK)
	favorite_category varchar(100),
	newsletter_subscribed boolean default false,
	constraint fk_cust_preferences
		foreign key(customer_id) references customers(customer_id)
);

-- Additional Features: Vouchers
-- Store vouchers or discount codes that can be used by customers.
create table if not exists vouchers(
	voucher_id serial primary key,
	customer_id int not null check(customer_id > 0),
	order_id int not null check(order_id > 0),
	discount_code varchar(100) not null unique,
	discount_percentage decimal (5,2),
	expiration_date date not null,
	is_used boolean default false,
	constraint fk_customer_voucher
		foreign key(customer_id) references customers(customer_id),
	constraint fk_order_voucher
		foreign key(order_id) references orders(order_id)
);



-- Case 2 : Add new data (5 data) to the orders and sales tables. 
-- Then call the view to calculate the monthly total payment that was created in question number 8 (exercise week 4).

-- Insert 5 New Data to orders table
insert into orders (order_id, customer_id, payment, order_date, delivery_date)
values 
(1006, 2, 250.00, '2021-8-1', '2024-12-2'),
(1007, 3, 150.00, '2021-9-12', '2024-9-14'),
(1008, 5, 500.00, '2021-10-15', '2024-10-16'),
(1009, 7, 120.00, '2021-10-16', '2024-10-17'),
(1010, 11, 300.00, '2021-10-18', '2024-10-20');


-- Insert 5 New Data to sales table
insert into sales (sales_id, order_id, product_id, price_per_unit, quantity, total_price)
values
(5005, 1006, 1259, 125.00, 2, 250.00),
(5006, 1007, 1259, 150.00, 1, 150.00),
(5007, 1008, 1, 100.00, 5, 500.00),
(5008, 1009, 2, 40.00, 3, 120.00),
(5009, 1010, 4, 150.00, 2, 300.00);


-- Call monthly_total_payment as the Table View
select 
	* 
from 
	monthly_total_payment;

-- Case 3: Create an index on the customer_name column in the customers table 
-- to improve search performance based on the customer name.
create index 
	index_cust_name 
	on 
		customers using btree(customer_name);



-- Case 4: Partition the orders table based on 
-- the order_date column to enhance query performance involving date ranges. 
-- For instance, frequent searches often require filtering by date ranges, 
-- and partitioning can significantly optimize such queries.  
-- (for example: Q1,Q2,Q3,Q4 from 2021)

--  Create Partition Table
create table if not exists orders_partitioned (
    order_id int,
    customer_id int,
    payment int,
    order_date date   
) 
partition by 
	range (order_date);

-- Create Table for Each Quarter (Q1, Q2, Q3, Q4)
create table if not exists orders_q1_2021 partition of orders_partitioned
    for values from ('2021-01-01') to ('2021-04-01');

create table if not exists orders_q2_2021 partition of orders_partitioned
    for values from ('2021-04-01') to ('2021-07-01');

create table if not exists orders_q3_2021 partition of orders_partitioned
    for values from ('2021-07-01') to ('2021-10-01');

create table if not exists orders_q4_2021 partition of orders_partitioned
    for values from ('2021-10-01') to ('2022-01-01');

-- Insert Data
insert into 
	orders_partitioned (order_id, 
						customer_id, 
						payment,
						order_date
						) 
select 
	order_id, 
	customer_id, 
	payment,
	to_date(order_date, 'YYYY-MM-DD') as order_date
from 
	orders
where
	to_date(order_date, 'YYYY-MM-DD') < '2023-01-01'
order by
	order_date;

-- Select from Partition Table
select
	*
from
	orders_partitioned;
	
select 
	*
from 
	orders_q1_2021;

select 
	* 
from 
	orders_q2_2021;	

select 
	* 
from 
	orders_q3_2021;

select 
	* 
from 
	orders_q4_2021;


	
-- case 5: Searches often use filters based on product type. 
-- Create a partition to enhanced the search process
-- Create a partition table and insert data from the products table. 
-- Do query from partition table!

-- Create Partition Table
create table if not exists product_type_partitioned(
	product_id int,
	product_type varchar(100),
	product_name varchar(100),
	size varchar(100),
	colour varchar(100),
	price int,
	quantity int,
	description varchar(100)
)
partition by
		list(product_type);

-- Create Table for each Product Type
create table if not exists
	products_trousers 
		partition of 
			product_type_partitioned 
		for values in ('Trousers'); 

create table if not exists
	products_shirt 
		partition of 
			product_type_partitioned 
		for values in ('Shirt'); 

create table if not exists
	products_jacket 
		partition of 
			product_type_partitioned 
		for values in ('Jacket'); 

-- Insert Data
insert into
	product_type_partitioned(
								product_id,
								product_type,
								product_name,
								size,
								colour,
								price,
								quantity,
								description
							)
select
	product_id,
	product_type,
	product_name,
	size,
	colour,
	price,
	quantity,
	description
from
	products
where
	product_type 
	in ('Trousers', 'Shirt', 'Jacket');

-- Select from Partition Table
select
	*
from
	product_type_partitioned;

select
	*
from
	products_shirt;

select
	*
from
	products_trousers;

select
	*
from
	products_jacket;



set search_path to exercise_week6_number_6_8;
-- Case 6 : Explain the condition of the table (whether it satisfies 1NF, 2NF, and 3NF)
-- Transform it into a form that meets the requirements of 3NF.
create table if not exists student_projects_old (
    student_id int,
    first_name varchar(50),
    last_name varchar(50),
    project_id varchar(10),
    project varchar(100),
    primary key (student_id, project_id) -- student_id and project_id are composite primary key (CPK)
);

insert into student_projects_old (student_id, first_name, last_name, project_id, project)
values
    (1000, 'Kira', 'Granger', 'P-0011', 'E-commerce Website'),
    (1001, 'Katherine', 'Erlich', 'P-0012', 'IoT Program'),
    (1000, 'Kira', 'Granger', 'P-0013', 'Book Catalog Website'),
    (1003, 'Shannon', 'Black', 'P-0014', 'VR Game');

select * from student_projects_old;

-- 1NF :
-- This table satisfies 1NF because there are no multivalues (columns contain only single values), 


-- 2NF:
-- FD1 : student_id -> first_name, last_name
-- FD2 : project_id -> project
-- This table does not satisfy 2NF because there is still a partial dependency 
-- because first_name and last_name only depend on student_id and also project only depend on project_id (not the combination of student_id and project_id). 
-- So, there must be 2 tables, namely the student table and the project table

-- 3NF:
-- This table does not fulfill 3NF because the table does not satisfy the 2NF Condition

-- To fulfill 3NF, the table must fulfill 2NF, 
-- and there must be no transitive dependencies 
-- (non-primary attributes must not depend on other non-primary attributes).

-- Create Table Student
create table if not exists student(
	student_id int primary key, -- PK
	first_name varchar(100) not null,
	last_name varchar(100) not null
);

insert into student(student_id, first_name, last_name)
values
    (1000, 'Kira', 'Granger'),
    (1001, 'Katherine', 'Erlich'),
    (1003, 'Shannon','Black');

select * from student;

-- Create Table Project
create table if not exists project(
	project_id varchar(100) primary key, -- PK
	project varchar(100) not null
);

insert into project(project_id, project)
values
    ('P-0011', 'E-commerce Website'),
    ('P-0012', 'IoT Program'),
    ('P-0013', 'Book Catalog Website'),
    ('P-0014', 'VR Game');

select * from project;

-- Create Table Student Project List
create table if not exists student_and_project_list(
	student_id int not null, -- CPK / FK
	project_id varchar(100) not null, --CPK /FK
	primary key(student_id, project_id),
	constraint fk_project
		foreign key(project_id) references project(project_id),
	constraint fk_student
		foreign key(student_id) references student(student_id)
);

insert into student_and_project_list(student_id, project_id)
values
    (1000, 'P-0011'),
    (1000, 'P-0013'),
    (1001, 'P-0012'),
    (1003, 'P-0014');

select * from student_and_project_list;



-- Case 7 : Explain the condition of the table (whether it satisfies 1NF, 2NF, and 3NF)
-- Transform it into a form that meets the requirements of 3NF.

-- 1NF (First Normal Form):
-- A table satisfies 1NF if each column contains atomic (indivisible) values, meaning no repeating groups or multiple values in a single cell.
-- In this table, the genre column contains multiple values for some rows (e.g., "fiction, contemporary" or "fiction, mystery"). This violates 1NF because these are not atomic values.
-- Conclusion: The table does not satisfy 1NF due to the non-atomic genre column.
create table if not exists books (
    book_id int primary key,
    title varchar(255),
    genre varchar(255),
    price int
);
insert into books (book_id, title, genre, price) values
(1000, 'The Miracles of the Namiya Store', 'fiction, contemporary', 100000.00),
(1001, 'And Then There Were None', 'fiction, mystery', 98000.00),
(1002, 'Six of Crows', 'fiction, fantasy', 88000.00),
(1003, 'Goodbye, Things: The New Japanese Minimalism', 'nonfiction', 92000.00);

select * from books;

-- Create Table Books 1NF to satisfy 1NF
-- But this Table still have redundant Data
create table if not exists books_1nf(
    book_id int not null, -- CPK
    title varchar(255),
    genre varchar(255) not null, -- CPK
    price int,
	primary key(book_id, genre)
);

insert into books_1nf(book_id, title, genre, price) 
values
(1000, 'The Miracles of the Namiya Store', 'fiction', 100000.00),
(1000, 'The Miracles of the Namiya Store', 'contemporary', 100000.00),
(1001, 'And Then There Were None', 'fiction', 98000.00),
(1001, 'And Then There Were None', 'mystery', 98000.00),
(1002, 'Six of Crows', 'fiction', 88000.00),
(1002, 'Six of Crows', 'fantasy', 88000.00),
(1003, 'Goodbye, Things: The New Japanese Minimalism', 'nonfiction', 92000.00);

select * from books_1nf;

-- 2NF (Second Normal Form):
-- A table satisfies 2NF because it is satisfies 1NF and all non-primary key attributes are fully functionally dependent on the primary key.
-- Assuming book_id is the primary key, each attribute (title, genre, price) is fully dependent on book_id, so there’s no partial dependency here.

-- Create the Books table
create table if not exists list_book_price (
    book_id int primary key, -- PK
    title varchar(100),
    price INT
);
insert into list_book_price (book_id, title, price) values
(1000, 'The Miracles of the Namiya Store', 100000),
(1001, 'And Then There Were None', 98000),
(1002, 'Six of Crows', 88000),
(1003, 'Goodbye, Things: The New Japanese Minimalism', 92000);

select * from list_book_price;

-- Create the Genres table
create table if not exists genres (
    genre_id int primary key, -- PK
    genre_name varchar(50)
);
insert into genres (genre_id, genre_name) values
(1, 'fiction'),
(2, 'contemporary'),
(3, 'mystery'),
(4, 'fantasy'),
(5, 'nonfiction');

select * from genres;

-- Create Table Books and Genres
create table book_genre_list(
	book_id int not null, -- CPK
	genre_id int not null, -- CPK
	primary key(book_id, genre_id),
	constraint fk_book 
		foreign key(book_id) references list_book_price,
	constraint fk_genre
		foreign key(genre_id) references genres
);
insert into book_genre_list(book_id, genre_id)
values
    (1000, 1),
    (1000, 2),
    (1001, 1),
    (1001, 3),
    (1002, 1),
    (1002, 4),
    (1003, 5);

select * from book_genre_list;
-- 3NF (Third Normal Form):
-- A table satisfies 3NF if it is in 2NF and has no transitive dependencies (no non-primary key column should depend on another non-primary key column).
-- In this table, there are no transitive dependencies. So, it is satisfy 3NF



-- Case 8 : Table structure in number 6 should be modified so that it may record information about the class that provided the project assignment 
-- as well as the score of the project the student worked on. 
-- Implement the table structure that was created using the ddl syntax.
create table if not exists student_project_score (
    student_id int, -- CPK
    first_name varchar(50),
    last_name varchar(50),
    project_id varchar(10), -- CPK
    project varchar(100),
    score int,
    class_id varchar(10),
    primary key (student_id, project_id)
);
insert into student_project_score (student_id, first_name, last_name, project_id, project, score, class_id) VALUES
(1000, 'Kira', 'Granger', 'P-0011', 'E-commerce Website', 100, 'C01'),
(1001, 'Katherine', 'Erlich', 'P-0012', 'IoT Program', 80, 'C02'),
(1000, 'Kira', 'Granger', 'P-0013', 'Book Catalog Website', 88, 'C03'),
(1003, 'Shannon', 'Black', 'P-0014', 'VR Game', 95, 'C05');

select * from  student_project_score;

-- Create Table Class
create table if not exists class (
    class_id varchar(10) primary key,
    class_name varchar(50) not null
);
-- Insert data into Classes table
insert into class(class_id, class_name) values
	('C01', 'Class A'),
	('C02', 'Class B'),
	('C03', 'Class C'),
	('C05', 'Class D');

select * from class;

-- Create Table Student Class
create table if not exists student_class(
	student_id int not null,
	class_id varchar(100) not null,
	primary key(student_id, class_id),
	constraint fk_student
		foreign key(student_id) references student(student_id),
	constraint fk_class
		foreign key(class_id) references class(class_id)
);

insert into student_class(student_id, class_id)
values
	(1000, 'C01'),
	(1000, 'C03'),
	(1001, 'C02'),
	(1003, 'C05');

select * from student_class;

-- Create Table Project Class
create table if not exists project_class(
	project_id varchar(100) primary key,
	class_id varchar(100) not null,
	constraint fk_project_classes
		foreign key(class_id) references class(class_id)
);

insert into project_class(project_id, class_id)
values
    ('P-0011','C01'),
    ('P-0012', 'C02'),
    ('P-0013', 'C03'),
    ('P-0014', 'C05');

  select * from project_class;
   
-- Create Table Score Final
create table if not exists score_table(
	student_id int not null,
	class_id varchar(100) not null,
	project_id varchar(100) not null,
	score int not null default 0,
	primary key (student_id, class_id, project_id),
	constraint fk_score_student
		foreign key(student_id) references student(student_id),
	constraint fk_score_class
		foreign key(class_id) references class(class_id),
	constraint fk_score_project
		foreign key(project_id) references project(project_id)
);

insert into score_table(student_id, class_id, project_id, score)
values
	(1000, 'C01','P-0011', 100),
	(1000, 'C03', 'P-0013', 88),
	(1001, 'C02', 'P-0012', 80),
	(1003, 'C05', 'P-0014', 95);
	
select * from score_table;



