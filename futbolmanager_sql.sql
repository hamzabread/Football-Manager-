
-- ENUM Types
CREATE TYPE intensity_enum AS ENUM ('low', 'medium', 'high');
CREATE TYPE fitness_enum AS ENUM ('poor', 'average', 'good', 'excellent');

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UserTeams (
    user_id INT REFERENCES Users(user_id) ,
    team_id INT REFERENCES Teams(team_id) ,
    PRIMARY KEY (user_id, team_id)
);

-- Teams
CREATE TABLE Teams (
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    coach_name VARCHAR(100),
    stadium_name VARCHAR(100)
);

-- Players
CREATE TABLE Players (
    player_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    nationality VARCHAR(50),
    position VARCHAR(50),
    jersey_number INT,
    is_injured BOOLEAN,
    is_available BOOLEAN,
    fitness_level fitness_enum,
    current_team_id INT REFERENCES Teams(team_id) ON DELETE SET NULL
);

-- Injuries
CREATE TABLE Injuries (
    injury_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    estimated_recovery_days INT
);

-- Player Injuries
CREATE TABLE Player_Injuries (
    player_injury_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES Players(player_id),
    injury_id INT REFERENCES Injuries(injury_id),
    injury_date DATE,
    recovery_date DATE
);

-- Fitness Routines
CREATE TABLE Fitness_Routines (
    routine_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    intensity_level intensity_enum
);

-- Player Fitness
CREATE TABLE Player_Fitness (
    player_fitness_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES Players(player_id),
    routine_id INT REFERENCES Fitness_Routines(routine_id),
    start_date DATE,
    end_date DATE
);

-- Training Routines
CREATE TABLE Training_Routines (
    training_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    focus_area VARCHAR(50),
    duration_minutes INT
);

-- Player Training
CREATE TABLE Player_Training (
    player_training_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES Players(player_id),
    training_id INT REFERENCES Training_Routines(training_id),
    date DATE
);

-- Transfers
CREATE TABLE Transfers (
    transfer_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES Players(player_id),
    from_team INT REFERENCES Teams(team_id),
    to_team INT REFERENCES Teams(team_id),
    transfer_fee DECIMAL(12, 2),
    transfer_date DATE
);

-- Strategies
CREATE TABLE Strategies (
    strategy_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    formation VARCHAR(20)
);

-- Matches
CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    home_team_id INT REFERENCES Teams(team_id),
    away_team_id INT REFERENCES Teams(team_id),
    match_date DATE,
    venue VARCHAR(100),
    home_score INT,
    away_score INT,
    is_played BOOLEAN,
    our_strategy_id INT REFERENCES Strategies(strategy_id)
);

-- Opponent Strategies
CREATE TABLE Match_Opponent_Strategies (
    match_strategy_id SERIAL PRIMARY KEY,
    match_id INT REFERENCES Matches(match_id),
    strategy_id INT REFERENCES Strategies(strategy_id),
    opponent_team_id INT REFERENCES Teams(team_id)
);

-- League Standings
CREATE TABLE League_Standings (
    team_id INT PRIMARY KEY REFERENCES Teams(team_id),
    games_played INT,
    wins INT,
    draws INT,
    losses INT,
    goals_for INT,
    goals_against INT,
    points INT
);

-- Transfer Market
CREATE TABLE TransferMarket (
    listing_id SERIAL PRIMARY KEY,
    player_id INT REFERENCES Players(player_id),
    current_team_id INT REFERENCES Teams(team_id),
    asking_price DECIMAL(12, 2),
    listing_date DATE,
    is_available BOOLEAN DEFAULT TRUE
);

---------------------------------------------------------
-- 🌟 Insert Sample Real World UCL Data
---------------------------------------------------------


