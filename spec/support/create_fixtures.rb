require 'factory_girl'

class CreateFixtures
  include FactoryGirl::Syntax::Methods

  attr_accessor :fbuilder

  def initialize(fbuilder)
    @fbuilder = fbuilder
  end

  def create_all
    create_users
  end

  private

  def create_users
    create(:user, email: 'larrythecableguy@example.com')
  end
end
