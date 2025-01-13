DROP TABLE IF EXISTS public."fine";
CREATE TABLE IF NOT EXISTS public."fine" (
	"fine_id" SERIAL PRIMARY KEY,
	"name" VARCHAR(30) NOT NULL,
	"number_plate" VARCHAR(6) NOT NULL,
	"violation" VARCHAR(50) NOT NULL,
	"sum_fine" DECIMAL(8, 2),
	"date_violation" DATE NOT NULL,
	"date_payment" DATE
);

DROP TABLE IF EXISTS public."traffic_violation";
CREATE TABLE IF NOT EXISTS public."traffic_violation" (
	"violation_id" SERIAL PRIMARY KEY,
	"violation" VARCHAR(50) NOT NULL UNIQUE,
	"sum_fine" DECIMAL(8, 2) NOT NULL
);