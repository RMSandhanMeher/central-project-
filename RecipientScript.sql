-- Create the database
CREATE DATABASE IF NOT EXISTS healthsure8;
USE healthsure8;
 
-- Drop old tables if needed
DROP TABLE IF EXISTS Recipient_Otp;
DROP TABLE IF EXISTS recipient;
 
-- Create Recipient table
CREATE TABLE recipient (
    h_id VARCHAR(20) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    mobile VARCHAR(10) UNIQUE,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    gender ENUM('MALE', 'FEMALE') NOT NULL,
    dob DATE NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    password VARCHAR(255),
    email VARCHAR(150) UNIQUE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE'
);
 
-- Create Recipient_Otp table
CREATE TABLE Recipient_Otp (
    otp_id INT PRIMARY KEY AUTO_INCREMENT,
    user_name VARCHAR(100) NOT NULL,
    otp_code INT NOT NULL,
    status ENUM('PENDING', 'VERIFIED', 'EXPIRED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    purpose ENUM('REGISTER','FORGOT_PASSWORD') NOT NULL,
    email VARCHAR(150) NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (user_name) REFERENCES recipient(user_name) ON DELETE CASCADE
);



-- Insurance Company
CREATE TABLE Insurance_company (
    company_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    logo_url VARCHAR(255),
    head_office VARCHAR(255),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- Insurance Plan
CREATE TABLE Insurance_plan (
    plan_id VARCHAR(50) PRIMARY KEY,
    company_id VARCHAR(50) NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    plan_type ENUM('SELF', 'FAMILY', 'SENIOR', 'CRITICAL_ILLNESS'),
    min_entry_age INT DEFAULT 18,
    max_entry_age INT DEFAULT 65,
    description TEXT,
    available_cover_amounts VARCHAR(100),
    waiting_period VARCHAR(50),
    created_on DATE DEFAULT '2025-06-01',
    expire_date DATE DEFAULT '2099-12-31',
    periodic_diseases ENUM('YES', 'NO'),
    FOREIGN KEY (company_id) REFERENCES Insurance_company(company_id)
);

-- Coverage Option
CREATE TABLE Insurance_coverage_option (
    coverage_id VARCHAR(50) PRIMARY KEY,
    plan_id VARCHAR(50),
    premium_amount NUMERIC(9,2),
    coverage_amount NUMERIC(9,2),
    status VARCHAR(30) DEFAULT 'ACTIVE',
    FOREIGN KEY (plan_id) REFERENCES Insurance_plan(plan_id)
);

-- Subscribe Table
CREATE TABLE subscribe (
    subscribe_id VARCHAR(50) PRIMARY KEY,
    h_id VARCHAR(50),
    coverage_id VARCHAR(50),
    subscribe_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    type ENUM('INDIVIDUAL', 'FAMILY'),
    status ENUM('ACTIVE', 'EXPIRED') NOT NULL,
    total_premium DECIMAL(10, 2) NOT NULL,
    amount_paid DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (coverage_id) REFERENCES Insurance_coverage_option(coverage_id)
);

-- Subscribed Members
CREATE TABLE subscribed_members (
    member_id VARCHAR(50) PRIMARY KEY,
    subscribe_id VARCHAR(50),
    full_name VARCHAR(100) NOT NULL,
    age INT,
    gender VARCHAR(10),
    relation_with_proposer VARCHAR(30),
    aadhar_no VARCHAR(20),
    FOREIGN KEY (subscribe_id) REFERENCES subscribe(subscribe_id)
);

-- Providers Table
CREATE TABLE Providers (
    provider_id VARCHAR(20) PRIMARY KEY,
    provider_name VARCHAR(100),
    hospital_name VARCHAR(100),
    email VARCHAR(100),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(20),
    status ENUM('APPROVED', 'PENDING', 'REJECTED')
);

-- Doctors Table
CREATE TABLE Doctors (
    doctor_id VARCHAR(20) PRIMARY KEY,
    provider_id VARCHAR(20),
    doctor_name VARCHAR(100) NOT NULL,
    qualification VARCHAR(255),
    specialization VARCHAR(100),
    license_no VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(225) NOT NULL,
    gender ENUM('MALE','FEMALE') NOT NULL,
    type ENUM('STANDARD', 'ADHOC') DEFAULT 'STANDARD',
    doctor_status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'INACTIVE',
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- Medical Procedure
CREATE TABLE medical_procedure (
    procedure_id VARCHAR(20) PRIMARY KEY,
    appointment_id VARCHAR(20),
    h_id VARCHAR(20),
    provider_id VARCHAR(20),
    doctor_id VARCHAR(20),
    procedure_date DATE,
    diagnosis VARCHAR(255),
    treatment_plan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id)
);

-- Claims
CREATE TABLE Claims (
    claim_id VARCHAR(20) PRIMARY KEY,
    subscribe_id VARCHAR(20) NOT NULL,
    procedure_id VARCHAR(20) NOT NULL,
    provider_id VARCHAR(20) NOT NULL,
    h_id VARCHAR(20) NOT NULL,
    claim_status ENUM('PENDING', 'APPROVED', 'DENIED') DEFAULT 'PENDING',
    claim_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount_claimed DECIMAL(10, 2) NOT NULL,
    amount_approved DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (procedure_id) REFERENCES medical_procedure(procedure_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN KEY (h_id) REFERENCES Recipient(h_id),
    FOREIGN KEY (subscribe_id) REFERENCES subscribe(subscribe_id)
);




INSERT INTO Insurance_company VALUES
('IC001', 'MediCare Ltd.', 'https://logo.medicare.com', 'Pune', 'support@medicare.com', '020-12345678');


INSERT INTO Providers VALUES
('PROV001', 'Adani', 'CityCare Hospital', 'admin@citycare.com', 'Station Road', 'Pune', 'MH', '411001', 'APPROVED');


INSERT INTO Insurance_plan (
    plan_id, company_id, plan_name, plan_type, min_entry_age, max_entry_age,
    description, available_cover_amounts, waiting_period,
    created_on, expire_date, periodic_diseases
) VALUES 
('PLAN001', 'IC001', 'Silver Health', 'SELF', 18, 60, 'Basic individual coverage plan', '100000,200000', '30 days', '2025-06-01', '2099-12-31', 'NO'),
('PLAN002', 'IC001', 'Family Health', 'FAMILY', 18, 65, 'Family floater plan', '300000,500000', '45 days', '2025-06-01', '2099-12-31', 'NO');


INSERT INTO Insurance_coverage_option (
    coverage_id, plan_id, premium_amount, coverage_amount, status
) VALUES
('COV001', 'PLAN001', 3500.00, 100000.00, 'ACTIVE'),
('COV002', 'PLAN001', 5500.00, 200000.00, 'ACTIVE'),
('COV003', 'PLAN002', 8000.00, 300000.00, 'ACTIVE'),
('COV004', 'PLAN002', 12000.00, 500000.00, 'ACTIVE');



-- Dummy Data
INSERT INTO Recipient (
    h_id, first_name, last_name, mobile, user_name,
    gender, dob, address, created_at, password,
    email, status
) VALUES
('HID001', 'Amit', 'Verma', '9876543210', 'amitv', 'MALE', '1990-01-15', 'Delhi', NOW(), 'amit@123', 'amit@example.com', 'ACTIVE'),
('HID002', 'Priya', 'Sharma', '9988776655', 'priyash', 'FEMALE', '1985-08-20', 'Mumbai', NOW(), 'priya@123', 'priya@example.com', 'ACTIVE'),
('HID003', 'Rohan', 'Kumar', '9765432109', 'rohanK', 'MALE', '1988-12-05', 'Bangalore', NOW(), 'rohan@123', 'rohan@example.com', 'ACTIVE'),
('HID004', 'Ananya', 'Patel', '9123456789', 'ananyap', 'FEMALE', '1992-03-10', 'Hyderabad', NOW(), 'ananya@123', 'ananya@example.com', 'ACTIVE'),
('HID005', 'Rajesh', 'Gupta', '9876543211', 'rajeshg', 'MALE', '1982-05-21', 'Chennai', NOW(), 'rajesh@123', 'rajesh@example.com', 'ACTIVE'),
('HID006', 'Sunita', 'Singh', '9988776654', 'sunitas', 'FEMALE', '1995-02-18', 'Kolkata', NOW(), 'sunita@123', 'sunita@example.com', 'ACTIVE'),
('HID007', 'Vikram', 'Thakur', '9765432108', 'vikramt', 'MALE', '1989-11-30', 'Pune', NOW(), 'vikram@123', 'vikram@example.com', 'ACTIVE'),
('HID008', 'Pooja', 'Mehta', '9123456788', 'poojam', 'FEMALE', '1993-04-25', 'Ahmedabad', NOW(), 'pooja@123', 'pooja@example.com', 'ACTIVE'),
('HID009', 'Sameer', 'Reddy', '9876543212', 'sameerr', 'MALE', '1987-07-14', 'Bangalore', NOW(), 'sameer@123', 'sameer@example.com', 'INACTIVE'),
('HID010', 'Neha', 'Desai', '9988776653', 'nehad', 'FEMALE', '1991-09-03', 'Delhi', NOW(), 'neha@123', 'neha@example.com', 'ACTIVE');


INSERT INTO Doctors (
    doctor_id, provider_id, doctor_name, qualification, specialization,
    license_no, email, address, gender, type, doctor_status
) VALUES
-- Gynecology
('DOC001', 'PROV001', 'Dr. Manav Malhotra', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11234', 'manav.malhotra@clinic.com', '464 Gynecology Street, Nagpur', 'MALE', 'STANDARD', 'INACTIVE'),
('DOC002', 'PROV001', 'Dr. Alok Mehra', 'MBBS, MD', 'Gynecology', 'LIC-GYNEC-11236', 'alok.mehra@clinic.com', '439 Gynecology Street, Bhopal', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC003', 'PROV001', 'Dr. Preeti Singh', 'MBBS, DM', 'Gynecology', 'LIC-GYNEC-11243', 'preeti.singh@clinic.com', '621 Gynecology Street, Jaipur', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC004', 'PROV001', 'Dr. Divya Jain', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11259', 'divya.jain@clinic.com', '741 Gynecology Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC005', 'PROV001', 'Dr. Yash Malhotra', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11272', 'yash.malhotra@clinic.com', '614 Gynecology Street, Kochi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC006', 'PROV001', 'Dr. Mitali Kapoor', 'MBBS, MD', 'Gynecology', 'LIC-GYNEC-11277', 'mitali.kapoor@clinic.com', '285 Gynecology Street, Chennai', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Orthopedics
('DOC007', 'PROV001', 'Dr. Meena Iyer', 'MBBS, DM', 'Orthopedics', 'LIC-ORTHO-11235', 'meena.iyer@clinic.com', '812 Orthopedics Street, Kochi', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC008', 'PROV001', 'Dr. Arjun Ghosh', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11262', 'arjun.ghosh@clinic.com', '682 Orthopedics Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC009', 'PROV001', 'Dr. Isha Sinha', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11265', 'isha.sinha@clinic.com', '894 Orthopedics Street, Pune', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC010', 'PROV001', 'Dr. Anuja Singh', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11269', 'anuja.singh@clinic.com', '921 Orthopedics Street, Nagpur', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC011', 'PROV001', 'Dr. Ritu Arora', 'MBBS, MD', 'Orthopedics', 'LIC-ORTHO-11273', 'ritu.arora@clinic.com', '348 Orthopedics Street, Bhopal', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Pediatrics
('DOC012', 'PROV001', 'Dr. Shreya Sethi', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11241', 'shreya.sethi@clinic.com', '699 Pediatrics Street, Chennai', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC013', 'PROV001', 'Dr. Nilesh Bhatia', 'MBBS, MD', 'Pediatrics', 'LIC-PEDIA-11242', 'nilesh.bhatia@clinic.com', '453 Pediatrics Street, Kochi', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC014', 'PROV001', 'Dr. Neha Arora', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11251', 'neha.arora@clinic.com', '522 Pediatrics Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC015', 'PROV001', 'Dr. Anjali Menon', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11267', 'anjali.menon@clinic.com', '625 Pediatrics Street, Hyderabad', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC016', 'PROV001', 'Dr. Ishita Sharma', 'MBBS, DCH', 'Pediatrics', 'LIC-PEDIA-11275', 'ishita.sharma@clinic.com', '154 Pediatrics Street, Bengaluru', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Cardiology
('DOC017', 'PROV001', 'Dr. Swati Bose', 'MBBS, DNB', 'Cardiology', 'LIC-CARDI-11245', 'swati.bose@clinic.com', '498 Cardiology Street, Pune', 'FEMALE', 'ADHOC', 'INACTIVE'),
('DOC018', 'PROV001', 'Dr. Vivek Mehra', 'MBBS, MD', 'Cardiology', 'LIC-CARDI-11250', 'vivek.mehra@clinic.com', '802 Cardiology Street, Delhi', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC019', 'PROV001', 'Dr. Zeeshan Rao', 'MBBS, DM', 'Cardiology', 'LIC-CARDI-11252', 'zeeshan.rao@clinic.com', '311 Cardiology Street, Bengaluru', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC020', 'PROV001', 'Dr. Mitali Iyer', 'MBBS, DM', 'Cardiology', 'LIC-CARDI-11257', 'mitali.iyer@clinic.com', '401 Cardiology Street, Hyderabad', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC021', 'PROV001', 'Dr. Tanmay Pillai', 'MBBS, MS', 'Cardiology', 'LIC-CARDI-11276', 'tanmay.pillai@clinic.com', '489 Cardiology Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC022', 'PROV001', 'Dr. Vikas Rathi', 'MBBS, DNB', 'Cardiology', 'LIC-CARDI-11278', 'vikas.rathi@clinic.com', '706 Cardiology Street, Kochi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC023', 'PROV001', 'Dr. Sakshi Verma', 'MBBS, MS', 'Cardiology', 'LIC-CARDI-11283', 'sakshi.verma@clinic.com', '994 Cardiology Street, Pune', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Neurology
('DOC024', 'PROV001', 'Dr. Pooja Thakur', 'MBBS, DM', 'Neurology', 'LIC-NEURO-11239', 'pooja.thakur@clinic.com', '581 Neurology Street, Bengaluru', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC025', 'PROV001', 'Dr. Roshni Kapoor', 'MBBS, MCh', 'Neurology', 'LIC-NEURO-11249', 'roshni.kapoor@clinic.com', '126 Neurology Street, Kochi', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC026', 'PROV001', 'Dr. Gaurav Malhotra', 'MBBS, MD', 'Neurology', 'LIC-NEURO-11268', 'gaurav.malhotra@clinic.com', '342 Neurology Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC027', 'PROV001', 'Dr. Preeti Rao', 'MBBS, MS', 'Neurology', 'LIC-NEURO-11279', 'preeti.rao@clinic.com', '263 Neurology Street, Bengaluru', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Psychiatry
('DOC028', 'PROV001', 'Dr. Kunal Das', 'MBBS, MS', 'Psychiatry', 'LIC-PSYCH-11238', 'kunal.das@clinic.com', '305 Psychiatry Street, Chennai', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC029', 'PROV001', 'Dr. Shalini Kapoor', 'MBBS, DM', 'Psychiatry', 'LIC-PSYCH-11255', 'shalini.kapoor@clinic.com', '279 Psychiatry Street, Pune', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC030', 'PROV001', 'Dr. Mohit Deshmukh', 'MBBS, MS', 'Psychiatry', 'LIC-PSYCH-11258', 'mohit.deshmukh@clinic.com', '565 Psychiatry Street, Bengaluru', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC031', 'PROV001', 'Dr. Raghav Deshmukh', 'MBBS, MD', 'Psychiatry', 'LIC-PSYCH-11280', 'raghav.deshmukh@clinic.com', '881 Psychiatry Street, Hyderabad', 'MALE', 'ADHOC', 'ACTIVE'),

-- Oncology
('DOC032', 'PROV001', 'Dr. Ravi Roy', 'MBBS, DNB', 'Oncology', 'LIC-ONCOL-11240', 'ravi.roy@clinic.com', '461 Oncology Street, Delhi', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC033', 'PROV001', 'Dr. Sneha Singh', 'MBBS, MS', 'Oncology', 'LIC-ONCOL-11247', 'sneha.singh@clinic.com', '978 Oncology Street, Hyderabad', 'FEMALE', 'ADHOC', 'INACTIVE'),
('DOC034', 'PROV001', 'Dr. Chirag Bose', 'MBBS, MCh', 'Oncology', 'LIC-ONCOL-11266', 'chirag.bose@clinic.com', '231 Oncology Street, Chennai', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC035', 'PROV001', 'Dr. Chirag Menon', 'MBBS, MD', 'Oncology', 'LIC-ONCOL-11282', 'chirag.menon@clinic.com', '456 Oncology Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),

-- Dermatology
('DOC036', 'PROV001', 'Dr. Nikhil Thakur', 'MBBS, DM', 'Dermatology', 'LIC-DERMA-11246', 'nikhil.thakur@clinic.com', '215 Dermatology Street, Bhopal', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC037', 'PROV001', 'Dr. Sakshi Thakur', 'MBBS, MD', 'Dermatology', 'LIC-DERMA-11261', 'sakshi.thakur@clinic.com', '912 Dermatology Street, Delhi', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC038', 'PROV001', 'Dr. Vandana Pillai', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11263', 'vandana.pillai@clinic.com', '710 Dermatology Street, Kochi', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC039', 'PROV001', 'Dr. Sneha Bose', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11271', 'sneha.bose@clinic.com', '827 Dermatology Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC040', 'PROV001', 'Dr. Abhinav Mehra', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11274', 'abhinav.mehra@clinic.com', '502 Dermatology Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),

-- General Surgery
('DOC041', 'PROV001', 'Dr. Rajiv Ghosh', 'MBBS, DCH', 'General Surgery', 'LIC-GENER-11248', 'rajiv.ghosh@clinic.com', '640 General Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC042', 'PROV001', 'Dr. Rohan Nair', 'MBBS, MS', 'General Surgery', 'LIC-GENER-11256', 'rohan.nair@clinic.com', '318 General Street, Nagpur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC043', 'PROV001', 'Dr. Rajiv Nair', 'MBBS, MD', 'General Surgery', 'LIC-GENER-11270', 'rajiv.nair@clinic.com', '319 General Street, Pune', 'MALE', 'ADHOC', 'ACTIVE'),

-- ENT
('DOC044', 'PROV001', 'Dr. Kavya Roy', 'MBBS, MD', 'ENT', 'LIC-ENT--11253', 'kavya.roy@clinic.com', '154 ENT Street, Chennai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC045', 'PROV001', 'Dr. Abhishek Singh', 'MBBS, DNB', 'ENT', 'LIC-ENT--11254', 'abhishek.singh@clinic.com', '614 ENT Street, Bhopal', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC046', 'PROV001', 'Dr. Nitin Bansal', 'MBBS, DNB', 'ENT', 'LIC-ENT--11264', 'nitin.bansal@clinic.com', '184 ENT Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC047', 'PROV001', 'Dr. Isha Suresh', 'MBBS, DNB', 'ENT', 'LIC-ENT--11281', 'isha.suresh@clinic.com', '338 ENT Street, Bhopal', 'FEMALE', 'STANDARD', 'ACTIVE'),

-- Urology
('DOC048', 'PROV001', 'Dr. Tara Malhotra', 'MBBS, DNB', 'Urology', 'LIC-UROLO-11237', 'tara.malhotra@clinic.com', '543 Urology Street, Mumbai', 'FEMALE', 'STANDARD', 'INACTIVE');

INSERT INTO Doctors (
    doctor_id, provider_id, doctor_name, qualification, specialization,
    license_no, email, address, gender, type, doctor_status
) VALUES
('DOC049', 'PROV001', 'Dr. Aman Sign', 'MBBS, DNB', 'psychiatrist', 'LIC-UROLO-11238', 'amansingh@clinic.com', '879 Street, Pune', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC050', 'PROV001', 'Dr. Prabhu Prasad', 'MBBS, DNB', 'Medicine Specialist', 'LIC-UROLO-11239', 'prabhuprasad@clinic.com', '444 Urology Street, Roulkela', 'MALE', 'STANDARD', 'ACTIVE');


INSERT INTO subscribe (subscribe_id, h_id, coverage_id, subscribe_date, expiry_date, type, status, total_premium, amount_paid) VALUES
-- HID001: 2 ACTIVE, 2 EXPIRED
('SUB001', 'HID001', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB002', 'HID001', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB003', 'HID001', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB004', 'HID001', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID001: 3 EXPIRED, 1 ACTIVE
('SUB005', 'HID001', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB006', 'HID001', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB007', 'HID001', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB008', 'HID001', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00),

-- HID002: 2 ACTIVE, 2 EXPIRED
('SUB009', 'HID002', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB010', 'HID002', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB011', 'HID002', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB012', 'HID002', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID002: 3 EXPIRED, 1 ACTIVE
('SUB013', 'HID002', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB014', 'HID002', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB015', 'HID002', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB016', 'HID002', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00),

-- HID003: 2 ACTIVE, 2 EXPIRED
('SUB017', 'HID003', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB018', 'HID003', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB019', 'HID003', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB020', 'HID003', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID003: 3 EXPIRED, 1 ACTIVE
('SUB021', 'HID003', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB022', 'HID003', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB023', 'HID003', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB024', 'HID003', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00),

-- HID004: 2 ACTIVE, 2 EXPIRED
('SUB025', 'HID004', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB026', 'HID004', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB027', 'HID004', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB028', 'HID004', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID004: 3 EXPIRED, 1 ACTIVE
('SUB029', 'HID004', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB030', 'HID004', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB031', 'HID004', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB032', 'HID004', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00),

-- HID005: 2 ACTIVE, 2 EXPIRED
('SUB033', 'HID005', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB034', 'HID005', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB035', 'HID005', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB036', 'HID005', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID005: 3 EXPIRED, 1 ACTIVE
('SUB037', 'HID005', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB038', 'HID005', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB039', 'HID005', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB040', 'HID005', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00),

-- HID006: 2 ACTIVE, 2 EXPIRED
('SUB041', 'HID006', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 5000.00, 5000.00),
('SUB042', 'HID006', 'COV002', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 9000.00, 9000.00),
('SUB043', 'HID006', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB044', 'HID006', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 7000.00, 7000.00),

-- HID006: 3 EXPIRED, 1 ACTIVE
('SUB045', 'HID006', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB046', 'HID006', 'COV002', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 10000.00, 10000.00),
('SUB047', 'HID006', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 5000.00, 5000.00),
('SUB048', 'HID006', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 7000.00, 7000.00);

SELECT *
FROM subscribe
WHERE h_id = 'HID001'
  AND status = 'ACTIVE';


INSERT INTO subscribed_members (member_id, subscribe_id, full_name, age, gender, relation_with_proposer, aadhar_no) VALUES
('MEM001', 'SUB002', 'Suman Verma', 35, 'FEMALE', 'SPOUSE', 'AADH1001'),
('MEM002', 'SUB002', 'Ravi Verma', 7, 'MALE', 'SON', 'AADH1002'),

('MEM003', 'SUB006', 'Renu Verma', 34, 'FEMALE', 'SPOUSE', 'AADH1003'),
('MEM004', 'SUB006', 'Anjali Verma', 5, 'FEMALE', 'DAUGHTER', 'AADH1004'),

('MEM005', 'SUB010', 'Manoj Sharma', 40, 'MALE', 'HUSBAND', 'AADH1005'),
('MEM006', 'SUB010', 'Asha Sharma', 13, 'FEMALE', 'DAUGHTER', 'AADH1006'),

('MEM007', 'SUB014', 'Kiran Sharma', 38, 'FEMALE', 'WIFE', 'AADH1007'),
('MEM008', 'SUB014', 'Aman Sharma', 10, 'MALE', 'SON', 'AADH1008'),

('MEM009', 'SUB018', 'Neha Kumar', 31, 'FEMALE', 'SPOUSE', 'AADH1009'),
('MEM010', 'SUB018', 'Aryan Kumar', 6, 'MALE', 'SON', 'AADH1010'),
-- SUB022
('MEM011', 'SUB022', 'Pooja Reddy', 30, 'FEMALE', 'SPOUSE', 'AADH1011'),
('MEM012', 'SUB022', 'Tanvi Reddy', 4, 'FEMALE', 'DAUGHTER', 'AADH1012'),

-- SUB026
('MEM013', 'SUB026', 'Rakesh Patel', 42, 'MALE', 'HUSBAND', 'AADH1013'),
('MEM014', 'SUB026', 'Vikas Patel', 8, 'MALE', 'SON', 'AADH1014'),

-- SUB030
('MEM015', 'SUB030', 'Anjali Gupta', 33, 'FEMALE', 'WIFE', 'AADH1015'),
('MEM016', 'SUB030', 'Rahul Gupta', 6, 'MALE', 'SON', 'AADH1016'),

-- SUB034
('MEM017', 'SUB034', 'Deepa Singh', 29, 'FEMALE', 'WIFE', 'AADH1017'),
('MEM018', 'SUB034', 'Arnav Singh', 5, 'MALE', 'SON', 'AADH1018'),

-- SUB038
('MEM019', 'SUB038', 'Kusum Gupta', 36, 'FEMALE', 'SPOUSE', 'AADH1019'),
('MEM020', 'SUB038', 'Sneha Gupta', 9, 'FEMALE', 'DAUGHTER', 'AADH1020');



INSERT INTO medical_procedure (
    procedure_id, appointment_id, h_id, provider_id, doctor_id, procedure_date,
    diagnosis, treatment_plan, created_at, updated_at
) VALUES
('PROC001', 'APP001', 'HID001', 'PROV001', 'DOC001', '2025-06-15', 'Hypertension', 'Prescribed medication and follow-up in 2 weeks.', NOW(), NOW()),
('PROC002', 'APP002', 'HID001', 'PROV001', 'DOC002', '2025-06-20', 'Pregnancy checkup', 'Routine prenatal care.', NOW(), NOW()),
('PROC003', 'APP003', 'HID001', 'PROV001', 'DOC003', '2025-06-22', 'Toothache', 'Root canal performed.', NOW(), NOW()),
('PROC004', 'APP004', 'HID002', 'PROV001', 'DOC004', '2025-06-25', 'Child fever', 'Paracetamol + rest', NOW(), NOW()),
('PROC005', 'APP005', 'HID003', 'PROV001', 'DOC005', '2025-06-27', 'Knee pain', 'Physiotherapy suggested.', NOW(), NOW());


INSERT INTO Claims (
    claim_id, subscribe_id, procedure_id, provider_id, h_id, claim_status,
    claim_date, amount_claimed, amount_approved
) VALUES
('CLM001', 'SUB001', 'PROC001', 'PROV001', 'HID001', 'APPROVED', NOW(), 4000.00, 3500.00),
('CLM002', 'SUB001', 'PROC002', 'PROV001', 'HID001', 'DENIED', NOW(), 6000.00, 0.00),
('CLM003', 'SUB009', 'PROC003', 'PROV001', 'HID001', 'PENDING', NOW(), 5000.00, 0.00),
('CLM004', 'SUB010', 'PROC004', 'PROV001', 'HID002', 'APPROVED', NOW(), 3000.00, 2800.00),
('CLM005', 'SUB017', 'PROC005', 'PROV001', 'HID003', 'APPROVED', NOW(), 7000.00, 6800.00),
('CLM006', 'SUB002', 'PROC002', 'PROV001', 'HID001', 'APPROVED', NOW(), 5000.00, 4900.00),
('CLM007', 'SUB003', 'PROC003', 'PROV001', 'HID001', 'DENIED', NOW(), 6000.00, 0.00),
('CLM008', 'SUB004', 'PROC004', 'PROV001', 'HID001', 'APPROVED', NOW(), 4200.00, 4000.00),
('CLM009', 'SUB005', 'PROC005', 'PROV001', 'HID001', 'APPROVED', NOW(), 3500.00, 3300.00),
('CLM010', 'SUB006', 'PROC001', 'PROV001', 'HID001', 'PENDING', NOW(), 4500.00, 0.00),
('CLM011', 'SUB007', 'PROC002', 'PROV001', 'HID001', 'APPROVED', NOW(), 3700.00, 3600.00),
('CLM012', 'SUB008', 'PROC003', 'PROV001', 'HID001', 'APPROVED', NOW(), 3900.00, 3850.00),
('CLM013', 'SUB011', 'PROC004', 'PROV001', 'HID002', 'APPROVED', NOW(), 4700.00, 4700.00),
('CLM014', 'SUB012', 'PROC005', 'PROV001', 'HID002', 'DENIED', NOW(), 5200.00, 0.00),
('CLM015', 'SUB013', 'PROC001', 'PROV001', 'HID002', 'APPROVED', NOW(), 6000.00, 5900.00),
('CLM016', 'SUB014', 'PROC002', 'PROV001', 'HID002', 'PENDING', NOW(), 3300.00, 0.00),
('CLM017', 'SUB015', 'PROC003', 'PROV001', 'HID002', 'APPROVED', NOW(), 3500.00, 3400.00),
('CLM018', 'SUB016', 'PROC004', 'PROV001', 'HID002', 'APPROVED', NOW(), 3600.00, 3500.00),
('CLM019', 'SUB018', 'PROC005', 'PROV001', 'HID003', 'APPROVED', NOW(), 3900.00, 3900.00),
('CLM020', 'SUB019', 'PROC001', 'PROV001', 'HID003', 'PENDING', NOW(), 4100.00, 0.00),
('CLM021', 'SUB020', 'PROC002', 'PROV001', 'HID003', 'APPROVED', NOW(), 4700.00, 4700.00),
('CLM022', 'SUB031', 'PROC003', 'PROV001', 'HID005', 'APPROVED', NOW(), 5200.00, 5000.00),
('CLM023', 'SUB031', 'PROC004', 'PROV001', 'HID005', 'DENIED', NOW(), 4100.00, 0.00),
('CLM024', 'SUB032', 'PROC005', 'PROV001', 'HID005', 'PENDING', NOW(), 4500.00, 0.00),
('CLM025', 'SUB032', 'PROC001', 'PROV001', 'HID005', 'APPROVED', NOW(), 6000.00, 5900.00),
('CLM026', 'SUB033', 'PROC002', 'PROV001', 'HID005', 'APPROVED', NOW(), 5500.00, 5300.00),
('CLM027', 'SUB033', 'PROC003', 'PROV001', 'HID005', 'APPROVED', NOW(), 4700.00, 4700.00),
('CLM028', 'SUB034', 'PROC004', 'PROV001', 'HID005', 'PENDING', NOW(), 3000.00, 0.00),
('CLM029', 'SUB034', 'PROC005', 'PROV001', 'HID005', 'APPROVED', NOW(), 6500.00, 6400.00),
('CLM030', 'SUB035', 'PROC001', 'PROV001', 'HID005', 'DENIED', NOW(), 3200.00, 0.00),
('CLM031', 'SUB035', 'PROC002', 'PROV001', 'HID005', 'APPROVED', NOW(), 4700.00, 4500.00),
('CLM032', 'SUB036', 'PROC003', 'PROV001', 'HID005', 'APPROVED', NOW(), 5100.00, 5100.00),
('CLM033', 'SUB036', 'PROC004', 'PROV001', 'HID005', 'APPROVED', NOW(), 4300.00, 4200.00),
('CLM034', 'SUB037', 'PROC005', 'PROV001', 'HID005', 'PENDING', NOW(), 3800.00, 0.00),
('CLM035', 'SUB037', 'PROC001', 'PROV001', 'HID005', 'APPROVED', NOW(), 5000.00, 4900.00),
('CLM036', 'SUB038', 'PROC002', 'PROV001', 'HID005', 'APPROVED', NOW(), 5900.00, 5800.00),
('CLM037', 'SUB038', 'PROC003', 'PROV001', 'HID005', 'APPROVED', NOW(), 3600.00, 3600.00),
('CLM038', 'SUB039', 'PROC004', 'PROV001', 'HID005', 'DENIED', NOW(), 6200.00, 0.00),
('CLM039', 'SUB039', 'PROC005', 'PROV001', 'HID005', 'APPROVED', NOW(), 6400.00, 6400.00),
('CLM040', 'SUB040', 'PROC001', 'PROV001', 'HID005', 'APPROVED', NOW(), 4900.00, 4700.00),
('CLM041', 'SUB040', 'PROC002', 'PROV001', 'HID005', 'PENDING', NOW(), 5200.00, 0.00);
