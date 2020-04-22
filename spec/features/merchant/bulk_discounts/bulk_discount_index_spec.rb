require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Page' do
  describe 'As an employee of a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
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

    it "I can see a list of current discounts" do
      visit '/merchant'

      click_link 'Manage Bulk Discounts'
      expect(current_path).to eql("/merchant/discounts")

      within "#discounts" do
        within "#discount-#{@discount_1.id}" do
          expect(page).to have_content(@discount_1.nickname)
          expect(page).to have_content("#{@discount_1.percent}% off for #{@discount_1.quantity} or more items")
        end
      end
    end

    it "I can click a link to create a new discount" do
      visit '/merchant/discounts'
      click_link 'Create New Bulk Discount'
      expect(current_path).to eql('/merchant/discounts/new')
    end

    it "I can click an 'Edit' button to edit a discount" do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_on 'Edit Discount'
      end

      expect(current_path).to eql("/merchant/discounts/#{@discount_1.id}/edit")
    end

    it "I can click a Delete Discount link and no longer see that discount" do
      visit '/merchant/discounts'

      within "#discount-#{@discount_1.id}" do
        click_on 'Delete Discount'
      end

      expect(page).to have_content('Succesfully Removed Discount')
    end
  end
end
