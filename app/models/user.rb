class User < ApplicationRecord

  has_secure_password

  has_many :posts

  has_many :active_relationships, class_name:"Relationship", foreign_key:"follower_id", dependent: :destroy
  has_many :passive_relationships, class_name:"Relationship", foreign_key:"following_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :following
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, {presence: true}
  validates :email, {presence: true, uniqueness: true}
  #validates :password, {presence: true}

  def posts
    return Post.where(user_id: self.id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(following_id: other_user.id)
  end

  # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(following_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end


end
