class User < ActiveRecord::Base
  has_many :repos, dependent: :restrict_with_exception

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :omniauthable, omniauth_providers: [:github]

  validates_presence_of :email
  validates_uniqueness_of :email, allow_blank: false, if: :email_changed?

  def self.find_for_github(auth)
    return nil unless auth.try(:info).present?

    data = auth.info
    user = User.where(email: data.fetch('email')).first

    unless user
      user = User.create!(email: data.fetch('email'))
    end

    user
  end
end
