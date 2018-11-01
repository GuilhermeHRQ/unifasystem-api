-- InserirControlePresenca
SELECT public.DeletarFuncoes('Administracao', 'InserirControlePresenca');
CREATE OR REPLACE FUNCTION Administracao.InserirControlePresenca(
    pSemestre            INTEGER,
    pIdDisciplina        BIGINT,
    pIdTurma             INTEGER,
    pIdProfessor         INTEGER,
    pNomeTurma           VARCHAR(100),
    pNomeDisciplina      VARCHAR(100),
    pHoraAbertura        TIME,
    pHoraFecahamento     TIME,
    pQuantidadePresencas INTEGER,
    pConteudo            TEXT
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Inserir um novo controle de presenças
    Autor.............: Guilherme Henrique
    Data..............: 19/10/2018
    Ex................:

    SELECT * FROM Administracao.InserirControlePresenca(
        2,
        5234,
        237,
        1,
        '4º SEM Batata',
        'Eduardo e Monica',
        '20:10' ::TIME,
        '21:00' ::TIME,
        2,
        null
    );
*/
DECLARE
    vId INTEGER;

BEGIN
    INSERT INTO Administracao.controlePresenca (semestre,
                                                idDisciplina,
                                                idTurma,
                                                idProfessor,
                                                nomeTurma,
                                                nomeDisciplina,
                                                horaAbertura,
                                                horaFechamento,
                                                quantidadePresencas,
                                                conteudo,
                                                idStatus)
    VALUES (pSemestre,
            pIdDisciplina,
            pIdTurma,
            pIdProfessor,
            pNomeTurma,
            pNomeDisciplina,
            pHoraAbertura,
            pHoraFecahamento,
            pQuantidadePresencas,
            pConteudo,
            1)
        RETURNING id
            INTO vId;

    RETURN json_build_object(
        'executionCode', 0,
        'content', json_build_object(
            'message', 'Controle de presenças inserido com sucesso',
            'id', vId
        )
    );
END;
$$
LANGUAGE PLPGSQL;

-- SelecionarControlePresenca
SELECT public.DeletarFuncoes('Administracao', 'SelecionarControlePresenca');
CREATE OR REPLACE FUNCTION Administracao.SelecionarControlePresenca(
    pIdProfessor  INTEGER,
    pSemestre     INTEGER,
    pIdDisciplina BIGINT,
    pIdTurma      INTEGER,
    pDataInicial  DATE,
    pDataFinal    DATE,
    pStatus       INTEGER,
    pLinhas       INTEGER,
    pPagina       INTEGER
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Selecionar controles de presenças cadastrados
    Autor.............: Guilherme Henrique
    Data..............: 20/10/2018
    Ex................:

    SELECT * FROM Administracao.SelecionarControlePresenca(
        1,
        null,
        null,
        null,
        null,
        null,
        null,
        10,
        1
    );
*/

DECLARE
    vRes         JSON;
    vTotalLinhas INTEGER;
BEGIN
    CREATE TEMPORARY TABLE TEMP AS
        SELECT cp.id,
               cp.semestre,
               cp.nomeTurma      "nomeTurma",
               cp.nomeDisciplina "nomeDisciplina",
               cp.dataCadastro   "dataCadastro",
               cp.idStatus       "idStatus",
               s.descricao       status
        FROM Administracao.controlePresenca cp
                 INNER JOIN Administracao.status s ON (s.id = cp.idStatus)
        WHERE cp.idProfessor = pIdProfessor
          AND (pSemestre IS NULL OR cp.semestre = pSemestre)
          AND (
                  CASE
                      WHEN pDataInicial IS NULL
                            THEN cp.dataCadastro :: DATE >= CURRENT_DATE
                      ELSE cp.dataCadastro :: DATE >= pDataInicial
                      END
                  )
          AND (
                  CASE
                      WHEN pDataFinal IS NULL
                            THEN cp.dataCadastro :: DATE <= CURRENT_DATE
                      ELSE cp.dataCadastro :: DATE <= pDataFinal
                      END
                  )
          AND (pIdDisciplina IS NULL OR cp.idDisciplina = pIdDisciplina)
          AND (pIdTurma IS NULL OR cp.idTurma = pIdTurma)
          AND (pStatus IS NULL OR cp.idStatus = pStatus)
        ORDER BY cp.dataCadastro;

    vTotalLinhas := (SELECT COUNT(id) FROM TEMP);

    vRes := (SELECT json_agg(exp) FROM (SELECT * FROM TEMP LIMIT pLinhas OFFSET ((pPagina - 1) * pLinhas)) exp);

    DROP TABLE IF EXISTS TEMP;

    RETURN jsonb_build_object(
        'content', COALESCE(vRes, '[]'),
        'totalLinhas', vTotalLinhas
    );
END;
$$
LANGUAGE PLPGSQL;

-- SelecionarControlePresencaPorId
SELECT public.DeletarFuncoes('Administracao', 'SelecionarControlePresencaPorId');
CREATE OR REPLACE FUNCTION Administracao.SelecionarControlePresencaPorId(
    pId INTEGER
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Seleciona um controle de presença com base no id
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.SelecionarControlePresencaPorId(10);
*/

DECLARE
    vRes JSON;
BEGIN
    IF NOT EXISTS(
        SELECT 1 FROM Administracao.controlePresenca WHERE id = pId
    )
    THEN
        RETURN jsonb_build_object(
            'executionCode', 1,
            'message', 'Controle de presenças não encontrado'
        );
    END IF;

    vRes := (SELECT row_to_json(result)
             FROM (SELECT cp.id,
                          cp.semestre,
                          cp.idDisciplina                                   "idDisciplina",
                          cp.idProfessor                                    "idProfessor",
                          cp.nomeTurma                                      "nomeTurma",
                          cp.idTurma                                        "idTurma",
                          cp.nomeDisciplina                                 "nomeDisciplina",
                          cp.horaAbertura                                   "horaAbertura",
                          cp.horaFechamento                                 "horaFechamento",
                          cp.quantidadePresencas                            "quantidadePresencas",
                          cp.conteudo,
                          cp.dataCadastro                                   "dataCadastro",
                          cp.dataConfirmacao                                "dataConfirmacao",
                          cp.idStatus                                       "idStatus",
                          s.descricao,
                          (SELECT COALESCE(json_agg(alunos), '[]')
                           FROM (SELECT ap.idControlePresenca  "idControlePresenca",
                                        ap.idAluno             "idAluno",
                                        ap.nomeAluno           "nomeAluno",
                                        ap.horaEntrada         "horaEntrada",
                                        ap.horaSaida           "horaSaida",
                                        ap.quantidadePresencas "quantidadePresencas"
                                 FROM Administracao.alunoPresenca ap
                                 WHERE ap.idControlePresenca = pId) alunos) alunos
                   FROM Administracao.controlePresenca cp
                            INNER JOIN Administracao.status s ON (s.id = cp.idStatus)
                   WHERE cp.id = pId) result);

    RETURN jsonb_build_object(
        'content', vRes
    );
END;
$$
LANGUAGE PLPGSQL;

-- AtualizarControlePresenca
SELECT public.DeletarFuncoes('Administracao', 'AtualizarControlePresenca');
CREATE OR REPLACE FUNCTION Administracao.AtualizarControlePresenca(
    pIdControle        INTEGER,
    pConteudo          TEXT,
    pAlunos            JSON,
    pConfirmarControle BOOLEAN
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Atualiza o controle de presença
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.AtualizarControlePresenca(
        2,
        'Batatinha quando nasce espalha a rama pelo chão.',
        '[
            {
                "idAluno": 20245,
                "quantidadePresencas": 1
            },
            {
                "idAluno": 2000,
                "quantidadePresencas": 2
            }
        ]' ::JSON,
        1
    );
*/

DECLARE
    vAluno JSON;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Administracao.controlePresenca WHERE id = pIdControle)
    THEN
        RETURN json_build_object(
            'executionCode', 1,
            'message', 'Controle de presenças não encontrado'
        );
    END IF;

    IF pConfirmarControle
    THEN
        IF pConteudo IS NULL
        THEN
            RETURN json_build_object(
                'executionCode', 2,
                'message', 'Deve ser informado o conteúdo lecionado para que o controle possa ser confirmado'
            );
        END IF;

        UPDATE Administracao.controlePresenca
        SET conteudo        = pConteudo,
            idStatus        = 3,
            dataConfirmacao = CURRENT_TIMESTAMP
        WHERE id = pIdControle;
    ELSE
        UPDATE Administracao.controlePresenca SET conteudo = pConteudo WHERE id = pIdControle;
    END IF;


    FOR vAluno IN SELECT * FROM json_array_elements(pAlunos)
    LOOP
        UPDATE Administracao.alunoPresenca
        SET quantidadePresencas = (vAluno ->> 'quantidadePresencas') :: INTEGER
        WHERE idControlePresenca = pIdControle
          AND idAluno = (vAluno ->> 'idAluno') :: INTEGER;
    END LOOP;

    RETURN json_build_object(
        'executionCode', 0,
        'message', 'Controle de presenças atualizado com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

-- CancelarControlePresenca
SELECT public.DeletarFuncoes('Administracao', 'CancelarControlePresenca');
CREATE OR REPLACE FUNCTION Administracao.CancelarControlePresenca(
    pIdControle INTEGER
)
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Cancela um controle de presença
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.CancelarControlePresenca(2);
*/

BEGIN
    IF NOT EXISTS(SELECT 1 FROM Administracao.controlePresenca WHERE id = pIdControle)
    THEN
        RETURN json_build_object(
            'exeutionCode', 1,
            'message', 'Controle de presença não encontrado'
        );
    END IF;

    UPDATE Administracao.controlePresenca SET idStatus = 4 WHERE id = pIdControle;

    RETURN json_build_object(
        'message', 'Controle de presença cancelado com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

-- FecharControlesPresenca
SELECT public.DeletarFuncoes('Administracao', 'FecharControlesPresenca');
CREATE OR REPLACE FUNCTION Administracao.FecharControlesPresenca()
    RETURNS JSON AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Fecha os controles de presenças de acordo com sua hora de fechamento automaticamente
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.FecharControlesPresenca();
*/

BEGIN
    UPDATE Administracao.controlePresenca
    SET idStatus = 2
    WHERE idStatus = 1
      AND (dataCadastro :: DATE || ' ' || horaFechamento) <= CURRENT_TIMESTAMP :: VARCHAR;

    RETURN json_build_object(
        'message', 'OK'
    );
END;
$$
LANGUAGE PLPGSQL;

-- VerificaChamadasProfessor
SELECT public.DeletarFuncoes('Administracao', 'VerificaChamadasProfessor');
CREATE OR REPLACE FUNCTION Administracao.VerificaChamadasProfessor(
    pIdProfessor INTEGER
)
    RETURNS BOOLEAN AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Verifica se o professor possui chamadas em aberto
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.VerificaChamadasProfessor(1);
*/

BEGIN
    IF EXISTS(SELECT 1 FROM Administracao.controlePresenca WHERE idProfessor = pIdProfessor
                                                             AND idStatus = 1
    )
    THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$
LANGUAGE PLPGSQL;

/*SELECT public.DeletarFuncoes('Administracao', 'VerificaChamadasDisciplina');
CREATE OR REPLACE FUNCTION Administracao.VerificaChamadasDisciplina(
    pIdProfessor    INTEGER,
    pIdDisciplina   VARCHAR,
    pHoraAbertura   TIME,
    pHoraFechamento TIME
)
    RETURNS BOOLEAN AS $$

/*
Documentation
    Source............: ControlePresenca.sql
    Objective.........: Verifica se o possui uma chamada em aberto para essa disciplina
    Autor.............: Guilherme Henrique
    Data..............: 21/10/2018
    Ex................:

    SELECT * FROM Administracao.VerificaChamadasProfessor(1);
*/

BEGIN
    IF EXISTS(SELECT 1
              FROM Administracao.controlePresenca
              WHERE idProfessor = pIdProfessor
                    AND idDisciplina = pIdDisciplina
                    AND idStatus = 1
                    AND (horaAbertura BETWEEN pHoraAbertura AND pHoraFechamento
                         OR horaFechamento BETWEEN pHoraAbertura AND pHoraFechamento))
    THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$
LANGUAGE PLPGSQL;*/