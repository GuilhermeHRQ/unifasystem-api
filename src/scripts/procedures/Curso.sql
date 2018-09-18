SELECT public.DeletarFuncoes('Administracao', 'InserirCurso');
CREATE OR REPLACE FUNCTION Administracao.InserirCurso(
    pIdCoordenador INTEGER,
    pNome          VARCHAR(60),
    pDescricao     VARCHAR(250),
    pValor         NUMERIC(10, 2)
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.InserirCurso(
        7,
        'Sistemas',
        'Formatar PC',
        15200.00
    );
*/

BEGIN
    INSERT INTO Administracao.curso (
        idCoordenador,
        nome,
        descricao,
        valor
    ) VALUES (
        pIdCoordenador,
        pNome,
        pDescricao,
        pValor
    );

    RETURN json_build_object(
        'excutionCode', 0,
        'message', 'Curso inserido com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarCurso');
CREATE OR REPLACE FUNCTION Administracao.SelecionarCurso(
    pFiltro VARCHAR(200),
    pLinhas INTEGER,
    pPagina INTEGER
)
    RETURNS TABLE(
        "totalLinhas" BIGINT,
        "id"          INTEGER,
        "nome"        VARCHAR,
        "ativo"       BOOLEAN
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarCurso('', 10, 1);
*/

BEGIN
    RETURN QUERY
    SELECT
        COUNT(1)
        OVER (
            PARTITION BY 1 ),
        c.id,
        c.nome,
        c.ativo
    FROM Administracao.curso c
    WHERE
        CASE WHEN pFiltro IS NOT NULL
            THEN
                c.nome ILIKE '%' || pFiltro || '%'
        ELSE
            TRUE
        END
    LIMIT
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN
                pLinhas
        ELSE
            NULL
        END
    OFFSET
        CASE WHEN pLinhas > 0 AND pPagina > 0
            THEN
                (pPagina - 1) * pLinhas
        ELSE
            NULL
        END;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarCursoPorId');
CREATE OR REPLACE FUNCTION Administracao.SelecionarCursoPorId(
    pId INTEGER
)
    RETURNS TABLE(
        "id"            INTEGER,
        "idCoordenador" INTEGER,
        "nome"          VARCHAR,
        "descricao"     VARCHAR,
        "valor"         NUMERIC(10, 2),
        "ativo"         BOOLEAN
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarCursoPorId(1);
*/

BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.idCoordenador,
        c.nome,
        c.descricao,
        c.valor,
        c.ativo
    FROM Administracao.curso c
    WHERE c.id = pId;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'AtualizarCurso');
CREATE OR REPLACE FUNCTION Administracao.AtualizarCurso(
    pId            INTEGER,
    pIdCoordenador INTEGER,
    pNome          VARCHAR,
    pDescricao     VARCHAR,
    pValor         NUMERIC(10, 2),
    pAtivo         BOOLEAN
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.AtualizarCurso(
        2,
        8,
        'Engenharia',
        'Mexe com numero',
        5000.00,
        TRUE
    );
*/

BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.curso
                  WHERE id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Curso não encontrado'
        );
    END IF;

    UPDATE Administracao.curso
    SET idCoordenador = pIdCoordenador,
        nome          = pNome,
        descricao     = pDescricao,
        valor         = pValor,
        ativo         = pAtivo
    WHERE id = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Curso atualizado com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'ExcluirCurso');
CREATE OR REPLACE FUNCTION Administracao.ExcluirCurso(
    pId INTEGER
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.ExcluirCurso(1);
*/

BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.curso
                  WHERE id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Curso não encontrado'
        );
    END IF;

    DELETE FROM Administracao.curso
    WHERE id = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Curso excluído com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;