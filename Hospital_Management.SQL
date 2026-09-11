CREATE DATABASE IF NOT EXISTS hospital_management;
USE hospital_management;

-- DATABASE SCHEMA CREATION & RELATIONSHIPS
-- ---------------------------------------------------------------------

-- 1. Patients Table
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob DATE,
    gender VARCHAR(10),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    registration_date DATE
);

INSERT INTO Patients (patient_id, name, dob, gender, phone_number, email, address, registration_date) VALUES
(1, 'John Doe', '1985-06-15', 'Male', '9876543210', 'john@example.com', '123 Main St, City', '2025-05-10'),
(2, 'Jane Smith', '1990-11-22', 'Female', '9765432109', 'jane@example.com', '456 Oak Rd, City', '2025-08-15'),
(3, 'Robert Johnson', '1978-03-05', 'Male', '9654321098', 'robert@example.com', '789 Pine Ave, City', '2026-01-10'),
(4, 'Emily Davis', '1995-12-30', 'Female', '9543210987', 'emily@example.com', '321 Maple Dr, City', '2026-03-01');

-- 2. Doctors Table
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone_number VARCHAR(15),
    email VARCHAR(100),
    available_days VARCHAR(50),
    consultation_fee DECIMAL(10, 2),
    experience_years INT
);

INSERT INTO Doctors (doctor_id, name, specialization, phone_number, email, available_days, consultation_fee, experience_years) VALUES
(1, 'Dr. Alice Smith', 'Cardiology', '9123456789', 'alice@hospital.com', 'Mon-Fri', 1200.00, 16),
(2, 'Dr. Bob Jones', 'Neurology', '9234567890', 'bob@hospital.com', 'Tue-Sat', 1500.00, 12),
(3, 'Dr. Charlie Brown', 'Dermatology', '9345678901', 'charlie@hospital.com', 'Mon-Wed', 900.00, 6),
(4, 'Dr. Diana Prince', 'Orthopedics', '9456789012', 'diana@hospital.com', 'Thu-Sat', 1100.00, 18);

-- 3. Departments Table
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);
INSERT INTO Departments (department_id, department_name) VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Dermatology'),
(4, 'Orthopedics');

-- 4. Doctor_Department (Mapping Table)
CREATE TABLE Doctor_Department (
    doctor_id INT,
    department_id INT,
    PRIMARY KEY (doctor_id, department_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id) ON DELETE CASCADE
);
INSERT INTO Doctor_Department (doctor_id, department_id) VALUES
(1, 123),
(2, 245),
(3, 300),
(4, 401);

-- 5. Appointments Table
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    status ENUM('Scheduled', 'Completed', 'Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE
);

INSERT INTO Appointments (appointment_id, patient_id, doctor_id, appointment_date, status) VALUES
(1, 1, 1, '2026-06-20 10:30:00', 'Scheduled'),
(2, 2, 2, '2026-05-12 11:00:00', 'Completed'),
(3, 3, 3, '2025-11-15 09:15:00', 'Completed'),
(4, 4, 4, '2025-10-01 14:00:00', 'Cancelled');

-- 6. Medical_Records Table
CREATE TABLE Medical_Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    diagnosis TEXT,
    prescription TEXT,
    treatment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE
);

INSERT INTO Medical_Records (record_id, patient_id, doctor_id, diagnosis, prescription, treatment_date) VALUES
(1, 1, 1, 'Mild hypertension', 'Amlodipine 5mg', '2026-06-20'),
(2, 2, 2, 'Migraine headache', 'Sumatriptan 50mg', '2025-05-12'),
(3, 3, 3, 'Eczema flare-up', 'Hydrocortisone cream', '2025-11-15');

-- 7. Billing Table
CREATE TABLE Billing (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    appointment_id INT,
    amount DECIMAL(10, 2),
    payment_status ENUM('Paid', 'Pending', 'Cancelled'),
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id) ON DELETE CASCADE
);

INSERT INTO Billing (invoice_id, patient_id, appointment_id, amount, payment_status, payment_date) VALUES
(1, 1, 1, 1200.00, 'Pending', NULL),
(2, 2, 2, 1500.00, 'Paid', '2025-05-12'),
(3, 3, 3, 900.00, 'Paid', '2025-11-15');

