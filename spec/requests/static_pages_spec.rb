require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Find me'" do
      visit '/static_pages/home'
      page.should have_content('Find me')
    end
  end
end