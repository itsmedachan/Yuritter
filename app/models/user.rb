class User < ApplicationRecord

  has_many :posts

  has_many :active_relationships, class_name:"Relationship", foreign_key:"follower_id", dependent: :destroy
  has_many :passive_relationships, class_name:"Relationship", foreign_key:"following_id", dependent: :destroy

  has_many :following, through: :active_relationships, source: :following
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length:{maximum:50}
  #validates :name, {presence: true} #{}省略可

  before_save {self.email=email.downcase}
  #before_save {self.email=self.email.downcase} #右辺のself省略可
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness:{case_sensitive:false},
                    length:{maximum:255}, format:{with:VALID_EMAIL_REGEX}
  #validates :email, {presence: true, uniqueness: true}

  has_secure_password
  validates :password, presence: true, length:{minimum:4}

  #渡された文字列のハッシュ値を返す(passwordをハッシュ化する)
  #テストのfixture用
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

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
