-- Create the database
DROP DATABASE IF EXISTS healthsure1;
CREATE DATABASE IF NOT EXISTS healthsure1;
USE healthsure1;

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
    plan_type ENUM('INDIVIDUAL', 'FAMILY', 'SENIOR', 'TOTALSHIELD'),
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
    type ENUM('INDIVIDUAL', 'FAMILY', 'SENIOR', 'TOTALSHIELD'),
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
    subscribe_id VARCHAR(50) NOT NULL,
    procedure_id VARCHAR(20),
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

---
## Data Insertion
---

INSERT INTO Insurance_company VALUES
('IC001', 'MediCare Ltd.', 'https://logo.medicare.com', 'Pune', 'support@medicare.com', '020-12345678');

INSERT INTO Providers VALUES
('PROV001', 'Adani', 'HealthSure Medica Inc.', 'admin@citycare.com', 'Station Road', 'Pune', 'MH', '411001', 'APPROVED');

INSERT INTO Insurance_plan (
    plan_id, company_id, plan_name, plan_type, min_entry_age, max_entry_age,
    description, available_cover_amounts, waiting_period,
    created_on, expire_date, periodic_diseases
) VALUES
('PLAN001', 'IC001', 'Health plus basic', 'INDIVIDUAL', 18, 60, 'Basic individual coverage plan', '100000,200000', '30 days', '2025-06-01', '2099-12-31', 'NO'),
('PLAN002', 'IC001', 'Family care shield', 'FAMILY', 18, 65, 'Family floater plan', '300000,500000', '45 days', '2025-06-01', '2099-12-31', 'NO'),
('PLAN003', 'IC001', 'Super health elite', 'FAMILY', 18, 70, 'Premium family coverage with extensive benefits', '750000,1500000', '15 days', '2025-06-01', '2099-12-31', 'YES'),
('PLAN004', 'IC001', 'Senior secure', 'SENIOR', 60, 90, 'Dedicated plan for senior citizens', '200000,400000', '90 days', '2025-06-01', '2099-12-31', 'YES'),
('PLAN005', 'IC001', '360 Premium Shield', 'TOTALSHIELD', 1, 99, 'All-inclusive comprehensive plan for all ages and medical needs', '5000000,10000000', '0 days', '2025-06-01', '2099-12-31', 'YES');


ALTER TABLE Insurance_coverage_option
MODIFY COLUMN coverage_amount DECIMAL(12, 2);
INSERT INTO Insurance_coverage_option (
    coverage_id, plan_id, premium_amount, coverage_amount, status
) VALUES
('COV001', 'PLAN001', 3500.00, 100000.00, 'ACTIVE'), -- Health plus basic (INDIVIDUAL)
('COV002', 'PLAN001', 5500.00, 200000.00, 'ACTIVE'),

('COV003', 'PLAN002', 8000.00, 300000.00, 'ACTIVE'), -- Family care shield (FAMILY)
('COV004', 'PLAN002', 12000.00, 500000.00, 'ACTIVE'),

('COV005', 'PLAN003', 20000.00, 750000.00, 'ACTIVE'), -- Super health elite (FAMILY, increased amount)
('COV006', 'PLAN003', 35000.00, 1500000.00, 'ACTIVE'),

('COV007', 'PLAN004', 10000.00, 200000.00, 'ACTIVE'), -- Senior secure (SENIOR)
('COV008', 'PLAN004', 18000.00, 400000.00, 'ACTIVE'),

('COV009', 'PLAN005', 50000.00, 5000000.00, 'ACTIVE'), -- 360 Premium Shield (TOTALSHIELD)
('COV010', 'PLAN005', 80000.00, 10000000.00, 'ACTIVE');


-- Dummy Data for 10 Recipients
INSERT INTO Recipient (
    h_id, first_name, last_name, mobile, user_name,
    gender, dob, address, created_at, password,
    email, status
) VALUES
('HID001', 'Amit', 'Verma', '9876543210', 'amitv', 'MALE', '1990-01-15', 'Delhi', NOW(), 'pass123!', 'amit@example.com', 'ACTIVE'),
('HID002', 'Priya', 'Sharma', '9876543211', 'priyas', 'FEMALE', '1985-05-20', 'Mumbai', NOW(), 'priyaPW!', 'priya@example.com', 'ACTIVE'),
('HID003', 'Rajesh', 'Kumar', '9876543212', 'rajeshk', 'MALE', '1970-11-01', 'Bangalore', NOW(), 'rajeshPW!', 'rajesh@example.com', 'ACTIVE'),
('HID004', 'Sneha', 'Gupta', '9876543213', 'snehag', 'FEMALE', '1992-03-08', 'Hyderabad', NOW(), 'snehaPW!', 'sneha@example.com', 'ACTIVE'),
('HID005', 'Vivek', 'Reddy', '9876543214', 'vivekr', 'MALE', '1980-07-25', 'Chennai', NOW(), 'vivekPW!', 'vivek@example.com', 'ACTIVE'),
('HID006', 'Nisha', 'Malhotra', '9876543215', 'nisham', 'FEMALE', '1968-09-12', 'Kolkata', NOW(), 'nishaPW!', 'nisha@example.com', 'ACTIVE'),
('HID007', 'Arjun', 'Singh', '9876543216', 'arjuns', 'MALE', '1995-02-18', 'Pune', NOW(), 'arjunPW!', 'arjun@example.com', 'ACTIVE'),
('HID008', 'Pooja', 'Das', '9876543217', 'poojad', 'FEMALE', '1975-04-03', 'Ahmedabad', NOW(), 'poojaPW!', 'pooja@example.com', 'ACTIVE'),
('HID009', 'Kunal', 'Jain', '9876543218', 'kunalj', 'MALE', '1988-12-30', 'Jaipur', NOW(), 'kunalPW!', 'kunal@example.com', 'ACTIVE'),
('HID010', 'Rina', 'Patel', '9876543219', 'rinap', 'FEMALE', '1960-06-05', 'Surat', NOW(), 'rinaPW!', 'rina@example.com', 'ACTIVE');


