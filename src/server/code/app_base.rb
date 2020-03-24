# frozen_string_literal: true
require_relative 'silently'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require 'json'
require 'sprockets'

class AppBase < Sinatra::Base

  def initialize
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -
  # stylesheets and javascript

  set :environment, Sprockets::Environment.new
  # append asset paths
  environment.append_path('code/assets/stylesheets')
  # compress assets
  # Cause a notable delay in response times so for now off.
  #environment.css_compressor = :scss

  get '/assets/app.css', provides:[:css] do
    respond_to do |format|
      format.css do
        env['PATH_INFO'].sub!('/assets', '')
        settings.environment.call(env)
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.probe_get(name)
    get "/#{name}" do
      result = instance_eval { target.public_send(name) }
      json({ name => result })
    end
  end

  private

  set :show_exceptions, false

  error do
    error = $!
    status(500)
    info = {
      exception: {
        request: {
          path:request.path,
          body:request.body.read
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path:error.path,
        args:error.args,
        name:error.name,
        body:error.body,
        message:error.message
      }
    else
      exception[:message] = error.message
    end
    @diagnostic = JSON.pretty_generate(info)
    puts @diagnostic
    erb :error
  end

end
