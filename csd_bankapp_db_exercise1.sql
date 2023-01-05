-- Kart numarası bilinen müşterilerin bilgilerini getiren sorrgu
SELECT cs.customer_number, citizen_number, first_name, middle_name, last_name, birth_date, marital_status_id
FROM customers cs
         inner join cards c on cs.customer_number = c.customer_number;
-- Müşteri numarası ve kart türü bilinen mişterinin kart bilgilerini getiren sorgu
SELECT *
FROM customers cs
         inner join cards c on cs.customer_number = c.customer_number
         inner join card_types ct on ct.card_type_id = c.card_type_id;
-- Evli olan müşterilerin kart bilgilerini getiren sorgu
SELECT *
FROM cards c
         inner join card_types ct on ct.card_type_id = c.card_type_id
         inner join customers cs on cs.customer_number = c.customer_number
         inner join marital_status ms on ms.marital_status_id = cs.marital_status_id
WHERE ms.description = 'Divorced';
-- Kart son kullanma yıl bilgisi bilinen kartlara ilişkin müşteri bilgilerini getiren sorgu
SELECT *
FROM customers cs
         inner join cards c on cs.customer_number = c.customer_number
         inner join card_types ct on ct.card_type_id = c.card_type_id
         inner join marital_status ms on cs.marital_status_id = ms.marital_status_id
         inner join customer_to_addresses cta on cs.customer_number = cta.customer_number
         inner join customer_to_phones ctp on cs.customer_number = ctp.customer_number
         inner join phone_types pt on ctp.phone_type_id = pt.phone_type_id
WHERE c.expiry_year = 2026;