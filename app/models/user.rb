class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  has_many :photos, dependent: :destroy

  # Only the account named by ADMIN_EMAIL gets in; with it unset, nobody does.
  def admin?
    admin_email = ENV["ADMIN_EMAIL"].to_s.strip.downcase
    admin_email.present? && email.to_s.downcase == admin_email
  end
end
