

-- Parametresi ile aldığı ders kodu için öğrencilerin sayısını notlara göre gruplayarak getiren sorguya geri dönen fonksiyonu yazınız

CREATE FUNCTION count_students_for_grades_by_lecture(@lecture_code varchar(10))
RETURNS TABLE 
AS  
RETURN 
(
    SELECT COUNT(student_id) AS Student Count  FROM FROM students INNER JOIN ON students.student_id = enrools.studentd_id
    INNER JOIN enrools.lecture_code = lecture.lecture_code
    INNER JOIN enrools.grade_id = grades.grade_id
    WHERE lecture.lecture_code = @lecture_code GROUP BY grades.description
)

--Her bir dersi alan öğrencilerin sayısını veren sorguyu yazınız
SELECT  COUNT(enrolls.student_id) AS student_count 
FROM enrolls 
INNER JOIN lectures ON enrolls.lecture_code = lectures.lecture_code 
GROUP BY lecture.lecture_code;


--Dersi 3'den fazla kez alan öğrencilerin kayıt olduğu dersleri gruplayan sorguyu yazınız
SELECT enrolls.lecture_code
FROM enrolls
INNER JOIN students ON enrolls.student_id = students.student_id
INNER JOIN lectures ON enrolls.lecture_code = lectures.lecture_code
GROUP BY enrolls.lecture_code
HAVING COUNT(*) > 3;


-- Dersi 3'den fazla kez alan öğrencilerin kayıt olduğu derslerin not ortalamasını getiren sorguyu yazınız
SELECT  AVG(grades.value) AS AVG GRADE
FROM enrolls
INNER JOIN students ON enrolls.student_id = students.student_id
INNER JOIN lectures ON enrolls.lecture_code = lectures.lecture_code
INNER JOIN grades ON enrolls.grade_id = grades.grade_id
GROUP BY enrolls.lecture_code
HAVING COUNT(*) > 3;
