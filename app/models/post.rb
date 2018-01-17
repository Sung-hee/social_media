class Post < ActiveRecord::Base
  mount_uploader :image, PhotoUploader # 업로더를 다른 모델이 쓸 수 있게 함
  belongs_to :user
  has_many :likes
  has_many :comments

  def require_permission?(user)
    self.user.id == user.id
  end
end
