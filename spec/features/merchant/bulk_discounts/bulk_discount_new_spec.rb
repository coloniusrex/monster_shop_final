require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts New Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      @discount_1 = @merchant_1.discounts.create(nickname:'Spring Sale', percent: 20, quantity: 5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can complete the form to create a discount and see a flash message on the index page" do
      visit 'merchant/discounts/new'

      within '#new-discount-form' do
        fill_in "Nickname", with: 'New Discount'
        fill_in "Percent", with: 15
        fill_in "Quantity", with: 5
        click_on 'Submit'
      end

      expect(current_path).to eql('/merchant/discounts')
      expect(page).to have_content('Succesfully Created Bulk Discount')
      within '#discounts' do
        expect(page).to have_content('New Discount')
        expect(page).to have_content('15% off for 5 or more items.')
      end
    end

    it "I can submit an incomplete form and see a flash message and redirect to the new form" do
      visit 'merchant/discounts/new'

      within '#new-discount-form' do
        fill_in "Nickname", with: 'New Discount'
        fill_in "Percent", with: 15
        fill_in "Quantity", with: ''
        click_on 'Submit'
      end

      expect(current_path).to eql('/merchant/discounts/new')
      expect(page).to have_content("Quantity can't be blank and Quantity is not a number, Try Again.")
    end
  end
end
