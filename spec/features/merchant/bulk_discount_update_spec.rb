require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Update Page' do
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
      @discount_1 = @merchant_1.discounts.create(nickname:'Spring Sale', price: 20, quantity: 5)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it "I can see a form pre-filled with the current info, complete/submit and see my changes on the discounts index page" do
      visit "/merchant/discounts/#{@discount_1.id}/edit"

      within '#edit-discount-form' do
        expect(find_field('Nickname').value).to eql(@discount_1.nickname)
        expect(find_field('Price').value).to eql(@discount_1.price.to_s)
        expect(find_field('Quantity').value).to eql(@discount_1.quantity.to_s)

        fill_in 'Nickname', with: 'New Nickname'
        fill_in 'Price', with: 5
        fill_in 'Quantity', with: 10
        click_on 'Submit'
      end

      expect(current_path).to eql('/merchant/discounts')

      within '#discounts' do
        within "#discount-#{@discount_1.id}" do
          expect(page).to have_content('New Nickname')
          expect(page).to have_content('5% off for 10 or more items')
        end
      end
    end

    it "I see a flash message and am redirected back if I submit an incomplete form" do
      visit "/merchant/discounts/#{@discount_1.id}/edit"

      within '#edit-discount-form' do
        expect(find_field('Nickname').value).to eql(@discount_1.nickname)
        expect(find_field('Price').value).to eql(@discount_1.price.to_s)
        expect(find_field('Quantity').value).to eql(@discount_1.quantity.to_s)

        fill_in 'Nickname', with: 'New Nickname'
        fill_in 'Price', with: ''
        fill_in 'Quantity', with: 10

        click_on 'Submit'
      end

      expect(page).to have_content('Incomplete Form, Try Again.')
      expect(current_path).to eql("/merchant/discounts/#{@discount_1.id}/edit")
    end
  end
end
