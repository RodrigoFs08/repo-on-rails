# Repo on Rails – Tecnologia e Confiança: Simplicidade, Automatização e Inteligência para Criar um Verdadeiro Mercado de Operações Compromissadas Tokenizadas.

O projeto "Repo on Rails" é uma aplicação desenvolvida em Ruby on Rails, focada na gestão de carteiras Ethereum e na interação com contratos inteligentes. Este sistema utiliza a ferramenta Truffle para implantação e testes automatizados de cinco Smart Contracts principais, essenciais ao ecossistema de operações compromissadas.

Além disso, a aplicação incorpora gems especializadas para aprimorar sua funcionalidade e interface de usuário:

- **Trestle**: Uma gem de administração moderna e modular, utilizada para construir interfaces administrativas intuitivas e personalizadas. Sua flexibilidade e facilidade de uso são fundamentais para o gerenciamento eficiente do sistema. [Saiba mais sobre Trestle](https://github.com/TrestleAdmin/trestle).

- **Eth**: Esta gem oferece uma poderosa interface Ruby para interagir com a Ethereum Blockchain, simplificando o processo de conexão, transação e execução de operações em contratos inteligentes. [Saiba mais sobre Eth](https://github.com/q9f/eth.rb).


**Smart Contracts (Rede de testes Ethereum Sepolia)**

- [DREXToken - 0xdF2a260e686E615adCcBc6dB585a0b444a67C0a2](https://sepolia.etherscan.io/address/0xC7b997B51A1c7C3e2468075e51EC034E036e424C)
- [TPFtToken - 0xbFd94123632BcC1b389f1a12541D6d3c76bae729](https://sepolia.etherscan.io/address/0xf663b153Ba7dA589bE7bF40B939b9a166C994AA2)
- [ExchangeContract - 0xeEAF1002AfA91A80b5c4794A64a28F2CdED8c553](https://sepolia.etherscan.io/address/0x960708E3E4aF151F4Abc62E0f668Faeed229d8d0)
- [STR - 0xBcA68b7edb94d73402B32C3EF9E57a992a97b554](https://sepolia.etherscan.io/address/0x890300ddB65Fc3f7094006C2cA75f8651a5A9B30)

- [Chainlink Automation - 0x315972edefc2842a05679e2c78f0d9060127490a](https://sepolia.etherscan.io/address/0x890300ddB65Fc3f7094006C2cA75f8651a5A9B30)
1.	`STR` (Sistema de Transferências de Reservas): Este contrato simula o STR e é responsável por adicionar participantes, emitir DREX (Digital Real ERC20), e criar e gerenciar operações compromissadas.
2.	`DREX` (Digital Real ERC20): Simula o Real Digital no padrão ERC20.
3.	`Tpft` (Token de Título Público ERC1155): Representa os títulos públicos no padrão ERC1155.
4.	`ExchangeContract`: Facilita a troca entre DREX e Tpft.
5.	`Chainlink Automation (Oráculo)`: Este contrato inteligente funciona como um oráculo automatizado que desempenha um papel crucial no monitoramento diário das operações compromissadas gerenciadas pelo contrato STR. Ele é especialmente programado para identificar operações que estão próximas do vencimento. No dia específico do vencimento de uma operação compromissada, o oráculo ativa automaticamente o processo de recompra, garantindo a execução pontual e eficiente das obrigações contratuais.


Além disso, o sistema inclui uma tarefa 'rake' que lê blocos da blockchain e procura por transações de operações compromissadas que ocorreram no ambiente.

Um aspecto notável do projeto é o desenvolvimento de um marketplace para a proposta de operações compromissadas. No final de cada janela de operações, se houver participantes que necessitem de liquidação (zeragem do caixa), um algoritmo de zeragem é acionado automaticamente para montar operações compromissadas. Dessa forma, existem dois cenários para as operações: um manual, através de propostas e aceites, e outro automatizado. Ambos os cenários lançam as propostas na web por meio do contrato STR.

Combinando essas tecnologias avançadas, "Repo on Rails" estabelece uma base sólida para um mercado de operações compromissadas tokenizadas, caracterizado por sua simplicidade, automação e inteligência estratégica.

<p align="center">
  <img src="https://i.ibb.co/xS4RBJb/Diagrama.png" width="600">
</p>

<p align="center">
  <img src="https://i.ibb.co/Gcwt0F5/Imagem-do-Whats-App-de-2023-12-04-s-19-05-02-560a22ad.jpg" width="1000">
</p>




## Pré-requisitos

Antes de iniciar, certifique-se de ter instalado em sua máquina:

- Ruby 3.0.6
- PostgreSQL
- Node.js e npm
- Truffle (via npm)

## Configuração do Ambiente

### Instalação do Ruby

Certifique-se de ter o Ruby 3.0.6 instalado. Você pode verificar a versão do Ruby com o comando:

`ruby -v`

Para Windows, instale o Ruby 3.0.6 usando [RubyInstaller](https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.6-1/rubyinstaller-devkit-3.0.6-1-x64.exe)

### Configuração do PostgreSQL

Certifique-se de que o PostgreSQL está instalado e rodando em sua máquina. Crie um banco de dados para o projeto e configure as credenciais de acesso no arquivo de configuração do projeto.

### Instalação do Node.js e npm

Instale o Node.js e npm (Node Package Manager) seguindo as instruções em [nodejs.org](https://nodejs.org/).

### Instalação do Truffle

Com o Node.js e npm instalados, instale o Truffle globalmente:

`npm install -g truffle`

# Tutorial de Implantação e Testes

Este tutorial guiará você pelos passos para testar e implantar os contratos inteligentes usando Truffle, configurar o ambiente Rails e preparar o sistema para uso no projeto "Repo on Rails".

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:
- Ruby on Rails
- Truffle
- Ganache (para testes locais) ou acesso a uma rede Ethereum como Sepolia
- Node.js e npm

## Configuração do Ambiente

### 1. Configurar Variáveis de Ambiente:
- Duplique o arquivo `.env.sample` e renomeie para `.env`.
- Preencha o `.env` com as variáveis necessárias, como host da rede blockchain, endereço dos contratos, entre outras configurações específicas.

### 2. Iniciar Ganache (Para Testes Locais):
- Se estiver usando Ganache para testes locais, inicie o Ganache e certifique-se de que todas as contas listadas no ambiente estão criadas e configuradas.

### 3. Distribuição de ETH para Testes na Rede Sepolia (Se Aplicável):
- Se estiver testando na rede Sepolia, distribua ETH para todas as carteiras necessárias conforme definido no seu ambiente.

## Implantação dos Contratos Inteligentes com Truffle

### 1. Compilar os Contratos:

- Instale as dependências do projeto Truffle:

`npm install`

- Navegue até o diretório do projeto (`truffle_project`, na raiz do projeto) e execute `truffle compile`.

### 2. Migrar os Contratos:
- Para implantar os contratos na sua rede de testes (Ganache ou Sepolia), execute `truffle migrate`.

### 3. Testes Automatizados:
- Para executar os testes automatizados dos contratos, utilize `truffle test`.

## Configuração do Projeto Rails

### 1. Instalar Dependências:
- Execute `bundle install` para instalar as dependências do Ruby on Rails.

### 2. Configurar Banco de Dados:
- Execute `rails db:create` e `rails db:migrate` para configurar o banco de dados.

### 2.5. Gerar e Configurar Chave de Criptografia:
- Uma nova chave de criptografia é necessária para proteger informações sensíveis, como as chaves privadas das carteiras.
- Gere uma nova chave de criptografia executando `rails secret`.
- Copie a chave gerada.
- Rode `EDITOR="nome_do_seu_editor --wait" rails credentials:edit` para abrir o arquivo de credenciais. Se estiver usando o VS Code, por exemplo, você pode usar `EDITOR="code --wait" rails credentials:edit`.
- Adicione a chave de criptografia gerada no arquivo de credenciais. Por exemplo:
  ```yaml
  wallet:
    private_key_encryption_key: <chave_gerada>

### 3. Criar Usuários e Carteiras:
- Para inicializar usuários e carteiras, execute `rails db:seed`.

### 4. Finalizar Configuração Inicial:
- Após implantar os contratos, atualize os endereços de cada um no `.env`.
- Execute `rails db:seed` novamente para rodar as configurações iniciais do projeto (adicionar participantes, dar as devidas autorizações, etc).

## Execução e Testes do Aplicativo

### 1. Iniciar o Servidor Rails:
- Execute `rails server` para iniciar o aplicativo.

### 2. Testar Funcionalidades:
- Navegue até a interface do aplicativo para testar as funcionalidades e interações com os contratos inteligentes.
- Para rodar o monitor de transações, digite `rake monitor:transactions`.

# Simulador de Compromissadas e Algoritmo de Otimização
O código SIMULADOR-COMPROMISSADA simula transações bancárias entre diferentes tipos de bancos e movimentos de mercado. Ele realiza as seguintes etapas:

1. **Definição de Datas e Feriados:** Define um intervalo de datas e uma lista de feriados.

2. **Definição de Bancos:** Cria classes para bancos superavitários, deficitários e neutros, cada um com saldos aleatórios em dinheiro real, DREX e bonds.

3. **Operações de Zeragem e Compromissadas:** Implementa funções para zerar saldos negativos entre bancos, converter saldos de dinheiro real para DREX e realizar operações de compromissadas entre bancos.

4. **Simulação Diária:** Simula transações diárias, valorização de ativos (bonds), operações intraday e overnight, identificação de bancos deficitários, zeragem de saldos, geração aleatória de caixas intraday e recompra.

5. **Exportação de Dados:** Gera DataFrames do Pandas e os exporta para arquivos Excel, registrando transações de compromissadas, saldos diários dos bancos e movimentações internas de zeragem.

Este código foi especialmente desenvolvido para criar uma simulação detalhada do ambiente de operações compromissadas, permitindo assim a geração de dados de teste robustos e proporcionando uma visão mais clara e precisa dos tipos de dados envolvidos. Além disso, este código serve como a base para a extração e refinamento do algoritmo de otimização, que é um componente crucial do nosso sistema, garantindo a eficiência e eficácia das operações compromissadas.

# Licença

MIT License

Copyright (c) 2023 RodrigoFs08

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
