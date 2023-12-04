Trestle.resource(:users, model: User, scope: Auth) do
  menu do
    item :users, icon: "fas fa-users", label: "Minhas Informações", priority: 0
  end

  # Utilize o escopo definido
  collection do
    if current_user.email == "admin@bc.com.br"
      User.all
    else
      User.where(email: current_user.email)
    end
  end

  table do
    column :avatar, header: false do |user|
      avatar_for(user)
    end
    column :email, link: true, align: :center
    column :name, header: "Nome", align: :center
    column :document, header: "Documento", align: :center
    column :saldo_drex, header: "Saldo DREX", align: :center do |user|
      number_to_currency(user.saldo_drex / 10 ** 18, unit: "DREX")
    end
    column :saldo_tpft, header: "Saldo Título Publico Tokenizado", align: :center do |user|
      user.saldo_tpft_1 / 10 ** 18
    end
  end

  form do |user|
    text_field :email

    row do
      col(sm: 6) { text_field :name }
      col(sm: 6) { text_field :document }
    end

    row do
      col(sm: 6) { password_field :password }
      col(sm: 6) { password_field :password_confirmation }
    end
  end
end
