class UsersController < ApplicationController
  def index
  end

  def new
  end

  def edit
  end

  def show
    @user = User.new(
        name: 'Vadim',
        username: 'installero',
    avatar_url: 'https://secure.gravatar.com/avatar/712696e0f757ddb4f73614f43ae445?s=100'
    )
    @questions = [
        Question.new(text: 'how are you?', created_at: Date.parse('25.03.2020'))
    ]
  end
end
