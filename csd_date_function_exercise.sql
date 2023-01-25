
/*----------------------------------------------------------------------------------------------------------------------
     Sınıf Çalışması: Aşağıda açıklanan rezervasyon sistemine ilişkin tabloya göre soruları cevaplayınız
     reservations
        - id
        - description
        - reservation_date
        - start_date
        - end_date
-----------------------------------------------------------------------------------------------------------------------*/

-- Hafta sonu yapılmış olan rezervasyonları ay ve yıl bilgisine göre getiren sorguyu yazınız
--MSSQL
SELECT description, MONTH(reservation_date), YEAR(reservation_date)
FROM dbo.reservation
WHERE (DATEPART(DW, start_date) BETWEEN 1 AND 7)
  AND (DATEPART(DW, end_date) BETWEEN 1 AND 7);
--POSTGRESQL
SELECT description, EXTRACT(MONTH FROM reservation_date), EXTRACT(YEAR FROM reservation_date)
FROM reservation
WHERE (EXTRACT(DOW FROM start_date) BETWEEN 1 AND 7)
AND (EXTRACT(DOW FROM end_date) BETWEEN 1 AND 7);

-- Hafta içi yapılmış olan rezervasyonları ay ve yıl bilgisine göre getiren sorguyu yazınız
--MSSQL
SELECT description, MONTH(reservation_date), YEAR(reservation_date)
FROM dbo.reservation
WHERE NOT (DATEPART(DW, start_date) BETWEEN 1 AND 7)
  AND NOT (DATEPART(DW, end_date) BETWEEN 1 AND 7);
--POSTGRESQL
SELECT description, EXTRACT(MONTH FROM reservation_date), EXTRACT(YEAR FROM reservation_date)
FROM reservation
WHERE NOT (EXTRACT(ISODOW FROM start_date) BETWEEN 1 AND 7)
AND NOT (EXTRACT(ISODOW FROM end_date) BETWEEN 1 AND 7);

-- Parametresi ile aldığı ay bilgisine göre şu anki yılın alınan ayında rezervasyoları tablo olarak döndüren fonksiyonu yazınız
--MSSQL
CREATE FUNCTION get_reservations_by_month_of_current_year(@month int)
    RETURNS
TABLE AS
RETURN
(SELECT * FROM dbo.reservation WHERE MONTH(reservation_date) = @month AND YEAR(reservation_date) = YEAR(GETDATE()));
--POSTGRESQL
CREATE FUNCTION get_reservations_by_month_of_current_year(@month int)
RETURNS TABLE AS
RETURN
(SELECT * FROM reservation WHERE EXTRACT(MONTH FROM reservation_date) = @month AND EXTRACT(YEAR FROM reservation_date) = EXTRACT(YEAR FROM CURRENT_DATE));

--  Parametresi ile aldığı ay ve yıl bilgisine yapılan rezervasyoları tablo olarak döndüren fonksiyonu yazınız
--MSSQL
CREATE FUNCTION get_reservations_by_month_and_year(@ month int , @ year int)
    RETURNS
TABLE AS
RETURN
(SELECT * FROM dbo.reservation WHERE MONTH(reservation_date) = @month AND YEAR(reservation_date) = @year);
--POSTGRESQL
CREATE FUNCTION get_reservations_by_month_and_year(month INTEGER, year INTEGER)
RETURNS TABLE
AS $$
BEGIN
RETURN QUERY
SELECT id, description, reservation_date, start_date, end_date
FROM reservations
WHERE EXTRACT(MONTH FROM reservation_date) = month AND EXTRACT(YEAR FROM reservation_date) = year;
END; $$ language plpgsql;

/*----------------------------------------------------------------------------------------------------------------------
     Sınıf Çalışması: Aşağıda verilen tabloya göre soruları cevaplayınız
     students
        - citizen_id
        - first_name
        - middle_name
        - last_name
        - birth_date
        - register_date
    Sorular:
    Not: Aşağıdaki istenen sorguların hepsini tablo döndüren fonksiyon olarak yazınız
-----------------------------------------------------------------------------------------------------------------------*/

--Okul dönemi Eylül ve Haziran arası olmak üzere okul dönemi içerisinde doğmuş olan öğrencileri yaşlarıyla birlikte getiren sorguyu yazınız

--MSSQL
CREATE FUNCTION get_students_by_birth_date_between_september_and_jun()
    RETURNS TABLE AS
    RETURN
