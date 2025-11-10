CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary FLOAT
);

INSERT INTO employees (id, name, salary)
VALUES (1, 'Alice', 50000.00),
       (2, 'Bob', 60000.50);

SELECT name, salary
FROM employees
WHERE salary >= 50000 AND name LIKE 'A%';
