# frozen_string_literal: true

module Admin
  # Admin email templates controller
  class EmailTemplatesController < BaseSupervisorController
    before_action :fetch_email_template, only: %i[show edit update translate save_translation test]
    before_action :fetch_translation, only: %i[translate save_translation]

    # GET /email_templates
    # GET /email_templates.json
    def index
      @email_templates = EmailTemplate.where(client_id: current_client.id).sort_by(&:type_name)
    end

    # GET /email_templates/1
    # GET /email_templates/1.json
    def show; end

    # GET /email_templates/1/edit
    def edit; end

    # PATCH/PUT /email_templates/1
    # PATCH/PUT /email_templates/1.json
    def update
      if @email_template.update(email_template_params)
        redirect_to admin_email_template_path(@email_template), notice: _('The email template was successfully updated.')
      else
        render :edit
      end
    end

    # GET /email_templates/1/translate
    def translate; end

    # POST /email_templates/1/save_translation
    def save_translation
      @email_template.assign_attributes(translation_params)

      if @email_template.save_translation(translation_locale)
        redirect_to translate_admin_email_template_path(@email_template, translation_locale: translation_locale),
                    notice: _('The email template was successfully translated.')
      else
        @translation.assign_attributes(translation_params)

        render :translate
      end
    end

    # POST /email_templates/1/test
    def test
      @email_template.send_test_email(current_admin_user)

      redirect_to admin_email_template_path(@email_template), notice: _('A test email was successfully sent to your email address.')
    end

    private

    def fetch_email_template
      @email_template = EmailTemplate.find_by!(id: params[:id], client_id: current_client.id)
    end

    def fetch_translation
      @translation = @email_template.translate(translation_locale)
    end

    def email_template_params
      params.require(:email_template).permit(:subject, :body)
    end

    def translation_params
      params.require(:email_template).permit(EmailTemplate::TRANSLATABLE_FIELDS)
    end
  end
end
