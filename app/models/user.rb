class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :comments
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  SKIP_CONFIRMATION = ['facebook'].freeze

  def author_of?(object)
    id == object.user_id
  end

  def subscribed_to?(question_id)
    subscriptions.find_by(question_id: question_id)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email] unless auth.info.blank?
    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      user.skip_confirmation! if SKIP_CONFIRMATION.include? auth.provider
      user.save
      user.create_authorization(auth) if user.persisted?
      return user
    end
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
