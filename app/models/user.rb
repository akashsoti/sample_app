class User < ActiveRecord::Base

  attr_accessible(:name, :email, :password, :password_confirmation)
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :followers, through: :reverse_relationships, source: :follower
                                   
  before_save :fix_email
  before_save :create_remember_token 
  before_create :create_verification_token

	validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates_presence_of :password, :password_confirmation, on: :create

  scope :search_user, ->(user) { where( "name LIKE ? ", "%#{user}%").order(:name) }

  after_create :send_mail

  def feed
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def verify_user
    self.is_verify = true
    destroy_verification_token 
    self.save
  end

  private

    def send_mail
      Verification.send_link(self).deliver
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def fix_email
  	  self.email = self.email.downcase if email?
    end

    def create_verification_token
      self.verification_token = SecureRandom.urlsafe_base64
    end

    def destroy_verification_token
      self.verification_token = nil
    end
end
