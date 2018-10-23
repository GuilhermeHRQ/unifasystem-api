SELECT public.DeletarFuncoes('Administracao', 'VerificarChamadaDisciplinaAberta');
CREATE OR REPLACE FUNCTION Administracao.VerificarChamadaDisciplinaAberta(
    pDisciplinas TEXT[]
)
    RETURNS JSON AS $$

/*
    Documentation
    Source............: AlunoPresenca.sql
    Objective.........: Verifica se existe uma chamada em aberto, para alguma das disciplinas as quais o aluno tem acesso
    Autor.............: Guilherme Henrique
    Data..............: 23/10/2018
    Ex................:

    SELECT * FROM Administracao.VerificarChamadaDisciplinaAberta(
        '{"4032-241", "207-5465"}' ::TEXT[]
    );
*/

DECLARE
    vIdControlePresenca INTEGER;

BEGIN
    vIdControlePresenca := (SELECT cp.id
                            FROM Administracao.controlePresenca cp
                            WHERE cp.idDisciplina = ANY(pDisciplinas)
                              AND cp.idStatus = 1);

    RETURN json_build_object(
        'executionCode', iif(vIdControlePresenca IS NOT NULL, 0, 1),
        'content', vIdControlePresenca
    );
END;
$$
LANGUAGE PLPGSQL;