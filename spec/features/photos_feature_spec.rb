require 'rails_helper'

RSpec.describe 'CRUD Photos', type: :feature do
  fixtures :photos

  let(:photo) { photos(:one) }

  describe "GET /photos" do
    it "displays photos", points: 1 do
      visit "/photos"

      expect(page).to have_xpath("//img[@src = '#{photo.source}']")
      expect(page).to have_content(photo.caption)
    end
  end

  describe "GET /photos/:id" do
    it "displays photo", points: 3 do
      visit "/photos/#{photo.id}"

      expect(page).to have_xpath("//img[@src = '#{photo.source}']")
      expect(page).to have_content(photo.caption)
    end
  end

  describe "GET /photos/new" do
    it "displays new photo form", points: 4 do
      visit "/photos/new"

      expect(page).to have_xpath("//form[@action = 'http://localhost:3000/create_photo']").or have_xpath("//form[@action = '/create_photo']")
    end
  end

  describe "GET /create_photo" do
    it "creates new photo", points: 5 do
      original_count = Photo.count

      visit "/photos/new"
      fill_in 'Image URL:', with: 'https://www.google.com/images/srpr/logo11w.png'
      fill_in 'Caption:', with: 'Google logo'

      form = page.find("form")
      class << form
        def submit!
          Capybara::RackTest::Form.new(driver, native).submit({})
        end
      end
      form.submit!

      expect(page).to have_xpath("//img[@src = 'https://www.google.com/images/srpr/logo11w.png']")
      expect(page).to have_content('Google logo')
      expect(Photo.count).to eq(original_count + 1)
    end
  end

  describe "GET /photos/:id/edit" do
    it "displays edit photo form", points: 5 do
      visit "/photos"
      find(:xpath, "//a[@href='http://localhost:3000/photos/#{photo.id}/edit']").click

      expect(page).to have_xpath("//form[@action = 'http://localhost:3000/update_photo/#{photo.id}']").or have_xpath("//form[@action = '/update_photo/#{photo.id}']")
    end
  end

  describe "GET /update_photo/:id" do
    it "updates photo", points: 7 do
      original_count = Photo.count

      visit "/photos/"
      find(:xpath, "//a[@href='http://localhost:3000/photos/#{photo.id}/edit']").click
      fill_in 'Image URL:', with: 'https://www.google.com/images/srpr/logo11w.png'
      fill_in 'Caption:', with: 'Google logo'

      form = page.find("form")
      class << form
        def submit!
          Capybara::RackTest::Form.new(driver, native).submit({})
        end
      end
      form.submit!

      expect(page).not_to have_content(photo.source)
      expect(page).not_to have_content(photo.caption)
      expect(page).to have_xpath("//img[@src = 'https://www.google.com/images/srpr/logo11w.png']")
      expect(page).to have_content('Google logo')

      expect(Photo.count).to eq(original_count)
    end
  end

  describe "GET /delete_photo/:id/" do
    it "deletes photo", points: 3 do
      visit "/photos/"
      find(:xpath, "//a[@href='http://localhost:3000/delete_photo/#{photo.id}']").click

      expect(page).not_to have_content(photo.source)
      expect(page).not_to have_content(photo.caption)
    end
  end
end
