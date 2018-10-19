-- CREATE SCHEMA administracao;

-- DROP TABLE administracao.disciplina CASCADE;
CREATE TABLE administracao.disciplina (
    id           SERIAL,
    nome         VARCHAR(60)          CONSTRAINT nn_disciplina_nome NOT NULL,
    descricao    VARCHAR(250)         CONSTRAINT nn_disciplina_descricao NOT NULL,
    cargahoraria DECIMAL(5, 2)        CONSTRAINT nn_disciplina_cargahoraria NOT NULL,
    ativo        BOOLEAN DEFAULT TRUE CONSTRAINT nn_disciplina_ativo NOT NULL,
    CONSTRAINT pk_disciplina_id PRIMARY KEY (id)
);

-- DROP TABLE administracao.curso CASCADE;
CREATE TABLE administracao.curso (
    id            SERIAL,
    idcoordenador INTEGER              CONSTRAINT nn_curso_id_coodenador NOT NULL,
    nome          VARCHAR(60)          CONSTRAINT nn_curso_nome NOT NULL,
    descricao     VARCHAR(250)         CONSTRAINT nn_curso_descricao NOT NULL,
    valor         NUMERIC(10, 2)       CONSTRAINT nn_curso_valor NOT NULL,
    ativo         BOOLEAN DEFAULT TRUE CONSTRAINT nn_curso_ativo NOT NULL,
    CONSTRAINT pk_curso_id PRIMARY KEY (id),
    CONSTRAINT fk_curso_professor_id_coordenador FOREIGN KEY (idcoordenador)
    REFERENCES administracao.professor (id),
    CONSTRAINT uq_curso_id_coordenador UNIQUE (idcoordenador)
);

-- DROP TABLE administracao.professor CASCADE;
CREATE TABLE administracao.professor (
    id             SERIAL,
    cpf            CHAR(11)       CONSTRAINT nn_professor_cpf NOT NULL,
    nome           VARCHAR(30)    CONSTRAINT nn_professor_nome NOT NULL,
    sobrenome      VARCHAR(30)    CONSTRAINT nn_professor_sobrenome NOT NULL,
    datanascimento DATE           CONSTRAINT nn_professor_datanascimento NOT NULL,
    salario        NUMERIC(10, 2) CONSTRAINT nn_professor_salario NOT NULL,
    email          VARCHAR(255)   CONSTRAINT nn_professor_email NOT NULL,
    telefone       CHAR(11)       CONSTRAINT nn_professor_telefone NOT NULL,
    idendereco     INTEGER        CONSTRAINT nn_professor_idendereco NOT NULL,
    CONSTRAINT pk_professor_id PRIMARY KEY (id),
    CONSTRAINT fk_professor_endreco_idendereco FOREIGN KEY (idendereco) REFERENCES administracao.endereco (id),
    CONSTRAINT uq_professor_cpf UNIQUE (cpf),
    CONSTRAINT uq_professor_email UNIQUE (email)
);

-- DROP TABLE administracao.endereco CASCADE;
CREATE TABLE administracao.endereco (
    id          SERIAL,
    cep         CHAR(8)      CONSTRAINT nn_professor_cep NOT NULL,
    idcidade    INTEGER      CONSTRAINT nn_professor_idcidade NOT NULL,
    logradouro  VARCHAR(100) CONSTRAINT nn_professor_logradouro NOT NULL,
    bairro      VARCHAR(50)  CONSTRAINT nn_professor_bairro NOT NULL,
    numero      VARCHAR(5)   CONSTRAINT nn_professor_numero NOT NULL,
    complemento VARCHAR(30),
    CONSTRAINT pk_endereco_id PRIMARY KEY (id),
    CONSTRAINT fk_endereco_cidade_idcidade FOREIGN KEY (idcidade) REFERENCES administracao.cidade (id)
);

