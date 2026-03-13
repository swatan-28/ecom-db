# ecom-db

A simple MySQL based project to manage an e-commerce platform including users, products, orders, payments, and deliveries.

## Features
- Create database and tables
- Add and manage product records
- Manage customer accounts
- Track orders and payments
- Update delivery status and order history

## Tech Stack
- MySQL 8.0
- SQL

## Database Schema
| Field | Type | Constraint |
|-----|-----|-----|
| user_id | INT | Primary Key |
| name | VARCHAR | Not Null |
| email | VARCHAR | Unique |
| product_id | INT | Primary Key |
| product_name | VARCHAR | Not Null |
| price | INT | Not Null |
| order_id | INT | Primary Key |
| payment_status | VARCHAR | Not Null |
| delivery_status | VARCHAR | — |
| order_date | DATE | — |

## How to Run
1. Install MySQL
2. Create the database
3. Run SQL queries to create tables
4. Insert and manage records
