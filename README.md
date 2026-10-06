# Academia — mini SaaS

Aplicação web de uma academia, publicada como serviço (SaaS) num servidor de aplicação Linux. Trabalho da disciplina Innovation Lab – SaaS Infrastructure , baseado no repositório [mini_saas](https://github.com/alessandrokraemer-arch/mini_saas) do Prof. Dr. Alessandro Kraemer.

**Integrantes:** _(preencher)_

## Objetivo

Registrar a frequência dos alunos (check-ins) e consultar, por aluno, o plano contratado e o histórico de frequência. O usuário acessa tudo pelo navegador; o servidor de aplicação e o banco ficam em máquinas separadas, como num SaaS.

## Arquitetura

```
 Navegador (Chrome)
        │  http://IP_DA_VM:8080/academia/
        ▼
 VM Ubuntu Server 26.04 (VMware, rede NAT)
   Tomcat 10 + páginas JSP + driver JDBC do SQL Server
        │  jdbc:sqlserver://IP_DO_WINDOWS:1433
        ▼
 Windows — SQL Server Express (banco Academia)
```

| Camada | Tecnologia |
|---|---|
| Interface | HTML + CSS |
| Aplicação | JSP no Apache Tomcat 10 |
| Acesso a dados | JDBC (`mssql-jdbc`) com `PreparedStatement` |
| Banco | Microsoft SQL Server Express |
| Infraestrutura | Ubuntu Server 26.04 em VMware Workstation |

## Banco de dados

Três tabelas, criadas por [`conf/academia.sql`](conf/academia.sql):

| Tabela | Conteúdo | Relação |
|---|---|---|
| `planos` | Básico, Intermediário e Premium, com valor mensal | — |
| `alunos` | 20 alunos, com data de matrícula | cada aluno tem 1 plano (`id_plano`) |
| `checkins` | 120 registros de frequência (mar–mai/2026) | cada check-in pertence a 1 aluno (`id_aluno`) |

O script também cria o login `saas`, com permissão só de leitura e escrita no banco `Academia`. A aplicação usa esse login, e não o administrador.

## Telas

| Página | O que faz |
|---|---|
| `index.html` | Menu inicial |
| `checkin.jsp` | Escolhe o aluno e a data, grava o check-in e mostra os 10 últimos |
| `insert.jsp` | Faz o `INSERT` do check-in e volta para `checkin.jsp` |
| `busca.jsp` | Busca aluno por nome: plano, mensalidade, matrícula, total de check-ins e último check-in (junta as 3 tabelas) |

## Estrutura do repositório

```
├── index.html, checkin.jsp, insert.jsp, busca.jsp, estilo.css
├── conexao.jspf            ← endereço, usuário e senha do banco
├── conf/
│   ├── academia.sql        ← script do banco (tabelas, dados e login)
│   └── academia.xml        ← registro da aplicação no Tomcat
└── docs/
    └── preparacao-ambiente.md  ← passo a passo da instalação
```

## Como instalar

O passo a passo completo está em [`docs/preparacao-ambiente.md`](docs/preparacao-ambiente.md).

## Observações

- A senha `saas` está no código apenas por ser um ambiente de estudo, como no repositório original. Num ambiente real ela ficaria fora do código (variável de ambiente ou configuração do servidor).
- Diferente da versão original, as consultas usam `PreparedStatement`, o que evita SQL injection.
