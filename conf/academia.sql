-- Banco do mini SaaS Academia (SQL Server)
-- Cria o banco, as 3 tabelas (planos, alunos, checkins), os dados de teste e o login da aplicação.

create database Academia
GO
Use Academia
GO

create table planos(
id_plano int not null,
nome_plano varchar (100) not null, 
valor_mensal decimal (10,2),

constraint pk_id_plano primary key (id_plano)
);

insert into planos (id_plano, nome_plano, valor_mensal)
values
(1, 'Básico', 79.90),
(2, 'Intermediário', 109.90),
(3, 'Premium', 149.90);

create table alunos(
id_aluno int not null,
id_plano int not null,
nome_aluno varchar (100) not null, 
data_matricula date ,

constraint pk_id_aluno primary key (id_aluno),
constraint fk_id_plano foreign key (id_plano) references planos (id_plano)
);

insert into alunos (id_aluno, nome_aluno, data_matricula, id_plano)
values
(1, 'Ana Souza', '2025-10-10', 1),
(2, 'Bruno Lima', '2025-10-12', 2),
(3, 'Carla Mendes', '2025-10-15', 3),
(4, 'Daniel Rocha', '2025-10-18', 1),
(5, 'Eduarda Silva', '2025-11-20', 2),
(6, 'Felipe Santos', '2025-11-22', 3),
(7, 'Gabriela Costa', '2025-11-25', 1),
(8, 'Henrique Alves', '2025-11-28', 2),
(9, 'Isabela Martins', '2025-11-01', 3),
(10, 'João Pereira', '2025-12-03', 1),
(11, 'Karen Oliveira', '2025-12-05', 2),
(12, 'Lucas Ferreira', '2025-12-08', 3),
(13, 'Mariana Gomes', '2026-01-10', 1),
(14, 'Nicolas Ribeiro', '2026-01-12', 2),
(15, 'Olivia Carvalho', '2026-01-15', 3),
(16, 'Paulo Teixeira', '2026-01-18', 1),
(17, 'Queila Araújo', '2026-02-20', 2),
(18, 'Rafael Barbosa', '2026-02-22', 3),
(19, 'Sabrina Lopes', '2026-02-25', 1),
(20, 'Thiago Moreira', '2026-02-28', 2);

create table checkins(
id_checkin int not null, 
id_aluno int not null, 
data_checkin date,

constraint pk_id_checkin primary key (id_checkin),
constraint fk_id_aluno foreign key (id_aluno) references alunos( id_aluno)
);

