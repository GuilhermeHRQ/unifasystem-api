CREATE OR REPLACE FUNCTION seguranca.LoginUsuario(
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
        "senhaCorreta"    BOOLEAN
    ) AS $$

/*
SELECT *
FROM seguranca.LoginUsuario(
        'admin',
        'teste123'
);
*/

BEGIN

    RETURN QUERY
    SELECT
        ua.idusuario,
        ua.id,
        ua.idtipousuario,
        ua.nome,
        ua.logon,
        ua.ativo,
        (ua.senha = md5(pSenha))
    FROM seguranca.usuarioacesso ua
    WHERE ua.logon = pLogin;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION seguranca.RefazLogin(
    pIdUsuarioAcesso INTEGER
)
    RETURNS TABLE(
        "idUsuario"       INTEGER,
        "idUsuarioAcesso" INTEGER,
        "idTipoUsuario"   INTEGER,
        "nome"            VARCHAR,
        "logon"           VARCHAR
    ) AS $$

-- SELECT * FROM seguranca.RefazLogin(1);

BEGIN
    RETURN QUERY
    SELECT
        ua.idusuario,
        ua.id,
        ua.idtipousuario,
        ua.nome,
        ua.logon
    FROM seguranca.usuarioacesso ua
    WHERE ua.id = pIdUsuarioAcesso;
END;
$$
LANGUAGE PLPGSQL;