-- 7. Hospital stays
CREATE TABLE Hospital_Stays (
    stay_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    admission_date DATE,
    discharge_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE
);

INSERT INTO Hospital_Stays (patient_id, admission_date, discharge_date) VALUES
(1, '2026-06-15', '2026-06-20'),
(2, '2025-05-10', '2025-05-12'),
(3, '2026-01-01', '2026-01-05');



-- TASK 1: IMPLEMENT CRUD OPERATIONS
-- ---------------------------------------------------------------------

-- Insert new patient
INSERT INTO Patients (name, dob, gender, phone_number, email, address, registration_date) 
VALUES ('John Doe', '1985-06-15', 'Male', '9876543210', 'john@example.com', '123 Main St', CURDATE());

+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
| patient_id | name           | dob        | gender | phone_number | email              | address            | registration_date |
+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
|          1 | John Doe       | 1985-06-15 | Male   | 9876543210   | john@example.com   | 123 Main St, City  | 2025-05-10        |
|          2 | Jane Smith     | 1990-11-22 | Female | 9765432109   | jane@example.com   | 456 Oak Rd, City   | 2025-08-15        |
|          3 | Robert Johnson | 1978-03-05 | Male   | 9654321098   | robert@example.com | 789 Pine Ave, City | 2026-01-10        |
|          4 | Emily Davis    | 1995-12-30 | Female | 9543210987   | emily@example.com  | 321 Maple Dr, City | 2026-03-01        |
|          5 | John Doe       | 1985-06-15 | Male   | 9876543210   | john@example.com   | 123 Main St        | 2026-09-11        |
+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
5 rows in set (0.007 sec)

-- Insert new doctor
INSERT INTO Doctors (name, specialization, phone_number, email, available_days, consultation_fee) 
VALUES ('Dr. Alice Smith', 'Cardiology', '9123456789', 'alice@hospital.com', 'Mon-Fri', 1200.00);
+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
| doctor_id | name              | specialization | phone_number | email                | available_days | consultation_fee | experience_years |
+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
|         1 | Dr. Alice Smith   | Cardiology     | 9123456789   | alice@hospital.com   | Mon-Fri        |          1200.00 |               16 |
|         2 | Dr. Bob Jones     | Neurology      | 9234567890   | bob@hospital.com     | Tue-Sat        |          1500.00 |               12 |
|         3 | Dr. Charlie Brown | Dermatology    | 9345678901   | charlie@hospital.com | Mon-Wed        |           900.00 |                6 |
|         4 | Dr. Diana Prince  | Orthopedics    | 9456789012   | diana@hospital.com   | Thu-Sat        |          1100.00 |               18 |
|         5 | Dr. Alice Smith   | Cardiology     | 9123456789   | alice@hospital.com   | Mon-Fri        |          1200.00 |             NULL |
+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
5 rows in set (0.095 sec)

-- Insert new appointment
INSERT INTO Appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2026-06-20 10:30:00', 'Scheduled');
+----------------+------------+-----------+---------------------+-----------+
| appointment_id | patient_id | doctor_id | appointment_date    | status    |
+----------------+------------+-----------+---------------------+-----------+
|              1 |          1 |         1 | 2026-06-20 10:30:00 | Scheduled |
|              2 |          2 |         2 | 2026-05-12 11:00:00 | Completed |
|              3 |          3 |         3 | 2025-11-15 09:15:00 | Completed |
|              4 |          4 |         4 | 2025-10-01 14:00:00 | Cancelled |
|              5 |          1 |         1 | 2026-06-20 10:30:00 | Scheduled |
+----------------+------------+-----------+---------------------+-----------+
5 rows in set (0.009 sec)

