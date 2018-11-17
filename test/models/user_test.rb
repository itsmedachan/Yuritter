require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #setupメソッドは各テストが走る前に実行される
  def setup
    @user=User.new(name:"Example user",email:"user@example.com",
          password:"foobar", password_confirmation:"foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  #nameのpresenceのvalidationのテスト
  test "name should be present" do
  @user.name = "     "
  assert_not @user.valid?
  end

  #emailのpresenceのvalidationのテスト
  test "email should be present" do
  @user.email = "     "
  assert_not @user.valid?
  end

  #nameのlengthのvalidationのテスト
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  #emailのlengthのvalidationのテスト
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  #有効なemailを通す
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@example.COM A_US-ER@foo.bar.com
                         foo.bar@example.com foo+bar@example.com]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  #無効なemailを彈く
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_example.com user@example.
                           user@foo_bar.com foo@bar+baz.com user@example..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  #emailのuniquenessのvalidationをテストするには実際にレコードをDBに登録する必要がある
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #emailは大文字で入力されても全て小文字でsaveする
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "UsER@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  #passwordのpresenceのvalidationのテスト
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 4
    assert_not @user.valid?
  end

  #passwordのlengthのvalidationのテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 3
    assert_not @user.valid?
  end

  #followとunfollow機能のテスト
  test "should follow and unfollow a user" do
    michael = users(:michael)
    katy  = users(:katy)
    assert_not michael.following?(katy)
    michael.follow(katy)
    assert michael.following?(katy)
    assert katy.followed_by?(michael)
    assert katy.followers.include?(michael)
    michael.unfollow(katy)
    assert_not michael.following?(katy)
  end

end
