# 이미지 업로더 만드는 절차

# 우선 필요한 젬깔기						
gem 'devise'						
gem 'cancancan'						
gem 'rolify'						
gem 'carrierwave', '~> 1.0'						
gem 'pry-rails'						
gem 'meta_request'						
gem 'devise-i18n'						
gem "mini_magick"						

gem 'rails_db'						
gem 'awesome_print'						
gem 'better_errors'						


# 스캐폴드로 로직 틀을 만듬 			image는 따로 만듬			
rails g scaffold posts title content:text tag user_id:integer image				
# 디바이즈로 유저 만들어줌		
rails g devise User

# 이미지 올리는법			https://code.tutsplus.com/tutorials/rails-image-upload-using-carrierwave-in-a-rails-app--cms-25183			
# 이미지매직 설치		
sudo apt-get install imagemagick				
# 이후 포토 업로더 생성						
rails g uploader Photo			이후에			
social_media\app\uploaders\photo_uploader.rb					이주소로가서 아래 구문 추가

include CarrierWave::MiniMagick #미니매직 젬 설치						
include ApplicationController::ApplicationHelper # 커런트유저 불러오기 위해 씀						


social_media\app\controllers\posts_controller.rb						이주소로가서 구문 추가함
mount_uploader :image, PhotoUploader # 업로더를 다른 모델이 쓸 수 있게 함						
belongs_to :user						


이주소 만들어서		social_media\config\initializers\carrier_wave.rb				
require 'carrierwave/orm/activerecord'				구문추가		

# 최종적으로 이미지 업로더 생성 됨
