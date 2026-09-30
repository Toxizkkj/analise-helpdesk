-- ========================================================
-- Arquivo: seed_data.sql
-- Descrição: População de dados realistas para testes
-- ========================================================

INSERT INTO departamentos (id_departamento, nome, centro_custo, localizacao) VALUES
(1, 'Financeiro', 'CC-101', 'Andar 2 - Bloco A'),
(2, 'Operações / Logística', 'CC-202', 'Galpão Central'),
(3, 'Tecnologia da Informação', 'CC-303', 'Andar 3 - Bloco B'),
(4, 'Recursos Humanos', 'CC-404', 'Andar 1 - Bloco A');

INSERT INTO tecnicos (id_tecnico, nome, nivel, email, ativo) VALUES
(1, 'Mozart', 'N3', 'mozart.informatica@saogeraldo.com', 1),
(2, 'Yann', 'N1', 'yann123@saogeraldo.com', 1),
(3, 'Yuri', 'N2', 'yuri.ti@saogeraldo.com', 1),
(4, 'Thiago', 'N1', 'thiago321@saogeraldo.com', 1);

INSERT INTO ativos_ti (id_ativo, tag_patrimonio, categoria, fabricante, modelo, id_departamento, data_aquisicao, status) VALUES
(1, 'PAT-NT-001', 'Notebook', 'Dell', 'Latitude 3420', 1, '2025-02-15', 'Em Uso'),
(2, 'PAT-NT-002', 'Notebook', 'Lenovo', 'ThinkPad E14', 3, '2024-11-20', 'Em Uso'),
(3, 'PAT-SW-010', 'Switch', 'TP-Link', 'SG3428 JetStream', 3, '2024-06-10', 'Em Uso'),
(4, 'PAT-SRV-01', 'Servidor', 'Dell', 'PowerEdge R440', 3, '2023-08-01', 'Em Uso'),
(5, 'PAT-IMP-03', 'Impressora', 'HP', 'LaserJet Pro M404n', 2, '2025-01-10', 'Em Manutenção');

INSERT INTO tickets (id_ticket, protocolo, id_departamento, id_ativo, id_tecnico, titulo, categoria, prioridade, status, data_abertura, data_resolucao, sla_limite_horas) VALUES
(1, 'TKT-2026-001', 1, 1, 1, 'Notebook não liga após atualização', 'Hardware', 'Alta', 'Resolvido', '2026-09-01 08:30:00', '2026-09-01 11:00:00', 8),
(2, 'TKT-2026-002', 2, 5, 3, 'Atolamento de papel recorrente', 'Impressão', 'Média', 'Resolvido', '2026-09-01 09:15:00', '2026-09-01 14:45:00', 12),
(3, 'TKT-2026-003', 3, 3, 2, 'Porta 12 do switch apresentando flapping', 'Redes', 'Crítica', 'Resolvido', '2026-09-02 14:00:00', '2026-09-02 15:30:00', 4),
(4, 'TKT-2026-004', 1, NULL, 1, 'Reset de senha de rede no Active Directory', 'Acesso/Permissão', 'Baixa', 'Resolvido', '2026-09-03 10:00:00', '2026-09-03 10:20:00', 4),
(5, 'TKT-2026-005', 2, NULL, 3, 'Falha de rota para filial via VPN', 'Redes', 'Alta', 'Resolvido', '2026-09-04 11:00:00', '2026-09-04 16:30:00', 6),
(6, 'TKT-2026-006', 4, NULL, 1, 'Instalação de software de folha de pagamento', 'Software', 'Média', 'Resolvido', '2026-09-05 09:00:00', '2026-09-05 13:00:00', 8),
(7, 'TKT-2026-007', 2, 5, 3, 'Erro de spooler de impressão', 'Impressão', 'Média', 'Resolvido', '2026-09-08 10:00:00', '2026-09-08 18:00:00', 8),
(8, 'TKT-2026-008', 3, 4, 4, 'Alerta de temperatura no rack principal', 'Hardware', 'Crítica', 'Resolvido', '2026-09-10 22:00:00', '2026-09-10 23:15:00', 2),
(9, 'TKT-2026-009', 1, 1, 1, 'Tela azul (BSOD) durante uso do Excel', 'Hardware', 'Alta', 'Aberto', '2026-09-27 16:00:00', NULL, 8),
(10, 'TKT-2026-010', 2, NULL, 2, 'Lentidão generalizada no link de dados', 'Redes', 'Alta', 'Em Atendimento', '2026-09-28 08:00:00', NULL, 6);