INSERT INTO Teams (name, coach_name, stadium_name) VALUES 
('Manchester City', 'Pep Guardiola', 'Etihad Stadium'),
('Real Madrid', 'Carlo Ancelotti', 'Santiago Bernabéu'),
('Bayern Munich', 'Thomas Tuchel', 'Allianz Arena'),
('Paris Saint-Germain', 'Luis Enrique', 'Parc des Princes'),
('Barcelona', 'Xavi Hernandez', 'Camp Nou'),
('Liverpool', 'Jürgen Klopp', 'Anfield'),
('Chelsea', 'Mauricio Pochettino', 'Stamford Bridge'),
('Juventus', 'Massimiliano Allegri', 'Allianz Stadium'),
('AC Milan', 'Stefano Pioli', 'San Siro'),
('Borussia Dortmund', 'Edin Terzić', 'Signal Iduna Park');


INSERT INTO Players (name, age, nationality, position, jersey_number, is_injured, is_available, fitness_level, current_team_id) VALUES
('Erling Haaland', 23, 'Norway', 'Forward', 9, FALSE, TRUE, 'excellent', 1),
('Luka Modrić', 38, 'Croatia', 'Midfielder', 10, FALSE, TRUE, 'good', 2),
('Jamal Musiala', 21, 'Germany', 'Midfielder', 42, FALSE, TRUE, 'excellent', 3),
('Kylian Mbappé', 25, 'France', 'Forward', 7, TRUE, FALSE, 'good', 4),
('Pedri', 21, 'Spain', 'Midfielder', 8, FALSE, TRUE, 'excellent', 5),
('Mohamed Salah', 32, 'Egypt', 'Forward', 11, FALSE, TRUE, 'good', 6),
('Reece James', 24, 'England', 'Defender', 24, TRUE, FALSE, 'good', 7),
('Dusan Vlahovic', 25, 'Serbia', 'Forward', 9, FALSE, TRUE, 'good', 8),
('Rafael Leao', 25, 'Portugal', 'Forward', 17, FALSE, TRUE, 'excellent', 9),
('Jude Bellingham', 22, 'England', 'Midfielder', 5, FALSE, TRUE, 'excellent', 2);


INSERT INTO Injuries (name, description, estimated_recovery_days) VALUES
('Hamstring Injury', 'Tear in hamstring muscle', 30),
('Ankle Sprain', 'Twist in ankle ligament', 14),
('Groin Strain', 'Strain in groin muscles', 21),
('Concussion', 'Head injury', 10),
('Broken Ankle', 'Fractured ankle bone', 90),
('ACL Tear', 'Anterior Cruciate Ligament tear', 180),
('Dislocated Shoulder', 'Shoulder displacement', 60),
('Back Spasms', 'Lower back muscle cramps', 20),
('Calf Strain', 'Tear in calf muscle', 25),
('Wrist Fracture', 'Broken wrist bone', 45);

INSERT INTO Player_Injuries (player_id, injury_id, injury_date, recovery_date) VALUES
(4, 1, '2025-04-15', '2025-05-15'),
(7, 2, '2025-04-10', '2025-04-24'),
(6, 3, '2025-04-05', '2025-04-26'),
(5, 4, '2025-04-01', '2025-04-11'),
(8, 5, '2025-04-18', '2025-07-18'),
(9, 6, '2025-04-20', '2025-10-20'),
(2, 7, '2025-04-03', '2025-06-02'),
(1, 8, '2025-04-22', '2025-05-12'),
(3, 9, '2025-04-25', '2025-05-20'),
(10, 10, '2025-04-30', '2025-06-15');

INSERT INTO Fitness_Routines (name, description, intensity_level) VALUES
('Explosive Sprinting', 'Improve explosive speed and agility', 'high'),
('Core Stability', 'Focus on core strength and balance', 'medium'),
('Endurance Running', 'Long-distance stamina building', 'medium'),
('Weight Training', 'Muscle mass and strength', 'high'),
('Yoga Flexibility', 'Enhance flexibility and breathing', 'low'),
('Agility Drills', 'Quick movement exercises', 'high'),
('Balance Training', 'Enhance equilibrium and stability', 'low'),
('Plyometric Jumps', 'Power and speed building', 'high'),
('Speed Ladder', 'Footwork and speed', 'medium'),
('Resistance Band Training', 'Strengthen muscles safely', 'medium');


