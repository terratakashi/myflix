class CategoriesController < ApplicationController

  def index
    
  end

  def show
    @category = Category.find(params[:id])
    @videos = @category.videos

  end

end
