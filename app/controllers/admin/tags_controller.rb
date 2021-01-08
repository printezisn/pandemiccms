# frozen_string_literal: true

module Admin
  # Admin tags controller
  class TagsController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_tag, only: %i[show edit update destroy]

    # GET /tags
    # GET /tags.json
    def index
      @tags = Tag.where(client_id: current_client.id)
                 .simple_text_search(params[:search])
                 .bound_sort(params[:sort_by], params[:dir])
                 .page(params[:page].to_i)
                 .per(PAGE_SIZE)
      render :_tags_table, layout: nil if request.xhr?
    end

    # GET /tags/1
    # GET /tags/1.json
    def show; end

    # GET /tags/new
    def new
      @tag = Tag.new
    end

    # GET /tags/1/edit
    def edit; end

    # POST /tags
    # POST /tags.json
    def create
      @tag = Tag.new(tag_params)
      @tag.client_id = current_client.id

      if @tag.save
        redirect_to admin_tag_path(@tag), notice: _('The tag was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /tags/1
    # PATCH/PUT /tags/1.json
    def update
      if @tag.update(tag_params)
        redirect_to admin_tag_path(@tag), notice: _('The tag was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /tags/1
    # DELETE /tags/1.json
    def destroy
      @tag.destroy

      redirect_to admin_tags_path, notice: _('The tag was successfully deleted.')
    end

    private

    def fetch_tag
      @tag = Tag.find_by!(id: params[:id], client_id: current_client.id)
    end

    def tag_params
      params.require(:tag).permit(:name, :slug, :description, :template)
    end
  end
end