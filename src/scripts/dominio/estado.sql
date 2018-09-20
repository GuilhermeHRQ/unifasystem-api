SELECT public.DeletarFuncoes('Administracao', 'SelecionarEstados');
CREATE OR REPLACE FUNCTION Administracao.SelecionarEstados()
    RETURNS TABLE(
        "sigla" CHAR(2),
        "nome"  VARCHAR(60)
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarEstados();
*/


BEGIN

    RETURN QUERY
    SELECT
        e.sigla,
        e.nome
    FROM Administracao.estado e;
END;
$$
LANGUAGE PLPGSQL;