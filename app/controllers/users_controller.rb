class UsersController < ApplicationController
  # Pular verificações de autenticação e CORS, se aplicável
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, raise: false

  # GET /users
  # Este método retorna todos os usuários em formato JSON
  def index
    @users = User.where.not(email: ["stn@gov.com.br", "admin@bc.com.br"])
    render json: @users, only: [:email, :name, :document, :saldo_real], methods: [:saldo_drex, :saldo_tpft_1]
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])

    render json: @user, only: [:email, :name, :document, :saldo_real], methods: [:saldo_drex, :saldo_tpft_1]
  end

  # Demais métodos do CRUD podem ser adicionados aqui se necessário

  # Método privado para definir parâmetros permitidos
  private

  def user_params
    params.require(:user).permit(:email, :password_digest, :name, :document)
  end
end
