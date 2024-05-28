-- Hack 3
CREATE TABLE priorities (
  id_priority serial primary key,
  type_name varchar(50) not null
);

CREATE TABLE countries (
  id_country serial primary key,
  name varchar(50) not null
);

CREATE TABLE contact_request (
  id_contact_request serial primary key,
  email VARCHAR(255) UNIQUE NOT NULL,
  id_country INT UNIQUE REFERENCES countries(id_country),
  id_priority INT UNIQUE REFERENCES priorities(id_priority),
  name varchar(50) not null,
  DETAIL VARCHAR(100),
  physical_address VARCHAR(100)
);

-- Hack 4
-- Insert
INSERT into countries (name) VALUES ('Venezuela'), ('Colombia'), ('Perú'), ('España'), ('Chile');
INSERT into priorities (type_name) VALUES ('Francisco'), ('Geraldo'), ('José');
INSERT into contact_request (email,id_country,id_priority,name,detail,physical_address) 
VALUES ('correo1@gmail.com',1,1,'Francisco', 'Un Chamo', 'Calle Independencia'), 
('correo2@gmail.com',2,2,'Geraldo', 'Otro chamo', 'Cerca de Insalud'), 
('correo3@gmail.com',3,3,'José', 'Nadie sabe quien es', 'Entre Paez y Muños');
-- Delete
DELETE FROM contact_request WHERE id_contact_request = 
(SELECT id_contact_request FROM contact_request ORDER by id_contact_request DESC LIMIT 1);
-- Update
UPDATE contact_request set (email, name, detail, physical_address) = ('correo4@gmail.com','Daniel', 'Civil', 'San Rafael') 
WHERE id_contact_request = (SELECT MIN(id_contact_request) FROM contact_request);