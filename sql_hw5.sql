-- Домашнее задание 5
-- В задании предлагается рассмотреть известную базу данных HR Oracle (ссылки на этой строке для общего развития, не обязательны): https://docs.oracle.com/en/database/oracle/oracle-database/12.2/comsc/HR-sample-schema-table-descriptions.html#GUID-506C25CE-FA5D-472A-9C4C-F9EF200823EE, https://github.com/oracle/db-sample-schemas/tree/main/human_resources

-- Скрипты для создания таблиц и заполнения их данными для разных СУБД: https://www.sqltutorial.org/sql-sample-database/

-- Необходимо написать 20 SQL-запросов (каждый по 0.5б), каждый из которых независимо будет решать описанную задачу.
-- В качестве решения необходимо сдать текстовый файл с расширением .sql, где останутся все условия, и после каждого условия будет написан решающий задачу код на SQL.

-- Укажите в конце этой строки СУБД, которую вы используете: PostgreSQL

-- 1
-- Таблица Employees. Получить список всех сотрудников из 5го и из 8го отдела (department_id), которых наняли в 1998 году
SELECT * FROM employees WHERE department_id IN (5,8) AND EXTRACT(YEAR FROM hire_date) = 1998;

-- 2
-- Таблица Employees. Получить список всех сотрудников, у которых в имени содержатся минимум 2 буквы 'n'
SELECT * FROM employees WHERE first_name like '%n%n';

-- 3
-- Таблица Employees. Получить список всех сотрудников, у которых зарплата находится в промежутке от 8000 до 9000 (включительно) и/или кратна 1000
SELECT * FROM employees WHERE salary >= 8000 AND salary <= 9000 OR (salary%1000)=0;

-- 4
-- Таблица Employees. Получить список всех сотрудников, у которых длина имени больше 10 букв и/или у которых в имени есть буква 'b' (без учета регистра)
SELECT * FROM employees WHERE LENGTH(first_name)>10 OR LOWER(first_name) like '%b%';

-- 5
-- Таблица Employees. Получить первое трёхзначное число телефонного номера сотрудника, если его номер в формате ХХХ.ХХХ.ХХХХ
SELECT SUBSTRING(phone_number, 1, 3) FROM Employees;

-- 6
-- Таблица Departments. Получить первое слово из имени департамента для тех, у кого в названии больше одного слова
SELECT SPLIT_PART(department_name, ' ', 1) FROM departments WHERE department_name like '% %';

-- 7
-- Таблица Employees. Получить список всех сотрудников, которые пришли на работу в первый день месяца (любого)
SELECT * FROM employees WHERE EXTRACT(DAY FROM hire_date) = 1;

-- Посмотрите, как можно записать условия в SQL. Обратите внимание на конструкцию CASE-WHEN
-- 8
-- Таблица Countries. Для каждой страны показать регион в котором она находится: 1-Europe, 2-America, 3-Asia, 4-Africa (без Join)
SELECT *,
    CASE
        WHEN region_id = 1 THEN 'Europe'
        WHEN region_id = 2 THEN 'America'
        WHEN region_id = 3 THEN 'Asia'
        WHEN region_id = 4 THEN 'Africa'
    END as region_name
FROM countries;

-- 9
-- Таблица Employees. Получить уровень зарплаты каждого сотрудника: Меньше 5000 считается Low level,
-- Больше или равно 5000 и меньше 10000 считается Normal level, Больше или равно 10000 считается High level
SELECT *,
    CASE
        WHEN salary < 5000 THEN 'Low level'
        WHEN salary >= 5000 AND salary < 10000 THEN 'Normal level'
        WHEN salary >= 10000 THEN 'High level'
    END as salary_class
FROM employees;

-- 10
-- Таблица Employees. Получить отчёт по department_id с минимальной и максимальной зарплатой, с самой ранней и самой поздней датой прихода на работу и с количеством сотрудников. Сортировать по количеству сотрудников (по убыванию)
SELECT MIN(salary) as salary_min,
       MAX(salary) as salary_max,
       MIN(hire_date) as hire_data_erliest,
       MAX(hire_date) as hire_date_latest,
       COUNT(employee_id) as eployee_cnt
FROM Employees GROUP BY department_id ORDER BY eployee_cnt DESC;

-- 11
-- Таблица Employees. Сколько сотрудников, которые работают в одном и тоже отделе и получают одинаковую зарплату?
SELECT department_id, salary, COUNT(employee_id) as eployee_cnt FROM employees GROUP BY department_id, salary HAVING COUNT(*)>1;

-- 12
-- Таблица Employees. Сколько в таблице сотрудников, имена которых начинаются с одной и той же буквы? Сортировать по количеству. Показывать только те строки, где количество сотрудников больше 1
SELECT SUBSTR (first_name, 1, 1) first_bykva, COUNT(employee_id) as eployee_cnt
FROM employees
GROUP BY  SUBSTR (first_name, 1, 1)
HAVING COUNT(*)>1
ORDER BY eployee_cnt DESC;

-- 13
-- Таблица Employees. Получить список department_id и округленную среднюю зарплату работников в каждом департаменте.
SELECT department_id, round(avg(salary)) FROM employees GROUP BY department_id;

-- 14
-- Таблица Countries. Получить список region_id, сумма длин всех country_name в котором больше 60
SELECT region_id, SUM(length(country_name)) FROM countries GROUP BY region_id HAVING SUM(length(country_name))>60;

-- 15
-- Таблица Employees, Departments, Locations, Countries, Regions. Получить список регионов и количество сотрудников в каждом регионе
SELECT r.region_name, COUNT(employee_id)
FROM employees
JOIN departments d on d.department_id = employees.department_id
JOIN locations l on l.location_id = d.location_id
JOIN countries c on c.country_id = l.country_id
join regions r on r.region_id = c.region_id
GROUP BY r.region_id;

-- 16
-- Таблица Employees. Показать всех менеджеров, которые имеют в подчинении больше шести сотрудников
SELECT manager_id, count(job_id) FROM employees GROUP BY manager_id HAVING count(job_id)>6;

-- 17
-- Таблица Employees. Показать всех сотрудников, у которых нет никого в подчинении
SELECT first_name FROM employees WHERE manager_id IS NULL;

-- 18
-- Таблица Employees, Departments. Показать все департаменты, в которых работают больше пяти сотрудников
SELECT department_name, count(*)
FROM employees
JOIN departments d on d.department_id = employees.department_id
GROUP BY d.department_id HAVING count(*)>5;

-- 19
-- Таблица Employees. Получить список сотрудников с зарплатой большей средней зарплаты всех сотрудников.
SELECT first_name, last_name FROM employees WHERE salary > (SELECT avg(salary) from employees);

-- 20
-- Таблица Employees, Departments. Показать сотрудников, которые работают в департаменте IT
SELECT first_name, last_name, department_id FROM employees
                             WHERE department_id =
                                   (SELECT department_id FROM departments WHERE department_name='IT');
