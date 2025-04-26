-- ENUM Types
CREATE TYPE intensity_enum AS ENUM ('low', 'medium', 'high');
CREATE TYPE fitness_enum AS ENUM ('poor', 'average', 'good', 'excellent');

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

-- Teams
INSERT INTO Teams (name, coach_name, stadium_name) VALUES 
('Manchester City', 'Pep Guardiola', 'Etihad Stadium'),
('Real Madrid', 'Carlo Ancelotti', 'Santiago Bernabéu'),
('Bayern Munich', 'Thomas Tuchel', 'Allianz Arena'),
('Paris Saint-Germain', 'Luis Enrique', 'Parc des Princes');

-- Players
INSERT INTO Players (name, age, nationality, position, jersey_number, is_injured, is_available, fitness_level, current_team_id) VALUES
('Erling Haaland', 23, 'Norway', 'Forward', 9, FALSE, TRUE, 'excellent', 1),
('Luka Modrić', 38, 'Croatia', 'Midfielder', 10, FALSE, TRUE, 'good', 2),
('Jamal Musiala', 21, 'Germany', 'Midfielder', 42, FALSE, TRUE, 'excellent', 3),
('Kylian Mbappé', 25, 'France', 'Forward', 7, TRUE, FALSE, 'good', 4);

-- Injuries
INSERT INTO Injuries (name, description, estimated_recovery_days) VALUES
('Hamstring Injury', 'Tear in hamstring muscle', 30),
('Ankle Sprain', 'Twist in ankle ligament', 14);

-- Player Injuries
INSERT INTO Player_Injuries (player_id, injury_id, injury_date, recovery_date) VALUES
(4, 1, '2025-04-15', '2025-05-15');

-- Fitness Routines
INSERT INTO Fitness_Routines (name, description, intensity_level) VALUES
('Explosive Sprinting', 'Improve explosive speed and agility', 'high'),
('Core Stability', 'Focus on core strength and balance', 'medium');

-- Player Fitness
INSERT INTO Player_Fitness (player_id, routine_id, start_date, end_date) VALUES
(1, 1, '2025-04-01', '2025-04-15'),
(2, 2, '2025-03-20', '2025-04-05');

-- Training Routines
INSERT INTO Training_Routines (name, description, focus_area, duration_minutes) VALUES
('Tactical Pressing', 'Organize high press situations', 'Pressing', 70),
('Quick Transition Play', 'Train fast counter-attacks', 'Counter-Attack', 60);

-- Player Training
INSERT INTO Player_Training (player_id, training_id, date) VALUES
(1, 1, '2025-04-10'),
(3, 2, '2025-04-11');

-- Transfers
INSERT INTO Transfers (player_id, from_team, to_team, transfer_fee, transfer_date) VALUES
(3, 3, 1, 80000000.00, '2025-06-01');

-- Strategies
INSERT INTO Strategies (name, description, formation) VALUES
('High Press 4-3-3', 'Aggressive pressing with front three', '4-3-3'),
('Defensive 4-2-3-1', 'Solid defensive shape with counters', '4-2-3-1');

-- Matches
INSERT INTO Matches (home_team_id, away_team_id, match_date, venue, home_score, away_score, is_played, our_strategy_id) VALUES
(1, 2, '2025-04-30', 'Etihad Stadium', 2, 1, TRUE, 1),
(3, 4, '2025-05-05', 'Allianz Arena', 1, 3, TRUE, 2);

-- Opponent Strategies
INSERT INTO Match_Opponent_Strategies (match_id, strategy_id, opponent_team_id) VALUES
(1, 2, 2),
(2, 1, 4);

-- League Standings
INSERT INTO League_Standings (team_id, games_played, wins, draws, losses, goals_for, goals_against, points) VALUES
(1, 6, 5, 0, 1, 15, 5, 15),
(2, 6, 4, 1, 1, 12, 6, 13),
(3, 6, 3, 2, 1, 10, 8, 11),
(4, 6, 2, 1, 3, 9, 11, 7);

-- Transfer Market
INSERT INTO TransferMarket (player_id, current_team_id, asking_price, listing_date, is_available) VALUES
(2, 2, 30000000.00, '2025-04-20', TRUE),
(4, 4, 120000000.00, '2025-04-21', TRUE);

