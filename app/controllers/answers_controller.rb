class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_answer, only: %i[update destroy]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    flash.now[:notice] = t('.success') if @answer.save
  end

  def update
    if @answer.user == current_user
      flash.now[:notice] = t('.success') if @answer.update(answer_params)
    end
  end

  def destroy
    if @answer.user == current_user
      flash.now[:notice] = t('.success') if @answer.destroy
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
