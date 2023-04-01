/*

levels:
        level_id
        description
    questions:
        question_id
        description
        level_id
        answer_index
    options
        option_id
        description
        question_id


    Dikkat edilirse tüm soruların değişken sayıda seçenekleri olacaktır.
    Sorular:
    1. Her çalıştırıldığında herhangi bir seviyeden rasgele bir soru getiren get_random_question fonksiyonunu yazınız
    2. Parametresi ile aldığı level_id bilgisine göre rasgele bir soru getiren get_random_question_by_level_id fonksiyonunu
    yazınız
 */

CREATE FUNCTION get_random_question()
RETURNS INT
AS
BEGIN
DECLARE @result int = 0
DECLARE @question_id int = 0

DECLARE crs_question cursor scroll for select @question_id from questions
OPEN crs_question

declare @max int = (select COUNT(*) from questions) + 1
declare @min int = 1
declare @index int = rand() * (@max - @min) + @min

FETCH ABSOLUTE @index FROM crs_question INTO @question_id

IF @@fetch_status = 0
    SET @result = @question_id

CLOSE crs_question
DEALLOCATE crs_question

RETURN @result

END;

--------------------------------------------------------------------------------------------------------------------

create function get_question_details_by_id(@question_id int)
returns table
as
return (
    SELECT q.description FROM questions question_id
    inner join options o on o.question_id = q.question_id WHERE q.question_id = @question_id;
)


/*----------------------------------------------------------------------------------------------------------------------
    Sınıf Çalışması: Aşağıdaki veritabanını oluturunuz ve soruları yanıtlayınız
    cities
        city_id
        name
    patients
        patient_id
        full_name
        city_id
        birth_date
    relations
        relation_id
        description (Annesi, Babası, Çocuğu, Teyzesi, Halası vb)
    companions
        companion_id
        full_name
        patient_id
        relation_id
    Sorular:
    1. Tüm patien_id'lere ilişkin hastaların isimlerini büyük harfe çeviren SP'yi yazınız
    2. Belirli bir yaştan büyük olan hastaların refakatçi ve kendi isimlerini büyük harfe çeviren SP'yi yazınız
    3. Yaşadığı il id'sine göre hastaların refekatçi isimlerini küçük harfe çeviren SP'yi yazınız
-----------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE sp_to_upper_case()
AS
BEGIN
    DECLARE cursor_patient CURSOR FOR SELECT patient_id FROM patients
    DECLARE @patient_id INT 
    OPEN cursor_patient

    FETCH NEXT FROM cursor_patient INTO @patient_id
    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE patients SET full_name = UPPER(full_name) WHERE patient_id = @patient_id
            FETCH NEXT FROM cursor_patient INTO @patient_id
        END

    CLOSE cursor_patient
    DEALLOCATE cursor_patient
END;


---------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_to_upper_case_for_patient_and_companions_older_than_given_age(@threshold_age INT)
AS
BEGIN
    DECLARE cursor_patient CURSOR FOR SELECT p.full_name, c.full_name FROM patients p inner join companions c on p.patient_id = c.patient_id WHERE DATEDIFF(YEAR,p.birth_date, GETDATE()) > @threshold_age
    DECLARE @patient_full_name VARCHAR(50)
    DECLARE @companion_full_name VARCHAR(50)
    OPEN cursor_patient

    FETCH NEXT FROM cursor_patient INTO @patient_full_name, @companion_full_name
    WHILE @@FETCH_STATUS = 0
        BEGIN
            update patients, companions set p.full_name = upper(p.full_name), c.full_name = upper(c.full_name)  where DATEDIFF(YEAR,p.birth_date, GETDATE()) > @threshold_age
            FETCH NEXT FROM cursor_patient INTO @patient_full_name, @companion_full_name
        END

    CLOSE cursor_patient
    DEALLOCATE cursor_patient
END;

---------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_to_lower_case_for_companions_by_the_city_lived(@city_id INT)
AS
BEGIN
    DECLARE @companion_full_name VARCHAR(50)
    DECLARE cursor_companion CURSOR FOR 
    SELECT c.full_name FROM companions c inner join patients p on p.patient_id = c.patient_id INNER JOIN cities s on s.city_id = p.city_id WHERE s.city_id = @city_id

    OPEN cursor_companion

    FETCH NEXT FROM cursor_companion INTO @companion_full_name
    WHILE @@FETCH_STATUS = 0
        BEGIN
            update companions set full_name = LOWER(c.full_name)
            FETCH NEXT FROM cursor_companion INTO @companion_full_name
        END

    CLOSE cursor_companion
    DEALLOCATE cursor_companion
END;