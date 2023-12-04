Trestle.resource(:exchange_transactions) do
  menu do
    item :exchange_transactions, icon: "fa fa-exchange", label: "Transações", priority: 3
  end

  # Customize the table columns shown on the index view.
  #
  table autolink: false do
    column :to_address, align: :center, header: "De"
    column :from_address, align: :center, header: "Para"
    column :tpft_token_id, align: :center, header: "Tipo Titulo Publico"
    column :tpft_amount, align: :center, header: "Quantidade Titulo Publico" do |ex|
      ex.tpft_amount / 10 ** 18
    end
    column :drex_amount, align: :center, header: "Valor da Transação" do |ex|
      number_to_currency(ex.drex_amount / 10 ** 18, unit: "DREX")
    end
    column :timestamp, align: :center, header: "Data" do |ex|
      ex.timestamp.strftime("%d/%m/%Y %H:%M")
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  # form do |exchange_transaction|
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
  #   params.require(:exchange_transaction).permit(:name, ...)
  # end
end
