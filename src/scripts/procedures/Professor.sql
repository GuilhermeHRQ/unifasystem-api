SELECT public.DeletarFuncoes('Administracao', 'InserirProfessor');
CREATE OR REPLACE FUNCTION Administracao.InserirProfessor(
    pCpf            CHAR(11),
    pNome           VARCHAR(30),
    pSobrenome      VARCHAR(30),
    pDataNascimento DATE,
    pSalario        NUMERIC(10, 2),
    pEmail          VARCHAR(255),
    pTelefone       CHAR(11),
    pLogon          VARCHAR(10),
    pSenha          VARCHAR(100),
    pEndereco       JSON
)
    RETURNS JSON AS $$

/*

SELECT * FROM Administracao.InserirProfessor(
    '12345678909',
    'Jamal',
    'Oliveira',
    '1999-02-12',
    1000.00,
    'jamal@b.com',
    '16992417883',
    'jamal',
    'teste123',
    '[
        {
            "cep": "14409013",
            "idCidade": 1,
            "logradouro": "Rua Jose Oliva",
            "numero": "33",
            "bairro": "Batatao",
            "complemento": "Iparitondgqa esquerda"
        }
    ]' ::JSON
);

*/

DECLARE
    vIdEndereco  INTEGER;
    vIdProfessor INTEGER;
BEGIN

    IF EXISTS(SELECT 1
              FROM Administracao.professor p
              WHERE p.cpf = pCpf)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'CPF já cadastrado'
        );
    END IF;



    IF EXISTS(SELECT 1
              FROM Administracao.professor p
              WHERE p.email = pEmail)
    THEN
        RETURN json_build_object(
            'executionCode', 2,
            'message', 'Email já cadastrado'
        );
    END IF;

    IF pEndereco IS NOT NULL
    THEN
        INSERT INTO Administracao.endereco (
            cep,
            idCidade,
            logradouro,
            numero,
            bairro,
            complemento
        )
            SELECT
                "cep",
                "idCidade",
                "logradouro",
                "numero",
                "bairro",
                "complemento"
            FROM json_to_recordset(pEndereco)
                AS x(
                 "cep" CHAR(8),
                 "idCidade" INTEGER,
                 "logradouro" VARCHAR,
                 "numero" VARCHAR,
                 "bairro" VARCHAR,
                 "complemento" VARCHAR
                 )
        RETURNING id
            INTO vIdEndereco;
    END IF;


    INSERT INTO Administracao.professor (
        cpf,
        nome,
        sobrenome,
        dataNascimento,
        salario,
        email,
        telefone,
        idEndereco
    ) VALUES (
        pCpf,
        pNome,
        pSobrenome,
        pDataNascimento,
        pSalario,
        pEmail,
        pTelefone,
        vIdEndereco
    )
    RETURNING id
        INTO vIdProfessor;

    INSERT INTO Seguranca.usuarioAcesso (
        idusuario,
        idtipousuario,
        nome,
        logon,
        senha
    ) VALUES (
        vIdProfessor,
        2, -- Professor
        pNome,
        pLogon,
        md5(pSenha)
    );

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Professor inserido com sucesso',
        'content', json_build_object(
            'id', vIdProfessor
        )
    );
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarProfessor');
CREATE OR REPLACE FUNCTION Administracao.SelecionarProfessor(
    pFiltro VARCHAR(200),
    pLinhas INTEGER,
    pPagina INTEGER
)
    RETURNS TABLE(
        "totalLinhas" BIGINT,
        "id"          INTEGER,
        "nome"        VARCHAR(30),
        "sobrenome"   VARCHAR(30),
        "cpf"         CHAR(11)
    ) AS $$

/*
 SELECT * FROM Administracao.SelecionarProfessor('', 10, 1);
*/

BEGIN
    RETURN QUERY
    SELECT
        COUNT(1)
        OVER (
            PARTITION BY 1 ),
        p.id,
        p.nome,
        p.sobrenome,
        p.cpf
    FROM Administracao.professor p
    WHERE
        CASE WHEN pFiltro IS NOT NULL
            THEN p.nome ILIKE '%' || pFiltro || '%' OR p.sobrenome ILIKE '%' || pFiltro || '%'
        ELSE
            TRUE
        END
    LIMIT
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN pLinhas
        ELSE
            NULL
        END
    OFFSET
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN (pPagina - 1) * pLinhas
        ELSE
            NULL
        END;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarProfessorPorId');
CREATE OR REPLACE FUNCTION Administracao.SelecionarProfessorPorId(
    pId INTEGER
)
    RETURNS TABLE(
        "id"             INTEGER,
        "cpf"            CHAR(11),
        "nome"           VARCHAR,
        "sobrenome"      VARCHAR,
        "dataNascimento" DATE,
        "salario"        NUMERIC(10, 2),
        "email"          VARCHAR,
        "telefone"       CHAR(11),
        "logon"          VARCHAR(10),
        "idTipoUsuario"  INTEGER,
        "ultimoLogin"    TIMESTAMP,
        "endereco"       JSON
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarProfessorPorId(3);
*/

BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.cpf,
        p.nome,
        p.sobrenome,
        p.dataNascimento,
        p.salario,
        p.email,
        p.telefone,
        ua.logon,
        ua.idTipoUsuario,
        ua.ultimoLogin,
        (
            SELECT COALESCE(json_agg(enderecoJson), '[]')
            FROM (
                     SELECT
                         pe.id          "id",
                         pe.cep         "cep",
                         pe.idCidade    "idCidade",
                         pe.logradouro  "logradouro",
                         pe.numero      "numero",
                         pe.bairro      "bairro",
                         pe.complemento "complemento"
                     FROM Administracao.endereco pe
                     WHERE pe.id = p.idEndereco
                 ) enderecoJson
        ) endereco
    FROM Administracao.professor p
        INNER JOIN Seguranca.usuarioAcesso ua ON (ua.idUsuario = p.id)
    WHERE p.id = pId;
END;
$$
LANGUAGE PLPGSQL;