INSERT INTO Player_Fitness (player_id, routine_id, start_date, end_date) VALUES
(1, 1, '2025-04-01', '2025-04-15'),
(2, 2, '2025-03-20', '2025-04-05'),
(3, 3, '2025-04-10', '2025-04-25'),
(4, 4, '2025-04-12', '2025-04-26'),
(5, 5, '2025-04-03', '2025-04-18'),
(6, 6, '2025-04-05', '2025-04-20'),
(7, 7, '2025-04-07', '2025-04-22'),
(8, 8, '2025-04-09', '2025-04-24'),
(9, 9, '2025-04-11', '2025-04-26'),
(10, 10, '2025-04-13', '2025-04-28');


INSERT INTO Training_Routines (name, description, focus_area, duration_minutes) VALUES
('Tactical Pressing', 'Organize high press situations', 'Pressing', 70),
('Quick Transition Play', 'Train fast counter-attacks', 'Counter-Attack', 60),
('Possession Play', 'Retain ball under pressure', 'Possession', 75),
('Crossing and Finishing', 'Perfect crosses and shots', 'Attacking', 65),
('Defensive Drills', 'Strengthen defensive structure', 'Defense', 80),
('Build-up Play', 'Structured play from back', 'Possession', 70),
('Free Kick Masterclass', 'Practice set pieces', 'Set Pieces', 50),
('Corner Strategies', 'Corner attack and defense', 'Set Pieces', 55),
('Midfield Control', 'Midfield domination', 'Control', 60),
('Press Breakers', 'Breaking high press', 'Defense', 65);


INSERT INTO Player_Training (player_id, training_id, date) VALUES
(1, 1, '2025-04-10'),
(3, 2, '2025-04-11'),
(5, 3, '2025-04-12'),
(6, 4, '2025-04-13'),
(2, 5, '2025-04-14'),
(7, 6, '2025-04-15'),
(8, 7, '2025-04-16'),
(9, 8, '2025-04-17'),
(4, 9, '2025-04-18'),
(10, 10, '2025-04-19');


INSERT INTO Transfers (player_id, from_team, to_team, transfer_fee, transfer_date) VALUES
(3, 3, 1, 80000000.00, '2025-06-01'),
(2, 2, 6, 30000000.00, '2025-07-01'),
(5, 5, 7, 60000000.00, '2025-07-15'),
(6, 6, 2, 70000000.00, '2025-07-20'),
(7, 7, 4, 50000000.00, '2025-07-22'),
(8, 8, 9, 75000000.00, '2025-07-25'),
(9, 9, 10, 45000000.00, '2025-07-27'),
(10, 2, 1, 85000000.00, '2025-08-01'),
(1, 1, 3, 95000000.00, '2025-08-05'),
(4, 4, 8, 120000000.00, '2025-08-10');

INSERT INTO Strategies (name, description, formation) VALUES
('High Press 4-3-3', 'Aggressive pressing with front three', '4-3-3'),
('Defensive 4-2-3-1', 'Solid defensive shape with counters', '4-2-3-1'),
('Wide 4-4-2', 'Focus on wing attacks', '4-4-2'),
('Narrow 4-1-2-1-2', 'Play through the middle', '4-1-2-1-2'),
('Counter 5-3-2', 'Defend deep and counter', '5-3-2'),
('Possession 3-5-2', 'Dominate midfield', '3-5-2'),
('Attacking 4-3-1-2', 'Flood the attack', '4-3-1-2'),
('Park the Bus', 'Ultra-defensive', '5-4-1'),
('Overlapping Fullbacks', 'Fullback attack support', '4-3-3'),
('False Nine Play', 'Deceptive striker movement', '4-6-0');


