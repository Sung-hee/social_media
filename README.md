```ruby

def index
  @posts = Post.all
  # Post.where(['created_at < ?', 30.seconds.ago]).destroy_all
  # Plus like
  std_time = 30.seconds
  plus_time = 10

  post = Post.where(['created_at < ?', std_time.seconds.ago])

  post.each do |post|
    if post.likes != nil
      like_count = post.likes.count
      total_time = std_time + (like_count * plus_time)
      Post.where(['created_at < ?', total_time.seconds.ago]).destroy_all
    else
      post.destroy
    end
  end
end

```

- std_time : 기본 게시글 시간
- plus_time : 좋아요 1개당 추가 시간
- post.likes : 좋아요 DB
- like_count = post.likes.count : 좋아요 개수
