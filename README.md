# Online Shop Platform Performance Analysis: Advance
<div align="center">
  <img src="https://github.com/user-attachments/assets/ed871daa-d471-461c-b566-b57ca0e1cb1c" width="600" height="400">
</div>

# Exercise Answer and SQL Script
1. Performance Analysis Answer (Exercise) : [Exercise SQL Week 6 (Mentoring 3) Answer Link](https://github.com/oktaviorezap/PacmannAcademy-Online-Shop-Performance-Analysis-with-SQL-Advance/blob/main/Exercise%20Week%206%20-%20Oktavio%20Reza%20Putra.pdf)
2. SQL Script with DBeaver : [SQL Script Link](https://github.com/oktaviorezap/PacmannAcademy-Online-Shop-Performance-Analysis-with-SQL-Advance/blob/main/Oktavio%20Reza%20Putra_Exercise%20Week%206%20-%20Mentoring%203.sql)

# Task Description
As a data analyst in an emerging online shopping platform, the manager has requested the following tasks:
<br> 1. Provide insights from the current transaction and customer history.
<br> 2. Design the necessary tables for new features.
<br> 3. Modify the table to meet the needs of stores that are expanding stores in various regions in order to reach more customers. Therefore, as a Data Analyst, I created new supporting features and tables to store these data to make it easier for Stores to conduct analyses and of course to satisfy user customers who want to shop online to continue to shop at this Online Store.

# The Dataset
<br>This database provides an insight about a simple online shop application, including product details, customer information, order and sales information. 
<div align="center">
  <img src="https://github.com/user-attachments/assets/9c2b81c4-c0f5-45ef-8089-6faacbb59e2e" width="500" height="300">
</div>

# Entity Relationship Diagram (ERD) Design (Before)
<div align="center">
  <img src="https://github.com/user-attachments/assets/cab843bc-6bc9-4d70-99b6-c4ba8e2ff763" width="500" height="400">
</div>


# Entity Relationship Diagram (ERD) Design (After)
![ERD Number 1 - Exercise Week 6 Mentoring 3](https://github.com/user-attachments/assets/d7556e18-c411-418c-93e1-5175d94f9f32)
<br>
<br>In accordance with the instructions from the Online Store Owner, as a Data Analyst I was asked to make modifications to the table by adding new features for business development purposes. 
The initial table only consists of Sales, Order, Products and Customers tables. To fulfil the business needs, I added new tables such as :

1. **Table 1: List Area Store Manager**
<br> Contains details about areamanagers overseeing multiplestores.
![image](https://github.com/user-attachments/assets/a30a94ad-4e5b-4fef-87c3-579ded6bcd7a)
![image](https://github.com/user-attachments/assets/f4a72006-7b23-4681-93f4-ffde13afe402) 

2. **Table 2: List Store Manager**
<br> Stores information on store managers who manage individual stores.
![image](https://github.com/user-attachments/assets/8f4db1d7-8f4a-4492-a806-1ab2a96ceb18)
![image](https://github.com/user-attachments/assets/aae63488-cff7-4794-92cb-2aa508647932)

3. **Table 3: Store Territory**
<br> Stores information on the territories of each store, including province, city, and postal code. 
![image](https://github.com/user-attachments/assets/7a024c02-62d3-41b2-8fae-943a1c020e63)
![image](https://github.com/user-attachments/assets/90534f03-5ad4-453e-80e0-18ef6688c60b)

4. **Table 4: Stores Table**
<br> Contains store details, including store name, address, associated managers, territory info, etc.
![image](https://github.com/user-attachments/assets/b2ca50ce-5ea1-4351-8e53-f3123f5cbc64)
![image](https://github.com/user-attachments/assets/840621a5-ad5c-47a7-a774-8058b5b2b60b)

5. **Table Link (Table 5): Stores and Product**
<br> Links products to stores, indicating the availability of each product at each store.
![image](https://github.com/user-attachments/assets/ec2f0fd8-82a8-4c57-b29c-f732fa4f7833)
![image](https://github.com/user-attachments/assets/45c5d968-62cd-47a2-ba83-f790d76873be)

6. **Table 6: Shopping Cart**
<br> Stores items that customers intend to purchase, including product quantity and last added item.
![image](https://github.com/user-attachments/assets/7ff805d2-c300-430a-a65e-f25296141003)
![image](https://github.com/user-attachments/assets/6c45e453-97c0-4a6e-8084-cf5d65f7d8f1)

7. **Table 7: Transaction Status Tracker**
<br> Tracks the status of orders (e.g., "Pending," "Paid", etc.) throughout the transaction journey.
![image](https://github.com/user-attachments/assets/c3bc4fe0-1b55-44ba-a213-2162c11ce46e)
![image](https://github.com/user-attachments/assets/b3271061-bc1e-414b-a7ab-3d5e8627d529)

8. **Table 8: Payment Table**
<br> Stores payment details for customer orders, tracking payment type and amount
![image](https://github.com/user-attachments/assets/4d0b564c-800e-4525-be71-8e946f01cd4b)
![image](https://github.com/user-attachments/assets/39e05d3a-6237-447f-9f46-b368d151b662)

9. **Table 9: Customer Review**
<br> Allows customers to leave reviews and ratings for purchased products.
![image](https://github.com/user-attachments/assets/63d376d0-30f7-46e9-975c-4378591f8b36)
![image](https://github.com/user-attachments/assets/1aa2f423-9cf5-443f-9222-587e72ef68e4)

10. **Table 10: Customer Loyalty Point**
<br> Tracks loyalty points that customers earn, which can be used for future discounts.
![image](https://github.com/user-attachments/assets/43d3b322-55a8-4515-96bf-e535ecffb82c)
![image](https://github.com/user-attachments/assets/764c45f4-999e-4777-a544-c4b299b481d7)

11. **Table 11: Product Views Search History**
<br> Logs viewed products to recommend items based on customers' browsing history.
![image](https://github.com/user-attachments/assets/3cefa9b4-49b2-44b2-a11f-30f0707a10f6)
![image](https://github.com/user-attachments/assets/30fc2709-bf2a-4885-9a07-6f2871013cea)

12. **Table 12: Security Settings**
<br> Stores security settings, such as two-factor authentication, for each customer.
![image](https://github.com/user-attachments/assets/87a122a8-a385-4afc-add9-8be893201a93)
![image](https://github.com/user-attachments/assets/3344fc72-62f5-45be-ad44-1071781795c8)

13. **Table 13: Customer Preferences**
<br>Stores customer preferences, such as favorite categories or subscription status.
![image](https://github.com/user-attachments/assets/f63e7178-4ec3-473e-a619-90c0ac7bb5ef)
![image](https://github.com/user-attachments/assets/61125ecb-78fa-4870-961f-a5c22cf7f1d0)

14. **Table 14: Vouchers**
<br> Manages discount codes and vouchers that customers can apply to orders.
![image](https://github.com/user-attachments/assets/af2c05bb-304d-45ee-99b7-806e5678450f)
![image](https://github.com/user-attachments/assets/1dc921c5-4f03-40c3-8f54-a55d368d0f0f)

