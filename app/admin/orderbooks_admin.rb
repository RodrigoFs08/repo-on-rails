Trestle.resource(:orderbooks) do
  menu do
    item :orderbooks, icon: "fa fa-envelope-o", label: "Propostas", priority: 1
  end

  build_instance do |attrs, params|
    instance = model.new(attrs)
    instance.lancador = current_user.id if params["action"] == "new"
    instance
  end

  # Customize the table columns shown on the index view.
  #
  table autolink: false do
    column :tipo_lancamento, align: :center, format: :tags, header: "Lançamento"
    column :tipo_moeda, align: :center, format: :tags, header: "Ativo"
    column :quantidade, align: :center
    column :taxa, align: :center, header: "% do CDI" do |orderbook|
      number_to_percentage(orderbook.taxa, precision: 0)
    end
    column :vencimento, align: :center do |orderbook|
      orderbook.vencimento.strftime("%d/%m/%Y %H:%M")
    end
    column :fechado, format: :tags, header: "Liquidado" do |orderbook|
      if orderbook.fechado?
        "Liquidado"
      end
    end
    actions do |toolbar, instance, admin|
      if !instance.fechado? && current_user.id != instance.lancador
        toolbar.link("Aprovar Proposta", approve_orderbooks_admin_path(instance), title: "Aprovar Proposta", data: { toggle: "confirm", placement: "left" }, style: :info, icon: "fa fa-thumbs-o-up")
      end
    end
  end

  # Customize the form fields shown on the new/edit views.
  #
  form dialog: true do |orderbook|
    select :tipo_lancamento, Orderbook.tipo_lancamentos.keys.map { |status| [status.humanize, status] }, label: "Lançamento"
    select :tipo_moeda, Orderbook.tipo_moedas.keys.map { |status| [status.humanize, status] }, label: "Ativo"
    number_field :quantidade, step: "any"
    number_field :taxa, step: "any", label: "Taxa (% do CDI)"
    datetime_field :vencimento
    hidden_field :lancador
  end

  controller do
    def approve
      order = Orderbook.find(params["id"])

      # lançamento na WEB3
      bc = User.find_by email: "admin@bc.com.br"
      str_client_bc = Contracts::Str.new(bc.wallet.private_key)
      exchange_contract_address = ENV["EXCHANGE_CONTRACT_ADDRESS"]

      lancador = User.find_by id: order.lancador
      tomador = User.find_by id: current_user.id

      preco_titulo = 1042.52
      tpft_token_id = 1

      quantidade_drex = order.quantidade * preco_titulo * 10 ** 18
      quantidade_tpft = order.quantidade * 10 ** 18
      valor_neg_drex = order.quantidade * preco_titulo * 10 ** 18

      vencimento_timestamp = order.vencimento.to_time.to_i

      taxa_cdi = 13.1
      taxa = taxa_cdi * order.taxa

      if order.tipo_lancamento == "compra"
        drex_client = Contracts::Drex.new(lancador.wallet.private_key)
        drex_client.approve(exchange_contract_address, valor_neg_drex)

        tpft_client = Contracts::Tpft.new(tomador.wallet.private_key)
        tpft_client.set_approval_for_all(exchange_contract_address, true)

        repo = str_client_bc.criar_operacao_compromissada(quantidade_drex, tpft_token_id, quantidade_tpft, tomador.wallet.address, lancador.wallet.address, vencimento_timestamp, taxa)
      end

      if order.tipo_lancamento == "venda"
        drex_client = Contracts::Drex.new(tomador.wallet.private_key)
        drex_client.approve(exchange_contract_address, valor_neg_drex)

        tpft_client = Contracts::Tpft.new(lancador.wallet.private_key)
        tpft_client.set_approval_for_all(exchange_contract_address, true)

        repo = str_client_bc.criar_operacao_compromissada(quantidade_drex, tpft_token_id, quantidade_tpft, lancador.wallet.address, tomador.wallet.address, vencimento_timestamp, taxa)
      end

      order.tomador = tomador.id
      order.fechado = true
      order.blockchain_tx = repo
      order.save!

      flash[:message] = "Proposta aceita com sucesso"
      redirect_to orderbooks_admin_index_path
    end
  end

  routes do
    get :approve, on: :member
  end
  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:orderbook).permit(:name, ...)
  # end
end
