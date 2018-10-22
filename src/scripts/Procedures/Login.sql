-- Login
SELECT public.DeletarFuncoes('Seguranca', 'Login');
CREATE OR REPLACE FUNCTION Seguranca.Login(
    pLogin VARCHAR,
    pSenha VARCHAR
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: Login.sql
    Objective.........: Login do usuário no sistema
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Seguranca.Login(
        'a@a.com',
        'teste123'
    );
*/

DECLARE
    vSenhaCorreta BOOLEAN;
    vRes          JSON;
BEGIN
    vSenhaCorreta := (SELECT ap.senha = md5(pSenha)
                      FROM Seguranca.acessoProfessor ap
                      WHERE ap.email = pLogin);

    vRes := (
        SELECT COALESCE(row_to_json(dados), '{}')
        FROM (
                 SELECT
                     ap.id,
                     ap.codigo,
                     ap.nome,
                     ap.email,
                     ap.ultimoLogin           "ultimoLogin",
                     (ap.senha = md5(pSenha)) "senhaCorreta"
                 FROM Seguranca.acessoProfessor ap
                 WHERE ap.email = pLogin
             ) dados
    );

    IF vSenhaCorreta IS TRUE
    THEN
        UPDATE Seguranca.acessoProfessor
        SET ultimoLogin = CURRENT_TIMESTAMP
        WHERE email = pLogin;
    END IF;

    RETURN json_build_object(
        'content', vRes
    );
END;
$$
LANGUAGE PLPGSQL;

-- RefazLogin
SELECT public.DeletarFuncoes('Seguranca', 'RefazLogin');
CREATE OR REPLACE FUNCTION Seguranca.RefazLogin(
    pId INTEGER
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: Login.sql
    Objective.........: Refaz o login do usuário no sistema
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Seguranca.RefazLogin(1);
*/
DECLARE
    vRes JSON;
BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Seguranca.acessoProfessor
                  WHERE id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Usuário não encontrado'
        );
    END IF;

    vRes := (
        SELECT COALESCE(row_to_json(dados), '{}')
        FROM (
                 SELECT
                     ap.id,
                     ap.codigo,
                     ap.nome,
                     ap.email,
                     ap.ultimoLogin "ultimoLogin"
                 FROM Seguranca.acessoProfessor ap
                 WHERE ap.id = pId
             ) dados
    );

    RETURN json_build_object(
        'content', vRes
    );
END;
$$
LANGUAGE PLPGSQL;