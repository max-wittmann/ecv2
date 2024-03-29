require 'spec_helper'

describe "UserPages" do
  subject { page }

  #before { User.delete_all }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    #before do
    #  puts "doing before"
    #  sign_in user
    #  visit users_path
    #end

    before(:each) do
      #puts ("doing before:each")
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      #before(:each) do
      #    puts ("Before:each inside")
      #end

      before(:all) {
        30.times {
          #puts ("creating")
          FactoryGirl.create(:user)
          #puts (User.all)
        }
        #puts (User.all)
        #sign_in user
        #visit users_path
      }
      after(:all)  { User.delete_all }

      it "should have pagination div" do
        #puts ("now is ")
        #puts(User.all)
        sign_in user
        visit users_path
        #puts ("Page html is: " + page.html)
        should have_selector('div.pagination')
      end

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
  end

=begin
    describe "index" do
    before (:all) do
      User.delete_all
    end
    let(:user) { FactoryGirl.create(:user) }
    before (:each) do
      sign_in user
      #FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      #FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      before(:all) do
        #User.delete_all
        30.times { FactoryGirl.create(:user)}
      end
      after(:all) { User.delete_all}

      it { should have_selector('div.pagination')}

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end
  end
=end

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      User.delete_all
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        #User.delete_all
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

  describe "delete links" do
    it { should_not have_link('delete') }

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit users_path
      end

      #puts("Html: " + page.html)
      it { should have_link('delete', href: user_path(User.first))}
      it "should be able to delete another user" do
        expect do
          click_link('delete', match: :first)
        end.to change(User, :count).by(-1)
      end
      it { should_not have_link('delete', href: user_path(admin))}
    end
  end
end