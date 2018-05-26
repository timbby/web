#coding: utf-8

#base
require 'sinatra'
#require 'sinatra-websocket'
require 'logger'
require 'json'
require 'time'
#require 'mongo'
require 'rest-client'
require 'cgi'
require 'redis'
require 'sequel'
require File.dirname(__FILE__) + '/api'
require File.dirname(__FILE__) + '/utils'

#commons
# require_relative './constants'

class Saas < Sinatra::Base
  include Api
  include Utils

  def initialize
    @config_path   = File.dirname(__FILE__) + '/etc/ws.json'
    @config        = get_json(@config_path)
    @logger        = Logger.new("#{@config['log']}/app.log", 10, 1024000)
    @redis         = Redis.new(host: @config['redis'], port: 6379)
    # @db_conf       = @config['db']
    # puts @db_conf
    # @db_web_server = Sequel.connect(
    #     :adapter  => @db_conf['adapter'],
    #     :host     => @db_conf['host'],
    #     :username => @db_conf['username'],
    #     :password => @db_conf['password'],
    #     :database => @db_conf['database'],
    #     :encoding => @db_conf['encoding'],
    # )
    @db_web_server = Sequel.connect(
        :adapter  => 'mysql2',
        :host     => '45.32.117.200',
        :username => 'root',
        :password => '150423',
        :database => 'web_server',
        :encoding => 'utf8',
    )
    super
  end

  def logger
    return @logger
  end

  def redis
    return @redis
  end

  def web_server
    Sequel::Model(@db_web_server[:message_board])
  end


  def load_cmd(cmd, params)
    file = open(File.dirname(__FILE__) + '/' + cmd + '.rb')
    code = file.read
    eval(code)
    run_cmd = "#{cmd}(#{params})"
    self.logger.debug "run_cmd: #{run_cmd}"
    eval(run_cmd)
  end

  def load_file

  end

  set :port, 15423
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/views'

  # set :frame_options, "Allow-From file://*"

  # websocket
  set :sockets, []

  #enable :sessions
  use Rack::Session::Pool, :expire_after => 2592000


  if Rack::Utils.respond_to?("key_space_limit=")
    Rack::Utils.key_space_limit = 20000000 # 20M
  end

  before do
    params['ip'] = self.request.ip
  end

  post "/api" do
    puts params
    self.send("api_#{params['cmd']}", params)
  end

  after do
    # self.response = self.response.to_json
  end

  not_found do
    halt 'This is nowhere to be found'
  end

  after do
    response.headers['X-Frame-Options'] = 'Allow-From *'
  end

  run! if app_file == $0
end
