-- Core Tables
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(255),
  role ENUM('user', 'admin', 'family', 'recruiter') DEFAULT 'user',
  two_factor_secret VARCHAR(255),
  is_verified BOOLEAN DEFAULT FALSE,
  is_banned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_users_email (email)
);

CREATE TABLE profiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  age INT CHECK (age BETWEEN 18 AND 100),
  religion VARCHAR(100),
  profession VARCHAR(255),
  skills JSON,
  resume_url VARCHAR(512),
  discovery_mode ENUM('arranged', 'modern', 'professional') DEFAULT 'modern',
  is_profile_verified BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_profiles_profession (profession)
);

-- Match System
CREATE TABLE matches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  target_user_id INT NOT NULL,
  status ENUM('pending', 'accepted', 'rejected') DEFAULT 'pending',
  compatibility_score FLOAT,
  last_interaction TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_matches_user (user_id),
  INDEX idx_matches_target (target_user_id)
);

-- Communication
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id VARCHAR(255) NOT NULL,
  sender_id INT NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_message_room (room_id)
);

-- Payments
CREATE TABLE subscriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  plan_id INT NOT NULL,
  gateway ENUM('razorpay', 'paypal') NOT NULL,
  gateway_id VARCHAR(255) NOT NULL,
  status ENUM('active', 'canceled') DEFAULT 'active',
  start_date DATE NOT NULL,
  end_date DATE NOT NULL
);

-- Admin System
CREATE TABLE admin_actions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  admin_id INT NOT NULL,
  action_type VARCHAR(255) NOT NULL,
  target_id INT NOT NULL,
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
