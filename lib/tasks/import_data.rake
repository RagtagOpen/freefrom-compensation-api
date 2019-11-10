task :import_data => :environment do
  require 'yaml'
  require 'byebug'

  # Always destroy data before re-importing
  ResourceCategory.destroy_all
  Resource.destroy_all
  Mindset.destroy_all
  QuizQuestion.destroy_all
  QuizResponse.destroy_all

  resource_categories = YAML.load(File.read('data/resource_categories.yml'))
  resource_category_to_id = {} # Convenient way of associating resource category names with ids

  resource_categories.each do |category|
    category_obj = ResourceCategory.create(
      name: category['name'],
      description: category['description']
    )

    resource_category_to_id[category['name']] = category_obj.id
  end

  Dir.foreach('data/resources') do |filename|
    next if filename == '.' or filename == '..'

    state_resources = YAML.load(File.read("data/resources/#{filename}"))
    state_resources.each do |resource|
      Resource.create(
        state: resource['state'],
        resource_category_id: resource_category_to_id[resource['resource_category']],
        who: resource['who'],
        where: resource['where'],
        when: resource['when'],
        time: resource['time'],
        cost: resource['cost'],
        award: resource['award'],
        covered_expenses: resource['covered_expenses'],
        likelihood: resource['likelihood'],
        safety: resource['safety'],
        story: resource['story'],
        attorney: resource['attorney'],
        challenges: resource['challenges'],
        steps: resource['steps'],
        what_to_expect: resource['what_to_expect'],
        what_if_i_disagree: resource['what_if_i_disagree'],
        resources: resource['resources'],
      )
    end
  end

  mindsets = YAML.load(File.read('data/mindsets.yml'))
  mindset_name_to_id = {} # Create a convenient way of associating mindset names with ids

  mindsets.each do |mindset|
    mindset_obj = Mindset.create(
      name: mindset['name'],
      description: mindset['description'],
      resource_category_id: resource_category_to_id[mindset['resource_category']]
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
