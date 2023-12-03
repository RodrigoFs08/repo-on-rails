Trestle.resource(:users, model: User, scope: Auth) do
  menu do
    item :users, icon: "fas fa-users", label: I18n.t("sidebar.users"), priority: 0
  end

  table do
    column :avatar, header: false do |user|
      avatar_for(user)
    end
    column :email, link: true
    column :name
    column :document
    column :saldo_drex do |user|
      user.saldo_drex
    end
    column :saldo_tpft do |user|
      user.saldo_tpft_1
    end
    actions do |a|
      a.delete unless a.instance == current_user
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
