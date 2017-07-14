class ArticlesController < ApplicationController

before_action  :set_article , only: [:edit,:update,:destroy,:show]
before_action :require_user, except: [:index, :show]
before_action :require_same_user, only: [:edit, :update, :destroy]
def index
  @articles = Article.paginate(page: params[:page],per_page: 5)
end

def new
@article = Article.new
end

def create
  @article = Article.new(article_params)
    @article.user = current_user
   if @article.save
          flash[:success]= "Article was successfully created"
          redirect_to article_path(@article)
   else
    #  flash[:alert] = @article.errors.full_messages
     render 'new'
   end
# we need to white list the articles params
end

def show
end

def destroy
  @article.destroy
  flash[:danger] = "Article deleted successfully"
  redirect_to articles_path

  #code
end

def edit
end

def update
 if @article.update(article_params)
   flash[:success] = "Article has been successfully updated"
   redirect_to article_path(@article)
 else
   render 'edit'
 end
end

private

def require_same_user
if current_user != @article.user
  flash[:danger] = "You can only edit or delete your own articles"
  redirect_to root_path
end
end


 def set_article
   @article = Article.find(params[:id])
 end


def article_params
  params.require(:article).permit(:title,:description)
end

end
