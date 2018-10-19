SELECT public.DeletarFuncoes('Administracao', 'InserirControlePresenca');
CREATE OR REPLACE FUNCTION Administracao.InserirControlePresenca(
    pSemestre            INTEGER,
    pIdDisciplina        VARCHAR(10),
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
        4,
        '402-240',
        1,
        '4º SEM Sistemas de Informação',
        'Engenharia de Software',
        '19:15' ::TIME,
        '20:40' ::TIME,
        2,
        null
    );
*/
DECLARE
    vId INTEGER;

BEGIN
    INSERT INTO Administracao.controlePresenca (
        semestre,
        idDisciplina,
        idProfessor,
        nomeTurma,
        nomeDisciplina,
        horaAbertura,
        horaFechamento,
        quantidadePresencas,
        conteudo,
        idStatus
    ) VALUES (
        pSemestre,
        pIdDisciplina,
        pIdProfessor,
        pNomeTurma,
        pNomeDisciplina,
        pHoraAbertura,
        pHoraFecahamento,
        pQuantidadePresencas,
        pConteudo,
        1
    )
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


