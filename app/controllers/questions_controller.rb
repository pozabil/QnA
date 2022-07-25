class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question

  def create
    if question.save
      redirect_to question, notice: t('.success')
    else
      render :new
    end
  end

  private

  helper_method :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def answer
    question.answers.new
  end
end
