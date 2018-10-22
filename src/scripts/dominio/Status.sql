-- DropdownStatus
SELECT public.DeletarFuncoes('Administracao', 'DropdownStatus');
CREATE OR REPLACE FUNCTION Administracao.DropdownStatus()
    RETURNS JSON AS $$

/*
Documentation
    Source............: Status.sql
    Objective.........: Dropdown de status
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.DropdownStatus();
*/

DECLARE
    vRes JSON;

BEGIN
    vRes := (
        SELECT COALESCE(json_agg(status), '[]')
        FROM (
                 SELECT *
                 FROM Administracao.status
             ) status
    );

    RETURN json_build_object(
        'content', vRes
    );
END;
$$
LANGUAGE PLPGSQL;