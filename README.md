# Nome do Projeto

O projeto "Repo on Rails - Operações Compromissadas na Web 3" é uma aplicação desenvolvida em Ruby on Rails que gerencia carteiras de Ethereum e interage com contratos inteligentes. O projeto utiliza a ferramenta Truffle para a implantação de contratos com testes automatizados e consiste em quatro Smart Contracts principais:

1.	`STR` (Sistema de Transferências de Reservas): Este contrato simula o STR e é responsável por adicionar participantes, emitir DREX (Digital Real ERC20), e criar e gerenciar operações compromissadas.
2.	`DREX` (Digital Real ERC20): Simula o Real Digital no padrão ERC20.
3.	`Tpft` (Token de Título Público ERC1155): Representa os títulos públicos no padrão ERC1155.
4.	`ExchangeContract`: Facilita a troca entre DREX e Tpft.
Além disso, o sistema inclui uma tarefa 'rake' que lê blocos da blockchain e procura por transações de operações compromissadas que ocorreram no ambiente.
Um aspecto notável do projeto é o desenvolvimento de um marketplace para a proposta de operações compromissadas. No final de cada janela de operações, se houver participantes que necessitem de liquidação (zeragem do caixa), um algoritmo de zeragem é acionado automaticamente para montar operações compromissadas. Dessa forma, existem dois cenários para as operações: um manual, através de propostas e aceites, e outro automatizado. Ambos os cenários lançam as propostas na web por meio do contrato STR.
Este resumo destaca a complexidade e a inovação incorporadas ao projeto, refletindo seu potencial para impactar significativamente o setor de operações financeiras na Web 3.


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


## Configuração do Projeto

### Instalação das Dependências do Ruby

Instale as dependências do Ruby especificadas no Gemfile:

`bundle install`


### Configuração do Truffle

Navegue até a pasta `truffle_projects`:

`cd truffle_projects`


Instale as dependências do projeto Truffle:

`npm install`



## Inicialização do Projeto Rails

Após concluir as configurações:

1. Volte para a raiz do seu projeto Rails (se você estiver na pasta `truffle projects`, use `cd ..`).
2. Execute as migrações do banco de dados:

    `rails db:create db:migrate`

3. Inicie o servidor Rails com:

    `rails server`

4. Acesse o aplicativo no navegador em `http://localhost:3000`.

## Contribuição

Instruções para contribuir para o projeto.



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