INSERT INTO Doctors (
    doctor_id, provider_id, doctor_name, qualification, specialization,
    license_no, email, address, gender, type, doctor_status
) VALUES
('DOC001', 'PROV001', 'Dr. Manav Malhotra', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11234', 'manav.malhotra@clinic.com', '464 Gynecology Street, Nagpur', 'MALE', 'STANDARD', 'INACTIVE'),
('DOC002', 'PROV001', 'Dr. Alok Mehra', 'MBBS, MD', 'Gynecology', 'LIC-GYNEC-11236', 'alok.mehra@clinic.com', '439 Gynecology Street, Bhopal', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC003', 'PROV001', 'Dr. Preeti Singh', 'MBBS, DM', 'Gynecology', 'LIC-GYNEC-11243', 'preeti.singh@clinic.com', '621 Gynecology Street, Jaipur', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC004', 'PROV001', 'Dr. Divya Jain', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11259', 'divya.jain@clinic.com', '741 Gynecology Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC005', 'PROV001', 'Dr. Yash Malhotra', 'MBBS, DNB', 'Gynecology', 'LIC-GYNEC-11272', 'yash.malhotra@clinic.com', '614 Gynecology Street, Kochi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC006', 'PROV001', 'Dr. Mitali Kapoor', 'MBBS, MD', 'Gynecology', 'LIC-GYNEC-11277', 'mitali.kapoor@clinic.com', '285 Gynecology Street, Chennai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC007', 'PROV001', 'Dr. Meena Iyer', 'MBBS, DM', 'Orthopedics', 'LIC-ORTHO-11235', 'meena.iyer@clinic.com', '812 Orthopedics Street, Kochi', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC008', 'PROV001', 'Dr. Arjun Ghosh', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11262', 'arjun.ghosh@clinic.com', '682 Orthopedics Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC009', 'PROV001', 'Dr. Isha Sinha', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11265', 'isha.sinha@clinic.com', '894 Orthopedics Street, Pune', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC010', 'PROV001', 'Dr. Anuja Singh', 'MBBS, MS', 'Orthopedics', 'LIC-ORTHO-11269', 'anuja.singh@clinic.com', '921 Orthopedics Street, Nagpur', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC011', 'PROV001', 'Dr. Ritu Arora', 'MBBS, MD', 'Orthopedics', 'LIC-ORTHO-11273', 'ritu.arora@clinic.com', '348 Orthopedics Street, Bhopal', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC012', 'PROV001', 'Dr. Shreya Sethi', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11241', 'shreya.sethi@clinic.com', '699 Pediatrics Street, Chennai', 'FEMALE', 'ADHOC', 'ACTIVE'),
('DOC013', 'PROV001', 'Dr. Nilesh Bhatia', 'MBBS, MD', 'Pediatrics', 'LIC-PEDIA-11242', 'nilesh.bhatia@clinic.com', '453 Pediatrics Street, Kochi', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC014', 'PROV001', 'Dr. Neha Arora', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11251', 'neha.arora@clinic.com', '522 Pediatrics Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC015', 'PROV001', 'Dr. Anjali Menon', 'MBBS, DNB', 'Pediatrics', 'LIC-PEDIA-11267', 'anjali.menon@clinic.com', '625 Pediatrics Street, Hyderabad', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC016', 'PROV001', 'Dr. Ishita Sharma', 'MBBS, DCH', 'Pediatrics', 'LIC-PEDIA-11275', 'ishita.sharma@clinic.com', '154 Pediatrics Street, Bengaluru', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC017', 'PROV001', 'Dr. Swati Bose', 'MBBS, DNB', 'Cardiology', 'LIC-CARDI-11245', 'swati.bose@clinic.com', '498 Cardiology Street, Pune', 'FEMALE', 'ADHOC', 'INACTIVE'),
('DOC018', 'PROV001', 'Dr. Vivek Mehra', 'MBBS, MD', 'Cardiology', 'LIC-CARDI-11250', 'vivek.mehra@clinic.com', '802 Cardiology Street, Delhi', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC019', 'PROV001', 'Dr. Zeeshan Rao', 'MBBS, DM', 'Cardiology', 'LIC-CARDI-11252', 'zeeshan.rao@clinic.com', '311 Cardiology Street, Bengaluru', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC020', 'PROV001', 'Dr. Mitali Iyer', 'MBBS, DM', 'Cardiology', 'LIC-CARDI-11257', 'mitali.iyer@clinic.com', '401 Cardiology Street, Hyderabad', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC021', 'PROV001', 'Dr. Tanmay Pillai', 'MBBS, MS', 'Cardiology', 'LIC-CARDI-11276', 'tanmay.pillai@clinic.com', '489 Cardiology Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC022', 'PROV001', 'Dr. Vikas Rathi', 'MBBS, DNB', 'Cardiology', 'LIC-CARDI-11278', 'vikas.rathi@clinic.com', '706 Cardiology Street, Kochi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC023', 'PROV001', 'Dr. Sakshi Verma', 'MBBS, MS', 'Cardiology', 'LIC-CARDI-11283', 'sakshi.verma@clinic.com', '994 Cardiology Street, Pune', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC024', 'PROV001', 'Dr. Pooja Thakur', 'MBBS, DM', 'Neurology', 'LIC-NEURO-11239', 'pooja.thakur@clinic.com', '581 Neurology Street, Bengaluru', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC025', 'PROV001', 'Dr. Roshni Kapoor', 'MBBS, MCh', 'Neurology', 'LIC-NEURO-11249', 'roshni.kapoor@clinic.com', '126 Neurology Street, Kochi', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC026', 'PROV001', 'Dr. Gaurav Malhotra', 'MBBS, MD', 'Neurology', 'LIC-NEURO-11268', 'gaurav.malhotra@clinic.com', '342 Neurology Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC027', 'PROV001', 'Dr. Preeti Rao', 'MBBS, MS', 'Neurology', 'LIC-NEURO-11279', 'preeti.rao@clinic.com', '263 Neurology Street, Bengaluru', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC028', 'PROV001', 'Dr. Kunal Das', 'MBBS, MS', 'Psychiatry', 'LIC-PSYCH-11238', 'kunal.das@clinic.com', '305 Psychiatry Street, Chennai', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC029', 'PROV001', 'Dr. Shalini Kapoor', 'MBBS, DM', 'Psychiatry', 'LIC-PSYCH-11255', 'shalini.kapoor@clinic.com', '279 Psychiatry Street, Pune', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC030', 'PROV001', 'Dr. Mohit Deshmukh', 'MBBS, MS', 'Psychiatry', 'LIC-PSYCH-11258', 'mohit.deshmukh@clinic.com', '565 Psychiatry Street, Bengaluru', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC031', 'PROV001', 'Dr. Raghav Deshmukh', 'MBBS, MD', 'Psychiatry', 'LIC-PSYCH-11280', 'raghav.deshmukh@clinic.com', '881 Psychiatry Street, Hyderabad', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC032', 'PROV001', 'Dr. Ravi Roy', 'MBBS, DNB', 'Oncology', 'LIC-ONCOL-11240', 'ravi.roy@clinic.com', '461 Oncology Street, Delhi', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC033', 'PROV001', 'Dr. Sneha Singh', 'MBBS, MS', 'Oncology', 'LIC-ONCOL-11247', 'sneha.singh@clinic.com', '978 Oncology Street, Hyderabad', 'FEMALE', 'ADHOC', 'INACTIVE'),
('DOC034', 'PROV001', 'Dr. Chirag Bose', 'MBBS, MCh', 'Oncology', 'LIC-ONCOL-11266', 'chirag.bose@clinic.com', '231 Oncology Street, Chennai', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC035', 'PROV001', 'Dr. Chirag Menon', 'MBBS, MD', 'Oncology', 'LIC-ONCOL-11282', 'chirag.menon@clinic.com', '456 Oncology Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC036', 'PROV001', 'Dr. Nikhil Thakur', 'MBBS, DM', 'Dermatology', 'LIC-DERMA-11246', 'nikhil.thakur@clinic.com', '215 Dermatology Street, Bhopal', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC037', 'PROV001', 'Dr. Sakshi Thakur', 'MBBS, MD', 'Dermatology', 'LIC-DERMA-11261', 'sakshi.thakur@clinic.com', '912 Dermatology Street, Delhi', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC038', 'PROV001', 'Dr. Vandana Pillai', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11263', 'vandana.pillai@clinic.com', '710 Dermatology Street, Kochi', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC039', 'PROV001', 'Dr. Sneha Bose', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11271', 'sneha.bose@clinic.com', '827 Dermatology Street, Mumbai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC040', 'PROV001', 'Dr. Abhinav Mehra', 'MBBS, MS', 'Dermatology', 'LIC-DERMA-11274', 'abhinav.mehra@clinic.com', '502 Dermatology Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC041', 'PROV001', 'Dr. Rajiv Ghosh', 'MBBS, DCH', 'General Surgery', 'LIC-GENER-11248', 'rajiv.ghosh@clinic.com', '640 General Street, Jaipur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC042', 'PROV001', 'Dr. Rohan Nair', 'MBBS, MS', 'General Surgery', 'LIC-GENER-11256', 'rohan.nair@clinic.com', '318 General Street, Nagpur', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC043', 'PROV001', 'Dr. Rajiv Nair', 'MBBS, MD', 'General Surgery', 'LIC-GENER-11270', 'rajiv.nair@clinic.com', '319 General Street, Pune', 'MALE', 'ADHOC', 'ACTIVE'),
('DOC044', 'PROV001', 'Dr. Kavya Roy', 'MBBS, MD', 'ENT', 'LIC-ENT--11253', 'kavya.roy@clinic.com', '154 ENT Street, Chennai', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC045', 'PROV001', 'Dr. Abhishek Singh', 'MBBS, DNB', 'ENT', 'LIC-ENT--11254', 'abhishek.singh@clinic.com', '614 ENT Street, Bhopal', 'MALE', 'ADHOC', 'INACTIVE'),
('DOC046', 'PROV001', 'Dr. Nitin Bansal', 'MBBS, DNB', 'ENT', 'LIC-ENT--11264', 'nitin.bansal@clinic.com', '184 ENT Street, Delhi', 'MALE', 'STANDARD', 'ACTIVE'),
('DOC047', 'PROV001', 'Dr. Isha Suresh', 'MBBS, DNB', 'ENT', 'LIC-ENT--11281', 'isha.suresh@clinic.com', '338 ENT Street, Bhopal', 'FEMALE', 'STANDARD', 'ACTIVE'),
('DOC048', 'PROV001', 'Dr. Tara Malhotra', 'MBBS, DNB', 'Urology', 'LIC-UROLO-11237', 'tara.malhotra@clinic.com', '543 Urology Street, Mumbai', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC049', 'PROV001', 'Dr. Aman Sign', 'MBBS, DNB', 'psychiatrist', 'LIC-UROLO-11238', 'amansingh@clinic.com', '879 Street, Pune', 'FEMALE', 'STANDARD', 'INACTIVE'),
('DOC050', 'PROV001', 'Dr. Prabhu Prasad', 'MBBS, DNB', 'Medicine Specialist', 'LIC-UROLO-11239', 'prabhuprasad@clinic.com', '444 Urology Street, Roulkela', 'MALE', 'STANDARD', 'ACTIVE');



INSERT INTO subscribe (subscribe_id, h_id, coverage_id, subscribe_date, expiry_date, type, status, total_premium, amount_paid) VALUES
-- Data based on PLAN001 (Health plus basic - INDIVIDUAL / SELF)
-- Using COV001 (3500.00, 100000.00) and COV002 (5500.00, 200000.00)
('SUB001', 'HID001', 'COV001', '2024-07-01', '2025-06-30', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB002', 'HID002', 'COV002', '2024-06-15', '2025-06-14', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB003', 'HID003', 'COV001', '2023-08-01', '2024-07-31', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB004', 'HID004', 'COV002', '2022-09-01', '2023-08-31', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB005', 'HID005', 'COV001', '2024-07-10', '2025-07-09', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB006', 'HID006', 'COV002', '2024-05-20', '2025-05-19', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB007', 'HID007', 'COV001', '2023-03-01', '2024-02-29', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB008', 'HID008', 'COV002', '2022-04-01', '2023-03-31', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB009', 'HID009', 'COV001', '2024-06-01', '2025-05-31', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB010', 'HID010', 'COV002', '2024-07-05', '2025-07-04', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),

-- Data based on PLAN002 (Family care shield - FAMILY)
-- Using COV003 (8000.00, 300000.00) and COV004 (12000.00, 500000.00)
('SUB011', 'HID001', 'COV003', '2024-07-01', '2025-06-30', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB012', 'HID002', 'COV004', '2024-06-15', '2025-06-14', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB013', 'HID003', 'COV003', '2023-08-01', '2024-07-31', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB014', 'HID004', 'COV004', '2022-09-01', '2023-08-31', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB015', 'HID005', 'COV003', '2024-07-10', '2025-07-09', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB016', 'HID006', 'COV004', '2024-05-20', '2025-05-19', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB017', 'HID007', 'COV003', '2023-03-01', '2024-02-29', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB018', 'HID008', 'COV004', '2022-04-01', '2023-03-31', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB019', 'HID009', 'COV003', '2024-06-01', '2025-05-31', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB020', 'HID010', 'COV004', '2024-07-05', '2025-07-04', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),

-- Data based on PLAN003 (Super health elite - INDIVIDUAL / SELF)
-- Using COV005 (15000.00, 500000.00) and COV006 (25000.00, 1000000.00)
('SUB021', 'HID001', 'COV005', '2024-07-01', '2025-06-30', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB022', 'HID002', 'COV006', '2024-06-15', '2025-06-14', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),
('SUB023', 'HID003', 'COV005', '2023-08-01', '2024-07-31', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB024', 'HID004', 'COV006', '2022-09-01', '2023-08-31', 'INDIVIDUAL', 'EXPIRED', 25000.00, 25000.00),
('SUB025', 'HID005', 'COV005', '2024-07-10', '2025-07-09', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB026', 'HID006', 'COV006', '2024-05-20', '2025-05-19', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),
('SUB027', 'HID007', 'COV005', '2023-03-01', '2024-02-29', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB028', 'HID008', 'COV006', '2022-04-01', '2023-03-31', 'INDIVIDUAL', 'EXPIRED', 25000.00, 25000.00),
('SUB029', 'HID009', 'COV005', '2024-06-01', '2025-05-31', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB030', 'HID010', 'COV006', '2024-07-05', '2025-07-04', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),

-- Data based on PLAN004 (Senior secure - SENIOR)
-- Using COV007 (10000.00, 200000.00) and COV008 (18000.00, 400000.00)
('SUB031', 'HID001', 'COV007', '2024-07-01', '2025-06-30', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB032', 'HID002', 'COV008', '2024-06-15', '2025-06-14', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB033', 'HID003', 'COV007', '2023-08-01', '2024-07-31', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB034', 'HID004', 'COV008', '2022-09-01', '2023-08-31', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB035', 'HID005', 'COV007', '2024-07-10', '2025-07-09', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB036', 'HID006', 'COV008', '2024-05-20', '2025-05-19', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB037', 'HID007', 'COV007', '2023-03-01', '2024-02-29', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB038', 'HID008', 'COV008', '2022-04-01', '2023-03-31', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB039', 'HID009', 'COV007', '2024-06-01', '2025-05-31', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB040', 'HID010', 'COV008', '2024-07-05', '2025-07-04', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),

-- Data based on PLAN005 (Critical cover plan - TOTALSHIELD / CRITICAL_ILLNESS)
-- Using COV009 (20000.00, 1000000.00) and COV010 (35000.00, 2000000.00)
('SUB041', 'HID001', 'COV009', '2024-07-01', '2025-06-30', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB042', 'HID002', 'COV010', '2024-06-15', '2025-06-14', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB043', 'HID003', 'COV009', '2023-08-01', '2024-07-31', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB044', 'HID004', 'COV010', '2022-09-01', '2023-08-31', 'TOTALSHIELD', 'EXPIRED', 35000.00, 35000.00),
('SUB045', 'HID005', 'COV009', '2024-07-10', '2025-07-09', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB046', 'HID006', 'COV010', '2024-05-20', '2025-05-19', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB047', 'HID007', 'COV009', '2023-03-01', '2024-02-29', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB048', 'HID008', 'COV010', '2022-04-01', '2023-03-31', 'TOTALSHIELD', 'EXPIRED', 35000.00, 35000.00),
('SUB049', 'HID009', 'COV009', '2024-06-01', '2025-05-31', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB050', 'HID010', 'COV010', '2024-07-05', '2025-07-04', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),

-- Remaining subscriptions for various HIDs, mixing types and statuses
('SUB051', 'HID001', 'COV001', '2024-08-01', '2025-07-31', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB052', 'HID002', 'COV003', '2024-09-01', '2025-08-31', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB053', 'HID003', 'COV005', '2024-10-01', '2025-09-30', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB054', 'HID004', 'COV007', '2024-11-01', '2025-10-31', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB055', 'HID005', 'COV009', '2024-12-01', '2025-11-30', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB056', 'HID006', 'COV002', '2023-01-01', '2023-12-31', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB057', 'HID007', 'COV004', '2023-02-01', '2024-01-31', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB058', 'HID008', 'COV006', '2023-03-01', '2024-02-29', 'INDIVIDUAL', 'EXPIRED', 25000.00, 25000.00),
('SUB059', 'HID009', 'COV008', '2023-04-01', '2024-03-31', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB060', 'HID010', 'COV010', '2023-05-01', '2024-04-30', 'TOTALSHIELD', 'EXPIRED', 35000.00, 35000.00),
('SUB061', 'HID001', 'COV003', '2024-01-15', '2025-01-14', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB062', 'HID002', 'COV005', '2024-02-20', '2025-02-19', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB063', 'HID003', 'COV007', '2024-03-25', '2025-03-24', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB064', 'HID004', 'COV009', '2024-04-10', '2025-04-09', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB065', 'HID005', 'COV001', '2023-06-01', '2024-05-31', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB066', 'HID006', 'COV003', '2023-07-01', '2024-06-30', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB067', 'HID007', 'COV005', '2023-08-01', '2024-07-31', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB068', 'HID008', 'COV007', '2023-09-01', '2024-08-31', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB069', 'HID009', 'COV009', '2023-10-01', '2024-09-30', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB070', 'HID010', 'COV002', '2024-01-01', '2024-12-31', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB071', 'HID001', 'COV004', '2024-02-01', '2025-01-31', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB072', 'HID002', 'COV006', '2024-03-01', '2025-02-28', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),
('SUB073', 'HID003', 'COV008', '2024-04-01', '2025-03-31', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB074', 'HID004', 'COV010', '2024-05-01', '2025-04-30', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB075', 'HID005', 'COV001', '2023-11-01', '2024-10-31', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB076', 'HID006', 'COV003', '2023-12-01', '2024-11-30', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB077', 'HID007', 'COV005', '2024-01-01', '2024-12-31', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB078', 'HID008', 'COV007', '2024-02-01', '2025-01-31', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB079', 'HID009', 'COV009', '2024-03-01', '2025-02-28', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB080', 'HID010', 'COV002', '2024-04-01', '2025-03-31', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB081', 'HID001', 'COV004', '2024-05-01', '2025-04-30', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB082', 'HID002', 'COV006', '2024-06-01', '2025-05-31', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),
('SUB083', 'HID003', 'COV008', '2024-07-01', '2025-06-30', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB084', 'HID004', 'COV010', '2024-08-01', '2025-07-31', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB085', 'HID005', 'COV001', '2023-01-01', '2023-12-31', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB086', 'HID006', 'COV003', '2023-02-01', '2024-01-31', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB087', 'HID007', 'COV005', '2023-03-01', '2024-02-29', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB088', 'HID008', 'COV007', '2023-04-01', '2024-03-31', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB089', 'HID009', 'COV009', '2023-05-01', '2024-04-30', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB090', 'HID010', 'COV010', '2024-09-01', '2025-08-31', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB091', 'HID001', 'COV001', '2024-10-01', '2025-09-30', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB092', 'HID002', 'COV003', '2024-11-01', '2025-10-31', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB093', 'HID003', 'COV005', '2024-12-01', '2025-11-30', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB094', 'HID004', 'COV007', '2025-01-01', '2025-12-31', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB095', 'HID005', 'COV009', '2025-02-01', '2026-01-31', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB096', 'HID006', 'COV002', '2023-06-01', '2024-05-31', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB097', 'HID007', 'COV004', '2023-07-01', '2024-06-30', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB098', 'HID008', 'COV006', '2023-08-01', '2024-07-31', 'INDIVIDUAL', 'EXPIRED', 25000.00, 25000.00),
('SUB099', 'HID009', 'COV008', '2023-09-01', '2024-08-31', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB100', 'HID010', 'COV010', '2023-10-01', '2024-09-30', 'TOTALSHIELD', 'EXPIRED', 35000.00, 35000.00),
('SUB101', 'HID001', 'COV005', '2024-07-15', '2025-07-14', 'INDIVIDUAL', 'ACTIVE', 15000.00, 15000.00),
('SUB102', 'HID002', 'COV007', '2024-08-10', '2025-08-09', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB103', 'HID003', 'COV009', '2024-09-05', '2025-09-04', 'TOTALSHIELD', 'ACTIVE', 20000.00, 20000.00),
('SUB104', 'HID004', 'COV001', '2024-10-20', '2025-10-19', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB105', 'HID005', 'COV003', '2024-11-25', '2025-11-24', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB106', 'HID006', 'COV005', '2023-01-10', '2024-01-09', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB107', 'HID007', 'COV007', '2023-02-15', '2024-02-14', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB108', 'HID008', 'COV009', '2023-03-20', '2024-03-19', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB109', 'HID009', 'COV002', '2023-04-25', '2024-04-24', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB110', 'HID010', 'COV004', '2023-05-30', '2024-05-29', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB111', 'HID001', 'COV006', '2024-12-05', '2025-12-04', 'INDIVIDUAL', 'ACTIVE', 25000.00, 25000.00),
('SUB112', 'HID002', 'COV008', '2025-01-01', '2025-12-31', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB113', 'HID003', 'COV010', '2025-02-01', '2026-01-31', 'TOTALSHIELD', 'ACTIVE', 35000.00, 35000.00),
('SUB114', 'HID004', 'COV001', '2025-03-01', '2026-02-28', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB115', 'HID005', 'COV003', '2025-04-01', '2026-03-31', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB116', 'HID006', 'COV005', '2023-06-05', '2024-06-04', 'INDIVIDUAL', 'EXPIRED', 15000.00, 15000.00),
('SUB117', 'HID007', 'COV007', '2023-07-10', '2024-07-09', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB118', 'HID008', 'COV009', '2023-08-15', '2024-08-14', 'TOTALSHIELD', 'EXPIRED', 20000.00, 20000.00),
('SUB119', 'HID009', 'COV002', '2023-09-20', '2024-09-19', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB120', 'HID010', 'COV004', '2023-10-25', '2024-10-24', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB121', 'HID001', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB122', 'HID002', 'COV002', '2024-06-01', '2025-06-01', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB123', 'HID003', 'COV001', '2023-07-03', '2024-07-03', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB124', 'HID004', 'COV002', '2022-07-03', '2023-07-03', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB125', 'HID005', 'COV001', '2021-07-03', '2022-07-03', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB126', 'HID006', 'COV002', '2020-07-03', '2021-07-03', 'INDIVIDUAL', 'EXPIRED', 5500.00, 5500.00),
('SUB127', 'HID007', 'COV001', '2019-07-03', '2020-07-03', 'INDIVIDUAL', 'EXPIRED', 3500.00, 3500.00),
('SUB128', 'HID008', 'COV002', '2018-07-03', '2019-07-03', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB129', 'HID009', 'COV001', '2024-07-03', '2025-07-03', 'INDIVIDUAL', 'ACTIVE', 3500.00, 3500.00),
('SUB130', 'HID010', 'COV002', '2024-06-01', '2025-06-01', 'INDIVIDUAL', 'ACTIVE', 5500.00, 5500.00),
('SUB131', 'HID001', 'COV003', '2024-07-03', '2025-07-03', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB132', 'HID002', 'COV004', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB133', 'HID003', 'COV003', '2023-07-03', '2024-07-03', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB134', 'HID004', 'COV004', '2022-07-03', '2023-07-03', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB135', 'HID005', 'COV003', '2021-07-03', '2022-07-03', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB136', 'HID006', 'COV004', '2020-07-03', '2021-07-03', 'FAMILY', 'EXPIRED', 12000.00, 12000.00),
('SUB137', 'HID007', 'COV003', '2019-07-03', '2020-07-03', 'FAMILY', 'EXPIRED', 8000.00, 8000.00),
('SUB138', 'HID008', 'COV004', '2018-07-03', '2019-07-03', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB139', 'HID009', 'COV003', '2024-07-03', '2025-07-03', 'FAMILY', 'ACTIVE', 8000.00, 8000.00),
('SUB140', 'HID010', 'COV004', '2024-06-01', '2025-06-01', 'FAMILY', 'ACTIVE', 12000.00, 12000.00),
('SUB141', 'HID001', 'COV007', '2024-07-03', '2025-07-03', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB142', 'HID002', 'COV008', '2024-06-01', '2025-06-01', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB143', 'HID003', 'COV007', '2023-07-03', '2024-07-03', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB144', 'HID004', 'COV008', '2022-07-03', '2023-07-03', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB145', 'HID005', 'COV007', '2021-07-03', '2022-07-03', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB146', 'HID006', 'COV008', '2020-07-03', '2021-07-03', 'SENIOR', 'EXPIRED', 18000.00, 18000.00),
('SUB147', 'HID007', 'COV007', '2019-07-03', '2020-07-03', 'SENIOR', 'EXPIRED', 10000.00, 10000.00),
('SUB148', 'HID008', 'COV008', '2018-07-03', '2019-07-03', 'SENIOR', 'ACTIVE', 18000.00, 18000.00),
('SUB149', 'HID009', 'COV007', '2024-07-03', '2025-07-03', 'SENIOR', 'ACTIVE', 10000.00, 10000.00),
('SUB150', 'HID010', 'COV008', '2024-06-01', '2025-06-01', 'SENIOR', 'ACTIVE', 18000.00, 18000.00);
SELECT
    h_id,
    COUNT(subscribe_id) AS total_subscriptions
FROM
    subscribe
GROUP BY
    h_id
ORDER BY
    h_id;



INSERT INTO subscribed_members (member_id, subscribe_id, full_name, age, gender, relation_with_proposer, aadhar_no) VALUES
-- HID001 (Amit Verma) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM001', 'SUB001', 'Amit Verma', 35, 'MALE', 'SELF', 'AADH_H01_S01'),
('MEM002', 'SUB001', 'Priya Verma', 30, 'FEMALE', 'SPOUSE', 'AADH_H01_F01'),
('MEM003', 'SUB001', 'Rohan Verma', 5, 'MALE', 'SON', 'AADH_H01_F02'),

-- FATHER (Senior Plan)
('MEM004', 'SUB002', 'Rajesh Verma', 65, 'MALE', 'FATHER', 'AADH_H01_S02'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM005', 'SUB003', 'Amit Verma', 35, 'MALE', 'SELF', 'AADH_H01_T01'),
('MEM006', 'SUB003', 'Priya Verma', 30, 'FEMALE', 'SPOUSE', 'AADH_H01_T02'),
('MEM007', 'SUB003', 'Rohan Verma', 5, 'MALE', 'SON', 'AADH_H01_T03'),
('MEM008', 'SUB003', 'Rajesh Verma', 65, 'MALE', 'FATHER', 'AADH_H01_T04'),

-- SELF only (Individual Plan)
('MEM009', 'SUB004', 'Amit Verma', 34, 'MALE', 'SELF', 'AADH_H01_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM010', 'SUB005', 'Suman Verma', 33, 'FEMALE', 'SPOUSE', 'AADH_H01_F03'),
('MEM011', 'SUB005', 'Anjali Verma', 4, 'FEMALE', 'DAUGHTER', 'AADH_H01_F04'),

-- MOTHER (Senior Plan)
('MEM012', 'SUB006', 'Meena Verma', 69, 'FEMALE', 'MOTHER', 'AADH_H01_S04'),

-- SELF, SPOUSE, DAUGHTER, MOTHER (Whole Family Plan)
('MEM013', 'SUB007', 'Amit Verma', 33, 'MALE', 'SELF', 'AADH_H01_T05'),
('MEM014', 'SUB007', 'Suman Verma', 32, 'FEMALE', 'SPOUSE', 'AADH_H01_T06'),
('MEM015', 'SUB007', 'Anjali Verma', 3, 'FEMALE', 'DAUGHTER', 'AADH_H01_T07'),
('MEM016', 'SUB007', 'Meena Verma', 68, 'FEMALE', 'MOTHER', 'AADH_H01_T08'),

-- SELF (Individual Plan)
('MEM017', 'SUB008', 'Amit Verma', 35, 'MALE', 'SELF', 'AADH_H01_S05'),

-- SPOUSE, SON (Family Plan)
('MEM018', 'SUB009', 'Radha Verma', 30, 'FEMALE', 'SPOUSE', 'AADH_H01_F05'),
('MEM019', 'SUB009', 'Aryan Verma', 5, 'MALE', 'SON', 'AADH_H01_F06'),

-- FATHER (Senior Plan)
('MEM020', 'SUB010', 'Arun Verma', 65, 'MALE', 'FATHER', 'AADH_H01_S06'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM021', 'SUB011', 'Amit Verma', 35, 'MALE', 'SELF', 'AADH_H01_T09'),
('MEM022', 'SUB011', 'Radha Verma', 30, 'FEMALE', 'SPOUSE', 'AADH_H01_T10'),
('MEM023', 'SUB011', 'Aryan Verma', 5, 'MALE', 'SON', 'AADH_H01_T11'),
('MEM024', 'SUB011', 'Arun Verma', 65, 'MALE', 'FATHER', 'AADH_H01_T12'),

-- SELF (Individual Plan)
('MEM025', 'SUB012', 'Amit Verma', 34, 'MALE', 'SELF', 'AADH_H01_S07'),

-- SPOUSE, SON (Family Plan - Variation 1)
('MEM026', 'SUB013', 'Kiran Verma', 33, 'FEMALE', 'SPOUSE', 'AADH_H01_F07'),
('MEM027', 'SUB013', 'Vivaan Verma', 4, 'MALE', 'SON', 'AADH_H01_F08'),

-- SPOUSE, SON (Family Plan - Variation 2)
('MEM028', 'SUB014', 'Kiran Verma', 32, 'FEMALE', 'SPOUSE', 'AADH_H01_F09'),
('MEM029', 'SUB014', 'Vivaan Verma', 3, 'MALE', 'SON', 'AADH_H01_F10'),

-- HID002 (Priya Sharma) Members
-- SELF (Individual Plan)
('MEM030', 'SUB015', 'Priya Sharma', 40, 'FEMALE', 'SELF', 'AADH_H02_S01'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM031', 'SUB016', 'Raj Sharma', 42, 'MALE', 'SPOUSE', 'AADH_H02_F01'),
('MEM032', 'SUB016', 'Meera Sharma', 15, 'FEMALE', 'DAUGHTER', 'AADH_H02_F02'),

-- MOTHER (Senior Plan)
('MEM033', 'SUB017', 'Gita Sharma', 68, 'FEMALE', 'MOTHER', 'AADH_H02_S02'),

-- SELF, SPOUSE, DAUGHTER, MOTHER (Whole Family Plan)
('MEM034', 'SUB018', 'Priya Sharma', 40, 'FEMALE', 'SELF', 'AADH_H02_T01'),
('MEM035', 'SUB018', 'Raj Sharma', 42, 'MALE', 'SPOUSE', 'AADH_H02_T02'),
('MEM036', 'SUB018', 'Meera Sharma', 15, 'FEMALE', 'DAUGHTER', 'AADH_H02_T03'),
('MEM037', 'SUB018', 'Gita Sharma', 68, 'FEMALE', 'MOTHER', 'AADH_H02_T04'),

-- SELF (Individual Plan)
('MEM038', 'SUB019', 'Priya Sharma', 39, 'FEMALE', 'SELF', 'AADH_H02_S03'),

-- SPOUSE, SON (Family Plan)
('MEM039', 'SUB020', 'Renu Sharma', 38, 'FEMALE', 'SPOUSE', 'AADH_H02_F03'),
('MEM040', 'SUB020', 'Kush Sharma', 10, 'MALE', 'SON', 'AADH_H02_F04'),

-- FATHER (Senior Plan)
('MEM041', 'SUB021', 'Ravi Sharma', 70, 'MALE', 'FATHER', 'AADH_H02_S04'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM042', 'SUB022', 'Priya Sharma', 39, 'FEMALE', 'SELF', 'AADH_H02_T05'),
('MEM043', 'SUB022', 'Renu Sharma', 38, 'FEMALE', 'SPOUSE', 'AADH_H02_T06'),
('MEM044', 'SUB022', 'Kush Sharma', 10, 'MALE', 'SON', 'AADH_H02_T07'),
('MEM045', 'SUB022', 'Ravi Sharma', 70, 'MALE', 'FATHER', 'AADH_H02_T08'),

-- SELF (Individual Plan)
('MEM046', 'SUB023', 'Priya Sharma', 40, 'FEMALE', 'SELF', 'AADH_H02_S05'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM047', 'SUB024', 'Anjali Sharma', 42, 'FEMALE', 'SPOUSE', 'AADH_H02_F05'),
('MEM048', 'SUB024', 'Siya Sharma', 15, 'FEMALE', 'DAUGHTER', 'AADH_H02_F06'),

-- FATHER (Senior Plan)
('MEM049', 'SUB025', 'Suresh Sharma', 68, 'MALE', 'FATHER', 'AADH_H02_S06'),

-- SELF, SPOUSE, DAUGHTER, FATHER (Whole Family Plan)
('MEM050', 'SUB026', 'Priya Sharma', 40, 'FEMALE', 'SELF', 'AADH_H02_T09'),
('MEM051', 'SUB026', 'Anjali Sharma', 42, 'FEMALE', 'SPOUSE', 'AADH_H02_T10'),
('MEM052', 'SUB026', 'Siya Sharma', 15, 'FEMALE', 'DAUGHTER', 'AADH_H02_T11'),
('MEM053', 'SUB026', 'Suresh Sharma', 68, 'MALE', 'FATHER', 'AADH_H02_T12'),

-- SELF (Individual Plan)
('MEM054', 'SUB027', 'Priya Sharma', 39, 'FEMALE', 'SELF', 'AADH_H02_S07'),

-- SPOUSE, SON (Family Plan - Variation 1)
('MEM055', 'SUB028', 'Nisha Sharma', 38, 'FEMALE', 'SPOUSE', 'AADH_H02_F07'),
('MEM056', 'SUB028', 'Dev Sharma', 10, 'MALE', 'SON', 'AADH_H02_F08'),

-- SPOUSE, SON (Family Plan - Variation 2)
('MEM057', 'SUB029', 'Nisha Sharma', 37, 'FEMALE', 'SPOUSE', 'AADH_H02_F09'),
('MEM058', 'SUB029', 'Dev Sharma', 9, 'MALE', 'SON', 'AADH_H02_F10'),


-- HID003 (Rajesh Kumar) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM059', 'SUB030', 'Rajesh Kumar', 55, 'MALE', 'SELF', 'AADH_H03_S01'),
('MEM060', 'SUB030', 'Pooja Kumar', 50, 'FEMALE', 'SPOUSE', 'AADH_H03_F01'),
('MEM061', 'SUB030', 'Saurabh Kumar', 22, 'MALE', 'SON', 'AADH_H03_F02'),

-- FATHER (Senior Plan)
('MEM062', 'SUB031', 'Sunil Kumar', 75, 'MALE', 'FATHER', 'AADH_H03_S02'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM063', 'SUB032', 'Rajesh Kumar', 55, 'MALE', 'SELF', 'AADH_H03_T01'),
('MEM064', 'SUB032', 'Pooja Kumar', 50, 'FEMALE', 'SPOUSE', 'AADH_H03_T02'),
('MEM065', 'SUB032', 'Saurabh Kumar', 22, 'MALE', 'SON', 'AADH_H03_T03'),
('MEM066', 'SUB032', 'Sunil Kumar', 75, 'MALE', 'FATHER', 'AADH_H03_T04'),

-- SELF (Individual Plan)
('MEM067', 'SUB033', 'Rajesh Kumar', 54, 'MALE', 'SELF', 'AADH_H03_S03'),

-- SPOUSE, SON (Partial Family Plan)
('MEM068', 'SUB034', 'Divya Kumar', 49, 'FEMALE', 'SPOUSE', 'AADH_H03_F03'),
('MEM069', 'SUB034', 'Aryan Kumar', 21, 'MALE', 'SON', 'AADH_H03_F04'),

-- MOTHER (Senior Plan)
('MEM070', 'SUB035', 'Meena Kumar', 74, 'FEMALE', 'MOTHER', 'AADH_H03_S04'),

-- SELF, SPOUSE, SON, MOTHER (Whole Family Plan)
('MEM071', 'SUB036', 'Rajesh Kumar', 54, 'MALE', 'SELF', 'AADH_H03_T05'),
('MEM072', 'SUB036', 'Divya Kumar', 49, 'FEMALE', 'SPOUSE', 'AADH_H03_T06'),
('MEM073', 'SUB036', 'Aryan Kumar', 21, 'MALE', 'SON', 'AADH_H03_T07'),
('MEM074', 'SUB036', 'Meena Kumar', 74, 'FEMALE', 'MOTHER', 'AADH_H03_T08'),

-- SELF (Individual Plan)
('MEM075', 'SUB037', 'Rajesh Kumar', 55, 'MALE', 'SELF', 'AADH_H03_S05'),

-- SPOUSE, SON (Family Plan)
('MEM076', 'SUB038', 'Simran Kumar', 50, 'FEMALE', 'SPOUSE', 'AADH_H03_F05'),
('MEM077', 'SUB038', 'Kunal Kumar', 22, 'MALE', 'SON', 'AADH_H03_F06'),

-- FATHER (Senior Plan)
('MEM078', 'SUB039', 'Anil Kumar', 75, 'MALE', 'FATHER', 'AADH_H03_S06'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM079', 'SUB040', 'Rajesh Kumar', 55, 'MALE', 'SELF', 'AADH_H03_T09'),
('MEM080', 'SUB040', 'Simran Kumar', 50, 'FEMALE', 'SPOUSE', 'AADH_H03_T10'),
('MEM081', 'SUB040', 'Kunal Kumar', 22, 'MALE', 'SON', 'AADH_H03_T11'),
('MEM082', 'SUB040', 'Anil Kumar', 75, 'MALE', 'FATHER', 'AADH_H03_T12'),

-- SELF (Individual Plan)
('MEM083', 'SUB041', 'Rajesh Kumar', 54, 'MALE', 'SELF', 'AADH_H03_S07'),

-- SPOUSE, SON (Family Plan - Variation 1)
('MEM084', 'SUB042', 'Ritika Kumar', 49, 'FEMALE', 'SPOUSE', 'AADH_H03_F07'),
('MEM085', 'SUB042', 'Vivek Kumar', 21, 'MALE', 'SON', 'AADH_H03_F08'),

-- SPOUSE, SON (Family Plan - Variation 2)
('MEM086', 'SUB043', 'Ritika Kumar', 48, 'FEMALE', 'SPOUSE', 'AADH_H03_F09'),
('MEM087', 'SUB043', 'Vivek Kumar', 20, 'MALE', 'SON', 'AADH_H03_F10'),

-- HID004 (Sneha Gupta) Members
-- SELF, SPOUSE, DAUGHTER (Family Plan)
('MEM088', 'SUB044', 'Sneha Gupta', 33, 'FEMALE', 'SELF', 'AADH_H04_S01'),
('MEM089', 'SUB044', 'Alok Gupta', 38, 'MALE', 'SPOUSE', 'AADH_H04_F01'),
('MEM090', 'SUB044', 'Ria Gupta', 7, 'FEMALE', 'DAUGHTER', 'AADH_H04_F02'),

-- GRANDMA (Senior Plan)
('MEM091', 'SUB045', 'Grandma Gupta', 60, 'FEMALE', 'GRANDPARENT', 'AADH_H04_S02'),

-- SELF, SPOUSE, DAUGHTER, GRANDMA (Whole Family Plan)
('MEM092', 'SUB046', 'Sneha Gupta', 33, 'FEMALE', 'SELF', 'AADH_H04_T01'),
('MEM093', 'SUB046', 'Alok Gupta', 38, 'MALE', 'SPOUSE', 'AADH_H04_T02'),
('MEM094', 'SUB046', 'Ria Gupta', 7, 'FEMALE', 'DAUGHTER', 'AADH_H04_T03'),
('MEM095', 'SUB046', 'Grandma Gupta', 60, 'FEMALE', 'GRANDPARENT', 'AADH_H04_T04'),

-- SELF (Individual Plan)
('MEM096', 'SUB047', 'Sneha Gupta', 32, 'FEMALE', 'SELF', 'AADH_H04_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM097', 'SUB048', 'Rahul Gupta', 37, 'MALE', 'SPOUSE', 'AADH_H04_F03'),
('MEM098', 'SUB048', 'Siya Gupta', 6, 'FEMALE', 'DAUGHTER', 'AADH_H04_F04'),

-- GRANDPA (Senior Plan)
('MEM099', 'SUB049', 'Grandpa Gupta', 59, 'MALE', 'GRANDPARENT', 'AADH_H04_S04'),

-- SELF, SPOUSE, DAUGHTER, GRANDPA (Whole Family Plan)
('MEM100', 'SUB050', 'Sneha Gupta', 32, 'FEMALE', 'SELF', 'AADH_H04_T05'),
('MEM101', 'SUB050', 'Rahul Gupta', 37, 'MALE', 'SPOUSE', 'AADH_H04_T06'),
('MEM102', 'SUB050', 'Siya Gupta', 6, 'FEMALE', 'DAUGHTER', 'AADH_H04_T07'),
('MEM103', 'SUB050', 'Grandpa Gupta', 59, 'MALE', 'GRANDPARENT', 'AADH_H04_T08'),

-- SELF (Individual Plan)
('MEM104', 'SUB051', 'Sneha Gupta', 33, 'FEMALE', 'SELF', 'AADH_H04_S05'),

-- SPOUSE, SON (Family Plan)
('MEM105', 'SUB052', 'Prakash Gupta', 38, 'MALE', 'SPOUSE', 'AADH_H04_F05'),
('MEM106', 'SUB052', 'Arjun Gupta', 7, 'MALE', 'SON', 'AADH_H04_F06'),

-- DADI (Senior Plan)
('MEM107', 'SUB053', 'Dadi Gupta', 60, 'FEMALE', 'GRANDPARENT', 'AADH_H04_S06'),

-- SELF, SPOUSE, SON, DADI (Whole Family Plan)
('MEM108', 'SUB054', 'Sneha Gupta', 33, 'FEMALE', 'SELF', 'AADH_H04_T09'),
('MEM109', 'SUB054', 'Prakash Gupta', 38, 'MALE', 'SPOUSE', 'AADH_H04_T10'),
('MEM110', 'SUB054', 'Arjun Gupta', 7, 'MALE', 'SON', 'AADH_H04_T11'),
('MEM111', 'SUB054', 'Dadi Gupta', 60, 'FEMALE', 'GRANDPARENT', 'AADH_H04_T12'),

-- SELF (Individual Plan)
('MEM112', 'SUB055', 'Sneha Gupta', 32, 'FEMALE', 'SELF', 'AADH_H04_S07'),

-- SPOUSE, SON (Family Plan - Variation 1)
('MEM113', 'SUB056', 'Kiran Gupta', 37, 'FEMALE', 'SPOUSE', 'AADH_H04_F07'),
('MEM114', 'SUB056', 'Dev Gupta', 6, 'MALE', 'SON', 'AADH_H04_F08'),

-- SPOUSE, SON (Family Plan - Variation 2)
('MEM115', 'SUB057', 'Kiran Gupta', 36, 'FEMALE', 'SPOUSE', 'AADH_H04_F09'),
('MEM116', 'SUB057', 'Dev Gupta', 5, 'MALE', 'SON', 'AADH_H04_F10'),

-- HID005 (Vivek Reddy) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM117', 'SUB058', 'Vivek Reddy', 45, 'MALE', 'SELF', 'AADH_H05_S01'),
('MEM118', 'SUB058', 'Shalini Reddy', 43, 'FEMALE', 'SPOUSE', 'AADH_H05_F01'),
('MEM119', 'SUB058', 'Arun Reddy', 18, 'MALE', 'SON', 'AADH_H05_F02'),

-- GRANDMA (Senior Plan)
('MEM120', 'SUB059', 'Grandma Reddy', 70, 'FEMALE', 'GRANDPARENT', 'AADH_H05_S02'),

-- SELF, SPOUSE, SON, GRANDMA (Whole Family Plan)
('MEM121', 'SUB060', 'Vivek Reddy', 45, 'MALE', 'SELF', 'AADH_H05_T01'),
('MEM122', 'SUB060', 'Shalini Reddy', 43, 'FEMALE', 'SPOUSE', 'AADH_H05_T02'),
('MEM123', 'SUB060', 'Arun Reddy', 18, 'MALE', 'SON', 'AADH_H05_T03'),
('MEM124', 'SUB060', 'Grandma Reddy', 70, 'FEMALE', 'GRANDPARENT', 'AADH_H05_T04'),

-- SELF (Individual Plan)
('MEM125', 'SUB061', 'Vivek Reddy', 44, 'MALE', 'SELF', 'AADH_H05_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM126', 'SUB062', 'Pooja Reddy', 42, 'FEMALE', 'SPOUSE', 'AADH_H05_F03'),
('MEM127', 'SUB062', 'Tanvi Reddy', 17, 'FEMALE', 'DAUGHTER', 'AADH_H05_F04'),

-- GRANDPA (Senior Plan)
('MEM128', 'SUB063', 'Grandpa Reddy', 69, 'MALE', 'GRANDPARENT', 'AADH_H05_S04'),

-- SELF, SPOUSE, DAUGHTER, GRANDPA (Whole Family Plan)
('MEM129', 'SUB064', 'Vivek Reddy', 44, 'MALE', 'SELF', 'AADH_H05_T05'),
('MEM130', 'SUB064', 'Pooja Reddy', 42, 'FEMALE', 'SPOUSE', 'AADH_H05_T06'),
('MEM131', 'SUB064', 'Tanvi Reddy', 17, 'FEMALE', 'DAUGHTER', 'AADH_H05_T07'),
('MEM132', 'SUB064', 'Grandpa Reddy', 69, 'MALE', 'GRANDPARENT', 'AADH_H05_T08'),

-- SELF (Individual Plan)
('MEM133', 'SUB065', 'Vivek Reddy', 45, 'MALE', 'SELF', 'AADH_H05_S05'),

-- SPOUSE, SON (Family Plan)
('MEM134', 'SUB066', 'Arti Reddy', 43, 'FEMALE', 'SPOUSE', 'AADH_H05_F05'),
('MEM135', 'SUB066', 'Vivaan Reddy', 18, 'MALE', 'SON', 'AADH_H05_F06'),

-- NANI (Senior Plan)
('MEM136', 'SUB067', 'Nani Reddy', 70, 'FEMALE', 'GRANDPARENT', 'AADH_H05_S06'),

-- SELF, SPOUSE, SON, NANI (Whole Family Plan)
('MEM137', 'SUB068', 'Vivek Reddy', 45, 'MALE', 'SELF', 'AADH_H05_T09'),
('MEM138', 'SUB068', 'Arti Reddy', 43, 'FEMALE', 'SPOUSE', 'AADH_H05_T10'),
('MEM139', 'SUB068', 'Vivaan Reddy', 18, 'MALE', 'SON', 'AADH_H05_T11'),
('MEM140', 'SUB068', 'Nani Reddy', 70, 'FEMALE', 'GRANDPARENT', 'AADH_H05_T12'),

-- SELF (Individual Plan)
('MEM141', 'SUB069', 'Vivek Reddy', 44, 'MALE', 'SELF', 'AADH_H05_S07'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 1)
('MEM142', 'SUB070', 'Deepak Reddy', 42, 'MALE', 'SPOUSE', 'AADH_H05_F07'),
('MEM143', 'SUB070', 'Kiara Reddy', 17, 'FEMALE', 'DAUGHTER', 'AADH_H05_F08'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 2)
('MEM144', 'SUB071', 'Deepak Reddy', 41, 'MALE', 'SPOUSE', 'AADH_H05_F09'),
('MEM145', 'SUB071', 'Kiara Reddy', 16, 'FEMALE', 'DAUGHTER', 'AADH_H05_F10'),

-- HID006 (Nisha Malhotra) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM146', 'SUB072', 'Nisha Malhotra', 57, 'FEMALE', 'SELF', 'AADH_H06_S01'),
('MEM147', 'SUB072', 'Alok Malhotra', 60, 'MALE', 'SPOUSE', 'AADH_H06_F01'),
('MEM148', 'SUB072', 'Rohan Malhotra', 25, 'MALE', 'SON', 'AADH_H06_F02'),

-- GRANDMA (Senior Plan)
('MEM149', 'SUB073', 'Grandma Malhotra', 80, 'FEMALE', 'GRANDPARENT', 'AADH_H06_S02'),

-- SELF, SPOUSE, SON, GRANDMA (Whole Family Plan)
('MEM150', 'SUB074', 'Nisha Malhotra', 57, 'FEMALE', 'SELF', 'AADH_H06_T01'),
('MEM151', 'SUB074', 'Alok Malhotra', 60, 'MALE', 'SPOUSE', 'AADH_H06_T02'),
('MEM152', 'SUB074', 'Rohan Malhotra', 25, 'MALE', 'SON', 'AADH_H06_T03'),
('MEM153', 'SUB074', 'Grandma Malhotra', 80, 'FEMALE', 'GRANDPARENT', 'AADH_H06_T04'),

-- SELF (Individual Plan)
('MEM154', 'SUB075', 'Nisha Malhotra', 56, 'FEMALE', 'SELF', 'AADH_H06_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM155', 'SUB076', 'Prakash Malhotra', 59, 'MALE', 'SPOUSE', 'AADH_H06_F03'),
('MEM156', 'SUB076', 'Divya Malhotra', 24, 'FEMALE', 'DAUGHTER', 'AADH_H06_F04'),

-- GRANDPA (Senior Plan)
('MEM157', 'SUB077', 'Grandpa Malhotra', 79, 'MALE', 'GRANDPARENT', 'AADH_H06_S04'),

-- SELF, SPOUSE, DAUGHTER, GRANDPA (Whole Family Plan)
('MEM158', 'SUB078', 'Nisha Malhotra', 56, 'FEMALE', 'SELF', 'AADH_H06_T05'),
('MEM159', 'SUB078', 'Prakash Malhotra', 59, 'MALE', 'SPOUSE', 'AADH_H06_T06'),
('MEM160', 'SUB078', 'Divya Malhotra', 24, 'FEMALE', 'DAUGHTER', 'AADH_H06_T07'),
('MEM161', 'SUB078', 'Grandpa Malhotra', 79, 'MALE', 'GRANDPARENT', 'AADH_H06_T08'),

-- SELF (Individual Plan)
('MEM162', 'SUB079', 'Nisha Malhotra', 57, 'FEMALE', 'SELF', 'AADH_H06_S05'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM163', 'SUB080', 'Kunal Malhotra', 60, 'MALE', 'SPOUSE', 'AADH_H06_F05'),
('MEM164', 'SUB080', 'Siya Malhotra', 25, 'FEMALE', 'DAUGHTER', 'AADH_H06_F06'),

-- DADI (Senior Plan)
('MEM165', 'SUB081', 'Dadi Malhotra', 80, 'FEMALE', 'GRANDPARENT', 'AADH_H06_S06'),

-- SELF, SPOUSE, DAUGHTER, DADI (Whole Family Plan)
('MEM166', 'SUB082', 'Nisha Malhotra', 57, 'FEMALE', 'SELF', 'AADH_H06_T09'),
('MEM167', 'SUB082', 'Kunal Malhotra', 60, 'MALE', 'SPOUSE', 'AADH_H06_T10'),
('MEM168', 'SUB082', 'Siya Malhotra', 25, 'FEMALE', 'DAUGHTER', 'AADH_H06_T11'),
('MEM169', 'SUB082', 'Dadi Malhotra', 80, 'FEMALE', 'GRANDPARENT', 'AADH_H06_T12'),

-- SELF (Individual Plan)
('MEM170', 'SUB083', 'Nisha Malhotra', 56, 'FEMALE', 'SELF', 'AADH_H06_S07'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 1)
('MEM171', 'SUB084', 'Raj Malhotra', 59, 'MALE', 'SPOUSE', 'AADH_H06_F07'),
('MEM172', 'SUB084', 'Ria Malhotra', 24, 'FEMALE', 'DAUGHTER', 'AADH_H06_F08'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 2)
('MEM173', 'SUB085', 'Raj Malhotra', 58, 'MALE', 'SPOUSE', 'AADH_H06_F09'),
('MEM174', 'SUB085', 'Ria Malhotra', 23, 'FEMALE', 'DAUGHTER', 'AADH_H06_F10'),

-- HID007 (Arjun Singh) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM175', 'SUB086', 'Arjun Singh', 30, 'MALE', 'SELF', 'AADH_H07_S01'),
('MEM176', 'SUB086', 'Priya Singh', 28, 'FEMALE', 'SPOUSE', 'AADH_H07_F01'),
('MEM177', 'SUB086', 'Aarav Singh', 2, 'MALE', 'SON', 'AADH_H07_F02'),

-- DADA (Senior Plan)
('MEM178', 'SUB087', 'Dada Singh', 65, 'MALE', 'GRANDPARENT', 'AADH_H07_S02'),

-- SELF, SPOUSE, SON, DADA (Whole Family Plan)
('MEM179', 'SUB088', 'Arjun Singh', 30, 'MALE', 'SELF', 'AADH_H07_T01'),
('MEM180', 'SUB088', 'Priya Singh', 28, 'FEMALE', 'SPOUSE', 'AADH_H07_T02'),
('MEM181', 'SUB088', 'Aarav Singh', 2, 'MALE', 'SON', 'AADH_H07_T03'),
('MEM182', 'SUB088', 'Dada Singh', 65, 'MALE', 'GRANDPARENT', 'AADH_H07_T04'),

-- SELF (Individual Plan)
('MEM183', 'SUB089', 'Arjun Singh', 29, 'MALE', 'SELF', 'AADH_H07_S03'),

-- SPOUSE, SON (Partial Family Plan)
('MEM184', 'SUB090', 'Rina Singh', 27, 'FEMALE', 'SPOUSE', 'AADH_H07_F03'),
('MEM185', 'SUB090', 'Kabir Singh', 1, 'MALE', 'SON', 'AADH_H07_F04'),

-- DADI (Senior Plan)
('MEM186', 'SUB091', 'Dadi Singh', 64, 'FEMALE', 'GRANDPARENT', 'AADH_H07_S04'),

-- SELF, SPOUSE, SON, DADI (Whole Family Plan)
('MEM187', 'SUB092', 'Arjun Singh', 29, 'MALE', 'SELF', 'AADH_H07_T05'),
('MEM188', 'SUB092', 'Rina Singh', 27, 'FEMALE', 'SPOUSE', 'AADH_H07_T06'),
('MEM189', 'SUB092', 'Kabir Singh', 1, 'MALE', 'SON', 'AADH_H07_T07'),
('MEM190', 'SUB092', 'Dadi Singh', 64, 'FEMALE', 'GRANDPARENT', 'AADH_H07_T08'),

-- SELF (Individual Plan)
('MEM191', 'SUB093', 'Arjun Singh', 30, 'MALE', 'SELF', 'AADH_H07_S05'),

-- SPOUSE, SON (Family Plan)
('MEM192', 'SUB094', 'Neha Singh', 28, 'FEMALE', 'SPOUSE', 'AADH_H07_F05'),
('MEM193', 'SUB094', 'Vihaan Singh', 2, 'MALE', 'SON', 'AADH_H07_F06'),

-- FATHER (Senior Plan)
('MEM194', 'SUB095', 'Ajay Singh', 65, 'MALE', 'FATHER', 'AADH_H07_S06'),

-- SELF, SPOUSE, SON, FATHER (Whole Family Plan)
('MEM195', 'SUB096', 'Arjun Singh', 30, 'MALE', 'SELF', 'AADH_H07_T09'),
('MEM196', 'SUB096', 'Neha Singh', 28, 'FEMALE', 'SPOUSE', 'AADH_H07_T10'),
('MEM197', 'SUB096', 'Vihaan Singh', 2, 'MALE', 'SON', 'AADH_H07_T11'),
('MEM198', 'SUB096', 'Ajay Singh', 65, 'MALE', 'FATHER', 'AADH_H07_T12'),

-- SELF (Individual Plan)
('MEM199', 'SUB097', 'Arjun Singh', 29, 'MALE', 'SELF', 'AADH_H07_S07'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 1)
('MEM200', 'SUB098', 'Simran Singh', 27, 'FEMALE', 'SPOUSE', 'AADH_H07_F07'),
('MEM201', 'SUB098', 'Aadhya Singh', 1, 'FEMALE', 'DAUGHTER', 'AADH_H07_F08'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 2)
('MEM202', 'SUB099', 'Simran Singh', 26, 'FEMALE', 'SPOUSE', 'AADH_H07_F09'),
('MEM203', 'SUB099', 'Aadhya Singh', 0, 'FEMALE', 'DAUGHTER', 'AADH_H07_F10'),

-- HID008 (Pooja Das) Members
-- SELF, SPOUSE, DAUGHTER (Family Plan)
('MEM204', 'SUB100', 'Pooja Das', 50, 'FEMALE', 'SELF', 'AADH_H08_S01'),
('MEM205', 'SUB100', 'Sameer Das', 52, 'MALE', 'SPOUSE', 'AADH_H08_F01'),
('MEM206', 'SUB100', 'Diya Das', 20, 'FEMALE', 'DAUGHTER', 'AADH_H08_F02'),

-- NANU (Senior Plan)
('MEM207', 'SUB101', 'Nanu Das', 70, 'MALE', 'GRANDPARENT', 'AADH_H08_S02'),

-- SELF, SPOUSE, DAUGHTER, NANU (Whole Family Plan)
('MEM208', 'SUB102', 'Pooja Das', 50, 'FEMALE', 'SELF', 'AADH_H08_T01'),
('MEM209', 'SUB102', 'Sameer Das', 52, 'MALE', 'SPOUSE', 'AADH_H08_T02'),
('MEM210', 'SUB102', 'Diya Das', 20, 'FEMALE', 'DAUGHTER', 'AADH_H08_T03'),
('MEM211', 'SUB102', 'Nanu Das', 70, 'MALE', 'GRANDPARENT', 'AADH_H08_T04'),

-- SELF (Individual Plan)
('MEM212', 'SUB103', 'Pooja Das', 49, 'FEMALE', 'SELF', 'AADH_H08_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM213', 'SUB104', 'Rahul Das', 51, 'MALE', 'SPOUSE', 'AADH_H08_F03'),
('MEM214', 'SUB104', 'Neha Das', 19, 'FEMALE', 'DAUGHTER', 'AADH_H08_F04'),

-- NANI (Senior Plan)
('MEM215', 'SUB105', 'Nani Das', 69, 'FEMALE', 'GRANDPARENT', 'AADH_H08_S04'),

-- SELF, SPOUSE, DAUGHTER, NANI (Whole Family Plan)
('MEM216', 'SUB106', 'Pooja Das', 49, 'FEMALE', 'SELF', 'AADH_H08_T05'),
('MEM217', 'SUB106', 'Rahul Das', 51, 'MALE', 'SPOUSE', 'AADH_H08_T06'),
('MEM218', 'SUB106', 'Neha Das', 19, 'FEMALE', 'DAUGHTER', 'AADH_H08_T07'),
('MEM219', 'SUB106', 'Nani Das', 69, 'FEMALE', 'GRANDPARENT', 'AADH_H08_T08'),

-- SELF (Individual Plan)
('MEM220', 'SUB107', 'Pooja Das', 50, 'FEMALE', 'SELF', 'AADH_H08_S05'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM221', 'SUB108', 'Rohan Das', 52, 'MALE', 'SPOUSE', 'AADH_H08_F05'),
('MEM222', 'SUB108', 'Riya Das', 20, 'FEMALE', 'DAUGHTER', 'AADH_H08_F06'),

-- GRANDPA (Senior Plan)
('MEM223', 'SUB109', 'Grandpa Das', 70, 'MALE', 'GRANDPARENT', 'AADH_H08_S06'),

-- SELF, SPOUSE, DAUGHTER, GRANDPA (Whole Family Plan)
('MEM224', 'SUB110', 'Pooja Das', 50, 'FEMALE', 'SELF', 'AADH_H08_T09'),
('MEM225', 'SUB110', 'Rohan Das', 52, 'MALE', 'SPOUSE', 'AADH_H08_T10'),
('MEM226', 'SUB110', 'Riya Das', 20, 'FEMALE', 'DAUGHTER', 'AADH_H08_T11'),
('MEM227', 'SUB110', 'Grandpa Das', 70, 'MALE', 'GRANDPARENT', 'AADH_H08_T12'),

-- SELF (Individual Plan)
('MEM228', 'SUB111', 'Pooja Das', 49, 'FEMALE', 'SELF', 'AADH_H08_S07'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 1)
('MEM229', 'SUB112', 'Akash Das', 51, 'MALE', 'SPOUSE', 'AADH_H08_F07'),
('MEM230', 'SUB112', 'Kriti Das', 19, 'FEMALE', 'DAUGHTER', 'AADH_H08_F08'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 2)
('MEM231', 'SUB113', 'Akash Das', 50, 'MALE', 'SPOUSE', 'AADH_H08_F09'),
('MEM232', 'SUB113', 'Kriti Das', 18, 'FEMALE', 'DAUGHTER', 'AADH_H08_F10'),

-- HID009 (Kunal Jain) Members
-- SELF, SPOUSE, SON (Family Plan)
('MEM233', 'SUB114', 'Kunal Jain', 37, 'MALE', 'SELF', 'AADH_H09_S01'),
('MEM234', 'SUB114', 'Smita Jain', 35, 'FEMALE', 'SPOUSE', 'AADH_H09_F01'),
('MEM235', 'SUB114', 'Veer Jain', 9, 'MALE', 'SON', 'AADH_H09_F02'),

-- GRANDMA (Senior Plan)
('MEM236', 'SUB115', 'Grandma Jain', 68, 'FEMALE', 'GRANDPARENT', 'AADH_H09_S02'),

-- SELF, SPOUSE, SON, GRANDMA (Whole Family Plan)
('MEM237', 'SUB116', 'Kunal Jain', 37, 'MALE', 'SELF', 'AADH_H09_T01'),
('MEM238', 'SUB116', 'Smita Jain', 35, 'FEMALE', 'SPOUSE', 'AADH_H09_T02'),
('MEM239', 'SUB116', 'Veer Jain', 9, 'MALE', 'SON', 'AADH_H09_T03'),
('MEM240', 'SUB116', 'Grandma Jain', 68, 'FEMALE', 'GRANDPARENT', 'AADH_H09_T04'),

-- SELF (Individual Plan)
('MEM241', 'SUB117', 'Kunal Jain', 36, 'MALE', 'SELF', 'AADH_H09_S03'),

-- SPOUSE, SON (Partial Family Plan)
('MEM242', 'SUB118', 'Priya Jain', 34, 'FEMALE', 'SPOUSE', 'AADH_H09_F03'),
('MEM243', 'SUB118', 'Aryan Jain', 8, 'MALE', 'SON', 'AADH_H09_F04'),

-- GRANDPA (Senior Plan)
('MEM244', 'SUB119', 'Grandpa Jain', 67, 'MALE', 'GRANDPARENT', 'AADH_H09_S04'),

-- SELF, SPOUSE, SON, GRANDPA (Whole Family Plan)
('MEM245', 'SUB120', 'Kunal Jain', 36, 'MALE', 'SELF', 'AADH_H09_T05'),
('MEM246', 'SUB120', 'Priya Jain', 34, 'FEMALE', 'SPOUSE', 'AADH_H09_T06'),
('MEM247', 'SUB120', 'Aryan Jain', 8, 'MALE', 'SON', 'AADH_H09_T07'),
('MEM248', 'SUB120', 'Grandpa Jain', 67, 'MALE', 'GRANDPARENT', 'AADH_H09_T08'),

-- SELF (Individual Plan)
('MEM249', 'SUB121', 'Kunal Jain', 37, 'MALE', 'SELF', 'AADH_H09_S05'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM250', 'SUB122', 'Neha Jain', 35, 'FEMALE', 'SPOUSE', 'AADH_H09_F05'),
('MEM251', 'SUB122', 'Siya Jain', 9, 'FEMALE', 'DAUGHTER', 'AADH_H09_F06'),

-- DADI (Senior Plan)
('MEM252', 'SUB123', 'Dadi Jain', 68, 'FEMALE', 'GRANDPARENT', 'AADH_H09_S06'),

-- SELF, SPOUSE, DAUGHTER, DADI (Whole Family Plan)
('MEM253', 'SUB124', 'Kunal Jain', 37, 'MALE', 'SELF', 'AADH_H09_T09'),
('MEM254', 'SUB124', 'Neha Jain', 35, 'FEMALE', 'SPOUSE', 'AADH_H09_T10'),
('MEM255', 'SUB124', 'Siya Jain', 9, 'FEMALE', 'DAUGHTER', 'AADH_H09_T11'),
('MEM256', 'SUB124', 'Dadi Jain', 68, 'FEMALE', 'GRANDPARENT', 'AADH_H09_T12'),

-- SELF (Individual Plan)
('MEM257', 'SUB125', 'Kunal Jain', 36, 'MALE', 'SELF', 'AADH_H09_S07'),

-- SPOUSE, SON (Family Plan - Variation 1)
('MEM258', 'SUB126', 'Rima Jain', 34, 'FEMALE', 'SPOUSE', 'AADH_H09_F07'),
('MEM259', 'SUB126', 'Vivaan Jain', 8, 'MALE', 'SON', 'AADH_H09_F08'),

-- SPOUSE, SON (Family Plan - Variation 2)
('MEM260', 'SUB127', 'Rima Jain', 33, 'FEMALE', 'SPOUSE', 'AADH_H09_F09'),
('MEM261', 'SUB127', 'Vivaan Jain', 7, 'MALE', 'SON', 'AADH_H09_F10'),

-- HID010 (Rina Patel) Members
-- SELF (Individual Plan)
('MEM262', 'SUB128', 'Rina Patel', 65, 'FEMALE', 'SELF', 'AADH_H10_S01'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM263', 'SUB129', 'Rajesh Patel', 68, 'MALE', 'SPOUSE', 'AADH_H10_F01'),
('MEM264', 'SUB129', 'Kiran Patel', 40, 'FEMALE', 'DAUGHTER', 'AADH_H10_F02'),

-- GRANDMA (Senior Plan)
('MEM265', 'SUB130', 'Grandma Patel', 85, 'FEMALE', 'GRANDPARENT', 'AADH_H10_S02'),

-- SELF, SPOUSE, DAUGHTER, GRANDMA (Whole Family Plan)
('MEM266', 'SUB131', 'Rina Patel', 65, 'FEMALE', 'SELF', 'AADH_H10_T01'),
('MEM267', 'SUB131', 'Rajesh Patel', 68, 'MALE', 'SPOUSE', 'AADH_H10_T02'),
('MEM268', 'SUB131', 'Kiran Patel', 40, 'FEMALE', 'DAUGHTER', 'AADH_H10_T03'),
('MEM269', 'SUB131', 'Grandma Patel', 85, 'FEMALE', 'GRANDPARENT', 'AADH_H10_T04'),

-- SELF (Individual Plan)
('MEM270', 'SUB132', 'Rina Patel', 64, 'FEMALE', 'SELF', 'AADH_H10_S03'),

-- SPOUSE, DAUGHTER (Partial Family Plan)
('MEM271', 'SUB133', 'Suresh Patel', 67, 'MALE', 'SPOUSE', 'AADH_H10_F03'),
('MEM272', 'SUB133', 'Pooja Patel', 39, 'FEMALE', 'DAUGHTER', 'AADH_H10_F04'),

-- GRANDPA (Senior Plan)
('MEM273', 'SUB134', 'Grandpa Patel', 84, 'MALE', 'GRANDPARENT', 'AADH_H10_S04'),

-- SELF, SPOUSE, DAUGHTER, GRANDPA (Whole Family Plan)
('MEM274', 'SUB135', 'Rina Patel', 64, 'FEMALE', 'SELF', 'AADH_H10_T05'),
('MEM275', 'SUB135', 'Suresh Patel', 67, 'MALE', 'SPOUSE', 'AADH_H10_T06'),
('MEM276', 'SUB135', 'Pooja Patel', 39, 'FEMALE', 'DAUGHTER', 'AADH_H10_T07'),
('MEM277', 'SUB135', 'Grandpa Patel', 84, 'MALE', 'GRANDPARENT', 'AADH_H10_T08'),

-- SELF (Individual Plan)
('MEM278', 'SUB136', 'Rina Patel', 65, 'FEMALE', 'SELF', 'AADH_H10_S05'),

-- SPOUSE, DAUGHTER (Family Plan)
('MEM279', 'SUB137', 'Anil Patel', 68, 'MALE', 'SPOUSE', 'AADH_H10_F05'),
('MEM280', 'SUB137', 'Neha Patel', 40, 'FEMALE', 'DAUGHTER', 'AADH_H10_F06'),

-- DADI (Senior Plan)
('MEM281', 'SUB138', 'Dadi Patel', 85, 'FEMALE', 'GRANDPARENT', 'AADH_H10_S06'),

-- SELF, SPOUSE, DAUGHTER, DADI (Whole Family Plan)
('MEM282', 'SUB139', 'Rina Patel', 65, 'FEMALE', 'SELF', 'AADH_H10_T09'),
('MEM283', 'SUB139', 'Anil Patel', 68, 'MALE', 'SPOUSE', 'AADH_H10_T10'),
('MEM284', 'SUB139', 'Neha Patel', 40, 'FEMALE', 'DAUGHTER', 'AADH_H10_T11'),
('MEM285', 'SUB139', 'Dadi Patel', 85, 'FEMALE', 'GRANDPARENT', 'AADH_H10_T12'),

-- SELF (Individual Plan)
('MEM286', 'SUB140', 'Rina Patel', 64, 'FEMALE', 'SELF', 'AADH_H10_S07'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 1)
('MEM287', 'SUB141', 'Rakesh Patel', 67, 'MALE', 'SPOUSE', 'AADH_H10_F07'),
('MEM288', 'SUB141', 'Tina Patel', 39, 'FEMALE', 'DAUGHTER', 'AADH_H10_F08'),

-- SPOUSE, DAUGHTER (Family Plan - Variation 2)
('MEM289', 'SUB142', 'Rakesh Patel', 66, 'MALE', 'SPOUSE', 'AADH_H10_F09'),
('MEM290', 'SUB142', 'Tina Patel', 38, 'FEMALE', 'DAUGHTER', 'AADH_H10_F10');


INSERT INTO medical_procedure (
    procedure_id, appointment_id, h_id, provider_id, doctor_id, procedure_date,
    diagnosis, treatment_plan, created_at, updated_at
) VALUES
('PROC001', 'APP001', 'HID001', 'PROV001', 'DOC001', '2025-06-15', 'Hypertension', 'Prescribed medication and follow-up in 2 weeks.', NOW(), NOW()),
('PROC002', 'APP002', 'HID001', 'PROV001', 'DOC002', '2025-06-20', 'Pregnancy checkup', 'Routine prenatal care.', NOW(), NOW()),
('PROC003', 'APP003', 'HID001', 'PROV001', 'DOC003', '2025-06-22', 'Toothache', 'Root canal performed.', NOW(), NOW()),
('PROC004', 'APP004', 'HID002', 'PROV001', 'DOC004', '2025-06-25', 'Child fever', 'Paracetamol + rest', NOW(), NOW()),
('PROC005', 'APP005', 'HID003', 'PROV001', 'DOC005', '2025-06-27', 'Knee pain', 'Physiotherapy suggested.', NOW(), NOW()),
('PROC006', 'APP006', 'HID004', 'PROV001', 'DOC006', '2025-07-01', 'Flu symptoms', 'Rest and fluids.', NOW(), NOW()),
('PROC007', 'APP007', 'HID005', 'PROV001', 'DOC007', '2025-07-05', 'Back pain', 'Painkillers and light exercise.', NOW(), NOW()),
('PROC008', 'APP008', 'HID006', 'PROV001', 'DOC008', '2025-07-10', 'Diabetes checkup', 'Blood test and diet review.', NOW(), NOW()),
('PROC009', 'APP009', 'HID007', 'PROV001', 'DOC009', '2025-07-12', 'Fractured arm', 'Cast applied.', NOW(), NOW()),
('PROC010', 'APP010', 'HID008', 'PROV001', 'DOC010', '2025-07-15', 'Migraine', 'Prescribed stronger medication.', NOW(), NOW()),
('PROC011', 'APP011', 'HID009', 'PROV001', 'DOC011', '2025-07-18', 'Skin rash', 'Topical cream applied.', NOW(), NOW()),
('PROC012', 'APP012', 'HID010', 'PROV001', 'DOC012', '2025-07-20', 'Routine checkup', 'General health assessment.', NOW(), NOW()),
('PROC013', 'APP013', 'HID001', 'PROV001', 'DOC013', '2025-07-22', 'Allergy symptoms', 'Antihistamines prescribed.', NOW(), NOW()),
('PROC014', 'APP014', 'HID002', 'PROV001', 'DOC014', '2025-07-25', 'Ear infection', 'Antibiotics prescribed.', NOW(), NOW()),
('PROC015', 'APP015', 'HID003', 'PROV001', 'DOC015', '2025-07-28', 'Eye irritation', 'Eye drops recommended.', NOW(), NOW());


INSERT INTO Claims (
    claim_id, subscribe_id, procedure_id, provider_id, h_id, claim_status,
    claim_date, amount_claimed, amount_approved
) VALUES
-- HID001 (Amit Verma) Claims - Multiple subscriptions and statuses
('CLM001', 'SUB001', 'PROC001', 'PROV001', 'HID001', 'APPROVED', '2025-06-20', 4000.00, 3500.00),
('CLM002', 'SUB001', 'PROC005', 'PROV001', 'HID001', 'DENIED', '2025-05-15', 6000.00, 0.00), -- Changed from PROV002
('CLM003', 'SUB001', 'PROC010', 'PROV001', 'HID001', 'PENDING', '2025-07-10', 5000.00, 0.00), -- Changed from PROV003
('CLM004', 'SUB003', 'PROC002', 'PROV001', 'HID001', 'APPROVED', '2024-11-01', 4500.00, 4200.00),
('CLM005', 'SUB003', 'PROC007', 'PROV001', 'HID001', 'DENIED', '2024-10-20', 7000.00, 0.00), -- Changed from PROV002
('CLM006', 'SUB003', 'PROC012', 'PROV001', 'HID001', 'PENDING', '2024-12-05', 5500.00, 0.00), -- Changed from PROV003
('CLM007', 'SUB004', 'PROC003', 'PROV001', 'HID001', 'APPROVED', '2023-08-10', 3300.00, 3100.00),
('CLM008', 'SUB004', 'PROC008', 'PROV001', 'HID001', 'APPROVED', '2023-09-05', 6200.00, 6000.00), -- Changed from PROV002
('CLM009', 'SUB006', 'PROC004', 'PROV001', 'HID001', 'DENIED', '2022-07-25', 2500.00, 0.00), -- Changed from PROV003
('CLM010', 'SUB007', 'PROC009', 'PROV001', 'HID001', 'PENDING', '2020-01-01', 9000.00, 0.00),
('CLM011', 'SUB008', 'PROC011', 'PROV001', 'HID001', 'APPROVED', '2019-03-15', 2800.00, 2700.00), -- Changed from PROV002
('CLM012', 'SUB009', 'PROC013', 'PROV001', 'HID001', 'APPROVED', '2025-04-01', 4200.00, 4000.00), -- Changed from PROV003
('CLM013', 'SUB011', 'PROC014', 'PROV001', 'HID001', 'DENIED', '2024-05-20', 8500.00, 0.00),
('CLM014', 'SUB012', 'PROC015', 'PROV001', 'HID001', 'PENDING', '2023-02-10', 13000.00, 0.00), -- Changed from PROV002
('CLM015', 'SUB013', 'PROC001', 'PROV001', 'HID001', 'APPROVED', '2022-08-01', 3800.00, 3600.00), -- Changed from PROV003

-- HID002 (Priya Sharma) Claims
('CLM016', 'SUB015', 'PROC002', 'PROV001', 'HID002', 'APPROVED', '2025-06-25', 3000.00, 2800.00),
('CLM017', 'SUB015', 'PROC006', 'PROV001', 'HID002', 'DENIED', '2025-05-10', 3200.00, 0.00), -- Changed from PROV002
('CLM018', 'SUB017', 'PROC011', 'PROV001', 'HID002', 'PENDING', '2024-11-15', 2900.00, 0.00), -- Changed from PROV003
('CLM019', 'SUB018', 'PROC003', 'PROV001', 'HID002', 'APPROVED', '2024-10-01', 3500.00, 3200.00),
('CLM020', 'SUB018', 'PROC008', 'PROV001', 'HID002', 'DENIED', '2024-09-20', 4000.00, 0.00), -- Changed from PROV002
('CLM021', 'SUB020', 'PROC004', 'PROV001', 'HID002', 'APPROVED', '2023-07-05', 2000.00, 1900.00), -- Changed from PROV003
('CLM022', 'SUB021', 'PROC009', 'PROV001', 'HID002', 'PENDING', '2022-06-10', 7000.00, 0.00),
('CLM023', 'SUB022', 'PROC012', 'PROV001', 'HID002', 'APPROVED', '2025-07-16', 3000.00, 2900.00), -- Changed from PROV002

-- HID003 (Rajesh Kumar) Claims
('CLM024', 'SUB030', 'PROC003', 'PROV001', 'HID003', 'APPROVED', '2024-08-05', 7000.00, 6800.00),
('CLM025', 'SUB030', 'PROC007', 'PROV001', 'HID003', 'DENIED', '2024-07-15', 8000.00, 0.00), -- Changed from PROV002
('CLM026', 'SUB032', 'PROC013', 'PROV001', 'HID003', 'PENDING', '2023-10-01', 7500.00, 0.00), -- Changed from PROV003
('CLM027', 'SUB033', 'PROC004', 'PROV001', 'HID003', 'APPROVED', '2025-06-01', 2900.00, 2700.00),
('CLM028', 'SUB033', 'PROC009', 'PROV001', 'HID003', 'APPROVED', '2025-07-12', 5000.00, 4800.00), -- Changed from PROV002
('CLM029', 'SUB035', 'PROC005', 'PROV001', 'HID003', 'DENIED', '2022-05-20', 3500.00, 0.00), -- Changed from PROV003
('CLM030', 'SUB036', 'PROC010', 'PROV001', 'HID003', 'PENDING', '2023-04-10', 6500.00, 0.00),

-- HID004 (Sneha Gupta) Claims
('CLM031', 'SUB044', 'PROC004', 'PROV001', 'HID004', 'APPROVED', '2023-01-15', 2500.00, 2500.00),
('CLM032', 'SUB044', 'PROC008', 'PROV001', 'HID004', 'APPROVED', '2023-02-20', 3000.00, 2900.00), -- Changed from PROV002
('CLM033', 'SUB046', 'PROC014', 'PROV001', 'HID004', 'DENIED', '2022-09-01', 2800.00, 0.00), -- Changed from PROV003
('CLM034', 'SUB047', 'PROC005', 'PROV001', 'HID004', 'PENDING', '2025-07-01', 2200.00, 0.00),
('CLM035', 'SUB049', 'PROC010', 'PROV001', 'HID004', 'APPROVED', '2025-05-01', 3800.00, 3600.00), -- Changed from PROV002

-- HID005 (Vivek Reddy) Claims
('CLM036', 'SUB058', 'PROC005', 'PROV001', 'HID005', 'DENIED', '2024-03-01', 4000.00, 0.00),
('CLM037', 'SUB058', 'PROC009', 'PROV001', 'HID005', 'APPROVED', '2024-04-10', 4500.00, 4300.00), -- Changed from PROV002
('CLM038', 'SUB060', 'PROC015', 'PROV001', 'HID005', 'PENDING', '2025-07-15', 5000.00, 0.00), -- Changed from PROV003
('CLM039', 'SUB061', 'PROC006', 'PROV001', 'HID005', 'APPROVED', '2025-06-05', 3200.00, 3000.00),
('CLM040', 'SUB061', 'PROC011', 'PROV001', 'HID005', 'DENIED', '2025-05-25', 4800.00, 0.00), -- Changed from PROV002

-- HID006 (Nisha Malhotra) Claims
('CLM041', 'SUB072', 'PROC006', 'PROV001', 'HID006', 'APPROVED', '2025-07-01', 8000.00, 7500.00),
('CLM042', 'SUB072', 'PROC010', 'PROV001', 'HID006', 'PENDING', '2025-07-16', 9000.00, 0.00), -- Changed from PROV002
('CLM043', 'SUB074', 'PROC007', 'PROV001', 'HID006', 'APPROVED', '2025-06-20', 7200.00, 7000.00), -- Changed from PROV003
('CLM044', 'SUB074', 'PROC012', 'PROV001', 'HID006', 'DENIED', '2025-05-18', 8500.00, 0.00),
('CLM045', 'SUB076', 'PROC008', 'PROV001', 'HID006', 'APPROVED', '2024-12-01', 5500.00, 5200.00), -- Changed from PROV002

-- HID007 (Arjun Singh) Claims
('CLM046', 'SUB086', 'PROC009', 'PROV001', 'HID007', 'PENDING', '2024-01-05', 12000.00, 0.00),
('CLM047', 'SUB086', 'PROC013', 'PROV001', 'HID007', 'APPROVED', '2024-02-10', 11000.00, 10500.00), -- Changed from PROV002
('CLM048', 'SUB088', 'PROC010', 'PROV001', 'HID007', 'DENIED', '2024-03-15', 10000.00, 0.00), -- Changed from PROV003
('CLM049', 'SUB089', 'PROC014', 'PROV001', 'HID007', 'APPROVED', '2024-04-20', 9500.00, 9000.00),
('CLM050', 'SUB092', 'PROC011', 'PROV001', 'HID007', 'PENDING', '2025-07-17', 15000.00, 0.00), -- Changed from PROV002

-- HID008 (Pooja Das) Claims
('CLM051', 'SUB100', 'PROC010', 'PROV001', 'HID008', 'APPROVED', '2024-11-01', 3500.00, 3200.00),
('CLM052', 'SUB100', 'PROC014', 'PROV001', 'HID008', 'APPROVED', '2024-12-05', 3800.00, 3600.00), -- Changed from PROV002
('CLM053', 'SUB102', 'PROC011', 'PROV001', 'HID008', 'DENIED', '2025-01-10', 4200.00, 0.00), -- Changed from PROV003
('CLM054', 'SUB103', 'PROC015', 'PROV001', 'HID008', 'PENDING', '2025-02-15', 3000.00, 0.00),
('CLM055', 'SUB105', 'PROC001', 'PROV001', 'HID008', 'APPROVED', '2025-03-20', 2500.00, 2300.00), -- Changed from PROV002

-- HID009 (Kunal Jain) Claims
('CLM056', 'SUB114', 'PROC011', 'PROV001', 'HID009', 'APPROVED', '2025-04-01', 2000.00, 2000.00),
('CLM057', 'SUB114', 'PROC015', 'PROV001', 'HID009', 'DENIED', '2025-04-20', 2500.00, 0.00), -- Changed from PROV002
('CLM058', 'SUB116', 'PROC012', 'PROV001', 'HID009', 'PENDING', '2025-05-01', 1800.00, 0.00), -- Changed from PROV003
('CLM059', 'SUB117', 'PROC001', 'PROV001', 'HID009', 'APPROVED', '2025-05-10', 2200.00, 2100.00),
('CLM060', 'SUB119', 'PROC002', 'PROV001', 'HID009', 'APPROVED', '2025-06-15', 2800.00, 2600.00), -- Changed from PROV002

-- HID010 (Rina Patel) Claims
('CLM061', 'SUB128', 'PROC012', 'PROV001', 'HID010', 'APPROVED', '2025-07-01', 1500.00, 1500.00),
('CLM062', 'SUB128', 'PROC001', 'PROV001', 'HID010', 'DENIED', '2025-07-16', 1800.00, 0.00), -- Changed from PROV002
('CLM063', 'SUB130', 'PROC002', 'PROV001', 'HID010', 'PENDING', '2025-06-25', 2000.00, 0.00), -- Changed from PROV003
('CLM064', 'SUB131', 'PROC003', 'PROV001', 'HID010', 'APPROVED', '2025-06-10', 1600.00, 1500.00),
('CLM065', 'SUB133', 'PROC004', 'PROV001', 'HID010', 'APPROVED', '2025-05-05', 1900.00, 1800.00); -- Changed from PROV002