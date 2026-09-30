-- ========================================================
-- Arquivo: analytics_queries.sql
-- Descrição: Queries analíticas com CTEs e Window Functions
-- ========================================================

-- QUERY 1: Cálculo de MTTR (Mean Time to Resolution) e Cumprimento de SLA por Técnico
-- Utiliza CTE para calcular a duração em horas e percentual de atendimento dentro do prazo
WITH DuracaoChamados AS (
    SELECT 
        id_ticket,
        id_tecnico,
        categoria,
        sla_limite_horas,
        -- Diferença em horas entre resolução e abertura (compatível com SQLite e Postgres)
        ROUND((strftime('%s', data_resolucao) - strftime('%s', data_abertura)) / 3600.0, 2) AS horas_resolucao
    FROM tickets
    WHERE status = 'Resolvido' AND data_resolucao IS NOT NULL
)
SELECT 
    tec.nome AS tecnico,
    tec.nivel,
    COUNT(dc.id_ticket) AS total_resolvidos,
    ROUND(AVG(dc.horas_resolucao), 2) AS mttr_horas_medio,
    SUM(CASE WHEN dc.horas_resolucao <= dc.sla_limite_horas THEN 1 ELSE 0 END) AS dentro_do_sla,
    ROUND(
        (SUM(CASE WHEN dc.horas_resolucao <= dc.sla_limite_horas THEN 1.0 ELSE 0.0 END) / COUNT(dc.id_ticket)) * 100, 
        1
    ) AS taxa_conformidade_sla_pct
FROM DuracaoChamados dc
INNER JOIN tecnicos tec ON dc.id_tecnico = tec.id_tecnico
GROUP BY tec.id_tecnico, tec.nome, tec.nivel
ORDER BY total_resolvidos DESC, taxa_conformidade_sla_pct DESC;


-- QUERY 2: Ranking de Incidência de Chamados por Ativo (Identificação de Falhas Crônicas)
-- Utiliza Window Function DENSE_RANK() para classificar os equipamentos mais problemáticos
WITH IncidentesPorAtivo AS (
    SELECT 
        a.tag_patrimonio,
        a.categoria AS tipo_ativo,
        a.fabricante || ' ' || a.modelo AS modelo_completo,
        d.nome AS departamento_alocado,
        COUNT(t.id_ticket) AS total_chamados
    FROM ativos_ti a
    INNER JOIN departamentos d ON a.id_departamento = d.id_departamento
    INNER JOIN tickets t ON a.id_ativo = t.id_ativo
    GROUP BY a.id_ativo, a.tag_patrimonio, a.categoria, a.fabricante, a.modelo, d.nome
)
SELECT 
    tag_patrimonio,
    tipo_ativo,
    modelo_completo,
    departamento_alocado,
    total_chamados,
    DENSE_RANK() OVER (ORDER BY total_chamados DESC) AS rank_criticidade
FROM IncidentesPorAtivo;


-- QUERY 3: Distribuição de Volume e Carga Relativa de Chamados por Categoria
-- Utiliza Window Functions para calcular proporção percentual sobre o total sem subquery redundante
SELECT 
    categoria,
    COUNT(id_ticket) AS volume_chamados,
    ROUND(
        COUNT(id_ticket) * 100.0 / SUM(COUNT(id_ticket)) OVER(), 
        2
    ) AS representatividade_pct,
    COUNT(CASE WHEN prioridade IN ('Alta', 'Crítica') THEN 1 END) AS chamados_urgentes
FROM tickets
GROUP BY categoria
ORDER BY volume_chamados DESC;