-- DROP TABLE administracao.aluno CASCADE;
CREATE TABLE administracao.aluno (
    id             SERIAL,
    cpf            CHAR(11)     CONSTRAINT nn_aluno_cpf NOT NULL,
    nome           VARCHAR(30)  CONSTRAINT nn_aluno_nome NOT NULL,
    sobrenome      VARCHAR(30)  CONSTRAINT nn_aluno_sobrenome NOT NULL,
    datanascimento DATE         CONSTRAINT nn_aluno_datanascimento NOT NULL,
    email          VARCHAR(255) CONSTRAINT nn_aluno_email NOT NULL,
    telefone       CHAR(11)     CONSTRAINT nn_aluno_telefone NOT NULL,
    idendereco     INTEGER      CONSTRAINT nn_aluno_idendereco NOT NULL,
    CONSTRAINT pk_aluno_id PRIMARY KEY (id),
    CONSTRAINT fk_aluno_endereco_idendereco FOREIGN KEY (idendereco) REFERENCES administracao.endereco (id),
    CONSTRAINT uq_aluno_cpf UNIQUE (cpf),
    CONSTRAINT uq_aluno_email UNIQUE (email)
);

-- DROP TABLE administracao.turma CASCADE;
CREATE TABLE administracao.turma (
    id          SERIAL,
    numero      VARCHAR(30)          CONSTRAINT nn_turma_numero NOT NULL,
    idcurso     INTEGER              CONSTRAINT nn_turma_idcurso NOT NULL,
    datainicio  DATE                 CONSTRAINT nn_turma_datainicio NOT NULL,
    datatermino DATE                 CONSTRAINT nn_turma_termino NOT NULL,
    idturno     INTEGER              CONSTRAINT nn_turma_idturno NOT NULL,
    ativo       BOOLEAN DEFAULT TRUE CONSTRAINT nn_turma_ativo NOT NULL,
    CONSTRAINT pk_turma_id PRIMARY KEY (id),
    CONSTRAINT fk_turma_curso_idcurso FOREIGN KEY (idcurso) REFERENCES administracao.curso (id),
    CONSTRAINT fk_turma_turno_idturno FOREIGN KEY (idturno) REFERENCES administracao.turno (id)
);

-- DROP TABLE administracao.professordisciplinaturma CASCADE;
CREATE TABLE administracao.professordisciplinaturma (
    idprofessor  INTEGER CONSTRAINT nn_professordisciplinaturma_idprofessor NOT NULL,
    iddisciplina INTEGER CONSTRAINT nn_professordisciplinaturma_iddisciplina NOT NULL,
    idturma      INTEGER CONSTRAINT nn_professordisciplinaturma_idturma NOT NULL,
    semestre     INTEGER CONSTRAINT nn_professordisciplinaturma_semestre NOT NULL,
    CONSTRAINT pk_professordisciplinaturma PRIMARY KEY (idprofessor, iddisciplina, idturma),
    CONSTRAINT fk_professordisciplinaturma_professor_idprofessor FOREIGN KEY (idprofessor) REFERENCES administracao.professor (id),
    CONSTRAINT fk_professordisciplinaturma_disciplina_iddisciplina FOREIGN KEY (iddisciplina) REFERENCES administracao.disciplina (id),
    CONSTRAINT fk_professordisciplinaturma_turma_idturma FOREIGN KEY (idturma) REFERENCES administracao.turma (id)
);

-- DROP TABLE administracao.alunoturma CASCADE;
CREATE TABLE administracao.alunoturma (
    idturma       INTEGER              CONSTRAINT nn_alunoturma_idturma NOT NULL,
    idaluno       INTEGER              CONSTRAINT nn_alunoturma_idaluno NOT NULL,
    dataingresso  DATE                 CONSTRAINT nn_alunoturma_dataingresso NOT NULL,
    dataconclusao DATE,
    ativo         BOOLEAN DEFAULT TRUE CONSTRAINT nn_alunoturma_ativo NOT NULL,
    CONSTRAINT pk_alunoturma PRIMARY KEY (idturma, idaluno),
    CONSTRAINT fk_alunoturma_turma_idturma FOREIGN KEY (idturma) REFERENCES administracao.turma (id),
    CONSTRAINT fk_alunoturma_turma_idaluno FOREIGN KEY (idaluno) REFERENCES administracao.aluno (id)
);

