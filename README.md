# Repo On Rails  - Operações Compromissadas na Web 3

O projeto "Repo on Rails - Operações Compromissadas na Web 3" é uma aplicação desenvolvida em Ruby on Rails que gerencia carteiras de Ethereum e interage com contratos inteligentes. O projeto utiliza a ferramenta Truffle para a implantação de contratos com testes automatizados e consiste em quatro Smart Contracts principais:

1.	`STR` (Sistema de Transferências de Reservas): Este contrato simula o STR e é responsável por adicionar participantes, emitir DREX (Digital Real ERC20), e criar e gerenciar operações compromissadas.
2.	`DREX` (Digital Real ERC20): Simula o Real Digital no padrão ERC20.
3.	`Tpft` (Token de Título Público ERC1155): Representa os títulos públicos no padrão ERC1155.
4.	`ExchangeContract`: Facilita a troca entre DREX e Tpft.


Além disso, o sistema inclui uma tarefa 'rake' que lê blocos da blockchain e procura por transações de operações compromissadas que ocorreram no ambiente.

Um aspecto notável do projeto é o desenvolvimento de um marketplace para a proposta de operações compromissadas. No final de cada janela de operações, se houver participantes que necessitem de liquidação (zeragem do caixa), um algoritmo de zeragem é acionado automaticamente para montar operações compromissadas. Dessa forma, existem dois cenários para as operações: um manual, através de propostas e aceites, e outro automatizado. Ambos os cenários lançam as propostas na web por meio do contrato STR.
Este resumo destaca a complexidade e a inovação incorporadas ao projeto, refletindo seu potencial para impactar significativamente o setor de operações financeiras na Web 3.

## Smart Contracts (Rede de testes Ethereum Sepolia)

colocar link para o etherscan dos contratos

DREXToken - 0xC7b997B51A1c7C3e2468075e51EC034E036e424C
TPFtToken - 0xf663b153Ba7dA589bE7bF40B939b9a166C994AA2
ExchangeContract - 0x960708E3E4aF151F4Abc62E0f668Faeed229d8d0
STR - 0x890300ddB65Fc3f7094006C2cA75f8651a5A9B30

Chainlink Automation Cron - 

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

## Licença

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