-- Update patient address
UPDATE Patients 
SET address = '456 New Avenue, City' 
WHERE patient_id = 1;
+------------+----------------+------------+--------+--------------+--------------------+----------------------+-------------------+
| patient_id | name           | dob        | gender | phone_number | email              | address              | registration_date |
+------------+----------------+------------+--------+--------------+--------------------+----------------------+-------------------+
|          1 | John Doe       | 1985-06-15 | Male   | 9876543210   | john@example.com   | 456 New Avenue, City | 2025-05-10        |
|          2 | Jane Smith     | 1990-11-22 | Female | 9765432109   | jane@example.com   | 456 Oak Rd, City     | 2025-08-15        |
|          3 | Robert Johnson | 1978-03-05 | Male   | 9654321098   | robert@example.com | 789 Pine Ave, City   | 2026-01-10        |
|          4 | Emily Davis    | 1995-12-30 | Female | 9543210987   | emily@example.com  | 321 Maple Dr, City   | 2026-03-01        |
|          5 | John Doe       | 1985-06-15 | Male   | 9876543210   | john@example.com   | 123 Main St          | 2026-09-11        |
+------------+----------------+------------+--------+--------------+--------------------+----------------------+-------------------+
5 rows in set (0.016 sec)

-- Delete cancelled appointments older than 6 months
DELETE FROM Appointments 
WHERE status = 'Cancelled' 
  AND appointment_date < NOW() - INTERVAL 6 MONTH;
  +----------------+------------+-----------+---------------------+-----------+
| appointment_id | patient_id | doctor_id | appointment_date    | status    |
+----------------+------------+-----------+---------------------+-----------+
|              1 |          1 |         1 | 2026-06-20 10:30:00 | Scheduled |
|              2 |          2 |         2 | 2026-05-12 11:00:00 | Completed |
|              3 |          3 |         3 | 2025-11-15 09:15:00 | Completed |
|              5 |          1 |         1 | 2026-06-20 10:30:00 | Scheduled |
+----------------+------------+-----------+---------------------+-----------+
4 rows in set (0.005 sec)

-- TASK 2: USE SQL CLAUSES (WHERE, HAVING, LIMIT)
-- ---------------------------------------------------------------------

-- Find all patients registered in the last year
SELECT * 
FROM Patients 
WHERE registration_date >= CURDATE() - INTERVAL 1 YEAR;
+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
| patient_id | name           | dob        | gender | phone_number | email              | address            | registration_date |
+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
|          3 | Robert Johnson | 1978-03-05 | Male   | 9654321098   | robert@example.com | 789 Pine Ave, City | 2026-01-10        |
|          4 | Emily Davis    | 1995-12-30 | Female | 9543210987   | emily@example.com  | 321 Maple Dr, City | 2026-03-01        |
|          5 | John Doe       | 1985-06-15 | Male   | 9876543210   | john@example.com   | 123 Main St        | 2026-09-11        |
+------------+----------------+------------+--------+--------------+--------------------+--------------------+-------------------+
3 rows in set (0.027 sec)

-- Get the top 5 highest-paying patients
SELECT p.patient_id, p.name, SUM(b.amount) AS total_paid
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.name
ORDER BY total_paid DESC
LIMIT 5;

+------------+----------------+------------+
| patient_id | name           | total_paid |
+------------+----------------+------------+
|          2 | Jane Smith     |    1500.00 |
|          3 | Robert Johnson |     900.00 |
+------------+----------------+------------+
2 rows in set (0.177 sec)

-- Retrieve doctors who charge more than 1000
SELECT * 
FROM Doctors 
WHERE consultation_fee > 1000.00;

+-----------+------------------+----------------+--------------+--------------------+----------------+------------------+------------------+
| doctor_id | name             | specialization | phone_number | email              | available_days | consultation_fee | experience_years |
+-----------+------------------+----------------+--------------+--------------------+----------------+------------------+------------------+
|         1 | Dr. Alice Smith  | Cardiology     | 9123456789   | alice@hospital.com | Mon-Fri        |          1200.00 |               16 |
|         2 | Dr. Bob Jones    | Neurology      | 9234567890   | bob@hospital.com   | Tue-Sat        |          1500.00 |               12 |
|         4 | Dr. Diana Prince | Orthopedics    | 9456789012   | diana@hospital.com | Thu-Sat        |          1100.00 |               18 |
|         5 | Dr. Alice Smith  | Cardiology     | 9123456789   | alice@hospital.com | Mon-Fri        |          1200.00 |             NULL |
+-----------+------------------+----------------+--------------+--------------------+----------------+------------------+------------------+
4 rows in set (0.021 sec)

