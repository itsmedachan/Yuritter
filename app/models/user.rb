class User < ApplicationRecord

  #User has_many posts. Userが削除されたらpostsも削除される。
  has_many :posts, dependent: :destroy
  #Userが他のUserをフォローする(能動的関係)。Relationshipクラスのfollower_idを外部キーとする。follower_idが削除されたらこの関係も削除される。
  has_many :active_relationships, class_name:"Relationship", foreign_key:"follower_id", dependent: :destroy
  #Userが他のUserにフォローされる(受動的関係)。Relationshipクラスのfollowed_idを外部キーとする。followed_idが削除されたらこの関係も削除される。
  has_many :passive_relationships, class_name:"Relationship", foreign_key:"followed_id", dependent: :destroy

  #has_many :followeds, through: :active_relationshipsの英語的エラーを処理するためsourceを導入
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships#,source: :follower
  #今回はRailsがfollowersを単数形にしたfollower_idを外部キーとして探してくれるのでsourceは省略可

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

  #ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  #ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  #現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  #現在のユーザーがフォローされていたらtrueを返す
  def followed_by?(other_user)
    followers.include?(other_user)
  end

end
