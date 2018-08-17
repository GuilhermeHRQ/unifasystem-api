CREATE SCHEMA administracao;

CREATE TABLE administracao.disciplina (
    id           SERIAL,
    nome         VARCHAR(60)          CONSTRAINT nn_disciplina_nome NOT NULL,
    descricao    VARCHAR(250)         CONSTRAINT nn_disciplina_descricao NOT NULL,
    cargahoraria DECIMAL(5, 2)        CONSTRAINT nn_disciplina_cargahoraria NOT NULL,
    ativo        BOOLEAN DEFAULT TRUE CONSTRAINT nn_disciplina_ativo NOT NULL,
    CONSTRAINT pk_disciplina_id PRIMARY KEY (id)
);


CREATE TABLE administracao.curso (
    id             SERIAL,
    id_coordenador INTEGER              CONSTRAINT nn_curso_id_coodenador NOT NULL,
    nome           VARCHAR(60)          CONSTRAINT nn_curso_nome NOT NULL,
    descricao      VARCHAR(250)         CONSTRAINT nn_curso_descricao NOT NULL,
    valor          NUMERIC(10, 2)       CONSTRAINT nn_curso_valor NOT NULL,
    ativo          BOOLEAN DEFAULT TRUE CONSTRAINT nn_curso_ativo NOT NULL,
    CONSTRAINT pk_curso_id PRIMARY KEY (id),
    CONSTRAINT fk_curso_professor_id_coordenador FOREIGN KEY (id_coordenador)
    REFERENCES administracao.professor (id),
    CONSTRAINT uq_curso_id_coordenador UNIQUE (id_coordenador)
);

CREATE TABLE administracao.professor (
    id             SERIAL,
    cpf            CHAR(11)       CONSTRAINT nn_professor_cpf NOT NULL,
    nome           VARCHAR(30)    CONSTRAINT nn_professor_nome NOT NULL,
    sobrenome      VARCHAR(30)    CONSTRAINT nn_professor_sobrenome NOT NULL,
    datanascimento DATE           CONSTRAINT nn_professor_datanascimento NOT NULL,
    salario        NUMERIC(10, 2) CONSTRAINT nn_professor_salario NOT NULL,
    email          VARCHAR(255)   CONSTRAINT nn_professor_email NOT NULL,
    telefone       CHAR(11)       CONSTRAINT nn_professor_telefone NOT NULL,
    cep            CHAR(8)        CONSTRAINT nn_professor_cep NOT NULL,
    idcidade       INTEGER        CONSTRAINT nn_professor_idcidade NOT NULL,
    logradouro     VARCHAR(100)   CONSTRAINT nn_professor_logradouro NOT NULL,
    bairro         VARCHAR(50)    CONSTRAINT nn_professor_bairro NOT NULL,
    numero         VARCHAR(5)     CONSTRAINT nn_professor_numero NOT NULL,
    complemento    VARCHAR(30),
    CONSTRAINT pk_professor_id PRIMARY KEY (id),
    CONSTRAINT uq_professor_cpf UNIQUE (cpf),
    CONSTRAINT fk_professor_cidade_idcidade FOREIGN KEY (idcidade) REFERENCES administracao.cidade (id)
);

CREATE TABLE administracao.aluno (
    id             SERIAL,
    cpf            CHAR(11)       CONSTRAINT nn_professor_cpf NOT NULL,
    nome           VARCHAR(30)    CONSTRAINT nn_professor_nome NOT NULL,
    sobrenome      VARCHAR(30)    CONSTRAINT nn_professor_sobrenome NOT NULL,
    datanascimento DATE           CONSTRAINT nn_professor_datanascimento NOT NULL,
    email          VARCHAR(255)   CONSTRAINT nn_professor_email NOT NULL,
    telefone       CHAR(11)       CONSTRAINT nn_professor_telefone NOT NULL,
    cep            CHAR(8)        CONSTRAINT nn_professor_cep NOT NULL,
    idcidade       INTEGER        CONSTRAINT nn_professor_idcidade NOT NULL,
    logradouro     VARCHAR(100)   CONSTRAINT nn_professor_logradouro NOT NULL,
    bairro         VARCHAR(50)    CONSTRAINT nn_professor_bairro NOT NULL,
    numero         VARCHAR(5)     CONSTRAINT nn_professor_numero NOT NULL,
    complemento    VARCHAR(30),
    CONSTRAINT pk_aluno_id PRIMARY KEY (id),
    CONSTRAINT uq_aluno_cpf UNIQUE (cpf),
    CONSTRAINT fk_aluno_cidade_idcidade FOREIGN KEY (idcidade) REFERENCES administracao.cidade (id)
);

CREATE TABLE administracao.estado (
    sigla CHAR(2),
    nome  VARCHAR(60) CONSTRAINT nn_estado_nome NOT NULL,
    CONSTRAINT fk_estado_sigla PRIMARY KEY (sigla)
);

CREATE TABLE administracao.cidade (
    id   INTEGER,
    nome VARCHAR(60) CONSTRAINT nn_cidade_nome NOT NULL,
    uf   CHAR(2)     CONSTRAINT nn_cidade_uf NOT NULL,
    CONSTRAINT pk_cidade_id PRIMARY KEY (id),
    CONSTRAINT fk_cidade_estado_uf FOREIGN KEY (uf) REFERENCES administracao.estado (sigla)
);

