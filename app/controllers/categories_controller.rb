class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:index, :show]


  def index
    @categories = Category.order('name').paginate(page: params[:page], per_page: 10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category created successfully'
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category name was successfully updated'
      redirect_to category_path(@category)
    else
      render 'edit'
    end

  end

  def show
    @category_articles = @category.articles.paginate(page: params[:page], per_page: 5)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_user.admin?)
      flash[:warning] = 'Only admins can perform that action.'
      redirect_to categories_path
    end
  end

end
