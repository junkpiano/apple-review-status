require 'sinatra'
require 'sinatra/reloader' if development?
require 'spaceship'
require 'slim'

get '/' do
    app = get_app
    data = collect_data(app)
    @version = data[:version]
    @status = data[:status]
    @color_class = data[:color]
    slim :toppage
end

get '/api' do
    app = get_app_app
    data = collect_data(app)
    data.to_json
end

private

def collect_data(app)
    ver = app.latest_version
    version = ver.version
    status = ver.raw_status
    color_class = 'is-danger'
    color_class = 'is-warning' if status == "inReview"
    color_class = 'is-success' if status == "readyForSale"
    {
        version: version,
        status: status,
        color: color_class
    }
end

def get_app
    get_app('com.example.app')
end

def get_app(bundle_id = 'com.example.app')
    Spaceship::Tunes.login(ENV['FASTLANE_USER'], ENV['FASTLANE_PASSWORD'])
    all_apps = Spaceship::Tunes::Application.all
    all_apps.find {|app| app.bundle_id == bundle_id}
end