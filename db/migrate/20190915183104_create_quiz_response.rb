class CreateQuizResponse < ActiveRecord::Migration[5.2]
  def change
    create_table :quiz_questions do |t|
      t.string  :title
      t.text    :description
      t.timestamps
    end

    create_table :quiz_responses do |t|
      t.text  :text
      t.timestamps

      t.belongs_to :quiz_question, index: true
    end

    create_join_table :quiz_responses, :mindsets do |t|
      t.index [:quiz_response_id, :mindset_id], name: :quiz_mindset_index
    end
  end
end
