# frozen_string_literal: true

module SuperAdmin
  # Clients controller
  class ClientsController < BaseController
    PAGE_SIZE = 10

    before_action :initialize_languages, only: :new
    before_action :fetch_client, only: %i[show edit update destroy]

    # GET /super_admin/clients
    def index
      @clients = Client.simple_text_search(params[:search])
                       .bound_sort(params[:sort_by], params[:dir])
                       .page(params[:page].to_i)
                       .per(PAGE_SIZE)

      render :_clients_table, layout: nil if request.xhr?
    end

    # GET /super_admin/clients/new
    def new
      @form_model = Form::Client.new
    end

    # POST /super_admin/clients
    def create
      @form_model = Form::Client.new(new_client_params)

      if @form_model.save
        redirect_to super_admin_client_path(@form_model.client), notice: _('The client was successfully created.')
      else
        render :new
      end
    end

    # GET /super_admin/clients/1
    def show; end

    # GET /super_admin/clients/1/edit
    def edit
      @form_model = Form::Client.new(
        client_id: @client.id,
        client_name: @client.name,
        domains: @client.client_domains.map(&:domain),
        ports: @client.client_domains.map { |client_domain| client_domain.port.to_s },
        language_ids: @client.client_languages.map { |cl| cl.language_id.to_s }
      )
    end

    # PATCH/PUT /super_admin/clients/1
    def update
      @form_model = Form::Client.new(update_client_params)

      if @form_model.save
        redirect_to super_admin_client_path(@form_model.client), notice: _('The client was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /super_admin/clients/1
    def destroy
      @client.destroy

      redirect_to super_admin_clients_path, notice: _('The client was successfully deleted.')
    end

    private

    def new_client_params
      params.require(:form_client).permit(
        :client_name, :client_template, :admin_email, :admin_username, :admin_password,
        :admin_password_confirmation, domains: [], ports: [], language_ids: []
      )
    end

    def update_client_params
      params.require(:form_client).permit(:client_id, :client_name, domains: [], ports: [], language_ids: [])
    end

    def initialize_languages
      LanguageInitializer.call
    end

    def fetch_client
      @client = Client.find(params[:id])
    end
  end
end
