class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  has_many :posts,
            dependent: :destroy
  has_many :likes,
            dependent: :destroy
  has_many :active_relationships,
            class_name: 'Relationship',
            foreign_key: 'follower_id',
            dependent: :destroy
  has_many :passive_relationships,
            class_name: 'Relationship',
            foreign_key: 'followed_id',
            dependent: :destroy
  has_many :following,
            through: :active_relationships,
            source: :followed
  has_many :followers,
            through: :passive_relationships

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 4 }

  before_save do
    self.email = email.downcase
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def posts
    Post.where(user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end
end