INSERT INTO Matches (home_team_id, away_team_id, match_date, venue, home_score, away_score, is_played, our_strategy_id) VALUES
(1, 2, '2025-04-30', 'Etihad Stadium', 2, 1, TRUE, 1),
(3, 4, '2025-05-05', 'Allianz Arena', 1, 3, TRUE, 2),
(5, 6, '2025-05-10', 'Camp Nou', 3, 2, TRUE, 3),
(7, 8, '2025-05-12', 'Stamford Bridge', 0, 1, TRUE, 4),
(9, 10, '2025-05-15', 'San Siro', 2, 2, TRUE, 5),
(1, 5, '2025-05-18', 'Etihad Stadium', 1, 0, TRUE, 6),
(2, 6, '2025-05-20', 'Santiago Bernabéu', 2, 2, TRUE, 7),
(3, 7, '2025-05-22', 'Allianz Arena', 1, 1, TRUE, 8),
(4, 8, '2025-05-25', 'Parc des Princes', 3, 1, TRUE, 9),
(5, 9, '2025-05-28', 'Camp Nou', 2, 1, TRUE, 10);


INSERT INTO Match_Opponent_Strategies (match_id, strategy_id, opponent_team_id) VALUES
(1, 2, 2),
(2, 1, 4),
(3, 4, 6),
(4, 5, 8),
(5, 6, 10),
(6, 7, 5),
(7, 8, 6),
(8, 9, 7),
(9, 10, 8),
(10, 1, 9);


INSERT INTO League_Standings (team_id, games_played, wins, draws, losses, goals_for, goals_against, points) VALUES
(1, 6, 5, 0, 1, 15, 5, 15),
(2, 6, 4, 1, 1, 12, 6, 13),
(3, 6, 3, 2, 1, 10, 8, 11),
(4, 6, 2, 1, 3, 9, 11, 7),
(5, 6, 2, 2, 2, 8, 9, 8),
(6, 6, 3, 1, 2, 10, 7, 10),
(7, 6, 1, 2, 3, 6, 10, 5),
(8, 6, 2, 1, 3, 7, 11, 7),
(9, 6, 3, 0, 3, 8, 8, 9),
(10, 6, 2, 2, 2, 7, 9, 8);


INSERT INTO TransferMarket (player_id, current_team_id, asking_price, listing_date, is_available) VALUES
(2, 2, 30000000.00, '2025-04-20', TRUE),
(4, 4, 120000000.00, '2025-04-21', TRUE),
(6, 6, 75000000.00, '2025-04-22', TRUE),
(8, 8, 65000000.00, '2025-04-23', TRUE),
(10, 2, 85000000.00, '2025-04-24', TRUE),
(1, 1, 95000000.00, '2025-04-25', TRUE),
(5, 5, 70000000.00, '2025-04-26', TRUE),
(7, 7, 55000000.00, '2025-04-27', TRUE),
(9, 9, 60000000.00, '2025-04-28', TRUE),
(3, 3, 80000000.00, '2025-04-29', TRUE);

-- ===============================
-- DELETED USER ARCHIVE STRUCTURE
-- ===============================
-- Deleted Strategies
CREATE TABLE Deleted_Strategies (
    strategy_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    formation VARCHAR(20)
);

-- Deleted Matches
CREATE TABLE Deleted_Matches (
    match_id SERIAL PRIMARY KEY,
    home_team_id INT REFERENCES Teams(team_id),
    away_team_id INT REFERENCES Teams(team_id),
    match_date DATE,
    venue VARCHAR(100),
    home_score INT,
    away_score INT,
    is_played BOOLEAN,
    our_strategy_id INT REFERENCES Strategies(strategy_id)
);

-- Deleted Match Opponent Strategies
CREATE TABLE Deleted_Match_Opponent_Strategies (
    match_strategy_id SERIAL PRIMARY KEY,
    match_id INT REFERENCES Matches(match_id),
    strategy_id INT REFERENCES Strategies(strategy_id),
    opponent_team_id INT REFERENCES Teams(team_id)
);


