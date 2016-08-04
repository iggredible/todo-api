class Api::UsersController < ApiController
  before_action :authenticated? #refer to authenticated? -> ensures that user and password are present
  respond_to :json

   def index
     @users = User.all
#     my_object = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
     render json: @users, each_serializer: UserSerializer, adapter: :json
#    render json: JSON.pretty_generate(my_object, each_serializer: UserSerializer)
#    render json: JSON.pretty_generate(@users.to_json), each_serializer: UserSerializer

   end

   def show
     @user = User.find_by(id: params[:id])
     @no_user_found = User.all #other alternative when user ID not found?
     if @user.nil?
       flash[:notice] = "No user found"
       render json: @no_user_found, each_serializer: UserSerializer
     else
      render json: @user, each_serializer: UserSerializer, adapter: :json
    end
   end

   def create
     @user = User.new(user_params)
     if @user.save

       render json: @user
     else

       render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
     end
   end

   def destroy
     begin
       user = User.find(params[:id])
       user.destroy

       render json: {}, status: :no_content
     rescue ActiveRecord::RecordNotFound
       render :json => {}, :status => :not_found
     end

   end

   private
   def user_params
     params.require(:user).permit(:username, :password)
   end


end
