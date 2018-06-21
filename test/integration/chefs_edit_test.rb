require 'test_helper'

class ChefsEditTestTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
	def setup
	  	@chef = Chef.create!(chefname: "manshur", email: "manshur@example.com",
	      password: "password", password_confirmation: "password")
	end

	test "reject an invalid edit" do 
		sign_in_as(@chef, "password")
	  	get edit_chef_path(@chef)
	  	assert_template 'chefs/edit'
  		patch chef_path(@chef), params: {chef: {chefname: " ", email: "congdang@gmail.com"}}
	  	assert_template 'chefs/edit'
	  	assert_select 'h2.panel-title'
	  	assert_select 'div.panel-body'
	end

    test "accept valid signup" do 
    	sign_in_as(@chef, "password")
	  	get edit_chef_path(@chef)
	  	assert_template 'chefs/edit'
  		patch chef_path(@chef), params: {chef: {chefname: "congdang ", email: "congdang@gmail.com"}}
	  	assert_redirected_to @chef
	  	assert_not flash.empty?
	  	@chef.reload
	  	assert_match "congdang", @chef.chefname
	  	assert_match "congdang@gmail.com", @chef.email
	end
end