CREATE TABLE Deleted_Users (
    deleted_user_id SERIAL PRIMARY KEY,
    original_user_id INT REFERENCES Users(user_id) ON DELETE SET NULL,
    deletion_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Deleted_UserTeams (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    team_id INT,
    PRIMARY KEY (deleted_user_id, team_id)
);

CREATE TABLE Deleted_Teams (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    team_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    coach_name VARCHAR(100),
    stadium_name VARCHAR(100)
);

CREATE TABLE Deleted_Players (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    player_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    nationality VARCHAR(50),
    position VARCHAR(50),
    jersey_number INT,
    is_injured BOOLEAN,
    is_available BOOLEAN,
    fitness_level fitness_enum,
    current_team_id INT
);

CREATE TABLE Deleted_Injuries (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    injury_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    estimated_recovery_days INT
);

CREATE TABLE Deleted_Player_Injuries (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    player_injury_id SERIAL PRIMARY KEY,
    player_id INT,
    injury_id INT,
    injury_date DATE,
    recovery_date DATE
);

CREATE TABLE Deleted_Fitness_Routines (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    routine_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    intensity_level intensity_enum
);

CREATE TABLE Deleted_Player_Fitness (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    player_fitness_id SERIAL PRIMARY KEY,
    player_id INT,
    routine_id INT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE Deleted_Training_Routines (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    training_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    focus_area VARCHAR(50),
    duration_minutes INT
);

CREATE TABLE Deleted_Player_Training (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    player_training_id SERIAL PRIMARY KEY,
    player_id INT,
    training_id INT,
    date DATE
);

CREATE TABLE Deleted_Transfers (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    transfer_id SERIAL PRIMARY KEY,
    player_id INT,
    from_team INT,
    to_team INT,
    transfer_fee DECIMAL(12, 2),
    transfer_date DATE
);

CREATE TABLE Deleted_League_Standings (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    team_id INT,
    games_played INT,
    wins INT,
    draws INT,
    losses INT,
    goals_for INT,
    goals_against INT,
    points INT,
    PRIMARY KEY (deleted_user_id, team_id)
);

CREATE TABLE Deleted_TransferMarket (
    deleted_user_id INT REFERENCES Deleted_Users(deleted_user_id),
    listing_id SERIAL PRIMARY KEY,
    player_id INT,
    current_team_id INT,
    asking_price DECIMAL(12, 2),
    listing_date DATE,
    is_available BOOLEAN
);
CREATE OR REPLACE FUNCTION archive_user_data_before_delete() RETURNS TRIGGER AS $$
DECLARE
    deleted_user_id INT;
BEGIN
    -- Step 1: Insert into Deleted_Users and get the new deleted_user_id
    INSERT INTO Deleted_Users (
        original_user_id,
        user_uuid,
        username,
        email,
        password_hash,
        is_admin,
        is_active,
        created_at,
        deleted_at
    )
    VALUES (
        OLD.user_id,
        OLD.user_uuid,
        OLD.username,
        OLD.email,
        OLD.password_hash,
        OLD.is_admin,
        OLD.is_active,
        OLD.created_at,
        NOW()
    )
    RETURNING deleted_user_id INTO deleted_user_id;

    -- Step 2: Archive related data
    INSERT INTO Deleted_UserTeams (deleted_user_id, team_id)
    SELECT deleted_user_id, team_id FROM UserTeams WHERE user_id = OLD.user_id;

    INSERT INTO Deleted_Teams (deleted_user_id, team_id, name, coach_name, stadium_name)
    SELECT deleted_user_id, t.team_id, t.name, t.coach_name, t.stadium_name
    FROM Teams t
    JOIN UserTeams ut ON t.team_id = ut.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Players (deleted_user_id, player_id, name, age, nationality, position, jersey_number, is_injured, is_available, fitness_level, current_team_id)
    SELECT deleted_user_id, p.player_id, p.name, p.age, p.nationality, p.position, p.jersey_number, p.is_injured, p.is_available, p.fitness_level, p.current_team_id
    FROM Players p
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Player_Injuries (deleted_user_id, player_injury_id, player_id, injury_id, injury_date, recovery_date)
    SELECT deleted_user_id, pi.player_injury_id, pi.player_id, pi.injury_id, pi.injury_date, pi.recovery_date
    FROM Player_Injuries pi
    JOIN Players p ON pi.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Fitness_Routines (deleted_user_id, routine_id, name, description, intensity_level)
    SELECT DISTINCT deleted_user_id, fr.routine_id, fr.name, fr.description, fr.intensity_level
    FROM Fitness_Routines fr
    JOIN Player_Fitness pf ON fr.routine_id = pf.routine_id
    JOIN Players p ON pf.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Player_Fitness (deleted_user_id, player_fitness_id, player_id, routine_id, start_date, end_date)
    SELECT deleted_user_id, pf.player_fitness_id, pf.player_id, pf.routine_id, pf.start_date, pf.end_date
    FROM Player_Fitness pf
    JOIN Players p ON pf.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Training_Routines (deleted_user_id, training_id, name, description, focus_area, duration_minutes)
    SELECT DISTINCT deleted_user_id, tr.training_id, tr.name, tr.description, tr.focus_area, tr.duration_minutes
    FROM Training_Routines tr
    JOIN Player_Training pt ON tr.training_id = pt.training_id
    JOIN Players p ON pt.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Player_Training (deleted_user_id, player_training_id, player_id, training_id, date)
    SELECT deleted_user_id, pt.player_training_id, pt.player_id, pt.training_id, pt.date
    FROM Player_Training pt
    JOIN Players p ON pt.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_Transfers (deleted_user_id, transfer_id, player_id, from_team, to_team, transfer_fee, transfer_date)
    SELECT deleted_user_id, tr.transfer_id, tr.player_id, tr.from_team, tr.to_team, tr.transfer_fee, tr.transfer_date
    FROM Transfers tr
    JOIN Players p ON tr.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_League_Standings (deleted_user_id, team_id, games_played, wins, draws, losses, goals_for, goals_against, points)
    SELECT deleted_user_id, ls.team_id, ls.games_played, ls.wins, ls.draws, ls.losses, ls.goals_for, ls.goals_against, ls.points
    FROM League_Standings ls
    JOIN UserTeams ut ON ls.team_id = ut.team_id
    WHERE ut.user_id = OLD.user_id;

    INSERT INTO Deleted_TransferMarket (deleted_user_id, listing_id, player_id, current_team_id, asking_price, listing_date, is_available)
    SELECT deleted_user_id, tm.listing_id, tm.player_id, tm.current_team_id, tm.asking_price, tm.listing_date, tm.is_available
    FROM TransferMarket tm
    JOIN Players p ON tm.player_id = p.player_id
    JOIN Teams t ON p.current_team_id = t.team_id
    JOIN UserTeams ut ON ut.team_id = t.team_id
    WHERE ut.user_id = OLD.user_id;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;



CREATE TRIGGER trigger_archive_user_data
BEFORE DELETE ON users
FOR EACH ROW
EXECUTE FUNCTION archive_user_data_before_delete();
 
-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Add a UUID column with default generation
ALTER TABLE users
ADD COLUMN user_uuid UUID DEFAULT uuid_generate_v4() UNIQUE;

ALTER TABLE Deleted_Users
ADD COLUMN user_uuid UUID;

-- Function and Trigger for Players table
CREATE OR REPLACE FUNCTION archive_player_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Players (deleted_user_id, player_id, name, age, nationality, position, jersey_number, is_injured, is_available, fitness_level, current_team_id)
    SELECT OLD.deleted_user_id, OLD.player_id, OLD.name, OLD.age, OLD.nationality, OLD.position, OLD.jersey_number, OLD.is_injured, OLD.is_available, OLD.fitness_level, OLD.current_team_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_player_data_before_delete_trigger
BEFORE DELETE ON Players
FOR EACH ROW EXECUTE FUNCTION archive_player_data_before_delete();

-- Function and Trigger for Teams table
CREATE OR REPLACE FUNCTION archive_team_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Teams (deleted_user_id, team_id, name, coach_name, stadium_name)
    SELECT OLD.deleted_user_id, OLD.team_id, OLD.name, OLD.coach_name, OLD.stadium_name;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_team_data_before_delete_trigger
BEFORE DELETE ON Teams
FOR EACH ROW EXECUTE FUNCTION archive_team_data_before_delete();

-- Function and Trigger for Transfers table
CREATE OR REPLACE FUNCTION archive_transfer_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Transfers (deleted_user_id, transfer_id, player_id, from_team, to_team, transfer_fee, transfer_date)
    SELECT OLD.deleted_user_id, OLD.transfer_id, OLD.player_id, OLD.from_team, OLD.to_team, OLD.transfer_fee, OLD.transfer_date;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_transfer_data_before_delete_trigger
BEFORE DELETE ON Transfers
FOR EACH ROW EXECUTE FUNCTION archive_transfer_data_before_delete();

-- Function and Trigger for Injuries table
CREATE OR REPLACE FUNCTION archive_injury_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Injuries (deleted_user_id, injury_id, name, description, estimated_recovery_days)
    SELECT OLD.deleted_user_id, OLD.injury_id, OLD.name, OLD.description, OLD.estimated_recovery_days;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_injury_data_before_delete_trigger
BEFORE DELETE ON Injuries
FOR EACH ROW EXECUTE FUNCTION archive_injury_data_before_delete();

-- Function and Trigger for Player Injuries table
CREATE OR REPLACE FUNCTION archive_player_injury_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Player_Injuries (deleted_user_id, player_injury_id, player_id, injury_id, injury_date, recovery_date)
    SELECT OLD.deleted_user_id, OLD.player_injury_id, OLD.player_id, OLD.injury_id, OLD.injury_date, OLD.recovery_date;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_player_injury_data_before_delete_trigger
BEFORE DELETE ON Player_Injuries
FOR EACH ROW EXECUTE FUNCTION archive_player_injury_data_before_delete();

-- Function and Trigger for Fitness Routines table
CREATE OR REPLACE FUNCTION archive_fitness_routine_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Fitness_Routines (deleted_user_id, routine_id, name, description, intensity_level)
    SELECT OLD.deleted_user_id, OLD.routine_id, OLD.name, OLD.description, OLD.intensity_level;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_fitness_routine_data_before_delete_trigger
BEFORE DELETE ON Fitness_Routines
FOR EACH ROW EXECUTE FUNCTION archive_fitness_routine_data_before_delete();

-- Function and Trigger for Player Fitness table
CREATE OR REPLACE FUNCTION archive_player_fitness_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Player_Fitness (deleted_user_id, player_fitness_id, player_id, routine_id, start_date, end_date)
    SELECT OLD.deleted_user_id, OLD.player_fitness_id, OLD.player_id, OLD.routine_id, OLD.start_date, OLD.end_date;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_player_fitness_data_before_delete_trigger
BEFORE DELETE ON Player_Fitness
FOR EACH ROW EXECUTE FUNCTION archive_player_fitness_data_before_delete();

-- Function and Trigger for Training Routines table
CREATE OR REPLACE FUNCTION archive_training_routine_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Training_Routines (deleted_user_id, training_id, name, description, focus_area, duration_minutes)
    SELECT OLD.deleted_user_id, OLD.training_id, OLD.name, OLD.description, OLD.focus_area, OLD.duration_minutes;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_training_routine_data_before_delete_trigger
BEFORE DELETE ON Training_Routines
FOR EACH ROW EXECUTE FUNCTION archive_training_routine_data_before_delete();

-- Function and Trigger for Player Training table
CREATE OR REPLACE FUNCTION archive_player_training_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_Player_Training (deleted_user_id, player_training_id, player_id, training_id, date)
    SELECT OLD.deleted_user_id, OLD.player_training_id, OLD.player_id, OLD.training_id, OLD.date;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_player_training_data_before_delete_trigger
BEFORE DELETE ON Player_Training
FOR EACH ROW EXECUTE FUNCTION archive_player_training_data_before_delete();

-- Function and Trigger for League Standings table
CREATE OR REPLACE FUNCTION archive_league_standing_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_League_Standings (deleted_user_id, team_id, games_played, wins, draws, losses, goals_for, goals_against, points)
    SELECT OLD.deleted_user_id, OLD.team_id, OLD.games_played, OLD.wins, OLD.draws, OLD.losses, OLD.goals_for, OLD.goals_against, OLD.points;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_league_standing_data_before_delete_trigger
BEFORE DELETE ON League_Standings
FOR EACH ROW EXECUTE FUNCTION archive_league_standing_data_before_delete();

-- Function and Trigger for Transfer Market table
CREATE OR REPLACE FUNCTION archive_transfer_market_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Deleted_TransferMarket (deleted_user_id, listing_id, player_id, current_team_id, asking_price, listing_date, is_available)
    SELECT OLD.deleted_user_id, OLD.listing_id, OLD.player_id, OLD.current_team_id, OLD.asking_price, OLD.listing_date, OLD.is_available;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER archive_transfer_market_data_before_delete_trigger
BEFORE DELETE ON TransferMarket
FOR EACH ROW EXECUTE FUNCTION archive_transfer_market_data_before_delete();

-- Function to archive data from Strategies before deletion
CREATE OR REPLACE FUNCTION archive_strategy_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    -- Archive the data from the Strategies table to the Deleted_Strategies table
    INSERT INTO Deleted_Strategies (strategy_id, name, description, formation)
    VALUES (OLD.strategy_id, OLD.name, OLD.description, OLD.formation);

    -- Return OLD to allow the delete operation
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger for archiving data from the Strategies table before deletion
CREATE TRIGGER before_delete_strategy
BEFORE DELETE ON Strategies
FOR EACH ROW
EXECUTE FUNCTION archive_strategy_data_before_delete();


-- Function to archive data from Match_Opponent_Strategies before deletion
CREATE OR REPLACE FUNCTION archive_match_opponent_strategy_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    -- Archive the data from the Match_Opponent_Strategies table to the Deleted_Match_Opponent_Strategies table
    INSERT INTO Deleted_Match_Opponent_Strategies (match_strategy_id, match_id, strategy_id, opponent_team_id)
    VALUES (OLD.match_strategy_id, OLD.match_id, OLD.strategy_id, OLD.opponent_team_id);

    -- Return OLD to allow the delete operation
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger for archiving data from the Match_Opponent_Strategies table before deletion
CREATE TRIGGER before_delete_match_opponent_strategy
BEFORE DELETE ON Match_Opponent_Strategies
FOR EACH ROW
EXECUTE FUNCTION archive_match_opponent_strategy_data_before_delete();


-- Function to archive data from Matches before deletion
CREATE OR REPLACE FUNCTION archive_match_data_before_delete() RETURNS TRIGGER AS $$
BEGIN
    -- Archive the data from the Matches table to the Deleted_Matches table
    INSERT INTO Deleted_Matches (match_id, home_team_id, away_team_id, match_date, venue, home_score, away_score, is_played, our_strategy_id)
    VALUES (OLD.match_id, OLD.home_team_id, OLD.away_team_id, OLD.match_date, OLD.venue, OLD.home_score, OLD.away_score, OLD.is_played, OLD.our_strategy_id);

    -- Return OLD to allow the delete operation
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Trigger for archiving data from the Matches table before deletion
CREATE TRIGGER before_delete_match
BEFORE DELETE ON Matches
FOR EACH ROW
EXECUTE FUNCTION archive_match_data_before_delete();
