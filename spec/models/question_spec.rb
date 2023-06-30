require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it "includes the Voteable module" do
    expect(Answer.include?(Voteable)).to be true
  end

  it { should belong_to :user }
  it { should belong_to(:best_answer).optional }
  it { should have_one(:trophy).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :trophy }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#append_files=' do
    it 'adds files to question' do
      question.append_files = {io: File.open("#{Rails.root}/spec/models/question_spec.rb"), filename: 'question_spec.rb'}
      expect(question.files.last.filename.to_s).to eq 'question_spec.rb'
    end
  end
end
