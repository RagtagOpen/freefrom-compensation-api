task :import_data => :environment do
  require 'yaml'

  # Always destroy data before re-importing
  ResourceCategory.destroy_all
  Resource.destroy_all
  Mindset.destroy_all
  QuizQuestion.destroy_all
  QuizResponse.destroy_all

  resource_categories = YAML.load(File.read('data/resource_categories.yml'))
  resource_categories.each { |category_yaml| create_resource_category(category_yaml) }

  verify(ResourceCategory, resource_categories.length)

  Dir.foreach('data/resources') do |filename|
    next if filename == '.' or filename == '..'

    state_resources = YAML.load(File.read("data/resources/#{filename}"))

    state = state_resources['state']
    state_resources['resources'].each { |resource_yaml| create_resource(resource_yaml, state) }
  end

  # TODO: verify that there are the proper number of resources once we have all the state data
  verify(Resource, 1)

  mindsets = YAML.load(File.read('data/mindsets.yml'))
  mindsets.each { |mindset_yaml| create_mindset(mindset_yaml) }

  verify(Mindset, mindsets.length)

  quiz_questions = YAML.load(File.read('data/quiz_questions.yml'))
  quiz_questions.each { |question_yaml| create_quiz_question(question_yaml) }

  verify(QuizQuestion, quiz_questions.length)
end

def verify(model, expected_count)
  actual_count = model.all.count

  unless actual_count == expected_count
    raise "Expected #{expected_count} #{model}s, but created #{actual count}"
  end
end

def create_resource_category(yaml)
  ResourceCategory.create(
    name: yaml['name'],
    description: yaml['description']
  )
end

def create_resource(yaml, state)
  resource_category_id = ResourceCategory.find_by(name: yaml['resource_category']).id

  unless resource_category_id
    raise "Could not find resource category with name #{yaml['resource_category']}"
  end

  Resource.create(
    state: state,
    resource_category_id: resource_category_id,
    who: yaml['who'],
    where: yaml['where'],
    when: yaml['when'],
    time: yaml['time'],
    cost: yaml['cost'],
    award: yaml['award'],
    covered_expenses: yaml['covered_expenses'],
    likelihood: yaml['likelihood'],
    safety: yaml['safety'],
    story: yaml['story'],
    attorney: yaml['attorney'],
    challenges: yaml['challenges'],
    steps: yaml['steps'],
    what_to_expect: yaml['what_to_expect'],
    what_if_i_disagree: yaml['what_if_i_disagree'],
    resources: yaml['resources'],
  )
end

def create_mindset(yaml)
  resource_category_id = ResourceCategory.find_by(name: yaml['resource_category']).id

  unless resource_category_id
    raise "Could not find resource category with name #{yaml['resource_category']}"
  end

  Mindset.create(
    name: yaml['name'],
    description: yaml['description'],
    resource_category_id: resource_category_id
  )
end

def create_quiz_question(yaml)
  question = QuizQuestion.create(
    title: yaml['title'],
    description: yaml['description']
  )

  yaml['responses'].each do |response_yaml|
    mindset_ids = response_yaml['mindsets'].map do |name|
      Mindset.find_by(name: name).id
    end

    unless mindset_ids.length == response_yaml['mindsets'].length
      raise "Expected quiz response to be associated with #{response_yaml['mindsets']} mindsets, but it was associated with #{mindset_ids.length}"
    end

    QuizResponse.create(
      quiz_question_id: question.id,
      text: yaml['text'],
      mindset_ids: mindset_ids
    )
  end
end
