# frozen_string_literal: true

module Admin
  # Admin posts controller
  class PostsController < BaseController
    PAGE_SIZE = 10

    before_action :fetch_post, only: %i[show edit update destroy translate save_translation publish]
    before_action :fetch_translation, only: %i[translate save_translation]
    before_action :fetch_templates, only: %i[new edit create update]
    before_action :fetch_visibilities, only: %i[new edit create update]

    decorates_assigned :posts

    # GET /posts
    # GET /category/:category_id/posts
    # GET /tag/:tag_id/posts
    # GET /user/:user_id/posts
    def index
      user_id = params[:user_id]
      user_id ||= current_admin_user.id if params[:only_mine].present?

      @posts = Post.includes(:translations).where(client_id: current_client.id)
      @posts = @posts.where(status: params[:status]) if params[:status].present?
      @posts = @posts.joins(:tag_taggables).where(tag_taggables: { tag_id: params[:tag_id] }) if params[:tag_id].present?
      if params[:category_id].present?
        @posts = @posts.joins(:category_categorizables).where(category_categorizables: { category_id: params[:category_id] })
      end
      @posts = @posts.where(author_id: user_id) if user_id.present?

      @posts = @posts.simple_text_search(params[:search])
                     .bound_sort(params[:sort_by], params[:dir])
                     .page(params[:page].to_i)
                     .per(PAGE_SIZE)
      render :_posts_table, layout: nil if request.xhr?
    end

    # GET /posts/search
    # GET /posts/search.json
    def search
      posts = Post.where(client_id: current_client.id)
                  .simple_text_search(params[:term])
                  .bound_sort(params[:sort_by] || 'name', params[:dir])
                  .select(:id, :name)
                  .page(params[:page].to_i)
                  .per(PAGE_SIZE)
      results = posts.map { |post| { id: post.id, text: post.name } }
      more = !posts.last_page? && results.any?

      render json: { results:, pagination: { more: } }
    end

    # GET /posts/1/show
    # GET /posts/1/show.json
    def show; end

    # GET /posts/new
    def new
      @post = Post.new
    end

    # GET /posts/1/edit
    # GET /posts/1/edit.json
    def edit
      @post.category_names = @post.categories.map(&:name)
      @post.tag_names = @post.tags.map(&:name)
    end

    # POST /posts
    # POST /posts.json
    def create
      @post = Post.new(post_params)
      @post.client_id = current_client.id
      @post.author_id = current_admin_user.id
      @post.should_save_categories = true
      @post.should_save_tags = true

      result = params[:publish].present? ? @post.publish_now : @post.save

      if result
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_post_path(@post), notice: _('The post was successfully created.')
      else
        render :new
      end
    end

    # PATCH/PUT /posts
    # PATCH/PUT /posts.json
    def update
      @post.assign_attributes(post_params)
      @post.should_save_categories = true
      @post.should_save_tags = true

      result = params[:publish].present? ? @post.publish_now : @post.save

      if result
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_post_path(@post), notice: _('The post was successfully updated.')
      else
        render :edit
      end
    end

    # DELETE /posts/1
    # DELETE /posts/1.json
    def destroy
      @post.destroy
      CacheVersionBumper.call(current_client.id)

      redirect_to admin_posts_path, notice: _('The post was successfully deleted.')
    end

    # POST /posts/1/publish
    # POST /posts/2/publish.json
    def publish
      if @post.publish_now
        CacheVersionBumper.call(current_client.id)
        redirect_to admin_post_path(@post), notice: _('The post was successfully published.')
      else
        redirect_to admin_post_path(@post), alert: _('The post could not be published.')
      end
    end

    # GET /posts/1/translate
    def translate; end

    # POST /posts/1/translate
    def save_translation
      @post.assign_attributes(translation_params)

      if @post.save_translation(translation_locale)
        CacheVersionBumper.call(current_client.id)
        redirect_to translate_admin_post_path(@post, translation_locale:),
                    notice: _('The post was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    private

    def fetch_post
      @post = Post.find_by!(id: params[:id], client_id: current_client.id).decorate
    end

    def fetch_translation
      @translation = @post.translate(translation_locale)
    end

    def fetch_templates
      path = Rails.root.join("app/views/templates/#{current_client.template}/posts/*.html.erb")
      @templates = Dir[path].map { |f| File.basename(f, '.html.erb') }
                            .reject { |f| f.start_with?('_') }
                            .sort
    end

    def fetch_visibilities
      @visibilities = [[_('Public|Visibility'), :public], [_('Private|Visibility'), :private]]
    end

    def post_params
      params.expect(post: [:image, :should_remove_image, :name, :slug, :description, :body,
                           :visibility, :template, { category_names: [], tag_names: [] }])
    end

    def translation_params
      params.expect(post: [Post::TRANSLATABLE_FIELDS])
    end
  end
end
