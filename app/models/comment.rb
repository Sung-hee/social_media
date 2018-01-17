class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  def require_permission?(user)
    self.user.id == user.id
  end
end
