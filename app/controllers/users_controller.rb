class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessible_request
    def create
        user = User.create!(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        end
    end
    def show
        user = User.find(session[:user_id])
        render json: user, status: :created
    rescue ActiveRecord::RecordNotFound
        render json: {error: "Unauthorized"}, status: :unauthorized
    end

    private
    def user_params
        params.permit(:username, :password, :image_url, :bio, :password_confirmation)
    end
    def render_unprocessible_request(e)
        render json: {"errors": e.record.errors.full_messages},status: :unprocessable_entity
    end
end
