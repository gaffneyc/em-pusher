# encoding: UTF-8
Gem::Specification.new do |s|
  s.name               = 'em-pusher'
  s.homepage           = 'http://github.com/gaffneyc/em-pusher'
  s.summary            = 'EventMachine client for pusherapp.com'
  s.require_path       = 'lib'
  s.authors            = ['Chris Gaffney', 'Brian Ryckbost']
  s.email              = ['gaffneyc@gmail.com', 'brian@collectiveidea.com']
  s.version            = '0.1.0'
  s.platform           = Gem::Platform::RUBY
  s.files              = Dir.glob("lib/**/*") + %w[LICENSE README.rdoc]

  s.add_dependency 'yajl-ruby',        '~> 0.7.6'
  s.add_dependency 'em-http-request',  '~> 0.2.10'
  s.add_dependency 'ruby-hmac',        '~> 0.4.0'
end
