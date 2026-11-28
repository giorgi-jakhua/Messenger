CREATE DATABASE IF NOT EXISTS messenger;
USE messenger;

CREATE TABLE IF NOT EXISTS users (
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_username_length CHECK (CHAR_LENGTH(username) >= 3),
    CONSTRAINT chk_username_characters CHECK (username REGEXP '^[A-Za-z0-9_]+$'),
    CONSTRAINT chk_password_length CHECK (CHAR_LENGTH(password) >=4)
);

CREATE TABLE IF NOT EXISTS rooms (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_name_length CHECK (CHAR_LENGTH(name) >=2),
    CONSTRAINT chk_name_lowercase CHECK (name = LOWER(name)),
    CONSTRAINT chk_name_characters CHECK (name REGEXP '^[a-z0-9-]+$')
);

CREATE TABLE IF NOT EXISTS messages (
	id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT NOT NULL,
    room_id INT NULL,
    receiver_id INT NULL,
    text VARCHAR(500) NOT NULL,
    sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_sender_id_users_id
		FOREIGN KEY (sender_id) REFERENCES users(id)
        ON DELETE RESTRICT,
        
	CONSTRAINT fk_room_id_rooms_id
		FOREIGN KEY (room_id) REFERENCES rooms(id)
        ON DELETE RESTRICT,
	
    CONSTRAINT fk_receiver_id_users_id
		FOREIGN KEY (receiver_id) REFERENCES users(id)
        ON DELETE RESTRICT,
        
	CONSTRAINT chk_room_or_receiver_null CHECK ((room_id IS NULL) <> (receiver_id IS NULL)),
    CONSTRAINT chk_text_not_empty CHECK (CHAR_LENGTH(TRIM(text)) > 0),
    CONSTRAINT chk_self_message CHECK (receiver_id IS NULL OR sender_id <> receiver_id)
);

INSERT IGNORE INTO rooms (name) VALUES ('general');