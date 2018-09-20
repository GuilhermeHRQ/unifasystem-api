SELECT public.DeletarFuncoes('Administracao', 'SelecionarCidade');
CREATE OR REPLACE FUNCTION Administracao.SelecionarCidade(
    pUf CHAR(2)
)
    RETURNS TABLE(
        "id"   INTEGER,
        "nome" VARCHAR(60)
    ) AS $$

/*
    SELECT * FROM Administracao.SelecionarCidade('SP');
*/

BEGIN
    RETURN QUERY
    SELECT
        c.id,
        c.nome
    FROM Administracao.cidade c
    WHERE pUf IS NULL OR c.uf = pUf;
END;
$$
LANGUAGE PLPGSQL;