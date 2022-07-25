class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :answers, from: :question
  expose :answer, ->{ params[:id] ? answers.find(params[:id]) : answers.new(answer_params) }
  expose :question, id: :question_id

  def create
    if answer.save
      redirect_to answer.question, notice: t('.success')
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
