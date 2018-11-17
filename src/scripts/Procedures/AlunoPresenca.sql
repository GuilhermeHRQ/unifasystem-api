/*
* TODO
* Alunos que não fazem determinadas aulas, estão na mesma turma?
* Receber array de disciplinas, e verficiar turma e disciplina aberta!!!!
*/

/*SELECT public.DeletarFuncoes('Administracao', 'VerificarChamadaAbertaTurma');
CREATE OR REPLACE FUNCTION Administracao.VerificarChamadaAbertaTurma(
    pIdTurma INTEGER
)
    RETURNS BOOLEAN AS $$

/*
    Documentation
    Source............: AlunoPresenca.sql
    Objective.........: Verifica se existe uma chamada em aberto, para a turma do aluno
    Autor.............: Guilherme Henrique
    Data..............: 01/11/2018
    Ex................:

    SELECT * FROM Administracao.VerificarChamadaAbertaTurma(
        237
    );
*/

BEGIN
    IF EXISTS(SELECT 1
              FROM Administracao.controlePresenca cp
              WHERE cp.idStatus = 1
                    AND cp.idTurma = pIdTurma)
    THEN
        RETURN TRUE;
    END IF;

    RETURN FALSE;
END;
$$
LANGUAGE PLPGSQL;*/

/*
* TODO
* Verificar também pelo horário da chamada, para poder inserir presença
* Fazer a verificação dos 75% por fora, para poder dar uma mensagem pro aluno que ele irá ficar sem presença
*/

SELECT public.DeletarFuncoes('Administracao', 'InserirPresencaAluno');
CREATE OR REPLACE FUNCTION Administracao.InserirPresencaAluno(
    pIdTurma   INTEGER,
    pIdAluno   INTEGER,
    pNomeAluno VARCHAR(100)
)
    RETURNS JSON AS $$

/*
    Documentation
    Source............: AlunoPresenca.sql
    Objective.........: Insere presença para o aluno
    Autor.............: Guilherme Henrique
    Data..............: 01/11/2018
    Ex................:

    SELECT * FROM Administracao.InserirPresencaAluno(
        237,
        1522,
        'Freii'
    );
*/

DECLARE
    vOcorrencia INTEGER;
    vIndex INTEGER;
    vArrayAux BOOLEAN[];
BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.controlePresenca cp
                  WHERE cp.idStatus = 1
                        AND cp.idTurma = pIdTurma)
    THEN
        RETURN json_build_object(
            'executionCode', 2,
            'message', 'No momento não existe nenhuma chamada em aberto para você'
        );
    END IF;

    --     CRIANDO TABELAS TEMPORARIAS COM DADOS NECESSÁRIOS PARA AS VERIFICAÇÕES
    CREATE TEMPORARY TABLE TControlePresenca AS
        SELECT
            cp.id,
            cp.quantidadePresencas,
            cp.horaAbertura,
            cp.horaFechamento
        FROM Administracao.controlePresenca cp
        WHERE cp.idTurma = pIdTurma
              AND cp.idStatus = 1;

    CREATE TEMPORARY TABLE TAlunoPresenca AS
        SELECT
            ap.idAluno,
            ap.horaEntrada,
            ap.horaSaida
        FROM Administracao.AlunoPresenca ap
        WHERE ap.idControlePresenca = (SELECT id
                                       FROM TControlePresenca)
              AND ap.idAluno = pIdAluno;

    -- VERIFICA SE O ALUNO JÁ SE ENCONTRA NA LISTA DE PRESENÇAS, CASO NÃO, O INSERE NA LISTA
    IF NOT EXISTS(SELECT idAluno
                  FROM TAlunoPresenca)
    THEN

        -- GERA O ARRAY PARA JOGAR PRESENÇAS PARA O ALUNO
        vIndex := 0;

        LOOP
            vArrayAux = array_append(vArrayAux, TRUE);
            vIndex := vIndex + 1;
            EXIT WHEN vIndex = (SELECT quantidadePresencas FROM TControlePresenca);
        END LOOP ;

        INSERT INTO Administracao.alunoPresenca (
            idControlePresenca,
            idAluno,
            nomeAluno,
            horaEntrada,
            presencas)
        VALUES (
            (SELECT id
             FROM TControlePresenca),
            pIdAluno,
            pNomeAluno,
            CURRENT_TIME,
            vArrayAux
        );
        vOcorrencia := 1;
    ELSE
        -- CASO SIM, VERIFICA SE ELE JÁ FEZ PASSOU O CARTÃO PARA SAIDA
        IF ((SELECT CURRENT_TIME ::TIME - (SELECT horaEntrada
                                     FROM TAlunoPresenca)) < ('5 minutes' :: INTERVAL)) IS TRUE
        THEN
            vOcorrencia := 2;
        ELSE
            IF (SELECT horaSaida
                FROM TAlunoPresenca) IS NULL
            THEN
                -- CASO NÃO TENHA PASSADO CARTÃO PARA SAIDA, FAZ A VERIFICAÇÃO SE O MESMO FICOU UM TEMPO >= A 75% DA AULA
                IF (SELECT CalcularTempoAulaAluno
                    FROM Administracao.CalcularTempoAulaAluno(
                        (SELECT horaAbertura
                         FROM TControlePresenca),
                        (SELECT horaFechamento
                         FROM TControlePresenca),
                        (SELECT horaEntrada
                         FROM TAlunoPresenca),
                        CURRENT_TIME :: TIME WITHOUT TIME ZONE
                    )) IS TRUE
                THEN
                    UPDATE Administracao.alunoPresenca
                    SET horaSaida = CURRENT_TIME :: TIME WITHOUT TIME ZONE
                    WHERE idAluno = pIdAluno;
                ELSE
                    -- GERA O ARRAY PARA JOGAR PRESENÇAS PARA O ALUNO
                    vIndex := 0;

                    LOOP
                        vArrayAux = array_append(vArrayAux, FALSE);
                        vIndex := vIndex + 1;
                        EXIT WHEN vIndex = (SELECT quantidadePresencas FROM TControlePresenca);
                    END LOOP ;

                    UPDATE Administracao.alunoPresenca
                    SET horaSaida           = CURRENT_TIME :: TIME WITHOUT TIME ZONE,
                        presencas           = vArrayAux
                    WHERE idAluno = pIdAluno;
                END IF;

                vOcorrencia := 3;
            ELSE
                vOcorrencia := 4;
            END IF;
        END IF;
    END IF;

    DROP TABLE IF EXISTS TControlePresenca;
    DROP TABLE IF EXISTS TAlunoPresenca;

    CASE vOcorrencia
        WHEN 1
        THEN
            RETURN json_build_object(
                'executionCode', 0,
                'message', 'Presença confirmada às ' || (SELECT date_part('hours', now()) || ':' || date_part('minutes', now()))
            );
        WHEN 2
        THEN
            RETURN json_build_object(
                'executionCode', 3,
                'message', 'Fazem menos de 5 minutos que você deu entrada nesta aula, por favor aguarde'
            );
        WHEN 3
        THEN
            RETURN json_build_object(
                'executionCode', 1,
                'message', 'Saída confirmada às ' || (SELECT date_part('hours', now()) || ':' || date_part('minutes', now()))
            );
        WHEN 4
        THEN
            RETURN json_build_object(
                'executionCode', 4,
                'message', 'Sua presença já foi confirmada nesta aula, caso tenha alguma dúvida procure o professor'
            );
    END CASE;
END;
$$
LANGUAGE PLPGSQL;

SELECT public.DeletarFuncoes('Administracao', 'CalcularTempoAulaAluno');
CREATE OR REPLACE FUNCTION Administracao.CalcularTempoAulaAluno(
    pHoraAbertura   TIME,
    pHoraFechamento TIME,
    pEntrada        TIME,
    pSaida          TIME
)
    RETURNS BOOLEAN AS $$

/*
    Documentation
    Source............: AlunoPresenca.sql
    Objective.........: Verifica se o aluno permaneceu em aula um tempo >= a 75% do tempo total
    Autor.............: Guilherme Henrique
    Data..............: 02/11/2018
    Ex................:

    SELECT * FROM Administracao.CalcularTempoAulaAluno(
        '17:10' ::TIME,
        '11:00' ::TIME,
        '09:00' ::TIME,
        '10:20' ::TIME
    );
*/

DECLARE
    vPorcentagemMinimaAula           INTEGER;
    vPorcetagemTempoPermanenciaAluno INTEGER;
BEGIN
    vPorcentagemMinimaAula := (SELECT (((EXTRACT('hours' FROM ((pHoraFechamento - pHoraAbertura))) * 3600) +
                                        (EXTRACT('minutes' FROM ((pHoraFechamento - pHoraAbertura))) * 60) +
                                        (EXTRACT('seconds' FROM ((pHoraFechamento - pHoraAbertura))))) / 100) * 75);

    vPorcetagemTempoPermanenciaAluno := (SELECT ((EXTRACT('hours' FROM ((pSaida - pEntrada))) * 3600) +
                                                 (EXTRACT('minutes' FROM ((pSaida - pEntrada))) * 60) +
                                                 (EXTRACT('seconds' FROM ((pSaida - pEntrada))))));

    RETURN vPorcetagemTempoPermanenciaAluno >= vPorcentagemMinimaAula;
END;
$$
LANGUAGE PLPGSQL;

