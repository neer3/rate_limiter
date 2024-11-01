class TokenBucketController < ApplicationController
  def show
    user_id = params[:user_id]
    if token_left?(user_id)
      render json: { message: 'Successfull call' }, status: :ok
    else
      render json: { message: 'Limit exhausuted' }, status: 429
    end
  end

  def update_max_token
    # only for testing
    user_id = params[:user_id]
    token_bucket = TokenBucket.find_by(user_id: user_id)

    if token_bucket.present?
      token_bucket.max_token = params[:max_token]
      token_bucket.save
      render json: { message: 'max token updated' }, status: :ok
    else
      render json: { message: 'No such user' }, status: 400
    end
  end

  private

  MAX_ALLOWED_TOKEN = 10
  PER_SCHEDULE_ADDED_TOKEN = 2
  SCHEDULED_IN_SECONDS = 30

  private_constant :MAX_ALLOWED_TOKEN
  private_constant :PER_SCHEDULE_ADDED_TOKEN
  private_constant :SCHEDULED_IN_SECONDS

  def token_left?(user_id)
    @token_bucket = TokenBucket.find_by(user_id: user_id)
    current_time = Time.now

    if @token_bucket.nil?
      @token_bucket = TokenBucket.create!(user_id: ,token_count: MAX_ALLOWED_TOKEN, last_timestamp: current_time, max_token: MAX_ALLOWED_TOKEN)
    end

    perform_token_refresh(current_time)

    if @token_bucket.token_count < 0
      return false
    end
    true
  end

  def perform_token_refresh(current_time)
    # updating the last time stamp and if user has crossed time then provide additional token for the user to carry on.
    
    if (current_time - @token_bucket.last_timestamp) > SCHEDULED_IN_SECONDS
      @token_bucket.last_timestamp = current_time
      @token_bucket.token_count = PER_SCHEDULE_ADDED_TOKEN + [ @token_bucket.token_count, 0].max

      @token_bucket.token_count = [@token_bucket.token_count, @token_bucket.max_token].min
    end

    @token_bucket.token_count -= 1
    @token_bucket.save
  end
end
