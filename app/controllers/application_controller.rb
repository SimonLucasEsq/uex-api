class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization

  rescue_from JWTSessions::Errors::Unauthorized, JWTSessions::Errors::Expired, with: :not_authorized
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

    # TODO: Fix method when payload it is not present
    #def current_user
    #  @current_user ||= User.find(payload['user_id'])
    #end

    def not_authorized
      render json: { error: 'Not authorized' }, status: :unauthorized
    end

    def unprocessable_entity(exception)
      render json: {errors: exception.record.errors}, status: 422
    end

    def record_not_found
      render json: { error: 'Record not found' }, status: :not_found
    end
end
