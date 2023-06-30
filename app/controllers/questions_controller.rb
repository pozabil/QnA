class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_trophy
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @question.user == current_user
      flash.now[:notice] = t('.success') if @question.update(question_params)
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to @question, notice: t('.success')
    else
      flash.now[:notice] = t('.failure')
      render :show
    end
  end

  private

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], append_files: [],
      links_attributes: [:name, :url], trophy_attributes: [:title, :image])
  end
end
