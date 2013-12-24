require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  describe "Home page" do
    it "should load" do
      get '/static_pages/home'
      response.status.should be(200)
    end

    it "should have content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('sample app')
    end

    it "should have the right title" do
      visit '/static_pages/home'
      page.should have_title(
            "#{base_title}")
    end

    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end

    it "should have the right title" do
      visit '/static_pages/help'
      page.should have_title(
        "#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should load" do
      get '/static_pages/about'
      response.status.should be(200)
    end

    it "should have the right title" do
      visit '/static_pages/about'
      page.should have_title(
        "#{base_title} | About")
    end

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
  end

end
