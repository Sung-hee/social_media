# 설명 (like, comment 기능)

- ```
  rails g model like
  ```

- ```
  rails g model comment
  ```

- post_controller에서 추가 사항

  - ```
    def show
        if user_signed_in?
          @like = Like.where(user_id: current_user.id, post_id: params[:id])
        else
          @like = []
        end
      end
    ```

  - ```
    def user_like_post
        @like = Like.where(user_id: current_user.id, post_id: params[:post_id]).first

        unless @like.nil?
          @like.destroy
          puts '좋아요 취소'

        else
          @like = Like.create(user_id: current_user.id, post_id: params[:post_id])
          puts '좋아요 누름'
        end
      end

      def create_comment
        @comment = Comment.create(
          user_id: current_user.id,
          post_id: params[:id],
          contents: params[:contents]
        )
      end

      def delete_comment
        @comment = Comment.find(params[:comment_id])
        if @comment.destroy
          respond_to do |format|
            format.js
          end
        end
      end
    ```

  - ```
    create 액션에 
    @post = Post.new(post_params) 다음에
    @post.user_id = current_user.id 추가
    ```

- model 폴더에 comment.rb, like.rb 추가

  - ```
      belongs_to :user
      belongs_to :post

      def require_permission?(user)
        self.user.id == user.id
      end
    ```

- model 폴더에  post.rb

  - ```
      belongs_to :user
      has_many :likes
      has_many :comments

      def require_permission?(user)
        self.user.id == user.id
      end
    ```

- model 폴더에 user.rb

  - ```
      has_many :posts
      has_many :likes
      has_many :comments
    ```

- views 폴더에 layouts 폴더에

  - ```
    <% if user_signed_in? %>
        <%= link_to "게시판", posts_path%>
        <%= link_to "로그아웃", destroy_user_session_path, method: "delete" %> <br>
        <p><%= current_user.email %></p>
      <% else %>
        <%= link_to "로그인", new_user_session_path %>
        <%= link_to "회원가입", new_user_registration_path %>
      <% end %>

      <%= yield %>

      <%= yield :script %>
    ```

- views 폴더에 create_comment.js.erb 추가 후

  - ```
    $('.comment-list').prepend(`
        <tr id="comment-<%= @comment.id %>">
          <td><%= comment.user.email %></td>
          <td class="comment" data-id="<%= @comment.id %>"><%= @comment.contents %></td>
          <td></td>
          <td><button class="delete-comment" data-id="<%= @comment.id %>">삭제</button></td>
        </tr>
      `);
    $('#comment-input').val('');
    ```

- views 폴더에 delete_comment.js.erb 추가 후

  - ```
    $("#comment-<%= @comment.id %>").fadeOut().remove();
    ```

- views 폴더에 show.html.erb에

  - ```
    <button type="button" class="like">좋아요(<span id="like-count"><%= @post.likes.count %></span>)</button>

    <form id="comment-form">
      <input id="comment-input" type="text" placeholder="Comment">
      <button type="submit">댓글쓰기</button>
    </form>

    <table class="table">
      <thead>
        <tr>
          <th width="20%">유저</th>
          <th width="50%">내용</th>
          <th width="15%"></th>
          <th width="15%"></th>
        </tr>
      </thead>
      <tbody class="comment-list">
        <% @post.comments.reverse.each do |comment| %>
          <tr id="comment-<%= comment.id %>">
            <td><%= comment.user.email %></td>
            <td class="comment" data-id="<%= comment.id %>"><%= comment.contents %></td>
            <% if (current_user.id == comment.user.id) %>
              <td><button class="delete-comment" data-id="<%= comment.id %>">삭제</button></td>
            <% else %>
              <td></td>
            <% end %>
          </tr>
        <% end %>
      </tbody>
    </table>

    <% content_for :script do %>
      <script>
        $(function() {
          //좋아요
          $('.like').on('click', function(){
            $.ajax({
              url: '/posts/<%= @post.id %>/like',
              method: "GET"
            });
          });

          //댓글 작성
          $('#comment-form').on('submit', function(e) {
            e.preventDefault();
            var value = $('#comment-input').val();
            $.ajax({
              url: '/posts/<%= @post.id %>/comments',
              method: 'POST',
              data: {
                contents: value
              }
            });
          });

          // 댓글 삭제
          $('.comment-list').on('click', '.delete-comment', function() {
            var id = $(this).data('id');
            $.ajax({
              url: '/posts/<%= @post.id %>/comments/' + id,
              method: "DELETE"
            });
          });
        })
      </script>
    <% end %>
    ```

- views 폴더에 user_like_post.js.erb 추가 후

  - ```
    alert("좋아요 버튼 누름");
    var like_count = parseInt($('#like-count').text());
    if(<%= @like.frozen? %>) {
      $('#like-count').text(like_count - 1);
    }
    else {
      $('#like-count').text(like_count + 1);
    }
    ```

- config 폴더에 routes.rb에

  - ```
    resources :posts do
        member do
          post '/comments' => 'posts#create_comment', as: :create_comment_to
          delete '/comments/:comment_id' => 'posts#delete_comment', as: :delete_comment_to
          patch '/comments/:comment_id' => 'posts#update_comment', as: :update_comment_to
        end

        collection do
          get '/:post_id/like' => 'posts#user_like_post', as: :user_like
        end
      end
    ```

- db폴더에 like에서 

  - ```
     t.references :user
     t.references :post
    ```

- db폴더에 comment에서

  - ```
    t.references :user
    t.references :post
    t.text :contents
    ```