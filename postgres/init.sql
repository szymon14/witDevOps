CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    semester INT NOT NULL
);

INSERT INTO students (name, surname, course_name, semester) VALUES
('Jan', 'Kowalski', 'Informatyka', 1),
('Anna', 'Nowak', 'Matematyka', 2),
('Katarzyna', 'Wiśniewska', 'Fizyka', 3),
('Michał', 'Wójcik', 'Chemia', 4),
('Piotr', 'Kowalczyk', 'Biologia', 2),
('Agnieszka', 'Kamińska', 'Historia', 3),
('Tomasz', 'Lewandowski', 'Geografia', 1),
('Monika', 'Zielińska', 'Filologia Polska', 4),
('Krzysztof', 'Szymański', 'Ekonomia', 2),
('Magdalena', 'Woźniak', 'Filozofia', 3);
