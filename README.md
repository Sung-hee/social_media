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



 