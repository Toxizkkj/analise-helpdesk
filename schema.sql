-- ========================================================
-- Projeto: IT HelpDesk & Asset Analytics
-- Arquivo: schema.sql
-- Descrição: Criação das tabelas relacionais, índices e views
-- ========================================================

-- Limpeza de tabelas existentes para reexecução idempotente
DROP VIEW IF EXISTS vw_kpi_mensal_sla;
DROP VIEW IF EXISTS vw_detalhes_chamados;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS ativos_ti;
DROP TABLE IF EXISTS tecnicos;
DROP TABLE IF EXISTS departamentos;

-- 1. Tabela de Departamentos da Empresa
CREATE TABLE departamentos (
    id_departamento INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    centro_custo VARCHAR(20) NOT NULL,
    localizacao VARCHAR(100) NOT NULL
);

-- 2. Tabela de Técnicos de TI / Analistas de Suporte
CREATE TABLE tecnicos (
    id_tecnico INTEGER PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('N1', 'N2', 'N3', 'Especialista')),
    email VARCHAR(120) UNIQUE NOT NULL,
    ativo BOOLEAN DEFAULT 1
);

-- 3. Tabela de Ativos de TI (Hardware, Servidores, Switches)
CREATE TABLE ativos_ti (
    id_ativo INTEGER PRIMARY KEY,
    tag_patrimonio VARCHAR(50) UNIQUE NOT NULL,
    categoria VARCHAR(50) CHECK (categoria IN ('Notebook', 'Desktop', 'Servidor', 'Switch', 'Roteador', 'Impressora')),
    fabricante VARCHAR(50) NOT NULL,
    modelo VARCHAR(80) NOT NULL,
    id_departamento INTEGER REFERENCES departamentos(id_departamento),
    data_aquisicao DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Em Uso' CHECK (status IN ('Em Uso', 'Em Manutenção', 'Descartado', 'Reserva'))
);

-- 4. Tabela de Chamados / Incidentes (Tickets)
CREATE TABLE tickets (
    id_ticket INTEGER PRIMARY KEY,
    protocolo VARCHAR(20) UNIQUE NOT NULL,
    id_departamento INTEGER NOT NULL REFERENCES departamentos(id_departamento),
    id_ativo INTEGER REFERENCES ativos_ti(id_ativo),
    id_tecnico INTEGER REFERENCES tecnicos(id_tecnico),
    titulo VARCHAR(150) NOT NULL,
    categoria VARCHAR(50) CHECK (categoria IN ('Hardware', 'Redes', 'Software', 'Acesso/Permissão', 'Impressão')),
    prioridade VARCHAR(20) CHECK (prioridade IN ('Baixa', 'Média', 'Alta', 'Crítica')),
    status VARCHAR(20) DEFAULT 'Aberto' CHECK (status IN ('Aberto', 'Em Atendimento', 'Resolvido', 'Cancelado')),
    data_abertura TIMESTAMP NOT NULL,
    data_resolucao TIMESTAMP,
    sla_limite_horas INTEGER NOT NULL
);

-- Índices estratégicos para otimização de consultas analíticas
CREATE INDEX idx_tickets_tecnico ON tickets(id_tecnico);
CREATE INDEX idx_tickets_status ON tickets(status);
CREATE INDEX idx_tickets_abertura ON tickets(data_abertura);
CREATE INDEX idx_ativos_departamento ON ativos_ti(id_departamento);

-- View Operacional: Detalhamento enriquecido de chamados
CREATE VIEW vw_detalhes_chamados AS
SELECT 
    t.id_ticket,
    t.protocolo,
    t.titulo,
    t.categoria AS categoria_ticket,
    t.prioridade,
    t.status,
    d.nome AS departamento_solicitante,
    d.localizacao AS local_departamento,
    COALESCE(tec.nome, 'Não Atribuído') AS tecnico_responsavel,
    tec.nivel AS nivel_tecnico,
    a.tag_patrimonio,
    a.categoria AS categoria_ativo,
    t.data_abertura,
    t.data_resolucao,
    t.sla_limite_horas
FROM tickets t
INNER JOIN departamentos d ON t.id_departamento = d.id_departamento
LEFT JOIN tecnicos tec ON t.id_tecnico = tec.id_tecnico
LEFT JOIN ativos_ti a ON t.id_ativo = a.id_ativo;