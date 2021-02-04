require_relative 'framework'
require_relative 'database'
require_relative 'queries'

DB = Database.connect('postgres://localhost:5432/framework_dev',
                      QUERIES)

APP = App.new do
  get '/' do
    "This is the root"
  end

  get '/users/:username' do |params|
    "This is #{params.fetch('username')}!"
  end

  get '/submissions' do |params|
    DB.all_submissions
  end

  get '/submissions/:name' do |params|
    name = params.fetch('name')
    user = DB.find_submission_by_name(name).fetch(0)
    "the user is #{user.fetch('name')}"
  end

end
