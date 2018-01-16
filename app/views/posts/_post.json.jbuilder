<<<<<<< HEAD
json.extract! post, :id, :title, :content, :tag, :user_id, :created_at, :updated_at
=======
json.extract! post, :id, :title, :content, :tag, :post_image, :user_id, :created_at, :updated_at
>>>>>>> 30372491eaa60629d10e2933c66dd101223f9070
json.url post_url(post, format: :json)
