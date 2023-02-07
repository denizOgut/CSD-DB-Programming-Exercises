/*----------------------------------------------------------------------------------------------------------------------
    Sınıf Çalışması: Aşağıda belirtilen peoplei, people_younger ve people_older isimli tablolara göre soruları yanıtlayınız
    - people
        citizen_id
        first_name
        last_name
        birth_date
        address

  - people_younger
        citizen_id
        first_name
        last_name
        birth_date
        address
  - people_older
        citizen_id
        first_name
        last_name
        birth_date
        address
  Sorular:
    - Parametresi ile aldığı person bilgilerine göre, yine parametresi ile aldığı iki tane yaş bilgisinden hareketle
  birinci yaş bilgisinden küçük olan kişileri people_younger, birinci ve ikinci yaş arasında kalan kişileri people
  tablosuna geri kalanları people_older tablosuna ekleyen SP'yi yazınız

    - people ve people_younger tablosundaki soyadları büyük harfe çeviren SP'yi yazınız

    - TODO: Yukarıdaki tüm tablolara bakarak yaşı parametresi ile aldığı iki tane yaş bilgisine göre tabloya uygun
    olmayanları uygun tablolara aktaran SP'yi yazınız
-----------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE sp_insert_person(@citizen_id char(36), @first_name nvarchar(100),@last_name nvarchar(100),@birth_date date,@address nvarchar(max),@max_age int,@min_age int)
AS
BEGIN
    DECLARE @age REAL = DATEDIFF(DAY,@birth_date, GETDATE()) / 365.;
    IF @age < @min_age
        INSERT INTO people_younger(citizen_id,first_name,last_name,birth_date,address) VALUES(@citizen_id,@first_name,@last_name,@birth_date,@address);
    ELSE IF @age < @max_age
        INSERT INTO people(citizen_id,first_name,last_name,birth_date,address) VALUES(@citizen_id,@first_name,@last_name,@birth_date,@address);
    ELSE
        INSERT INTO people_older(citizen_id,first_name,last_name,birth_date,address) VALUES(@citizen_id,@first_name,@last_name,@birth_date,@address);
END

CREATE PROCEDURE sp_update_last_names_to_upper_for_people_and_people_younger
AS
BEGIN
    --BEGIN TRANSACTION
        UPDATE people SET last_name = UPPER(last_name);

        UPDATE people_younger SET last_name = UPPER(last_name);
    --COMMIT TRANSACTION
END;


/*----------------------------------------------------------------------------------------------------------------------
	Sınıf Çalışması: Aşağıda belirtilen tablolara göre soruları yanıtlayınız:

	- sensors
		sensor_id
		name
		host
		port
	- sensor_data
		sensor_data_id
		sensor_id
		data
		read_date_time

	- Parametresi ile aldığı name, host, port ve data bilgilerine göre sensor'ü ve sensor'ün verisini ekleyen procedure'ü
	yazınız

	- Parametresi ile aldığı sensor_id, data ve okuma zamanı bilgisine göre sensor verisini ekleyen procedure'ü yazınız
----------------------------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE sp_insert_sensor_with_data(@name nvarchar(100), @host char(15), @port int, @data real)
AS
BEGIN
    BEGIN TRANSACTION
    insert into sensors (name, host, port) values (@name, @host, @port)
	declare @sensor_id int = @@IDENTITY

	insert into sensor_data (sensor_id, data, read_date_time) values (@sensor_id, @data, SYSDATETIME())
    COMMIT TRANSACTION
END;

CREATE PROCEDURE sp_insert_data(@sensor_id int, @data real, @read_date_time datetime)
AS
BEGIN
    insert into sensor_data (sensor_id, data, read_date_time) values (@sensor_id, @data, @read_date_time)
END;