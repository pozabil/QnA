class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :answers, from: :question
  expose :answer, ->{ params[:id] ? answers.find(params[:id]) : answers.new(answer_params) }

  def create
    if answer.save
      redirect_to answer.question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    Question.find(params[:question_id])
  end
end
