# frozen_string_literal: true

RSpec.shared_examples 'admin user page' do
  context 'when the admin user is not signed in' do
    let(:signed_in_user) { nil }

    it 'redirects to the sign in page' do
      request

      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end
end

RSpec.shared_examples 'supervisor page' do
  context 'when the admin user is not signed in' do
    let(:signed_in_user) { nil }

    it 'redirects to the sign in page' do
      request

      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end

  context 'when the admin user is not a supervisor' do
    let(:signed_in_user) { admin_user }

    it 'redirects to the admin dashboard page' do
      request

      expect(response).to redirect_to(admin_root_path)
    end
  end
end