insert into checkins (id_checkin, id_aluno, data_checkin)
values
-- aluno 1: assiduo (14, 15 e 13 check-ins/mes)
(1,1,'2026-03-01'),(2,1,'2026-03-02'),(3,1,'2026-03-03'),(4,1,'2026-03-04'),
(5,1,'2026-03-06'),(6,1,'2026-03-08'),(7,1,'2026-03-09'),(8,1,'2026-03-11'),
(9,1,'2026-03-13'),(10,1,'2026-03-15'),(11,1,'2026-03-17'),(12,1,'2026-03-20'),
(13,1,'2026-03-24'),(14,1,'2026-03-27'),
(15,1,'2026-04-01'),(16,1,'2026-04-02'),(17,1,'2026-04-03'),(18,1,'2026-04-05'),
(19,1,'2026-04-06'),(20,1,'2026-04-08'),(21,1,'2026-04-10'),(22,1,'2026-04-12'),
(23,1,'2026-04-14'),(24,1,'2026-04-16'),(25,1,'2026-04-18'),(26,1,'2026-04-21'),
(27,1,'2026-04-23'),(28,1,'2026-04-26'),(29,1,'2026-04-28'),
(30,1,'2026-05-02'),(31,1,'2026-05-04'),(32,1,'2026-05-05'),(33,1,'2026-05-07'),
(34,1,'2026-05-09'),(35,1,'2026-05-12'),(36,1,'2026-05-14'),(37,1,'2026-05-16'),
(38,1,'2026-05-19'),(39,1,'2026-05-21'),(40,1,'2026-05-23'),(41,1,'2026-05-26'),
(42,1,'2026-05-28'),
-- aluno 2: regular (7, 6 e 9 por mes)
(43,2,'2026-03-03'),(44,2,'2026-03-06'),(45,2,'2026-03-10'),(46,2,'2026-03-13'),
(47,2,'2026-03-17'),(48,2,'2026-03-21'),(49,2,'2026-03-26'),
(50,2,'2026-04-02'),(51,2,'2026-04-07'),(52,2,'2026-04-11'),(53,2,'2026-04-16'),
(54,2,'2026-04-21'),(55,2,'2026-04-27'),
(56,2,'2026-05-01'),(57,2,'2026-05-04'),(58,2,'2026-05-08'),(59,2,'2026-05-11'),
(60,2,'2026-05-14'),(61,2,'2026-05-18'),(62,2,'2026-05-21'),(63,2,'2026-05-25'),
(64,2,'2026-05-29'),
-- aluno 3: inativo (2, 3 e 1 por mes)
(65,3,'2026-03-05'),(66,3,'2026-03-19'),
(67,3,'2026-04-04'),(68,3,'2026-04-15'),(69,3,'2026-04-25'),
(70,3,'2026-05-10'),
-- aluno 4: evolucao (3 -> 8 -> 14, otimo pra ver a media movel subir)
(71,4,'2026-03-02'),(72,4,'2026-03-12'),(73,4,'2026-03-22'),
(74,4,'2026-04-01'),(75,4,'2026-04-05'),(76,4,'2026-04-09'),(77,4,'2026-04-13'),
(78,4,'2026-04-17'),(79,4,'2026-04-20'),(80,4,'2026-04-24'),(81,4,'2026-04-28'),
(82,4,'2026-05-01'),(83,4,'2026-05-03'),(84,4,'2026-05-05'),(85,4,'2026-05-07'),
(86,4,'2026-05-09'),(87,4,'2026-05-11'),(88,4,'2026-05-13'),(89,4,'2026-05-15'),
(90,4,'2026-05-17'),(91,4,'2026-05-20'),(92,4,'2026-05-22'),(93,4,'2026-05-25'),
(94,4,'2026-05-27'),(95,4,'2026-05-30'),
-- aluno 5: oscilando (10 -> 4 -> 6)
(96,5,'2026-03-01'),(97,5,'2026-03-04'),(98,5,'2026-03-07'),(99,5,'2026-03-10'),
(100,5,'2026-03-13'),(101,5,'2026-03-16'),(102,5,'2026-03-19'),(103,5,'2026-03-22'),
(104,5,'2026-03-25'),(105,5,'2026-03-28'),
(106,5,'2026-04-05'),(107,5,'2026-04-12'),(108,5,'2026-04-19'),(109,5,'2026-04-26'),
(110,5,'2026-05-03'),(111,5,'2026-05-08'),(112,5,'2026-05-13'),(113,5,'2026-05-18'),
(114,5,'2026-05-23'),(115,5,'2026-05-28'),
-- aluno 19: tem check-ins, mas matricula recente -> deve SUMIR no filtro de 6 meses
(116,19,'2026-05-05'),(117,19,'2026-05-10'),(118,19,'2026-05-15'),
(119,19,'2026-05-20'),(120,19,'2026-05-25');

-- ============================================================
-- Usuário da aplicação (o Tomcat entra no banco com este login)
-- Senha simples apenas para laboratório, no padrão do professor (saas/saas).
-- Requer o SQL Server em modo de autenticação misto (SQL Server e Windows).
-- ============================================================
GO
CREATE LOGIN saas WITH PASSWORD = 'saas', CHECK_POLICY = OFF;
GO
USE Academia;
GO
CREATE USER saas FOR LOGIN saas;
ALTER ROLE db_datareader ADD MEMBER saas;
ALTER ROLE db_datawriter ADD MEMBER saas;
GO