-- DROP TABLE administracao.turno CASCADE;
CREATE TABLE administracao.turno (
    id          SERIAL,
    nome        VARCHAR(20) CONSTRAINT nn_turno_nome NOT NULL,
    horainicio  TIME        CONSTRAINT nn_turno_horainicio NOT NULL,
    horatermino TIME        CONSTRAINT nn_turno_horatermino NOT NULL,
    CONSTRAINT pk_turno_id PRIMARY KEY (id)
);

-- DROP TABLE administracao.estado CASCADE;
CREATE TABLE administracao.estado (
    sigla CHAR(2),
    nome  VARCHAR(60) CONSTRAINT nn_estado_nome NOT NULL,
    CONSTRAINT fk_estado_sigla PRIMARY KEY (sigla)
);

-- DROP TABLE administracao.cidade CASCADE;
CREATE TABLE administracao.cidade (
    id   INTEGER,
    nome VARCHAR(60) CONSTRAINT nn_cidade_nome NOT NULL,
    uf   CHAR(2)     CONSTRAINT nn_cidade_uf NOT NULL,
    CONSTRAINT pk_cidade_id PRIMARY KEY (id),
    CONSTRAINT fk_cidade_estado_uf FOREIGN KEY (uf) REFERENCES administracao.estado (sigla)
);

-- SEGURANCA


-- CREATE SCHEMA seguranca;

-- DROP TABLE seguranca.usuarioacesso CASCADE;
CREATE TABLE seguranca.usuarioacesso (
    id            SERIAL,
    idusuario     INTEGER              CONSTRAINT nn_usuarioacesso_idusuario NOT NULL,
    idtipousuario INTEGER              CONSTRAINT nn_usuarioacesso_idtipousuario NOT NULL,
    nome          VARCHAR(30)          CONSTRAINT nn_usuarioacesso_nome NOT NULL,
    logon         VARCHAR(10)          CONSTRAINT nn_usuarioacesso_logon NOT NULL,
    senha         VARCHAR(100)         CONSTRAINT nn_usuarioacesso_senha NOT NULL,
    ativo         BOOLEAN DEFAULT TRUE CONSTRAINT nn_usuarioacesso_ativo NOT NULL,
    ultimologin   TIMESTAMP,
    CONSTRAINT pk_usuarioacesso_id PRIMARY KEY (id),
    CONSTRAINT fk_usuarioacesso_tipousuario_idtipousuario FOREIGN KEY (idtipousuario) REFERENCES seguranca.tipousuario (id),
    CONSTRAINT uq_usuarioacesso_logon UNIQUE (logon),
    CONSTRAINT uq_usuarioacesso_idusuario UNIQUE (idusuario)
);

-- DROP TABLE seguranca.tipousuario CASCADE;
CREATE TABLE seguranca.tipousuario (
    id   SERIAL,
    nome VARCHAR(20) CONSTRAINT nn_tipousuario_nome NOT NULL,
    CONSTRAINT pk_tipousuario_id PRIMARY KEY (id)
);

-- DROP TABLE seguranca.opcaomenu CASCADE;
CREATE TABLE seguranca.opcaomenu (
    id SERIAL,
    idmae INTEGER,
    url VARCHAR(100),
    nome VARCHAR(30) CONSTRAINT nn_opcaomenu_nome NOT NULL,
    CONSTRAINT pk_opcaomenu_id PRIMARY KEY (id),
    CONSTRAINT fk_opcaomenu_idmae FOREIGN KEY (idmae) REFERENCES seguranca.opcaomenu(id)
);

-- DROP TABLE seguranca.opcaomenuacesso CASCADE;
CREATE TABLE seguranca.opcaomenuacesso (
    id SERIAL,
    idopcaomenu INTEGER CONSTRAINT nn_opcaomenuacesso_idopcaomenu NOT NULL,
    idtipousuario INTEGER CONSTRAINT nn_opcaomenuacesso_idtipousuario NOT NULL,
    CONSTRAINT pk_opcaomenuacesso_id PRIMARY KEY (id),
    CONSTRAINT fk_opcaomenuacesso_idopcaomenu FOREIGN KEY (idopcaomenu) REFERENCES seguranca.opcaomenu(id),
    CONSTRAINT fk_opcaomenuacesso_idtipousuario FOREIGN KEY (idtipousuario) REFERENCES seguranca.tipousuario(id)
);
