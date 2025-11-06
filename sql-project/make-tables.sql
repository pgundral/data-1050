CREATE DATABASE hospital;

CREATE TABLE hospital.physicians (
    ssn CHAR(11) PRIMARY KEY, 
    name VARCHAR(128), 
    primary_speciality VARCHAR(128), 
    experience_years NUMERIC(2,0) 
);

CREATE TABLE hospital.patients (
    ssn CHAR(11) PRIMARY KEY, 
    name VARCHAR(128), 
    address VARCHAR(255), 
    birth_date VARCHAR(128), 
    physician_id CHAR(11), 
    FOREIGN KEY(physician_id) REFERENCES hospital.physicians(ssn) 
);

CREATE TABLE hospital.pharmacies (
    id NUMERIC(3,0) PRIMARY KEY, 
    name VARCHAR(128), 
    address VARCHAR(255),
    phone VARCHAR(20) 
);

CREATE TABLE hospital.drugs (
    id NUMERIC(3,0), 
    name VARCHAR(128) PRIMARY KEY
);

CREATE TABLE hospital.prescriptions (
    id NUMERIC(3,0) PRIMARY KEY, 
    patient_id CHAR(11), 
    physician_id CHAR(11), 
    drug_name VARCHAR(128), 
    date VARCHAR(128), 
    quantity NUMERIC(3,0),
    FOREIGN KEY(patient_id) REFERENCES hospital.patients(ssn), 
    FOREIGN KEY(physician_id) REFERENCES hospital.physicians(ssn),
    FOREIGN KEY(drug_name) REFERENCES hospital.drugs(name)
);

CREATE TABLE hospital.adverse_interactions (
    drug_name VARCHAR(128), 
    drug_name_2 VARCHAR(128), 
    PRIMARY KEY (drug_name, drug_name_2),
    FOREIGN KEY(drug_name) REFERENCES hospital.drugs(name)
);

CREATE TABLE hospital.alerts (
    patient_id CHAR(11), 
    physician_id CHAR(11),
    alert_date VARCHAR(128), 
    drug1 VARCHAR(128), 
    drug2 VARCHAR(128),
    PRIMARY KEY (patient_id, physician_id, alert_date, drug1, drug2),
    FOREIGN KEY(patient_id) REFERENCES hospital.patients(ssn),
    FOREIGN KEY(physician_id) REFERENCES hospital.physicians(ssn),
    FOREIGN KEY(patient_id, drug1) REFERENCES hospital.prescriptions(patient_id, drug_name),
    FOREIGN KEY(patient_id, drug2) REFERENCES hospital.prescriptions(patient_id, drug_name)
);

CREATE TABLE hospital.pharmacy_fills (
    prescription_id NUMERIC(3,0),
    pharmacy_id NUMERIC(3,0), 
    date VARCHAR(128), 
    cost NUMERIC(6,2),
    PRIMARY KEY(prescription_id, pharmacy_id),
    FOREIGN KEY(prescription_id) REFERENCES hospital.prescriptions(id),
    FOREIGN KEY(pharmacy_id) REFERENCES hospital.pharmacies(id)
);

CREATE TABLE hospital.companies (
    id NUMERIC(3,0) PRIMARY KEY, 
    name VARCHAR(128), 
    address VARCHAR(255),
    contact_phone VARCHAR(20), 
    contact_name VARCHAR(128)
);

CREATE TABLE hospital.contracts (
    id NUMERIC(3,0) PRIMARY KEY,
    company_id NUMERIC(3,0), 
    pharmacy_id NUMERIC(3,0), 
    drug_name VARCHAR(128), 
    dosage NUMERIC(5,0), 
    quantity NUMERIC(3,0), 
    date VARCHAR(128),
    price NUMERIC(6,2),
    FOREIGN KEY(company_id) REFERENCES hospital.companies(id),
    FOREIGN KEY(pharmacy_id) REFERENCES hospital.pharmacies(id),
    FOREIGN KEY(drug_name) REFERENCES hospital.drugs(name)
);

ALTER TABLE hospital.prescriptions
ADD INDEX idx_patient_drug (patient_id, drug_name);

ALTER TABLE hospital.alerts
ADD CONSTRAINT fk_alerts_prescriptions
FOREIGN KEY (patient_id, drug1)
REFERENCES hospital.prescriptions (patient_id, drug_name);

ALTER TABLE hospital.alerts
ADD CONSTRAINT fk_alerts_prescriptions_2
FOREIGN KEY (patient_id, drug2)
REFERENCES hospital.prescriptions (patient_id, drug_name);