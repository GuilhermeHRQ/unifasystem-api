SELECT public.DeletarFuncoes('Administracao', 'VerificarChamadaAbertaTurma');
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
LANGUAGE PLPGSQL;