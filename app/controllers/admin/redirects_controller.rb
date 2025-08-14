# frozen_string_literal: true

module Admin
  # Admin redirects controller
  class RedirectsController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_redirect, only: %i[show edit update destroy]

    # GET /redirects
    # GET /redirects.json
    def index
      @redirects = Redirect.where(client_id: current_client.id)
                           .simple_text_search(params[:search])
                           .bound_sort(params[:sort_by], params[:dir])
                           .page(params[:page].to_i)
                           .per(PAGE_SIZE)
      render :_redirects_table, layout: nil if request.xhr?
    end

    # GET /redirects/1
    # GET /redirects/1.json
    def show; end

    # GET /redirects/new
    def new
      @redirect = Redirect.new
    end

    # GET /redirects/1/edit
    def edit; end

    # POST /redirects
    # POST /redirects.json
    def create
      @redirect = Redirect.new(redirect_params)
      @redirect.client_id = current_client.id

      if @redirect.save
        redirect_to admin_redirect_path(@redirect), notice: _('The redirect was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /redirects/1
    # PATCH/PUT /redirects/1.json
    def update
      if @redirect.update(redirect_params)
        redirect_to admin_redirect_path(@redirect), notice: _('The redirect was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /redirects/1
    # DELETE /redirects/1.json
    def destroy
      @redirect.destroy

      redirect_to admin_redirects_path, notice: _('The redirect was successfully deleted.')
    end

    private

    def fetch_redirect
      @redirect = Redirect.find_by!(id: params[:id], client_id: current_client.id)
    end

    def redirect_params
      params.expect(redirect: %i[from to])
    end
  end
end
