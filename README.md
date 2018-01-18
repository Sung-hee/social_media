### [yj_naver-login]

# Naver Login

## 0. gem file

```
gem 'figaro'
gem 'devise'
# naver login
gem 'omniauth-naver'

```

## 1. app -> views -> layouts -> application.html.erb

login, logout 버튼 생성

```
<!-- login -->
<%= link_to 'login', new_user_session_path, method: :get %>
<!-- logout -->
<%= link_to 'logout', destroy_user_session_path, method: :delete %>

```

## 2. config -> environments -> development.rb

devise 생성 후 코드 추가

```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

```

## 3. config -> locales -> routes.rb

routes 설정

```
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } do
  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
 end

```

## 4. config -> initializers -> devise.rb

naver 개발자 id, secret key

```
config.omniauth :naver,
            ENV['6번째 변수랑 동일(nv_id)'], ENV['6번째 변수랑 동일(nv_secret)']

```

## 5. app -> controllers -> users -> omniauth_callbacks_controller.rb

naver login시 if 성공 else 실패

```
 def naver
   # You need to implement the method below in your model (e.g. app/models/user.rb)
   @user = User.from_omniauth(request.env["omniauth.auth"])

   if @user.persisted?
     sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
     set_flash_message(:notice, :success, kind: "naver") if is_navigational_format?
   else
     session["devise.naver_data"] = request.env["omniauth.auth"]
     redirect_to new_user_registration_url
   end
 end

 def failure
   redirect_to root_path
 end

```

## 6. config -> application.yml

이 file은 .gitignore에서 숨기는 파일

```
nv_id: 자기 아이디
nv_secret: 자기 시크릿코드

```

## 7. app -> models -> user.rb

```
devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:naver]
  has_many :posts

  def self.from_omniauth(auth)
   user = where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
     user.email = auth.info.email
     user.password = Devise.friendly_token[0,20]
   end
  end

  def self.new_with_session(params, session)
   super.tap do |user|
     if data = session["devise.naver_data"] && session["devise.naver_data"]["extra"]["raw_info"]
       user.email = data["email"] if user.email.blank?
     end
   end
  end

```

## 8. .gitignore

```
# Ignore application configuration
/config/application.yml

```

------

### [yj_faker&admin]

# faker

## 0. gem file

```
# 회원 권한 기능
gem 'cancancan', '~> 2.0'

# faker
gem 'faker'

```

## 1. db -> migrate -> 20180112062057_devise_create_users.rb

```
# username(nickname) 선언
t.string :username,           null: false
# admin 선언
t.boolean :admin,             null: false, default: false

```

## 2. config -> routes.rb

```
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions' } do
  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
 end

```

## 3. app -> models -> user.rb

```
before_validation :create_user_name
----------------------------------------------------------------------------------
def self.from_omniauth(auth)
     user.username = Faker::Superhero.name
end
----------------------------------------------------------------------------------
def create_user_name
    self.username = Faker::Superhero.name
end

```

## 4. app -> controllers -> application_controller.rb

```
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
```

---

### [yj_editusername]

# edit username

## 0. app -> controllers -> users -> registrations_controller.rb

```
before_action :configure_sign_up_params, only: [:create]
before_action :configure_account_update_params, only: [:update]
-----------------------------------------------------------------------------------
# POST /resource
  def create
    # super
    User.create(
      email: params[:email],
      username: params[:username],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  end
-----------------------------------------------------------------------------------
protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
```

## 1. app -> models -> user.rb

```
def create_user_name
    # self.username = Faker::Superhero.name // 이거 지우기
  end
```

## 2. app -> views -> devise -> registrations -> edit.html.erb

```
<div class="form-inputs">
    <%= f.input :email, required: true, autofocus: true %>

    <% if devise_mapping.confirmable? && resource.pending_reconfirmation? %>
      <p>Currently waiting confirmation for: <%= resource.unconfirmed_email %></p>
    <% end %>

    <%= f.input :username, required:true %> // 추가된 코드
    <%= f.input :password, autocomplete: "off", hint: "leave it blank if you don't want to change it", required: false %>
    <%= f.input :password_confirmation, required: false %>
    <%= f.input :current_password, hint: "we need your current password to confirm your changes", required: true %>
  </div>
```

## 3. app -> views -> devise -> registrations -> new.html.erb 

```
<div class="form-inputs">
    <%= f.input :email, required: true, autofocus: true %>
    <%= f.input :username, required: true %> // 추가된 코드
    <%= f.input :password, required: true, hint: ("#{@minimum_password_length} characters minimum" if @minimum_password_length) %>
    <%= f.input :password_confirmation, required: true %>
  </div>
```

## 4. app -> views -> layouts -> application.html.erb 

```
<!-- edit --> // 수정버튼 생성
<%= link_to 'edit', edit_user_registration_path, method: :get %> 
```

