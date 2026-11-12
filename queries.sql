-- Учебный проект: анализ выполнения плана продаж АЗК
-- SQLite. Все данные вымышленные.
-- Перед запуском запросов необходимо выполнить setup.sql.


-- 1. АЗК, не выполнившие план за март

SELECT station
FROM sales
WHERE actual_amount < plan_amount
  AND month = 'Март';


-- 2. Отклонение фактических продаж от плана за март
-- Отрицательное значение означает недовыполнение плана.

SELECT station,
       month,
       actual_amount - plan_amount AS difference_amount
FROM sales
WHERE month = 'Март'
ORDER BY difference_amount ASC;


-- 3. Процент выполнения плана за март

SELECT station,
       plan_amount,
       actual_amount,
       ROUND(actual_amount * 100.0 / plan_amount, 2) AS completion_percent
FROM sales
WHERE month = 'Март';


-- 4. Общий план и факт по каждой АЗК за пять месяцев

SELECT station,
       SUM(plan_amount) AS total_plan,
       SUM(actual_amount) AS total_actual
FROM sales
GROUP BY station;


-- 5. Процент выполнения общего плана за пять месяцев

SELECT station,
       SUM(plan_amount) AS total_plan,
       SUM(actual_amount) AS total_actual,
       ROUND(SUM(actual_amount) * 100.0 / SUM(plan_amount), 2) AS completion_percent
FROM sales
GROUP BY station;


-- 6. АЗК, не выполнившие общий план за пять месяцев

SELECT station,
       SUM(plan_amount) AS total_plan,
       SUM(actual_amount) AS total_actual,
       ROUND(SUM(actual_amount) * 100.0 / SUM(plan_amount), 2) AS completion_percent
FROM sales
GROUP BY station
HAVING SUM(actual_amount) < SUM(plan_amount);


-- 7. Объединение таблиц: продажи за март с указанием города

SELECT sales.station,
       stations.city,
       sales.month,
       sales.actual_amount
FROM sales
JOIN stations ON sales.station = stations.station
WHERE sales.month = 'Март';


-- 8. Общая сумма фактических продаж за март по городам

SELECT stations.city,
       SUM(sales.actual_amount) AS total_actual
FROM sales
JOIN stations ON sales.station = stations.station
WHERE sales.month = 'Март'
GROUP BY stations.city;


-- 9. Города, в которых продажи за март превысили 1 500 000 рублей

SELECT stations.city,
       SUM(sales.actual_amount) AS total_actual
FROM sales
JOIN stations ON sales.station = stations.station
WHERE sales.month = 'Март'
GROUP BY stations.city
HAVING SUM(sales.actual_amount) > 1500000;


-- 10. Города, не выполнившие общий план за пять месяцев

SELECT stations.city,
       SUM(sales.plan_amount) AS total_plan,
       SUM(sales.actual_amount) AS total_actual,
       ROUND(SUM(sales.actual_amount) * 100.0 / SUM(sales.plan_amount), 2) AS completion_percent
FROM sales
JOIN stations ON sales.station = stations.station
GROUP BY stations.city
HAVING SUM(sales.actual_amount) < SUM(sales.plan_amount);
