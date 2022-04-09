# frozen_string_literal: true

module SuperAdmin
  # Clients controller
  class ClientsController < BaseController
    PAGE_SIZE = 10

    # GET /super_admin/clients
    def index
      @clients = Client.simple_text_search(params[:search])
                       .bound_sort(params[:sort_by], params[:dir])
                       .page(params[:page].to_i)
                       .per(PAGE_SIZE)

      render :_clients_table, layout: nil if request.xhr?
    end

    # GET /super_admin/clients/new
    def new; end

    # POST /super_admin/clients
    def create; end

    # GET /super_admin/clients/1/edit
    def edit; end

    # PATCH/PUT /super_admin/clients/1
    def update; end

    # DELETE /super_admin/clients/1
    def destroy; end
  end
end
