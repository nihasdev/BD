drop database if exists sistema_veiculos;
CREATE DATABASE IF NOT EXISTS sistema_veiculos;
USE sistema_veiculos;

-- 1. Tabela Empresa
CREATE TABLE Empresa (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    endereco VARCHAR(40),
    email VARCHAR(50),
    telefone VARCHAR(20)
);

-- 2. Tabela Cliente (Adicionei o CPF para as tabelas abaixo funcionarem)
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE, -- Essencial para as chaves estrangeiras abaixo
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(50),
    endereco VARCHAR(40),
    idade INT -- Alterado para INT, pois idade é um número
);

-- 3. Tabela Veiculos
CREATE TABLE Veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_empresa INT,
    valor DECIMAL(10, 2),
    quilometragem DECIMAL(10, 2),
    CONSTRAINT fk_veiculo_empresa FOREIGN KEY (id_empresa) REFERENCES Empresa(id_empresa)
);

-- 4. Tabela Contrato
CREATE TABLE Contrato (
    id_contrato INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_veiculo INT,
    data_devolucao DATE, -- Alterado para DATE para permitir cálculos de data
    valor DECIMAL(10, 2),
    quilometragem_inicial DECIMAL(10, 2),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_contrato_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo)
);

-- 5. Tabela Manutenção
CREATE TABLE Manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT,
    id_cliente INT,
    id_contrato INT,
    valor DECIMAL(10, 2),
    tipo_manutencao VARCHAR(20),
    CONSTRAINT fk_manutencao_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_manutencao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    CONSTRAINT fk_manutencao_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);

-- 6. Tabela Multa (Corrigido nomes de tabelas e acentos)
CREATE TABLE multa (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    desc_multa VARCHAR(50),
    id_veiculo INT,
    id_contrato INT,
    valor_multa DECIMAL(10,2),
    CONSTRAINT fk_multa_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_multa_contrato FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);

-- 7. Tabela Reserva
CREATE TABLE reserva (
    id_reserva INT PRIMARY KEY AUTO_INCREMENT,
    data_res DATE,
    id_veiculo INT,
    id_cliente INT, -- Alterado de CPF para id_cliente para manter o padrão de integridade
    CONSTRAINT fk_reserva_veiculo FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- 8. Tabela Pagamento
CREATE TABLE pagamento (
    id_pag INT PRIMARY KEY AUTO_INCREMENT,
    estado VARCHAR(20),
    valor DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- 9. Tabela Devolução (Removido acento do nome da tabela)
CREATE TABLE devolucao (
    id_devolucao INT PRIMARY KEY AUTO_INCREMENT,
    km_final VARCHAR(20),
    danos_ident VARCHAR(50),
    valor_adic DECIMAL(10,2),
    id_cliente INT,
    CONSTRAINT fk_devolucao_cliente FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

INSERT INTO Cliente ( nome, cpf, email , endereco, idade) VALUES 
('Ricardo Silva' ,  '472910338-25' , 'ricardo.silva88@gmail.com'  ,'Rua das Palmeiras-450',34),
('Beatriz Souza' ,  '159004672-11' , 'bia.souza.dev@gmail.com'    ,'Av. Paulista-1500' ,28),
('Carlos Eduardo', '833125490-44'  , 'cadu.vendas@gmail.com'      ,'Rua Amazonas-22',42),
('Mariana Costa' ,  '02874196308'  , 'mari.costa.cine@gmail.com'  ,'Travessa do Sol-98',21),
('Lucas Oliveira', '65539211897'	 , 'lucas.oliveira.ti@gmail.com','Alameda Santos-310',37);
Select * from Cliente;

INSERT INTO Empresa ( nome,endereco,email,telefone) VALUES
('LocaDrive Brasil', 'Av. das Nações, 1010', 'contato@locadrive.com.br', '(11) 3344-5566'),
('RentCar Express', 'Rua Chile, 250', 'sac@rentcarexpress.com', '(21) 98877-6655'),
('Velocità Alugueis', 'Rodovia Santos Dumont, s/n', 'faturamento@velocita.it', '(19) 3251-4000'),
('Elite Prime Motors', 'Alameda Jauaperi, 45', 'reservas@eliteprime.com.br', '(11) 5051-2233'),
('EcoMove Sustentável', 'Av. Beira Mar, 500', 'administrativo@ecomove.eco.br', '(48) 3222-1100');
Select * from Empresa;

INSERT INTO Veiculos (id_empresa, valor, quilometragem) VALUES
(1, 55000.00, 15200.50),
(2, 72400.00, 8340.00),
(3, 145000.00, 45000.00),
(4, 180000.00, 2100.25),
(5, 149800.00, 500.00);
select * from Veiculos;

INSERT INTO Contrato (id_cliente, id_veiculo, data_devolucao, valor, quilometragem_inicial) VALUES 
(1, 1, '2024-06-15 09:00:00', 1200.00, 15200.50),
(2, 3, '2024-06-20 09:00:00', 3500.00, 45000.00),
(3, 2, '2024-06-12 09:00:00', 950.00, 8340.00),
(4, 5, '2024-07-01 09:00:00', 4200.00, 500.00),
(5, 4, '2024-06-18 09:00:00', 5800.00, 2100.25);
select * from Contrato;

INSERT INTO Manutencao (id_veiculo, id_cliente, id_contrato, valor, tipo_manutencao) VALUES
(1, 1, 1, 150.00, 'Troca de Óleo'),
(3, 2, 2, 450.00, 'Alinhamento'),
(5, 4, 4, 1200.00, 'Troca de Pneus');
select * from Manutencao;

INSERT INTO multa (desc_multa, id_veiculo, id_contrato, valor_multa) VALUES
('Excesso de Velocidade', 1, 1, 293.47),
('Estacionamento Irregular', 3, 2, 130.16),
('Avanço de Sinal Vermelho', 2, 3, 293.47);
select * from multa;

INSERT INTO reserva (data_res, id_veiculo, id_cliente) VALUES
('2024-08-10', 2, 1),
('2024-08-12', 4, 3),
('2024-08-15', 1, 5);
select * from reserva;

INSERT INTO pagamento (estado, valor, id_cliente) VALUES
('Pago', 1200.00, 1),
('Pendente', 3500.00, 2),
('Pago', 950.00, 3),
('Processando', 4200.00, 4),
('Pago', 5800.00, 5);
select * from pagamento;

INSERT INTO devolucao (km_final, danos_ident, valor_adic, id_cliente) VALUES
('15450.50', 'Nenhum', 0.00, 1),
('45800.00', 'Arranhão porta direita', 250.00, 2),
('8600.00', 'Nenhum', 0.00, 3),
('1200.00', 'Limpeza pesada necessária', 80.00, 4),
('2500.25', 'Nenhum', 0.00, 5);
select * from devolucao;