-- TASK 3: APPLY SQL OPERATORS (AND, OR, NOT)
-- ---------------------------------------------------------------------

-- Find appointments where status = 'Scheduled' AND doctor_id = 3
SELECT * 
FROM Appointments 
WHERE status = 'Scheduled' AND doctor_id = 3;

Empty set (0.026 sec)

-- Retrieve doctors who specialize in Cardiology OR Neurology
SELECT * 
FROM Doctors 
WHERE specialization = 'Cardiology' OR specialization = 'Neurology';

+-----------+-----------------+----------------+--------------+--------------------+----------------+------------------+------------------+
| doctor_id | name            | specialization | phone_number | email              | available_days | consultation_fee | experience_years |
+-----------+-----------------+----------------+--------------+--------------------+----------------+------------------+------------------+
|         1 | Dr. Alice Smith | Cardiology     | 9123456789   | alice@hospital.com | Mon-Fri        |          1200.00 |               16 |
|         2 | Dr. Bob Jones   | Neurology      | 9234567890   | bob@hospital.com   | Tue-Sat        |          1500.00 |               12 |
|         5 | Dr. Alice Smith | Cardiology     | 9123456789   | alice@hospital.com | Mon-Fri        |          1200.00 |             NULL |
+-----------+-----------------+----------------+--------------+--------------------+----------------+------------------+------------------+
3 rows in set (0.011 sec)

-- Get patients who have NOT visited in the past year
SELECT * 
FROM Patients 
WHERE patient_id NOT IN (
    SELECT DISTINCT patient_id 
    FROM Appointments 
    WHERE appointment_date >= CURDATE() - INTERVAL 1 YEAR
);

+------------+-------------+------------+--------+--------------+-------------------+--------------------+-------------------+
| patient_id | name        | dob        | gender | phone_number | email             | address            | registration_date |
+------------+-------------+------------+--------+--------------+-------------------+--------------------+-------------------+
|          4 | Emily Davis | 1995-12-30 | Female | 9543210987   | emily@example.com | 321 Maple Dr, City | 2026-03-01        |
|          5 | John Doe    | 1985-06-15 | Male   | 9876543210   | john@example.com  | 123 Main St        | 2026-09-11        |
+------------+-------------+------------+--------+--------------+-------------------+--------------------+-------------------+
2 rows in set (0.082 sec)

-- TASK 4: SORTING & GROUPING DATA (ORDER BY, GROUP BY)
-- ---------------------------------------------------------------------

-- List all doctors sorted by specialization
SELECT * 
FROM Doctors 
ORDER BY specialization ASC;

+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
| doctor_id | name              | specialization | phone_number | email                | available_days | consultation_fee | experience_years |
+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
|         1 | Dr. Alice Smith   | Cardiology     | 9123456789   | alice@hospital.com   | Mon-Fri        |          1200.00 |               16 |
|         5 | Dr. Alice Smith   | Cardiology     | 9123456789   | alice@hospital.com   | Mon-Fri        |          1200.00 |             NULL |
|         3 | Dr. Charlie Brown | Dermatology    | 9345678901   | charlie@hospital.com | Mon-Wed        |           900.00 |                6 |
|         2 | Dr. Bob Jones     | Neurology      | 9234567890   | bob@hospital.com     | Tue-Sat        |          1500.00 |               12 |
|         4 | Dr. Diana Prince  | Orthopedics    | 9456789012   | diana@hospital.com   | Thu-Sat        |          1100.00 |               18 |
+-----------+-------------------+----------------+--------------+----------------------+----------------+------------------+------------------+
5 rows in set (0.019 sec)

-- Display the number of patients assigned to each doctor
SELECT d.doctor_id, d.name, COUNT(DISTINCT a.patient_id) AS patient_count
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name;

