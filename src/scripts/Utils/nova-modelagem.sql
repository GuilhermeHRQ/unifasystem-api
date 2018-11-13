DROP TABLE IF EXISTS Administracao.alunoPresenca;
DROP TABLE IF EXISTS Administracao.controlePresenca;
DROP TABLE IF EXISTS Administracao.status;
DROP TABLE IF EXISTS Seguranca.acessoProfessor;

-- CREATE DATABASE unifasystem
--     ENCODING 'UTF-8'
--     TEMPLATE = TEMPLATE0
--     CONNECTION LIMIT 100;

CREATE SCHEMA IF NOT EXISTS Administracao;
CREATE SCHEMA IF NOT EXISTS Seguranca;


CREATE TABLE seguranca.acessoprofessor (
    id          SERIAL,
    codigo      INTEGER      CONSTRAINT nn_acessoprofessor_codigo NOT NULL,
    nome        VARCHAR(100) CONSTRAINT nn_acessoprofessor_nome NOT NULL,
    email       VARCHAR(255) CONSTRAINT nn_acessoprofessor_email NOT NULL,
    senha       VARCHAR(100) CONSTRAINT nn_acessoprofessor_senha NOT NULL,
    ultimologin TIMESTAMP,
    CONSTRAINT pk_acessoprofessor_id PRIMARY KEY (id),
    CONSTRAINT uq_acessoprofessor_codigo UNIQUE (codigo),
    CONSTRAINT uq_acessoprofessor_email UNIQUE (email)
);

CREATE TABLE administracao.status (
    id        SERIAL,
    descricao VARCHAR(30),
    CONSTRAINT pk_status_id PRIMARY KEY (id)
);

CREATE TABLE administracao.controlepresenca (
    id                  SERIAL,
    semestre            INTEGER      CONSTRAINT nn_controlepresenca_semestre NOT NULL,
    iddisciplina        INTEGER       CONSTRAINT nn_controlepresenca_iddisciplina NOT NULL,
    idprofessor         INTEGER      CONSTRAINT nn_controlepresenca_idprofessor NOT NULL,
    idturma             INTEGER      CONSTRAINT nn_controlepresenca_idturma NOT NULL,
    nometurma           VARCHAR(100) CONSTRAINT nn_controlepresenca_nometurma NOT NULL,
    nomedisciplina      VARCHAR(100) CONSTRAINT nn_controlepresenca_nomedisciplina NOT NULL,
    horaabertura        TIME         CONSTRAINT nn_controlepresenca_horaabertura NOT NULL,
    horafechamento      TIME         CONSTRAINT nn_controlepresenca_horafechamento NOT NULL,
    quantidadepresencas SMALLINT     CONSTRAINT nn_controlepresenca_quantidadepresencas NOT NULL,
    conteudo            TEXT,
    datacadastro        TIMESTAMP    CONSTRAINT nn_controlepresenca_datacadastro NOT NULL DEFAULT now(),
    dataconfirmacao     TIMESTAMP,
    idstatus            INTEGER      CONSTRAINT nn_controlepresenca_idstatus NOT NULL,
    CONSTRAINT pk_controlepresenca PRIMARY KEY (id),
    CONSTRAINT fk_controlepresenca_acessoprofessor_id FOREIGN KEY (idprofessor) REFERENCES seguranca.acessoprofessor (id),
    CONSTRAINT fk_controlepresenca_status_id FOREIGN KEY (idstatus) REFERENCES administracao.status (id)
);

CREATE TABLE administracao.alunopresenca (
    idcontrolepresenca  INTEGER,
    idaluno             INTEGER,
    nomealuno           VARCHAR(100) CONSTRAINT nn_alunopresenca_nomealuno NOT NULL,
    horaentrada         TIME         CONSTRAINT nn_alunopresenca_horaentrada NOT NULL,
    horasaida           TIME         CONSTRAINT nn_alunopresenca_horasaida NOT NULL,
    quantidadepresencas SMALLINT     CONSTRAINT nn_alunopresenca_quantidadepresencas NOT NULL,
    CONSTRAINT pk_alunopresenca PRIMARY KEY (idcontrolepresenca, idaluno),
    CONSTRAINT fk_alunopresenca_idcontrolepresenca FOREIGN KEY (idcontrolepresenca) REFERENCES administracao.controlepresenca (id)
);

-- DROP TABLE seguranca.opcaomenu CASCADE;
CREATE TABLE seguranca.opcaomenu (
    id    SERIAL,
    idmae INTEGER,
    url   VARCHAR(100),
    nome  VARCHAR(30) CONSTRAINT nn_opcaomenu_nome NOT NULL,
    CONSTRAINT pk_opcaomenu_id PRIMARY KEY (id),
    CONSTRAINT fk_opcaomenu_idmae FOREIGN KEY (idmae) REFERENCES seguranca.opcaomenu (id)
);