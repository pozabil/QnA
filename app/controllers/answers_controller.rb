class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    flash.now[:notice] = t('.success') if @answer.save
  end

  def update
    @answer = Answer.find(params[:id])

    if @answer.user == current_user
      flash.now[:notice] = t('.success') if @answer.update(answer_params)
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if @answer.user == current_user
      @question = @answer.question
      @answer.destroy
      redirect_to @question, notice: t('.success')
    else
      flash.now[:notice] = t('.failure')
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