+-----------+-------------------+---------------+
| doctor_id | name              | patient_count |
+-----------+-------------------+---------------+
|         1 | Dr. Alice Smith   |             1 |
|         2 | Dr. Bob Jones     |             1 |
|         3 | Dr. Charlie Brown |             1 |
|         4 | Dr. Diana Prince  |             0 |
|         5 | Dr. Alice Smith   |             0 |
+-----------+-------------------+---------------+
5 rows in set (0.080 sec)

-- Show total revenue generated per department
SELECT dept.department_id, dept.department_name, SUM(b.amount) AS total_revenue
FROM Departments dept
JOIN Doctor_Department dd ON dept.department_id = dd.department_id
JOIN Appointments a ON dd.doctor_id = a.doctor_id
JOIN Billing b ON a.appointment_id = b.appointment_id
WHERE b.payment_status = 'Paid'
GROUP BY dept.department_id, dept.department_name;

Empty set (0.025 sec)

-- TASK 5: USE AGGREGATE FUNCTIONS (SUM, AVG, MAX, MIN, COUNT)
-- ---------------------------------------------------------------------

-- Find the total revenue collected
SELECT SUM(amount) AS total_revenue 
FROM Billing 
WHERE payment_status = 'Paid';

+---------------+
| total_revenue |
+---------------+
|       2400.00 |
+---------------+
1 row in set (0.013 sec)

-- Identify the most visited doctor
SELECT d.doctor_id, d.name, COUNT(a.appointment_id) AS total_visits
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name
ORDER BY total_visits DESC
LIMIT 1;
+-----------+-----------------+--------------+
| doctor_id | name            | total_visits |
+-----------+-----------------+--------------+
|         1 | Dr. Alice Smith |            2 |
+-----------+-----------------+--------------+
1 row in set (0.066 sec)

-- Calculate the average consultation fee
SELECT AVG(consultation_fee) AS avg_consultation_fee 
FROM Doctors;
+----------------------+
| avg_consultation_fee |
+----------------------+
|          1180.000000 |
+----------------------+
1 row in set (0.047 sec)

-- TASK 7: IMPLEMENT JOINS
-- ---------------------------------------------------------------------

-- Retrieve a list of doctors along with their department names using INNER JOIN
SELECT d.doctor_id, d.name AS doctor_name, dept.department_name
FROM Doctors d
JOIN Doctor_Department dd ON d.doctor_id = dd.doctor_id
JOIN Departments dept ON dd.department_id = dept.department_id;
Empty set (0.016 sec)

-- Get all patients who have completed appointments using LEFT JOIN
SELECT DISTINCT p.patient_id, p.name 
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.status = 'Completed';
+------------+----------------+
| patient_id | name           |
+------------+----------------+
|          2 | Jane Smith     |
|          3 | Robert Johnson |
+------------+----------------+
2 rows in set (0.020 sec)

-- Find appointments that have no payments using RIGHT JOIN (or LEFT JOIN depending on perspective, matching instructions)
SELECT a.appointment_id, a.appointment_date, b.invoice_id
FROM Billing b
RIGHT JOIN Appointments a ON b.appointment_id = a.appointment_id
WHERE b.invoice_id IS NULL;
+----------------+---------------------+------------+
| appointment_id | appointment_date    | invoice_id |
+----------------+---------------------+------------+
|              5 | 2026-06-20 10:30:00 |       NULL |
+----------------+---------------------+------------+
1 row in set (0.050 sec)

-- Show patients who have never booked an appointment using FULL OUTER JOIN (Emulated in MySQL via UNION)
SELECT p.patient_id, p.name, a.appointment_id
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL
UNION
SELECT p.patient_id, p.name, a.appointment_id
FROM Patients p
RIGHT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE p.patient_id IS NULL;
+------------+-------------+----------------+
| patient_id | name        | appointment_id |
+------------+-------------+----------------+
|          4 | Emily Davis |           NULL |
|          5 | John Doe    |           NULL |
+------------+-------------+----------------+
2 rows in set (0.135 sec)

-- TASK 8: USE SUBQUERIES
-- ---------------------------------------------------------------------

-- Find doctors who have handled more than 50 patients
SELECT * 
FROM Doctors 
WHERE doctor_id IN (
    SELECT doctor_id 
    FROM Appointments 
    GROUP BY doctor_id 
    HAVING COUNT(DISTINCT patient_id) > 50
);

