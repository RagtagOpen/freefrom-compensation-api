task :import_data => :environment do
  require 'yaml'

  # Always destroy data before re-importing
  ResourceCategory.destroy_all
  Mindset.destroy_all
  QuizQuestion.destroy_all
  QuizResponse.destroy_all

  # This is just to create the quiz questions below
  ResourceCategory.create(id: 1)

  mindsets = YAML.load(File.read('data/mindsets.yml'))
  mindset_name_to_id = {} # Create a convenient way of associating mindset names with ids

  mindsets.each do |mindset|
    mindset_obj = Mindset.create(
      name: mindset['name'],
      description: mindset['description'],
      resource_category_id: 1
    )

    mindset_name_to_id[mindset['name']] = mindset_obj.id
  end

  quiz_questions = YAML.load(File.read('data/quiz_questions.yml'))
  quiz_questions.each do |question|
    question_obj = QuizQuestion.create(
      title: question['title'],
      description: question['description']
    )

    question['responses'].each do |response|
      QuizResponse.create(
        quiz_question_id: question_obj.id,
        text: response['text'],
        mindset_ids: response['mindsets'].map { |name| mindset_name_to_id[name] }
      )
    end
  end
end
