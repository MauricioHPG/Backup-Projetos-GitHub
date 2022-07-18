-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05-Jul-2022 às 20:02
-- Versão do servidor: 10.4.11-MariaDB
-- versão do PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `padarosa`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `categorias`
--

CREATE TABLE `categorias` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `categorias`
--

INSERT INTO `categorias` (`id`, `nome`) VALUES
(1, 'Alimentação');

-- --------------------------------------------------------

--
-- Estrutura da tabela `ordens_comandas`
--

CREATE TABLE `ordens_comandas` (
  `id` int(11) NOT NULL,
  `id_ficha` int(11) NOT NULL,
  `id_produto` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `id_resp` int(11) NOT NULL,
  `data_adic` timestamp NOT NULL DEFAULT current_timestamp(),
  `situacao` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `ordens_comandas`
--

INSERT INTO `ordens_comandas` (`id`, `id_ficha`, `id_produto`, `quantidade`, `id_resp`, `data_adic`, `situacao`) VALUES
(1, 100, 1, 2, 1, '2022-06-30 17:13:29', 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `produtos`
--

CREATE TABLE `produtos` (
  `id` int(11) NOT NULL,
  `nome` varchar(200) NOT NULL,
  `preco` double NOT NULL,
  `id_categoria` int(11) NOT NULL,
  `id_respcadastro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `produtos`
--

INSERT INTO `produtos` (`id`, `nome`, `preco`, `id_categoria`, `id_respcadastro`) VALUES
(1, 'Coxinha de Frango', 5.5, 1, 1);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome_completo` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `senha` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome_completo`, `email`, `senha`) VALUES
(1, 'Administrador da Silva', 'admin@admin.com', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918');

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `view_fichas`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `view_fichas` (
`ID_Ordem` int(11)
,`Ficha` int(11)
,`produtos` varchar(200)
,`Quantidade` int(11)
,`Valor_Unit` double
,`Total_Item` double
,`Resp` varchar(212)
,`Data_Horario` timestamp
);

-- --------------------------------------------------------

--
-- Estrutura stand-in para vista `view_produtos`
-- (Veja abaixo para a view atual)
--
CREATE TABLE `view_produtos` (
`ID` int(11)
,`Nome` varchar(200)
,`Preco` double
,`Categoria` varchar(200)
,`RespCadastro` varchar(200)
);

-- --------------------------------------------------------

--
-- Estrutura para vista `view_fichas`
--
DROP TABLE IF EXISTS `view_fichas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_fichas`  AS  select `ordens_comandas`.`id` AS `ID_Ordem`,`ordens_comandas`.`id_ficha` AS `Ficha`,`produtos`.`nome` AS `produtos`,`ordens_comandas`.`quantidade` AS `Quantidade`,`produtos`.`preco` AS `Valor_Unit`,`ordens_comandas`.`quantidade` * `produtos`.`preco` AS `Total_Item`,concat(ucase(substring_index(`usuarios`.`nome_completo`,' ',1)),'-',`ordens_comandas`.`id_resp`) AS `Resp`,`ordens_comandas`.`data_adic` AS `Data_Horario` from ((`ordens_comandas` join `produtos` on(`ordens_comandas`.`id_produto` = `produtos`.`id`)) join `usuarios` on(`ordens_comandas`.`id_resp` = `usuarios`.`id`)) where `ordens_comandas`.`situacao` = 1 ;

-- --------------------------------------------------------

--
-- Estrutura para vista `view_produtos`
--
DROP TABLE IF EXISTS `view_produtos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `view_produtos`  AS  select `produtos`.`id` AS `ID`,`produtos`.`nome` AS `Nome`,`produtos`.`preco` AS `Preco`,`categorias`.`nome` AS `Categoria`,`usuarios`.`nome_completo` AS `RespCadastro` from ((`produtos` join `usuarios` on(`produtos`.`id_respcadastro` = `usuarios`.`id`)) join `categorias` on(`produtos`.`id` = `categorias`.`id`)) ;

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`id`);

--
-- Índices para tabela `ordens_comandas`
--
ALTER TABLE `ordens_comandas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_produto` (`id_produto`),
  ADD KEY `id_resp` (`id_resp`);

--
-- Índices para tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_categoria` (`id_categoria`),
  ADD KEY `id_respcadastro` (`id_respcadastro`);

--
-- Índices para tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `categorias`
--
ALTER TABLE `categorias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `ordens_comandas`
--
ALTER TABLE `ordens_comandas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `ordens_comandas`
--
ALTER TABLE `ordens_comandas`
  ADD CONSTRAINT `ordens_comandas_ibfk_1` FOREIGN KEY (`id_produto`) REFERENCES `produtos` (`id`),
  ADD CONSTRAINT `ordens_comandas_ibfk_2` FOREIGN KEY (`id_resp`) REFERENCES `usuarios` (`id`);

--
-- Limitadores para a tabela `produtos`
--
ALTER TABLE `produtos`
  ADD CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id`),
  ADD CONSTRAINT `produtos_ibfk_2` FOREIGN KEY (`id_respcadastro`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
