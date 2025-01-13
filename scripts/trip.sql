DROP TABLE IF EXISTS "trip";
CREATE TABLE IF NOT EXISTS PUBLIC."trip" (
	"trip_id" SERIAL PRIMARY KEY,
	"name" VARCHAR(30) NOT NULL,
	"city" VARCHAR(25) NOT NULL,
	"per_diem" DECIMAL(8, 2) NOT NULL,
	"date_first" DATE NOT NULL,
	"date_last" DATE NOT NULL
);

INSERT INTO
	public."trip"
VALUES
	(
		1,
		'Баранов П.Е.',
		'Москва',
		700,
		'2020-01-12',
		'2020-01-17'
	),
	(
		2,
		'Абрамова К.А.',
		'Владивосток',
		450,
		'2020-01-14',
		'2020-01-27'
	),
	(
		3,
		'Семенов И.В.',
		'Москва',
		700,
		'2020-01-23',
		'2020-01-31'
	),
	(
		4,
		'Ильиных Г.Р.',
		'Владивосток',
		450,
		'2020-01-12',
		'2020-02-02'
	),
	(
		5,
		'Колесов С.П.',
		'Москва',
		700,
		'2020-02-01',
		'2020-02-06'
	),
	(
		6,
		'Баранов П.Е.',
		'Москва',
		700,
		'2020-02-14',
		'2020-02-22'
	),
	(
		7,
		'Абрамова К.А.',
		'Москва',
		700,
		'2020-02-23',
		'2020-03-01'
	),
	(
		8,
		'Лебедев Т.К.',
		'Москва',
		700,
		'2020-03-03',
		'2020-03-06'
	),
	(
		9,
		'Колесов С.П.',
		'Новосибирск',
		450,
		'2020-02-27',
		'2020-03-12'
	),
	(
		10,
		'Семенов И.В.',
		'Санкт-Петербург',
		700,
		'2020-03-29',
		'2020-04-05'
	),
	(
		11,
		'Абрамова К.А.',
		'Москва',
		700,
		'2020-04-06',
		'2020-04-14'
	),
	(
		12,
		'Баранов П.Е.',
		'Новосибирск',
		450,
		'2020-04-18',
		'2020-05-04'
	),
	(
		13,
		'Лебедев Т.К.',
		'Томск',
		450,
		'2020-05-20',
		'2020-05-31'
	),
	(
		14,
		'Семенов И.В.',
		'Санкт-Петербург',
		700,
		'2020-06-01',
		'2020-06-03'
	),
	(
		15,
		'Абрамова К.А.',
		'Санкт-Петербург',
		700,
		'2020-05-28',
		'2020-06-04'
	),
	(
		16,
		'Федорова А.Ю.',
		'Новосибирск',
		450,
		'2020-05-25',
		'2020-06-04'
	),
	(
		17,
		'Колесов С.П.',
		'Новосибирск',
		450,
		'2020-06-03',
		'2020-06-12'
	),
	(
		18,
		'Федорова А.Ю.',
		'Томск',
		450,
		'2020-06-20',
		'2020-06-26'
	),
	(
		19,
		'Абрамова К.А.',
		'Владивосток',
		450,
		'2020-07-02',
		'2020-07-13'
	),
	(
		20,
		'Баранов П.Е.',
		'Воронеж',
		450,
		'2020-07-19',
		'2020-07-25'
	);

SELECT * FROM "trip";

/*
Вывести информацию о командировках во все города кроме Москвы и Санкт-Петербурга 
(фамилии и инициалы сотрудников, город ,  длительность командировки в днях, при этом первый и последний день относится к периоду командировки). 
Последний столбец назвать Длительность. Информацию вывести в упорядоченном по убыванию длительности поездки, 
а потом по убыванию названий городов (в обратном алфавитном порядке).
*/
SELECT
	"name",
	"city",
	("date_last"::DATE - "date_first"::DATE) + 1 AS "Длительность"
FROM
	"trip"
WHERE
	"city" != 'Москва'
	AND "city" != 'Санкт-Петербург'
ORDER BY
	Длительность DESC,
	"city" DESC;

/*
Вывести информацию о командировках сотрудника(ов), которые были самыми короткими по времени. 
В результат включить столбцы name, city, date_first, date_last.
*/
SELECT
	"name",
	"city",
	"date_first",
	"date_last"
FROM
	"trip"
ORDER BY
	("date_last"::DATE - "date_first"::DATE) + 1
LIMIT
	1;
SELECT
	"name",
	"city",
	"date_first",
	"date_last"
FROM
	"trip"
WHERE
	(
		SELECT
			MIN("date_last"::DATE - "date_first"::DATE)
		FROM
			"trip"
	) = ("date_last"::DATE - "date_first"::DATE);


/*
Вывести информацию о командировках, начало и конец которых относятся к одному месяцу (год может быть любой). 
В результат включить столбцы name, city, date_first, date_last. 
Строки отсортировать сначала  в алфавитном порядке по названию города, а затем по фамилии сотрудника .
*/
SELECT
	"name",
	"city",
	"date_first",
	"date_last"
FROM
	"trip"
WHERE
	EXTRACT(
		MONTH
		FROM
			"date_first"
	) = EXTRACT(
		MONTH
		FROM
			"date_last"
	)
ORDER BY
	"city",
	"name";

/*
Вывести название месяца и количество командировок для каждого месяца. 
Считаем, что командировка относится к некоторому месяцу, если она началась в этом месяце. 
Информацию вывести сначала в отсортированном по убыванию количества, а потом в алфавитном порядке по названию месяца виде. 
Название столбцов – Месяц и Количество.
*/
SELECT
	TO_CHAR("date_first", 'Month') AS "Месяц",
	COUNT(*) AS "Количество"
FROM
	"trip"
GROUP BY
	"Месяц"
ORDER BY
	"Количество" DESC,
	"Месяц";

/*
Вывести сумму суточных (произведение количества дней командировки и размера суточных) для командировок, 
первый день которых пришелся на февраль или март 2020 года. 
Значение суточных для каждой командировки занесено в столбец per_diem. 
Вывести фамилию и инициалы сотрудника, город, первый день командировки и сумму суточных. 
Последний столбец назвать Сумма. Информацию отсортировать сначала  в алфавитном порядке по фамилиям сотрудников, а затем по убыванию суммы суточных.
*/
SELECT
	"name",
	"city",
	"date_first",
	"per_diem" * (("date_last"::DATE - "date_first"::DATE) + 1) AS "Сумма"
FROM
	"trip"
WHERE
	(
		EXTRACT(
			MONTH
			FROM
				"date_first"
		) = 2
		AND EXTRACT(
			YEAR
			FROM
				"date_first"
		) = 2020
	)
	OR (
		EXTRACT(
			MONTH
			FROM
				"date_first"
		) = 3
		AND EXTRACT(
			YEAR
			FROM
				"date_first"
		) = 2020
	)
ORDER BY
	"name",
	"Сумма" DESC;

/*
Вывести фамилию с инициалами и общую сумму суточных, полученных за все командировки для тех сотрудников, 
которые были в командировках больше чем 3 раза, в отсортированном по убыванию сумм суточных виде. Последний столбец назвать Сумма.
Только для этого задания изменена строка таблицы trip: 4	Ильиных Г.Р.	Владивосток	450	2020-01-12	2020-03-02
*/
SELECT
	"name",
	SUM(
		"per_diem" * (("date_last"::DATE - "date_first"::DATE) + 1)
	) AS "Сумма"
FROM
	"trip"
GROUP BY
	"name"
HAVING
	COUNT("name") > 3
ORDER BY
	"Сумма" DESC;
