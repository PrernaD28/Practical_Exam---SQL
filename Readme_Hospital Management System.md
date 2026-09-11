Hospital Management System
Project Objective
Develop a comprehensive Hospital Management System using MySQL to enable hospital administrators to manage patient records, doctor schedules, appointments, billing invoices, and medical reports. The system supports CRUD operations, data filtering, sorting, aggregation, relational constraints, joins, subqueries, and advanced SQL features.

Database Schema & Relationships
1. Patients
patient_id (Primary Key)

name

dob

gender

phone_number

email

address

registration_date

2. Doctors
doctor_id (Primary Key)

name

specialization

phone_number

email

available_days

consultation_fee

3. Departments
department_id (Primary Key)

department_name

4. Doctor_Department (Mapping Table)
doctor_id (Foreign Key referencing Doctors.doctor_id)

department_id (Foreign Key referencing Departments.department_id)

5. Appointments
appointment_id (Primary Key)

patient_id (Foreign Key referencing Patients.patient_id)

doctor_id (Foreign Key referencing Doctors.doctor_id)

appointment_date

status (Scheduled, Completed, Cancelled)

6. Medical_Records
record_id (Primary Key)

patient_id (Foreign Key referencing Patients.patient_id)

doctor_id (Foreign Key referencing Doctors.doctor_id)

diagnosis

prescription

treatment_date

7. Billing
invoice_id (Primary Key)

patient_id (Foreign Key referencing Patients.patient_id)

appointment_id (Foreign Key referencing Appointments.appointment_id)

amount

payment_status (Paid, Pending, Cancelled)

payment_date

Tasks & Functionalities
CRUD Operations: Insert new patients, doctors, and appointments; update patient addresses; delete cancelled appointments older than 6 months.

SQL Clauses: Filter and restrict results using WHERE, HAVING, and LIMIT.

SQL Operators: Filter data using logical operators (AND, OR, NOT).

Sorting & Grouping: Organize data using ORDER BY and aggregate groups with GROUP BY.

Aggregate Functions: Compute metrics utilizing SUM, AVG, MAX, MIN, and COUNT.

Relationships & Joins: Enforce referential integrity through foreign keys and retrieve combined data using INNER JOIN, LEFT JOIN, RIGHT JOIN, and emulated FULL OUTER JOIN.

Subqueries: Execute nested queries for advanced filtering and dataset comparisons.

Date & Time Functions: Extract date parts, calculate hospital stay durations, and format treatment dates.

String Manipulation: Convert text cases, trim whitespace, and handle missing values.

Window Functions: Apply ranking (RANK()) and calculate running totals / cumulative revenues.

CASE Expressions: Categorize patients into risk levels and classify doctors based on experience levels.