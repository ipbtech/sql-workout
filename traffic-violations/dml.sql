SELECT * FROM "fine"
ORDER BY "fine_id";
SELECT * FROM "traffic_violation";

/*
Занести в таблицу fine суммы штрафов, которые должен оплатить водитель, в соответствии с данными из таблицы traffic_violation. 
При этом суммы заносить только в пустые поля столбца sum_fine.
*/
UPDATE "fine"
SET "sum_fine" = (
	SELECT "sum_fine"
	FROM "traffic_violation"
	WHERE "violation" = "fine"."violation"
)
WHERE "sum_fine" IS NULL;

/*
Вывести фамилию, номер машины и нарушение только для тех водителей, которые на одной машине нарушили одно и то же правило два и более раз. 
При этом учитывать все нарушения, независимо от того оплачены они или нет. 
Информацию отсортировать в алфавитном порядке, сначала по фамилии водителя, потом по номеру машины и, наконец, по нарушению.
*/
SELECT
	"name",
	"number_plate",
	"violation"
FROM "fine"
GROUP BY
	"name",
	"number_plate",
	"violation"
HAVING COUNT(*) >= 2
ORDER BY "name", "number_plate", "violation";

/*
В таблице fine увеличить в два раза сумму неоплаченных штрафов для отобранных на предыдущем шаге записей. 
*/
WITH "query" AS(
	SELECT
		"name",
		"number_plate",
		"violation"
	FROM "fine"
	GROUP BY
		"name",
		"number_plate",
		"violation"
	HAVING COUNT(*) >= 2
)
UPDATE "fine"
SET "sum_fine" = "sum_fine" * 2
WHERE "date_payment" IS NULL 
	AND ("fine"."name", "fine"."number_plate", "fine"."violation") IN (
    	SELECT "name", "number_plate", "violation" FROM "query"
);

/*
Водители оплачивают свои штрафы. В таблице payment занесены даты их оплаты:
payment_id	name	number_plate	violation	date_violation	date_payment
1	Яковлев Г.Р.	М701АА	Превышение скорости(от 20 до 40)	2020-01-12	2020-01-22
2	Баранов П.Е.	Р523ВТ	Превышение скорости(от 40 до 60)	2020-02-14	2020-03-06
3	Яковлев Г.Р.	Т330ТТ	Проезд на запрещающий сигнал	2020-03-03	2020-03-23
Необходимо:
в таблицу fine занести дату оплаты соответствующего штрафа из таблицы payment; 
уменьшить начисленный штраф в таблице fine в два раза  (только для тех штрафов, информация о которых занесена в таблицу payment) , 
если оплата произведена не позднее 20 дней со дня нарушения.
*/
CREATE TABLE IF NOT EXISTS "payment" (
	"payment_id" SERIAL PRIMARY KEY,
	"name" VARCHAR,
	"number_plate" VARCHAR,
	"violation" VARCHAR,
	"date_violation" DATE,
	"date_payment" DATE
);
INSERT INTO "payment" VALUES
(1, 'Яковлев Г.Р.',	'М701АА', 'Превышение скорости(от 20 до 40)', '2020-01-12', '2020-01-22'),
(2, 'Баранов П.Е.', 'Р523ВТ', 'Превышение скорости(от 40 до 60)', '2020-02-14', '2020-03-06'),
(3, 'Яковлев Г.Р.', 'Т330ТТ', 'Проезд на запрещающий сигнал', '2020-03-03', '2020-03-23');
UPDATE "fine"
SET
	"date_payment" = (
		SELECT "date_payment"
		FROM "payment"
		WHERE
			"fine"."name" = "payment"."name"
			AND "fine"."number_plate" = "payment"."number_plate"
			AND "fine"."violation" = "payment"."violation"
	),
	"sum_fine" = 
		CASE
			WHEN (
				SELECT ("date_payment"::DATE - "date_violation"::DATE)
				FROM "payment"
				WHERE
					"fine"."name" = "payment"."name"
					AND "fine"."number_plate" = "payment"."number_plate"
					AND "fine"."violation" = "payment"."violation"
			) <= 20 THEN "fine"."sum_fine" / 2
			ELSE "sum_fine"
		END
WHERE
	"date_payment" IS NULL;


/*
Создать новую таблицу back_payment, куда внести информацию о неоплаченных штрафах 
(Фамилию и инициалы водителя, номер машины, нарушение, сумму штрафа и дату нарушения) из таблицы fine.
Важно. На этом шаге необходимо создать таблицу на основе запроса! Не нужно одним запросом создавать таблицу, а вторым в нее добавлять строки.
*/
CREATE TABLE IF NOT EXISTS public."back_payment" AS (
	SELECT
		"name",
		"number_plate",
		"violation",
		"sum_fine",
		"date_violation"
	FROM "fine"
	WHERE "date_payment" IS NULL
)

/*
Удалить из таблицы fine информацию о нарушениях, совершенных раньше 1 февраля 2020 года. 
*/
DELETE FROM "fine"
WHERE "date_violation" < ('2020-02-01'::DATE);
