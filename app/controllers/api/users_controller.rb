class Api::UsersController < ApiController
  before_action :authenticated? #refer to authenticated? -> ensures that user and password are present
  respond_to :json
   def index
     @users = User.all
     render json: @users, each_serializer: UserSerializer
   end


end
