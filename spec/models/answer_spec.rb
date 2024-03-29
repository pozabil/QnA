require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  it "includes the Voteable module" do
    expect(Answer.include?(Voteable)).to be true
  end
  
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    it 'assigns selected answer to best for parent question' do
      answer.mark_as_best
      expect(answer.question.best_answer).to eq answer
    end

    it "assign question's trophy to answer's author" do
      question.create_trophy!(title: 'best_answer_trophy',
                              image: {io: File.open(file_fixture('pes_s_rukoi.jpg')), filename: 'pes_s_rukoi.jpg'})

      answer.mark_as_best

      expect(answer.user.trophies.reload.last).to eq question.trophy
    end
  end

  describe '#append_files=' do
    it 'adds files to answer' do
      answer.append_files = {io: File.open("#{Rails.root}/spec/models/answer_spec.rb"), filename: 'answer_spec.rb'}
      expect(answer.files.last.filename.to_s).to eq 'answer_spec.rb'
    end
  end

  context 'answer is best for some question' do
    before { answer.mark_as_best }

    describe '#destroy' do
      it 'nullify best_answer_id for question when destroy answer' do
        answer.destroy
        expect(answer.question.best_answer).to be_nil
      end
    end
  end
end
