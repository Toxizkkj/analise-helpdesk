# IT HelpDesk & Asset Analytics

> Modelo relacional de dados e suíte de inteligência analítica para operações de suporte de TI, controle de SLA e ciclo de vida de ativos.

![SQL](https://img.shields.io/badge/Language-SQL-orange?style=for-the-badge&logo=postgresql)
![Database](https://img.shields.io/badge/Engines-PostgreSQL%20%7C%20SQLite-blue?style=for-the-badge&logo=sqlite)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## Visão Geral

Este projeto simula um ambiente real de suporte de infraestrutura e governança de TI. Ele organiza o ecossistema de chamados, técnicos e equipamentos em um modelo relacional normalizado (3FN) e disponibiliza queries analíticas para extração de indicadores essenciais como:

- **MTTR (Mean Time to Resolution):** Tempo médio gasto para restabelecimento de serviços.
- **Conformidade de SLA (%):** Taxa percentual de chamados resolvidos dentro do prazo pactuado.
- **Auditoria de Hardware Problemático:** Rastreamento de equipamentos com falhas reincidentes via Window Functions.

## Estrutura do Banco de Dados

- `departamentos`: Centros de custo e localização física das áreas da empresa.
- `tecnicos`: Analistas de suporte (níveis N1, N2, N3 e Especialistas).
- `ativos_ti`: Catálogo e inventário de hardware (notebooks, roteadores, switches, servidores).
- `tickets`: Tabela de fatos com histórico completo de incidentes, status, abertura e resolução.

## Como Executar

### Opção 1: Usando SQLite (Execução Rápida sem Instalação de Servidor)
No terminal, basta executar:

```bash
# 1. Cria o banco e carrega o schema
sqlite3 helpdesk.db < schema.sql

# 2. Insere os dados de teste
sqlite3 helpdesk.db < seed_data.sql

# 3. Roda as queries analíticas de SLA e MTTR
sqlite3 -header -column helpdesk.db < analytics_queries.sql