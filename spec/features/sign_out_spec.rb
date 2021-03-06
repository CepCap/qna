require 'rails_helper'

feature 'user can sign out', %q{
  In order to end session,
  As an athenticated user,
  I'd like to sign out.
} do

  given!(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User presses sign out' do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
