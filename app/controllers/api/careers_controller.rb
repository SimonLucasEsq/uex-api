module Api
    class CareersController < Api::BaseController
      before_action :set_career, only: [:create, :show, :update, :destroy]
  
      def create
        @career.save!
        render json: @career
      end
  
      def index
        careers = Career.search(params).paginate(page: page, per_page: per_page)
        render json: careers, each_serializer: CareerSerializer, meta: meta_attributes(careers)
      end
  
      def show
        render json: @career
      end
  
      def update
        @career.update!(career_params)
        render json: @career
      end
  
      def destroy
        @career.destroy!
      end
  
      private
      def set_career
        @career = if params[:id]
          Career.find(params[:id])
        else
          Career.new(career_params)
        end
      end
  
      def career_params
        params.require(:career).permit(:name)
      end
    end
  end