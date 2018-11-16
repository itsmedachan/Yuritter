require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #無効なuserデータの送信が正しく失敗するかテスト
  test "invalid signup information" do
    get signup_path
    #レコードが弾かれるか
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    #users/newにrenderするか
    assert_template 'users/new'
    #assert_select 'エラーメッセージのテスト'
    #signup_pathが使われているか
    assert_select 'form[action=?]',signup_path
  end

  #有効なuserデータの送信が成功するかのテスト
  test "valid signup information" do
    get signup_path
    #レコードの数(count)が1増えるか
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    end
    #POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動するか
    follow_redirect!
    #users/showのテンプレにredirectするか
    assert_template 'users/show'
    assert_not flash.nil?
    #assert_not flash.empty? #nil?とempty?の違いはググれ
  end
  #こういうのをend to endなテスト(統合テスト)と言う？
end
