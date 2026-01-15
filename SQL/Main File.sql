CREATE DATABASE Support_Ticket_Analysis;
USE Support_Ticket_Analysis;

CREATE TABLE Customers (Customer_Id INT PRIMARY KEY, Customer_Name VARCHAR (100),
City VARCHAR (100), Signup_Date DATE);

CREATE TABLE Agents (Agent_Id INT PRIMARY KEY, Agent_Name VARCHAR (100), Team VARCHAR (100),
Joining_Date DATE);

CREATE TABLE Categories (Category_Id INT PRIMARY KEY,  Category_Name VARCHAR (100), Sla_Hours INT);

CREATE TABLE Tickets 
(Ticket_Id INT PRIMARY KEY, 
Customer_Id INT,
Agent_Id INT,
Category_Id INT,
Created_At DATETIME, 
Resolved_At DATETIME, 
Status VARCHAR (100), 
Customer_Rating INT,
FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id), 
FOREIGN KEY (Agent_Id) REFERENCES Agents(Agent_Id), 
FOREIGN KEY (Category_Id) REFERENCES Categories (Category_Id));

INSERT INTO Customers (Customer_Id, Customer_Name, City , Signup_Date) VALUES
(1, "Amit Sharma", "Delhi", '2023-01-10'),
(2, "Neha Verma", "Mumbai", '2023-02-15'),
(3, "Rohit Mehta", "Bangalore", '2023-03-05'),
(4, "Sneha Iyer", "Chennai", '2023-04-20'),
(5, "Karan Singh", "Pune", '2023-05-01'),
(6, "Pooja Nair", "Kochi", '2023-06-12'),
(7, "Arjun Patel", "Kochi", '2023-07-08'),
(8, "Riya Malhotra", "Kochi", '2023-08-21');

INSERT INTO Agents (Agent_Id, Agent_Name, Team, Joining_Date) VALUES
(101, "Ravi Kumar" , "Technical", '2022-06-01'),
(102, "Anita Rao" , "Billing", '2022-09-15'),
(103, "Suresh Patel" , "General", '2023-01-10'),
(104, "Meena Joshi" , "Technical", '2023-03-18'),
(105, "Vikram Das" , "Billing", '2023-05-22');

INSERT INTO Categories (Category_Id, Category_Name, Sla_Hours) VALUES
(1, "Login Issue" , 24),
(2, "Payment Failure" , 12),
(3, "Account Closure" , 48),
(4, "Refund Request" , 72),
(5, "Profile Update" , 24);

INSERT INTO Tickets (Ticket_Id, Customer_Id, Agent_Id, Category_Id, Created_At, Resolved_At, Status, Customer_Rating) VALUES
(1001, 1, 101, 1, '2024-01-01 10:00', '2024-01-01 18:00' , "Resolved" , 4),
(1002, 2, 102, 2, '2024-01-02 11:30', '2024-01-03 02:00' , "Resolved" , 3),
(1003, 3, 101, 1, '2024-01-03 09:15', '2024-01-04 12:00' , "Resolved" , 5),
(1004, 4, 103, 4, '2024-01-04 14:00', '2024-01-07 10:00' , "Resolved" , 2),
(1005, 5, 102, 3, '2024-01-05 16:45', NULL , "Open" , NULL),
(1006, 6, 104, 5, '2024-01-06 10:20', '2024-01-06 15:00' , "Resolved" , 4),
(1007, 7, 101, 2, '2024-01-07 09:00', '2024-01-08 01:30' , "Resolved" , 2),
(1008, 8, 103, 4, '2024-01-08 11:10', NULL , "Reopened" , NULL),
(1009, 1, 105, 2, '2024-01-09 15:40', '2024-01-10 05:00' , "Resolved" , 3),
(1010, 2, 104, 1, '2024-01-10 10:10', '2024-01-10 13:00' , "Resolved" , 5),
(1011, 3, 101, 3, '2024-01-11 16:00', NULL , "Open" , NULL),
(1012, 4, 105, 2, '2024-01-12 09:30', '2024-01-13 00:30' , "Resolved" , 2),
(1013, 6, 102, 4, '2024-01-13 11:45', '2024-01-16 09:00' , "Resolved" , 1),
(1014, 7, 103, 5, '2024-01-14 10:00', '2024-01-14 14:30' , "Resolved" , 4),
(1015, 8, 104, 1, '2024-01-15 17:20', '2024-01-16 22:00' , "Resolved" , 3);



SELECT Ticket_Id, 
Created_At, 
Resolved_At, 
Status, 
Customer_Rating, 
Sla_Hours, 
Agent_Name, 
Category_Name, 
TIMESTAMPDIFF( HOUR, Created_At, Resolved_At) AS Resolution_Time_Hours, 
CASE
    WHEN TIMESTAMPDIFF(HOUR, tickets.created_at, tickets.resolved_at) > categories.sla_hours THEN 'Yes'
    WHEN TIMESTAMPDIFF(HOUR, tickets.created_at, tickets.resolved_at) <= categories.sla_hours THEN 'No'
    ELSE 'Pending'
END AS Sla_Breached
FROM Tickets
INNER JOIN Agents
ON Tickets.Agent_Id = Agents.Agent_Id
INNER JOIN Categories
ON Tickets.Category_Id = Categories.Category_Id;


SELECT Category_Name, 
Sla_hours, 
COUNT(Ticket_Id) AS Total_Tickets, 
AVG(TIMESTAMPDIFF(HOUR, Created_At, Resolved_At)) AS Avg_Resoution_Time_Hours,
AVG(
    CASE 
        WHEN TIMESTAMPDIFF(HOUR, tickets.created_at, tickets.resolved_at) > categories.sla_hours 
        THEN 100 
        ELSE 0 
    END
) AS sla_breached_percent
FROM Tickets
INNER JOIN Categories
ON Tickets.Category_Id = Categories.Category_Id
GROUP BY Category_Name , Sla_Hours;