(SELECT first_name, middle_name, last_name, DATEDIFF(year, birth_date, GETDATE()) AS age
 FROM dbo.students
 WHERE MONTH(birth_date) BETWEEN 9 AND 6
);
--POSTGRESQL
CREATE FUNCTION get_students_by_birth_date_between_september_and_jun()
RETURNS TABLE AS
RETURN
(SELECT first_name, middle_name, last_name, DATE_PART('year', age(birth_date)) AS age
FROM students
WHERE EXTRACT(MONTH FROM birth_date) BETWEEN 9 AND 6
);


-- Doğum ay bilgisi kayıt ayı ile aynı olan öğrencileri getiren sorguyu yazınız
    --MSSQL
CREATE FUNCTION get_students_by_same_birth_month_as_registration_month()
    RETURNS TABLE AS
    RETURN
(SELECT * FROM students WHERE MONTH(birth_date) = MONTH(register_date));

--POSTGRESQL

CREATE FUNCTION get_students_by_same_birth_month_as_registration_month()
RETURNS TABLE AS
RETURN
(SELECT * FROM students WHERE EXTRACT(MONTH FROM birth_date) = EXTRACT(MONTH FROM register_date));

-- Parametresi ile aldığı doğum tarihi bilgisine göre, doğum günü geçmiş ise -1, doğum günü henüz gelmemiş ise 1 ve o gün doğum günü ise sıfır döndüren get_birth_day_status isimli fonksiyonu yazınız
--MSSQL
CREATE FUNCTION get_birth_day_status(@birth_date DATETIME)
RETURNS TABLE AS
RETURN(
    SELECT  CASE WHEN GETDATE() > @birth_date THEN -1
                WHEN GETDATE()  < @birth_date THEN 1
                ELSE 0
            END AS birth_day_status
);
--POSTGRESQL

CREATE FUNCTION get_birth_day_status(birth_date TIMESTAMP)
RETURNS TABLE AS
RETURN(
SELECT CASE WHEN NOW() > birth_date THEN -1
WHEN NOW() < birth_date THEN 1
ELSE 0
END AS birth_day_status
);


-- Parametresi ile aldığı doğum tarihi bilgisine göre aşağıdaki gibi Türkçe mesajlar döndüren get_birth_day_message_tr fonksiyonunu yazınız:
--Doğum günü geçmiş ise "Geçmiş doğum gününüz kutlu olsun. Yeni yaşınızı (46) kutlarım"
--Doğum günü henüz gelmemiş ise "Doğum gününüz şimdiden kutlu olsun. Yeni yaşınızı (46) kutlarım"
--Doğum günü o gün  ise "Doğum gününüz kutlu olsun. Yeni yaşınız: (46) kutlarım"

--MSSQL
CREATE FUNCTION get_birth_day_message_tr(@birth_date DATETIME)
    RETURNS
TABLE AS
RETURN
(SELECT CASE
            WHEN dbo.get_birth_day_status(@birth_date) = -1
                THEN 'Geçmiş doğum gününüz kutlu olsun. Yeni yaşınızı: ' +
                     CAST(DATEDIFF(year, @birth_date, GETDATE()) AS VARCHAR(10)) + ' kutlarım'
            WHEN dbo.get_birth_day_status(@birth_date) = 1
                THEN 'Doğum gününüz şimdiden kutlu olsun. Yeni yaşınızı: ' +
                     CAST(DATEDIFF(year, @birth_date, GETDATE()) AS VARCHAR(10)) + ' kutlarım'
            ELSE 'Doğum gününüz kutlu olsun. Yeni yaşınız: ' +
                 CAST(DATEDIFF(year, @birth_date, GETDATE()) AS VARCHAR(10)) + ' kutlarım'
            END AS birth_day_message_tr
 )

--POSTGRESQL

CREATE FUNCTION get_birth_day_message_tr(birth_date TIMESTAMP)
RETURNS TABLE AS
RETURN
(SELECT CASE
WHEN CURRENT_DATE > birth_date THEN 'Geçmiş doğum gününüz kutlu olsun. Yeni yaşınızı: ' ||
AGE(birth_date) || ' kutlarım'
WHEN CURRENT_DATE < birth_date THEN 'Doğum gününüz şimdiden kutlu olsun. Yeni yaşınızı: ' ||
AGE(birth_date) || ' kutlarım'
ELSE 'Doğum gününüz kutlu olsun. Yeni yaşınız: ' ||
AGE(birth_date) || ' kutlarım'
END AS birth_day_message_tr
);