class User < ApplicationRecord
  include Clearance::User

  before_validation :generate_api_token, on: :create
  validates :api_token, presence: true, uniqueness: true

  def generate_api_token
    self.api_token = Clearance::Token.new
  end

  def reset_api_token!
    generate_api_token
    save!
  end
end
