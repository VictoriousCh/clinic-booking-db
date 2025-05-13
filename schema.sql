-- ============================================
-- Clinic Booking System Database Schema
-- Author: Victorious Chaponda
-- Date: 2025-05-13
-- ============================================

-- 1. Patients
CREATE TABLE patients (
    patient_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    gender          ENUM('M','F','Other') NOT NULL,
    phone           VARCHAR(20)  UNIQUE,
    email           VARCHAR(100) UNIQUE,
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Doctors
CREATE TABLE doctors (
    doctor_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    specialty       VARCHAR(100)  NOT NULL,
    phone           VARCHAR(20),
    email           VARCHAR(100) UNIQUE,
    hired_date      DATE          NOT NULL,
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. Appointments
CREATE TABLE appointments (
    appointment_id  INT AUTO_INCREMENT PRIMARY KEY,
    patient_id      INT NOT NULL,
    doctor_id       INT NOT NULL,
    appointment_dt  DATETIME      NOT NULL,
    status          ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
    created_at      TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Treatments
CREATE TABLE treatments (
    treatment_id    INT AUTO_INCREMENT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL UNIQUE,
    description     TEXT,
    cost            DECIMAL(10,2) NOT NULL CHECK (cost >= 0)
) ENGINE=InnoDB;

-- 5. Appointment_Treatments (M–M between appointments and treatments)
CREATE TABLE appointment_treatments (
    appointment_id  INT NOT NULL,
    treatment_id    INT NOT NULL,
    quantity        INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    PRIMARY KEY (appointment_id, treatment_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Prescriptions
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id  INT NOT NULL,
    medication      VARCHAR(100) NOT NULL,
    dosage          VARCHAR(50)  NOT NULL,
    frequency       VARCHAR(50)  NOT NULL,
    duration_days   INT          NOT NULL CHECK (duration_days > 0),
    notes           TEXT,
    created_at      TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;