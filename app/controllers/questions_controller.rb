class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, ->{ Question.all }
  expose :question, build: ->(params){ current_user.questions.new(params) }

  def create
    if question.save
      redirect_to question, notice: t('.success')
    else
      render :new
    end
  end

  def destroy
    if question.user == current_user
      question.destroy
      redirect_to question, notice: t('.success')
    else
      flash.now[:notice] = t('.failure')
      render :show
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
