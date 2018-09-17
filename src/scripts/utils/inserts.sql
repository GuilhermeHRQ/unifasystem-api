-- ESTADO
SELECT *
FROM administracao.estado;
INSERT INTO administracao.estado
VALUES
    ('SP', 'São Paulo'),
    ('MG', 'Minas Gerais'),
    ('RJ', 'Rio de Janeiro');

-- CIDADE
SELECT *
FROM administracao.cidade;
INSERT INTO administracao.cidade
VALUES
    (1, 'Franca', 'SP'),
    (2, 'Passos', 'MG'),
    (3, 'Rio de Janeiro', 'RJ');

-- TIPOUSUARIO
SELECT *
FROM seguranca.tipousuario;
INSERT INTO seguranca.tipousuario
VALUES
    (1, 'Administrador'),
    (2, 'Professor'),
    (3, 'Aluno');

SELECT *
FROM administracao.turno;
INSERT INTO administracao.turno (nome, horainicio, horatermino)
VALUES
    --     ('Manhã', '08:00', '12:00'),
    ('Tarde', '12:00', '18:00'),
    ('Noite', '19:00', '22:30');