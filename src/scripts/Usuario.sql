CREATE OR REPLACE FUNCTION seguranca.LoginUsuario(
    pLogin VARCHAR,
    pSenha VARCHAR
)
    RETURNS TABLE(
        "idUsuario"       INTEGER,
        "idUsuarioAcesso" INTEGER,
        "idTipoUsuario"   INTEGER,
        "nome"            VARCHAR(50),
        "email"           VARCHAR(255),
        "logon"           VARCHAR(10),
        "ativo"           BOOLEAN,
        "senhaCorreta"    BOOLEAN
    ) AS $$

/*
SELECT *
FROM seguranca.LoginUsuario(
        'teste',
        ''
);
*/

BEGIN

    RETURN QUERY
    SELECT
        a.id,
        ua.id,
        ua.idtipousuario,
        a.nome,
        a.email,
        ua.logon,
        ua.ativo,
        (md5(pSenha) = ua.senha)
    FROM seguranca.usuarioacesso ua
        INNER JOIN seguranca.administrador a on ua.id = a.idusuarioacesso
    WHERE ua.logon = pLogin;
END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION seguranca.RefazLogin(
    pIdUsuarioAcesso INTEGER,
    pIdUsuario INTEGER
)
    RETURNS TABLE(
        "idUsuario"       INTEGER,
        "idUsuarioAcesso" INTEGER,
        "idTipoUsuario"   INTEGER,
        "nome"            VARCHAR,
        "email"           VARCHAR,
        "logon"           VARCHAR
    ) AS $$

SELECT * FROM seguranca.RefazLogin(1);

BEGIN
    RETURN QUERY
    SELECT
        u.id,
        ua.id,
        ua.idtipousuario,
        u.nome,
        u.email,
        ua.logon
    FROM seguranca.usuarioacesso ua
        INNER JOIN seguranca.administrador u ON (u.idusuarioacesso = ua.id)
    WHERE ua.id = pIdUsuarioAcesso AND u.id = pIdUsuario;
END;
$$
LANGUAGE PLPGSQL;


