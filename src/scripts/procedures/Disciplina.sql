SELECT public.DeletarFuncoes('Administracao', 'InserirDisciplina');
CREATE OR REPLACE FUNCTION Administracao.InserirDisciplina(
    pNome         VARCHAR(60),
    pCargaHoraria NUMERIC(5, 2),
    pDescricao    VARCHAR(250)
)
    RETURNS JSON AS $$
/*
    SELECT * FROM Administracao.InserirDisciplina('Matematica', 500.00, 'Foda pra krl');
*/

DECLARE
    vId INTEGER;

BEGIN
    INSERT INTO Administracao.disciplina (
        nome,
        descricao,
        cargahoraria
    ) VALUES (
        pNome,
        pDescricao,
        pCargaHoraria
    )
    RETURNING id
        INTO vId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Disciplina inserida com sucesso',
        'content', vId
    );
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarDisciplina');
CREATE OR REPLACE FUNCTION Administracao.SelecionarDisciplina(
    pFiltro VARCHAR(200),
    pLinhas INTEGER,
    pPagina INTEGER
)
    RETURNS TABLE(
        "totalLinhas"  BIGINT,
        "id"           INTEGER,
        "nome"         VARCHAR(60),
        "cargaHoraria" NUMERIC(5, 2)
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarDisciplina(null, 10, 1);
*/

BEGIN
    RETURN QUERY
    SELECT
        COUNT(1)
        OVER (
            PARTITION BY 1 ),
        d.id,
        d.nome,
        d.cargaHoraria
    FROM Administracao.disciplina d
    WHERE pFiltro IS NULL OR d.nome ILIKE '%' || pFiltro || '%'
    LIMIT CASE WHEN pLinhas > 0 AND pPagina > 0
        THEN
            pLinhas
          ELSE
              NULL
          END
    OFFSET CASE WHEN pLinhas > 0 AND pPagina > 0
        THEN
            (pPagina - 1) * pLinhas
           ELSE
               NULL
           END;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'SelecionarDisciplinaPorId');
CREATE OR REPLACE FUNCTION Administracao.SelecionarDisciplinaPorId(
    pId INTEGER
)
    RETURNS TABLE(
        "id"           INTEGER,
        "nome"         VARCHAR(60),
        "descricao"    VARCHAR(250),
        "cargaHoraria" NUMERIC(5, 2),
        "ativo"        BOOLEAN
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarDisciplinaPorId(2);
*/

BEGIN
    RETURN QUERY
    SELECT
        d.id,
        d.nome,
        d.descricao,
        d.cargaHoraria,
        d.ativo
    FROM Administracao.disciplina d
    WHERE d.id = pId;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'AtualizarDisciplina');
CREATE OR REPLACE FUNCTION Administracao.AtualizarDisciplina(
    pId           INTEGER,
    pNome         VARCHAR(60),
    pCargaHoraria NUMERIC(5, 2),
    pDescricao    VARCHAR(250),
    pAtivo        BOOLEAN
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.AtualizarDisciplina(
        2,
        'História',
        50.5,
        'Mais ou menos',
        true
    );
*/

BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.disciplina
                  WHERE id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Disciplina não encontrada'
        );
    END IF;

    UPDATE Administracao.disciplina
    SET nome         = pNome,
        cargaHoraria = pCargaHoraria,
        descricao    = pDescricao,
        ativo        = pAtivo
    WHERE id = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Disciplina atualizada com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'ExcluirDisciplina');
CREATE OR REPLACE FUNCTION Administracao.ExcluirDisciplina(
    pId INTEGER
)
    RETURNS JSON AS $$

/*
    SELECT * FROM Administracao.ExcluirDisciplina(2);
*/

BEGIN

    IF NOT EXISTS(SELECT 1
                  FROM Administracao.disciplina
                  WHERE id = pId)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Disciplina não encontrada'
        );
    END IF;

    DELETE FROM Administracao.disciplina
    WHERE id = pId;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Disciplina excluída com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;
