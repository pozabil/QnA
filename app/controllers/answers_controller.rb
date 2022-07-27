class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :question, id: -> { params[:question_id] || answer.question.id }
  expose :answers, from: :question
  expose :answer, build: ->(params){ answers.new(params) }

  def create
    if answer.save
      redirect_to answer.question, notice: t('.success')
    else
      render 'questions/show'
    end
  end

  def destroy
    if answer.user == current_user
      answer.destroy
      redirect_to answer.question, notice: t('.success')
    else
      self.answer = answers.new(user_id: current_user.id)
      flash.now[:notice] = t('.failure')
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(user_id: current_user.id)
  end
end
