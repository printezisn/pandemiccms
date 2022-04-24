# frozen_string_literal: true

module SuperAdmin
  # Clients controller
  class ClientsController < BaseController
    PAGE_SIZE = 10

    before_action :initialize_languages, only: :new
    before_action :fetch_client, only: :show

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
    def edit; end

    # PATCH/PUT /super_admin/clients/1
    def update; end

    # DELETE /super_admin/clients/1
    def destroy; end

    private

    def new_client_params
      params.require(:form_client).permit(
        :client_name, :client_template, :default_language_id, :admin_email, :admin_username,
        :admin_password, :admin_password_confirmation, domains: [], ports: [], language_ids: []
      )
    end

    def initialize_languages
      LanguageInitializer.call
    end

    def fetch_client
      @client = Client.find(params[:id])
    end
  end
end
