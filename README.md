# Nome do Projeto

Breve descrição do seu projeto.

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

