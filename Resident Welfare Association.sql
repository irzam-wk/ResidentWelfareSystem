create database RWS;
-- Building information
CREATE TABLE Building (
    BuildingID INT PRIMARY KEY,
    BuildingName VARCHAR(50),
    BlockName VARCHAR(50),
    FloorNumber INT,
    FlatNumber INT
);

-- Flat / Apartment details
CREATE TABLE Flat (
    FlatID INT PRIMARY KEY,
    FloorNumber INT,
    FlatNumber VARCHAR(10),
    BuildingID INT,
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

-- Resident details
CREATE TABLE Resident (
    ResidentID INT PRIMARY KEY,
    Name VARCHAR(100),
    ContactNo VARCHAR(15),
    Email VARCHAR(100),
    FlatID INT,
    BuildingID INT,
    FOREIGN KEY (FlatID) REFERENCES Flat(FlatID),
    FOREIGN KEY (BuildingID) REFERENCES Building(BuildingID)
);

-- Visitor log
CREATE TABLE VisitorLog (
    VisitorID INT PRIMARY KEY,
    VisitorName VARCHAR(100),
    Address VARCHAR(150),
    ContactNo VARCHAR(15),
    Purpose VARCHAR(100),
    EntryTime DATETIME,
    ExitTime DATETIME,
    ResidentID INT,
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID)
);

-- Staff details
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    StaffName VARCHAR(100),
    Designation VARCHAR(50),
    ContactNo VARCHAR(15)
);

-- Complaint or Grievance
CREATE TABLE Complaint (
    ComplaintID INT PRIMARY KEY,
    ComplaintType VARCHAR(50),
    Description TEXT,
    DateFiled DATE,
    Status VARCHAR(30),
    Priority VARCHAR(20),
    ResidentID INT,
    AssignedTo INT,
    FOREIGN KEY (ResidentID) REFERENCES Resident(ResidentID),
    FOREIGN KEY (AssignedTo) REFERENCES Staff(StaffID)
);

-- Feedback table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    ComplaintID INT,
    Rating INT,
    Comments TEXT,
    FeedbackDate DATE,
    FOREIGN KEY (ComplaintID) REFERENCES Complaint(ComplaintID)
);

-- Maintenance Schedule
CREATE TABLE MaintenanceSchedule (
    ScheduleID INT PRIMARY KEY,
    WorkType VARCHAR(100),
    StartDate DATE,
    EndDate DATE,
    AssignedTo INT,
    Status VARCHAR(30),
    FOREIGN KEY (AssignedTo) REFERENCES Staff(StaffID)
);

-- Service table (like Cleaning, Gardening, etc.)
CREATE TABLE Service (
    ServiceID INT PRIMARY KEY,
    ServiceType VARCHAR(50),
    StaffID INT,
    ScheduleDate DATE,
    Status VARCHAR(30),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Assignment (links maintenance or service to staff)
CREATE TABLE Assignment (
    AssignmentID INT PRIMARY KEY,
    ScheduleID INT,
    StaffID INT,
    AssignedDate DATE,
    CompletedDate DATE,
    FOREIGN KEY (ScheduleID) REFERENCES MaintenanceSchedule(ScheduleID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- User Login Details
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Resident', 'Staff') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    PaymentMode VARCHAR(20), -- e.g., Cash, Card, UPI
    Status VARCHAR(30),      -- e.g., Paid, Pending, Failed
    ServiceID INT,
    PayerType VARCHAR(20),   -- 'Resident' or 'Management'
    PayerID INT,             -- If Resident pays, this = ResidentID
    ReceiverID INT,          -- StaffID or ManagementID
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID),
    FOREIGN KEY (PayerID) REFERENCES Resident(ResidentID),
    FOREIGN KEY (ReceiverID) REFERENCES Staff(StaffID)
);
