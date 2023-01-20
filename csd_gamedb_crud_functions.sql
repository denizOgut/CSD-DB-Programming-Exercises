--write DELETE-UPDATE-INSERT functions for game_db

--MSSQL
--DELETE FUNCTIONS
create function delete_from_players_by_nickname(@nick_name varchar (250))(
    returns as void;
    BEGIN
    DELETE FROM players WHERE players.nick_name = @nick_name;
    END
    );

create function delete_from_games_by_name(@name varchar (250))(
    returns as void;
    BEGIN
    DELETE FROM games WHERE games.name = @name;
    END
    );

create function delete_from_player_to_games_by_name(@player_id int, @game_id int)(
    returns as void;
    BEGIN
    DELETE FROM player_to_games WHERE player_to_games.player_id = @player_id AND player_to_games.game_id = @game_id;
    END
    );

--UPDATE FUNCTIONS
create function update_players_email_by_nick_name(@email varchar (250),@nick_name varchar (250))
    (
    return as void;
    BEGIN
    UPDATE players SET email = @email WHERE nick_name = @nick_name;
    END
    );

create function update_games_publisher_by_name(@publisher varchar (250),@name varchar (250))
    (
    return as void;
    BEGIN
    UPDATE games SET publisher = @publisher WHERE name = @name;
    END
    );

--INSERT FUNCTIONS

create function insert_into_players(@nick_name varchar (250),@password varchar (250),@first_name varchar (250),@middle_name varchar (250),@last_name varchar (250),@email varchar (250),@register_date datetime ,@birth_date datetime)
    (
    return as void;
    BEGIN
    INSERT INTO players(nick_name, password,first_name,middle_name,last_name,email,register_date,birth_date) VALUES (@nick_name,@password,@first_name,@middle_name,@last_name,@email,@register_date,@birth_date);
    END
    );

create function insert_into_games(@name varchar (250),@publisher varchar (250),@release_date datetime,@is_available bit)
    (
    return as void
    BEGIN
    INSERT INTO games(name,publisher,release_date,is_available) VALUES (@ name,@publisher,@release_date,@is_available);
    END
    );

--POSTGRESQL
--DELETE FUNCTIONS
CREATE OR REPLACE FUNCTION delete_from_players_by_nickname($1)
RETURNS VOID AS $$
BEGIN
   DELETE FROM players WHERE nick_name = $1;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION delete_from_games_by_name($1)
RETURNS  VOID AS $$
    BEGIN
        DELETE FROM games WHERE name = $1;
    END;
    $$ language plpgsql;

CREATE OR REPLACE FUNCTION delete_from_player_to_games_by_name($1, $2)
RETURNS VOID AS $$
BEGIN
   DELETE FROM players_to_games WHERE player_id = $1 AND game_id = $2;
END; $$ LANGUAGE plpgsql;

--UPDATE FUNCTIONS
CREATE OR REPLACE FUNCTION update_players_email_by_nick_name($1, $2)
RETURNS VOID AS $$
BEGIN
   UPDATE players SET email = $1 WHERE nick_name = $2;
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_games_publisher_by_name($1, $2)
RETURNS VOID AS $$
BEGIN
   UPDATE games SET publisher = $1 WHERE name = $2;
END; $$ LANGUAGE plpgsql;

--INSERT FUNCTIONS
CREATE OR REPLACE FUNCTION insert_into_players($1,$2,$3,$4,$5,$6,$7,$8)
RETURNS VOID AS $$
BEGIN
   INSERT INTO players(nick_name,password,first_name,middle_name,last_name,email,register_date,birth_date) VALUES ($1,$2,$3,$4,$5,$6,$7,$8);
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_games($1,$2,$3,$4)
RETURNS VOID AS $$
BEGIN
   INSERT INTO games(name,publisher,release_date,is_available) VALUES ($1,$2,$3,$4);
END; $$ LANGUAGE plpgsql;
