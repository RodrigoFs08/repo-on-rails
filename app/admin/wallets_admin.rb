Trestle.resource(:wallets) do
  menu do
    item :wallets, icon: "fa fa-money-bill-alt", label: I18n.t("sidebar.wallets")
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :user, header: I18n.t("wallets.fields.user")
    column :address, header: I18n.t("wallets.fields.address")
    column :created_at, align: :center, header: I18n.t("common.created_at") do |wallet|
      wallet.created_at.strftime("%d/%m/%Y %H:%M")
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |wallet|
  #   text_field :name
  #
  #   row do
  #     col { datetime_field :updated_at }
  #     col { datetime_field :created_at }
  #   end
  # end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:wallet).permit(:name, ...)
  # end
end
