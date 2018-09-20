SELECT *
FROM public.DeletarFuncoes('Seguranca', 'LoginUsuario');
CREATE OR REPLACE FUNCTION Seguranca.LoginUsuario(
    pLogin VARCHAR,
    pSenha VARCHAR
)
    RETURNS TABLE(
        "idUsuario"       INTEGER,
        "idUsuarioAcesso" INTEGER,
        "idTipoUsuario"   INTEGER,
        "nome"            VARCHAR(50),
        "logon"           VARCHAR(10),
        "ativo"           BOOLEAN,
        "senhaCorreta"    BOOLEAN,
        "ultimoLogin"     TIMESTAMP WITH TIME ZONE,
        "opcoes"          JSON
    ) AS $$

/*
SELECT *
FROM seguranca.LoginUsuario(
        'jamal',
        'teste123'
);
*/

DECLARE
    vSenhaCorreta BOOLEAN;
BEGIN

    vSenhaCorreta = (SELECT ua.senha = md5(pSenha)
                     FROM Seguranca.usuarioAcesso ua
                     WHERE ua.logon = pLogin);

    IF vSenhaCorreta IS TRUE
    THEN
        UPDATE Seguranca.usuarioAcesso ua
        SET ultimoLogin = NOW()
        WHERE ua.logon = pLogin;
    END IF;

    RETURN QUERY
    SELECT
        ua.idusuario,
        ua.id,
        ua.idtipousuario,
        ua.nome,
        ua.logon,
        ua.ativo,
        (ua.senha = md5(pSenha)) senhaCorreta,
        ua.ultimoLogin,
        (CASE WHEN (ua.senha = md5(pSenha))
            THEN (SELECT COALESCE(json_agg(opcoesJson), '[]')
                  FROM (SELECT
                            opm.id,
                            opm.idmae,
                            opm.url,
                            opm.nome
                        FROM Seguranca.opcaomenuacesso opma
                            INNER JOIN Seguranca.opcaomenu opm ON (opma.idopcaomenu = opm.id)
                        WHERE opma.idtipousuario = ua.idtipousuario
                        ORDER BY opm.nome) opcoesJson)
         ELSE
             '[]'
         END)                    opcoes
    FROM seguranca.usuarioacesso ua
    WHERE ua.logon = pLogin;
END;
$$
LANGUAGE PLPGSQL;

SELECT *
FROM public.DeletarFuncoes('Seguranca', 'RefazLogin');
CREATE OR REPLACE FUNCTION Seguranca.RefazLogin(
    pIdUsuarioAcesso INTEGER
)
    RETURNS TABLE(
        "idUsuario"       INTEGER,
        "idUsuarioAcesso" INTEGER,
        "idTipoUsuario"   INTEGER,
        "nome"            VARCHAR,
        "logon"           VARCHAR,
        "ativo"           BOOLEAN,
        "opcoes"          JSON
    ) AS $$

-- SELECT * FROM seguranca.RefazLogin(1);

BEGIN
    RETURN QUERY
    SELECT
        ua.idusuario,
        ua.id,
        ua.idtipousuario,
        ua.nome,
        ua.logon,
        ua.ativo,
        (SELECT CASE
                WHEN json_agg(opcoesJson) IS NULL
                    THEN '[]'
                ELSE json_agg(opcoesJson) END
         FROM (SELECT
                   opm.id,
                   opm.idmae,
                   opm.url,
                   opm.nome
               FROM Seguranca.opcaomenuacesso opma
                   INNER JOIN Seguranca.opcaomenu opm ON (opma.idopcaomenu = opm.id)
               WHERE opma.idtipousuario = ua.idtipousuario
               ORDER BY opm.nome) opcoesJson) opcoes
    FROM seguranca.usuarioacesso ua
    WHERE ua.id = pIdUsuarioAcesso;
END;
$$
LANGUAGE PLPGSQL;
