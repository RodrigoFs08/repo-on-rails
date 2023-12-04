Trestle.resource(:wallets) do
  # menu do
  #   item :wallets, icon: "fa fa-money-bill-alt", label: I18n.t("sidebar.wallets")
  # end

  table do
    column :user, header: I18n.t("wallets.fields.user")
    column :address, header: I18n.t("wallets.fields.address")
    column :created_at, align: :center, header: I18n.t("common.created_at") do |wallet|
      wallet.created_at.strftime("%d/%m/%Y %H:%M")
    end

    actions do |toolbar, instance, admin|
    end
  end
end
