class RecipesController < ApplicationController
  # need before_action :authenticate_user! own_this_recipe?
   before_action :authenticate_user!
   before_action :right_to_recipe?, except: [:index, :show]

  def index
    @blogger_id = params[:blogger_id]
    @ingredient_id = params[:ingredient_id]
    @date = params[:date]
    @recipes = Recipe.pick_blogger(@blogger_id).by_ingredient(@ingredient_id).by_date(@date)
  end

  def show
    @recipe = Recipe.find_by(id: params[:id])
    if !@recipe.nil?
      @comments = @recipe.comments
    else
      flash[:alert] = "No such recipe exists."
      redirect_to recipes_path
    end
  end

  def new
    @user = User.find_by(id: params[:user_id])
    @recipe = @user.recipes.build
    5.times {@recipe.ingredients.build}
  end

  def create
    @user = User.find_by(id: params[:user_id])
    @recipe = Recipe.new(recipe_params)
    @recipe.user_id = params[:user_id]
    if @recipe.save
      flash[:notice] = "Recipe successfully created."
      return redirect_to recipe_path @recipe
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:user_id])
    @recipe = @user.recipes.find_by(id: params[:id])
    2.times {@recipe.ingredients.build}
  end

  def update
    @user = User.find_by(id: params[:user_id])
    @recipe = @user.recipes.find_by(id: params[:id])
    @recipe.attributes = recipe_params
    if @recipe.save
      flash[:notice] = "Recipe successfully edited."
      return redirect_to recipe_path @recipe
    else
      render 'edit'
    end
  end

  def destroy
    Recipe.find_by(params[:id]).destroy
    redirect_to recipes_path
  end


  private
  def recipe_params
    params.require(:recipe).permit(:title, :content, ingredients_attributes: [:name])
  end

  def right_to_recipe?
    unless params[:user_id].to_i == current_user.id
      return redirect_to recipes_path, alert: "You do not have right to create/modify this recipe"
    end
  end

end
