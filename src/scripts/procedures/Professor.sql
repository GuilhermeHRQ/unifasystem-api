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
    '11111111',
    'Jamal',
    'Oliveira',
    '1999-02-12',
    1000.00,
    'a@b.com',
    '16992417883',
    'jamale',
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

    IF EXISTS(SELECT 1
              FROM Seguranca.usuarioAcesso ua
              WHERE ua.logon = pLogon)
    THEN
        RETURN json_build_object(
            'executionCode', 3,
            'message', 'Logon já cadastrado'
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
        "cpf"         CHAR(11),
        "ativo"       BOOLEAN
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
        p.cpf,
        ua.ativo
    FROM Administracao.professor p
        INNER JOIN Seguranca.usuarioAcesso ua ON ua.idUsuario = p.id
    WHERE
        CASE WHEN pFiltro IS NOT NULL
            THEN p.nome ILIKE '%' || pFiltro || '%' OR p.sobrenome ILIKE '%' || pFiltro || '%'
        ELSE
            TRUE
        END
        AND ua.ativo IS TRUE
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
        "ativo"          BOOLEAN,
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
        ua.ativo,
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


SELECT public.DeletarFuncoes('Administracao', 'AtualizarProfessor');
CREATE OR REPLACE FUNCTION Administracao.AtualizarProfessor(
    pId             INTEGER,
    pCpf            CHAR(8),
    pNome           VARCHAR(30),
    pSobrenome      VARCHAR(30),
    pDataNascimento DATE,
    pSalario        NUMERIC(10, 2),
    pEmail          VARCHAR(255),
    pTelefone       CHAR(11),
    pLogon          VARCHAR(10),
    pAtivo          BOOLEAN,
    pEndereco       JSON
)
    RETURNS JSON AS $$

/*
SELECT * FROM Administracao.AtualizarProfessor (
    8,
    '13245678908',
    'Adroso',
    'Bata',
    '2018-09-18',
    15520.20,
    'batata@va.com',
    '16998635542',
    'jamelaco',
    true,
    '[
        {
            "id": 7,
            "cep": "14409023",
            "idCidade": 2,
            "logradouro": "Rua das Pinhas",
            "numero": "564",
            "bairro": "Distrito",
            "complemento": "Em frente o poste"
        }
    ]' ::JSON
);
*/

BEGIN

    IF EXISTS(SELECT 1
              FROM Administracao.professor p
              WHERE p.cpf = pCpf
                    AND p.id <> pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'CPF já cadastrado'
        );
    END IF;

    IF EXISTS(SELECT 1
              FROM Administracao.professor p
              WHERE p.email = pEmail
                    AND p.id <> pId)
    THEN
        RETURN json_build_object(
            'executionCode', 2,
            'message', 'Email já cadastrado'
        );
    END IF;

    IF EXISTS(SELECT 1
              FROM Seguranca.usuarioAcesso ua
              WHERE ua.logon = pLogon
                    AND ua.idUsuario <> pId)
    THEN
        RETURN json_build_object(
            'executionCode', 3,
            'message', 'Logon já cadastrado'
        );
    END IF;


    UPDATE Administracao.professor
    SET cpf            = pCpf,
        nome           = pNome,
        sobrenome      = pSobrenome,
        dataNascimento = pDataNascimento,
        salario        = pSalario,
        email          = pEmail,
        telefone       = pTelefone
    WHERE id = pId;

    UPDATE Administracao.endereco pe
    SET cep         = e."cep",
        idCidade    = e."idCidade",
        logradouro  = e."logradouro",
        bairro      = e."bairro",
        numero      = e."numero",
        complemento = e."complemento"
    FROM json_to_recordset(pEndereco)
        AS e(
         "id" INTEGER,
         "cep" CHAR(8),
         "idCidade" INTEGER,
         "logradouro" VARCHAR,
         "bairro" VARCHAR,
         "numero" VARCHAR,
         "complemento" VARCHAR
         )
    WHERE pe.id = e.id;

    UPDATE Seguranca.usuarioAcesso
    SET nome  = pNome,
        logon = pLogon,
        ativo = pAtivo
    WHERE idUsuario = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Professor atualizado com sucesso'
    );
END;

$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'ExcluirProfessor');
CREATE OR REPLACE FUNCTION Administracao.ExcluirProfessor(
    pId INTEGER
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.ExcluirProfessor(8);
*/

BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.professor p
                  WHERE p.id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Professor não encontrado'
        );
    END IF;

    UPDATE Seguranca.usuarioAcesso
    SET ativo = FALSE
    WHERE idUsuario = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Professor excluído com sucesso'
    );
END;

$$
LANGUAGE PLPGSQL;