Empty set (0.029 sec)

-- Identify the patient who has spent the most on treatments
SELECT p.patient_id, p.name, SUM(b.amount) AS total_spent
FROM Patients p
JOIN Billing b ON p.patient_id = b.patient_id
WHERE b.payment_status = 'Paid'
GROUP BY p.patient_id, p.name
ORDER BY total_spent DESC
LIMIT 1;
+------------+------------+-------------+
| patient_id | name       | total_spent |
+------------+------------+-------------+
|          2 | Jane Smith |     1500.00 |
+------------+------------+-------------+
1 row in set (0.008 sec)

-- Get appointments where the doctor specializes in Dermatology
SELECT * 
FROM Appointments 
WHERE doctor_id IN (
    SELECT doctor_id 
    FROM Doctors 
    WHERE specialization = 'Dermatology'
);

+----------------+------------+-----------+---------------------+-----------+
| appointment_id | patient_id | doctor_id | appointment_date    | status    |
+----------------+------------+-----------+---------------------+-----------+
|              3 |          3 |         3 | 2025-11-15 09:15:00 | Completed |
+----------------+------------+-----------+---------------------+-----------+
1 row in set (0.056 sec)

-- TASK 9: IMPLEMENT DATE & TIME FUNCTIONS
-- ---------------------------------------------------------------------

-- Extract the month from appointment_date to count visits per month
SELECT MONTH(appointment_date) AS visit_month, COUNT(*) AS visit_count
FROM Appointments
GROUP BY MONTH(appointment_date);
+-------------+-------------+
| visit_month | visit_count |
+-------------+-------------+
|           6 |           2 |
|           5 |           1 |
|          11 |           1 |
+-------------+-------------+
3 rows in set (0.026 sec)

-- Calculate total hospital stay duration (Assuming admission_date and discharge_date columns exist or can be computed via datetime intervals)
SELECT patient_id, DATEDIFF(discharge_date, admission_date) AS stay_duration_days 
FROM Hospital_Stays;
+------------+--------------------+
| patient_id | stay_duration_days |
+------------+--------------------+
|          1 |                  5 |
|          2 |                  2 |
|          3 |                  4 |
+------------+--------------------+
3 rows in set (0.011 sec)

-- Format treatment_date as DD-MM-YYYY
SELECT record_id, DATE_FORMAT(treatment_date, '%d-%m-%Y') AS formatted_treatment_date
FROM Medical_Records;

+-----------+--------------------------+
| record_id | formatted_treatment_date |
+-----------+--------------------------+
|         1 | 20-06-2026               |
|         2 | 12-05-2025               |
|         3 | 15-11-2025               |
+-----------+--------------------------+
3 rows in set (0.020 sec)

-- TASK 10: USE STRING MANIPULATION FUNCTIONS
-- ---------------------------------------------------------------------

-- Convert all patient names to uppercase
SELECT UPPER(name) AS uppercase_name 
FROM Patients;

+----------------+
| uppercase_name |
+----------------+
| JOHN DOE       |
| JANE SMITH     |
| ROBERT JOHNSON |
| EMILY DAVIS    |
| JOHN DOE       |
+----------------+
5 rows in set (0.018 sec)

-- Trim whitespace from doctor names
SELECT TRIM(name) AS trimmed_name 
FROM Doctors;
+-------------------+
| trimmed_name      |
+-------------------+
| Dr. Alice Smith   |
| Dr. Bob Jones     |
| Dr. Charlie Brown |
| Dr. Diana Prince  |
+-------------------+
4 rows in set (0.012 sec)

-- Replace missing phone numbers with "Not Available"
SELECT COALESCE(NULLIF(phone_number, ''), 'Not Available') AS contact_number 
FROM Patients;
+----------------+
| contact_number |
+----------------+
| 9876543210     |
| 9765432109     |
| 9654321098     |
| 9543210987     |
| 9876543210     |
+----------------+
5 rows in set (0.020 sec)

-- TASK 11: IMPLEMENT WINDOW FUNCTIONS
-- ---------------------------------------------------------------------

