require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up')}
    it { should have_title(full_title('Sign up'))}
  end

  describe "profile page" do
    let(:user) {FactoryGirl.create(:user) }
    before {
      User.delete_all()
      visit user_path(user)
    }

    it { should have_content(user.name)}
    it { should have_title(user.name)}
  end

  describe "signup page" do
    before { visit signup_path}

    let(:submit) { "Create my account"}

    it { should have_content('Sign up')}
    it { should have_title (full_title('Sign up'))}

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      it "should be on signup page" do
        click_button submit
        should have_title('Sign up')
      end

      it "should display error message" do
        click_button submit
        should have_content('errors')
      end
    end

    describe "with valid information" do
      before do
        User.delete_all
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit}.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before {click_button submit}
        let(:user) { User.find_by(email: 'user@example.com')}

        it { should have_link('Sign out')}
        it { should have_title(user.name)}
        it { should have_selector('div.alert.alert-success', text: 'Welcome')}
      end

    end

  end
end