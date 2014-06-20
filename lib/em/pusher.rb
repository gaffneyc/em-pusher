require 'em-http'
require 'multi_json'
require 'hmac-sha2'
require 'digest/md5'

class EventMachine::Pusher < EventMachine::HttpRequest
  AUTH_VERSION = '1.0'

  # Initialize a new client, each client is associated with only one channel
  # at a time.
  #
  # === Required options
  # [:app_id]
  #   ID specific to your application
  # [:auth_key]
  #   Application key provided by pusherapp.com
  # [:auth_secret]
  #   Application secret provided by pusherapp.com
  # [:channel]
  #   Channel that updates will be posted to
  #
  def initialize(config)
    @app_id      = config[:app_id]
    @auth_key    = config[:auth_key]
    @auth_secret = config[:auth_secret]
    @channel     = config[:channel]

    super("http://api.pusherapp.com/apps/#{@app_id}/channels/#{@channel}/events")
  end

  # Trigger +event+ on the client side with the given name. The +data+ parameter
  # is converted to JSON and parsed on the other end.
  #
  # ==== Examples
  #
  #   # Send the counts event updating how many users there are
  #   pusher.trigger('counts', :users => 5)
  #
  #   # Send an update and check to see if it succeeded
  #   post = pusher.trigger('users', :user => { :name => 'Mary' })
  #   post.callback do
  #     # Ensure it worked
  #   end
  #
  def trigger(event, data)
    body         = MultiJson.encode(data)
    digest       = Digest::MD5.hexdigest(body)
    timestamp    = Time.now.to_i

    signature =
      "POST\n/apps/#{@app_id}/channels/#{@channel}/events\nauth_key=#{@auth_key}&" +
      "auth_timestamp=#{timestamp}&auth_version=#{AUTH_VERSION}&" +
      "body_md5=#{digest}&name=#{event}"

    self.post(
      :query => {
        'auth_key'       => @auth_key,
        'auth_timestamp' => timestamp,
        'body_md5'       => digest,
        'name'           => event,
        'auth_version'   => AUTH_VERSION,
        'auth_signature' => HMAC::SHA256.hexdigest(@auth_secret, signature)
      },
      :body => body
    )
  end
end
