require_relative 'framework'
require_relative 'database'
require_relative 'queries'
require_relative 'templates'

DB = Database.connect('postgres://localhost:5432/framework_dev',
                      QUERIES)
TEMPLATES = Templates.new('views')

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
    begin
      user = DB.find_submission_by_name(Name: name).fetch(0)
      TEMPLATES.submissions_show(user: user)
    rescue
      TEMPLATES.submissions_not_found()
    end
  end

end
