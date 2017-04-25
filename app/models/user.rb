class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  def admin?
    is_admin
  end

  has_many :resumes
  has_many :posts
  has_many :likes, :dependent => :destroy
  has_many :liked_posts, :through => :likes, :source => :post

  def display_name
    # # 取 email 的前半来显示，如果你也可以另开一个字段是 nickname 让用户可以自己编辑显示名称
    self.email.split("@").first
  end

  # def self.from_omniauth(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0,20]
  #     # user.name = auth.info.name   # assuming the user model has a name
  #     # user.image = auth.info.image # assuming the user model has an image
  #     # If you are using confirmable and the provider(s) you use validate emails,
  #     # uncomment the line below to skip the confirmation emails.
  #     # user.skip_confirmation!
  #   end
  # end

  def self.from_omniauth(auth)
      where(email: auth.info.email).first_or_initialize.tap do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.save
      end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.github_data"] && session["devise.github_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