-- Rank doctors based on the number of patients they have treated
SELECT d.doctor_id, d.name, 
       COUNT(DISTINCT a.patient_id) AS patients_treated,
       RANK() OVER (ORDER BY COUNT(DISTINCT a.patient_id) DESC) AS doctor_rank
FROM Doctors d
LEFT JOIN Appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id, d.name;

+-----------+-------------------+------------------+-------------+
| doctor_id | name              | patients_treated | doctor_rank |
+-----------+-------------------+------------------+-------------+
|         1 | Dr. Alice Smith   |                1 |           1 |
|         2 | Dr. Bob Jones     |                1 |           1 |
|         3 | Dr. Charlie Brown |                1 |           1 |
|         4 | Dr. Diana Prince  |                1 |           1 |
+-----------+-------------------+------------------+-------------+
4 rows in set (0.329 sec)

-- Show the cumulative revenue per month
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
       SUM(amount) AS monthly_revenue,
       SUM(SUM(amount)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS cumulative_revenue
FROM Billing
WHERE payment_status = 'Paid'
GROUP BY payment_month;
+---------------+-----------------+--------------------+
| payment_month | monthly_revenue | cumulative_revenue |
+---------------+-----------------+--------------------+
| 2025-05       |         1500.00 |            1500.00 |
| 2025-11       |          900.00 |            2400.00 |
+---------------+-----------------+--------------------+
2 rows in set (0.077 sec)

-- Display the running total of appointments made
SELECT appointment_id, appointment_date,
       COUNT(*) OVER (ORDER BY appointment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_appointments
FROM Appointments;
+----------------+---------------------+----------------------------+
| appointment_id | appointment_date    | running_total_appointments |
+----------------+---------------------+----------------------------+
|              4 | 2025-10-01 14:00:00 |                          1 |
|              3 | 2025-11-15 09:15:00 |                          2 |
|              2 | 2026-05-12 11:00:00 |                          3 |
|              1 | 2026-06-20 10:30:00 |                          4 |
+----------------+---------------------+----------------------------+
4 rows in set (0.021 sec)

-- TASK 12: APPLY SQL CASE EXPRESSIONS
-- ---------------------------------------------------------------------

-- Assign a Patient_Risk_Level based on medical records count
SELECT p.patient_id, p.name, 
       COUNT(m.record_id) AS record_count,
       CASE 
           WHEN COUNT(m.record_id) > 5 THEN 'High'
           WHEN COUNT(m.record_id) BETWEEN 3 AND 5 THEN 'Medium'
           ELSE 'Low'
       END AS Patient_Risk_Level
FROM Patients p
LEFT JOIN Medical_Records m ON p.patient_id = m.patient_id
GROUP BY p.patient_id, p.name;
+------------+----------------+--------------+--------------------+
| patient_id | name           | record_count | Patient_Risk_Level |
+------------+----------------+--------------+--------------------+
|          1 | John Doe       |            1 | Low                |
|          2 | Jane Smith     |            1 | Low                |
|          3 | Robert Johnson |            1 | Low                |
|          4 | Emily Davis    |            0 | Low                |
|          5 | John Doe       |            0 | Low                |
+------------+----------------+--------------+--------------------+
5 rows in set (0.032 sec)

-- Categorize doctors based on years of experience (Assuming an experience_years column exists)
SELECT doctor_id, name, specialization,
       CASE 
           WHEN experience_years > 15 THEN 'Senior'
           WHEN experience_years BETWEEN 5 AND 15 THEN 'Mid-Level'
           ELSE 'Junior'
       END AS doctor_category
FROM Doctors;
+-----------+-------------------+----------------+-----------------+
| doctor_id | name              | specialization | doctor_category |
+-----------+-------------------+----------------+-----------------+
|         1 | Dr. Alice Smith   | Cardiology     | Senior          |
|         2 | Dr. Bob Jones     | Neurology      | Mid-Level       |
|         3 | Dr. Charlie Brown | Dermatology    | Mid-Level       |
|         4 | Dr. Diana Prince  | Orthopedics    | Senior          |
+-----------+-------------------+----------------+-----------------+
4 rows in set (0.006 sec)
