require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
	module Strategies
    #
    # Authenticate to BitBucket via OAuth and retrieve an access token for API usage
    #
    # Usage:
    #
    #    use OmniAuth::Strategies::BitBucket, 'consumerkey', 'consumersecret'
    #
		class BitBucket < OmniAuth::Strategies::OAuth
       # Initialize the BitBucket strategy.
       #
       # @option options [Hash, {}] :client_options Options to be passed directly to the OAuth Consumer
		   def initialize(app, consumer_key = nil, consumer_secret = nil, options = {}, &block)
        		client_options = {
          			:site => 'https://www.bitbucket.org',
          			:request_token_path => '/api/1.0/oauth/request_token/',
          			:access_token_path => '/api/1.0/oauth/access_token/',
          			:authorize_path => '/api/1.0/oauth/authenticate/',
        		}

        		super(app, :bitbucket, consumer_key, consumer_secret, client_options, options, &block)
      		end

      		def auth_hash
        		OmniAuth::Utils.deep_merge(super, {
          			'uid' => user_data.id,
          			'user_info' => user_info,
          			'extra' => user_data
        		})
      		end

      		def user_info
        		{
          			'first_name' => user_data["first_name"],
          			'last_name' => user_data["last_name"],
          			'nickname' => user_data["username"],
          			'avatar' => user_ddata["avatar"]
        		}
      		end

      		def user_data
	      		@data ||= MultiJson.decode(@access_token.get('/api/1.0/users/').body)['user']
      		end
		end
	end
end