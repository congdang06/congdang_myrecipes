require "test_helper"

class ChefTest < ActiveSupport::TestCase

	def setup
		@chef = Chef.new(chefname: "Davison", email: "davis@hotmail.com",
			password: "password", password_confirmation: "password")
	end

	test "chefname should be valid" do
		assert @chef.valid?
	end

	test "email should be valid" do
		assert @chef.valid?
	end

	test "chefname should be presented" do 
		@chef.chefname = " "
		assert_not @chef.valid?
	end

	test "email should be presented" do 
		@chef.email = " "
		assert_not @chef.valid?
	end


	test "maximum chefname should be 30 characters" do
		@chef.chefname = "a" * 31
		assert_not @chef.valid?
	end

	test "email should not too longt" do
		@chef.email = "a" * 245 + "@example.com"
		assert_not @chef.valid?
	end


	test "email should accept the correct format" do 
		valid_emails = %w[user@example.com CDANG@email.com m.first@yahoo.co john+smith@co.uk.org]
		valid_emails.each do |valids|
			@chef.email = valids 
			assert @chef.valid?, "{valids.inspect} should be valid"
		end
	end

	test "should reject invalid addresses" do 
		invalid_emails = %w[masurah@exmaple mashar@example,com masrhe.ane@gmail. joe+food+font.com]
		invalid_emails.each do |invalids|
			@chef.email = invalids
			assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
		end
	end

	test "email should be unique and insensitive" do 
		duplicate_chef = @chef.dup 
		duplicate_chef.email = @chef.email.upcase
		@chef.save
		assert_not duplicate_chef.valid?
	end

	test "email should be lowercase before hitting db" do
		mixed_email = "JOHNMIx@EXAMPLE.COM"
		@chef.email = mixed_email
		@chef.save
		assert_equal mixed_email.downcase, @chef.reload.email 
	end

	test 'password should be presented' do
		@chef.password = @chef.password_confirmation = " "
		assert_not @chef.valid?

	end

	test "password should be at least 5 characters" do 
		@chef.password = @chef.password_confirmation = "x" * 4
		assert_not @chef.valid?
	end

	test "associated recipe should be destroyed" do 
		@chef.save
		@chef.recipes.create!(name: "testing destroy", description: "Testing destroy function")
		assert_difference 'Recipe.count', -1 do @chef.destroy
		end
	end


end