require 'rack/oauth2'

module APIGuard
  extend ActiveSupport::Concern
  included do |base|
    # OAuth2 Resource Server Authentication
    use Rack::OAuth2::Server::Resource::Bearer, 'The API' do |request|
      request.access_token
    end

    helpers HelperMethods

    token_install_error_responders(base)
  end

  module HelperMethods
    LOCALE_MAP={ZH: 'zh', CN: 'zh', EN: 'en', DE: 'de'}

    def guard!
      authenticate!
    end

    def user_signed_in?
      !current_user.nil?
    end

    def current_user
      #@warden.user
      @current_user
    end

    def warden
      request.env['warden']
    end

    def authenticate!
      unless warden.authenticate?
        return error!({result: 0}, 401)
      else
        @current_user= @warden.user
      end
    end

    def guard_locale

      puts '----------------------------------------------1-'
      puts request.env['CONTENT_TYPE']
      puts '----------------------------------------------1-'

      I18n.locale=locale
    end

    def locale
      @locale||= get_locale
    end

    def token_guard!(scopes= [])
      begin
        if request.env['HTTP_AUTHORIZATION'].present?

          if request.env['HTTP_AUTHORIZATION'].split(' ')[0]=='Bearer'
            token_guard_by_token(scopes)
          else
            token_guard_by_basic
          end
        else
          raise NoAuthError
        end
      rescue
        raise NoAuthError
      end
    end

    private
    def token_guard_by_basic
      auth_header = env['HTTP_AUTHORIZATION'].split(' ')
      user, pass = Base64.decode64(auth_header[1]).split(':')

      Rails.logger.debug '*************use auth basic'
      Rails.logger.debug user
      Rails.logger.debug pass
      Rails.logger.debug '*************use auth basic'

      if (user=User.find_for_database_authentication(:email => user)) && user.valid_password?(pass)
        @current_user=user
      else
        raise BasicAuthError
      end
    end

    def token_guard_by_token(scopes= [])

      token_string = token_get_token_string()
      if token_string.blank?
        raise MissingTokenError

      elsif (access_token = token_find_access_token(token_string)).nil?
        raise TokenNotFoundError

      else
        case token_validate_access_token(access_token, scopes)
          when Oauth2::AccessTokenValidationService::INSUFFICIENT_SCOPE
            raise InsufficientScopeError.new(scopes)
          when Oauth2::AccessTokenValidationService::EXPIRED
            raise ExpiredError
          when Oauth2::AccessTokenValidationService::REVOKED
            raise RevokedError
          when Oauth2::AccessTokenValidationService::VALID
            @current_user = User.find(access_token.resource_owner_id)
        end
      end
    end

    def token_get_token_string
      # The token was stored after the authenticator was invoked.
      # It could be nil. The authenticator does not check its existence.
      request.env[Rack::OAuth2::Server::Resource::ACCESS_TOKEN]
    end

    def token_find_access_token(token_string)
      Doorkeeper::AccessToken.by_token(token_string)
    end

    def token_validate_access_token(access_token, scopes)
      Oauth2::AccessTokenValidationService.validate(access_token, scopes: scopes)
    end

    def get_locale
      Rails.logger.debug("***http localization header:#{request.env['HTTP_ACCEPT_LANGUAGE'].present?}")

      Rails.logger.debug("***http localization header:#{request.env['HTTP_ACCEPT_LANGUAGE']}")

      locale_header=request.env['HTTP_LOCALIZATION']||request.env['HTTP_ACCEPT_LANGUAGE']

      if locale_header.present?
        LOCALE_MAP[locale_header.upcase.to_sym] || 'en'
      else
        'en'
      end
    end
  end

  module ClassMethods
    def guard_all!
      before do
        guard!
      end
    end

    def token_guard_all!(scopes=[])
      before do
        guard_locale
        token_guard! scopes: scopes
      end
    end

    def guard_locale!
      before do
        guard_locale
      end
    end

    private
    def token_install_error_responders(base)
      error_classes = [NoAuthError, BasicAuthError, MissingTokenError, TokenNotFoundError,
                       ExpiredError, RevokedError, InsufficientScopeError]

      base.send :rescue_from, *error_classes, token_oauth2_bearer_token_error_handler
    end

    def token_oauth2_bearer_token_error_handler
      Proc.new { |e|
        response = case e
                     when NoAuthError
                       Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                           :invalid_tokens,
                           "Invalid User Info.")
                     when BasicAuthError
                       Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                           :invalid_token,
                           "Invalid User Info.")
                     when MissingTokenError
                       Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new

                     when TokenNotFoundError
                       Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                           :invalid_token,
                           "Bad Access Token.")
                     when ExpiredError
                       #Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                       #      :invalid_token,
                       #     "Token is expired. You can either do re-authorization or token refresh.")

                       r= Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                           :expired_token,
                           "Token is expired. You can resign in to get new token.")

                       r.status=403
                       r
                     when RevokedError
                       Rack::OAuth2::Server::Resource::Bearer::Unauthorized.new(
                           :invalid_token,
                           "Token was revoked. You have to re-authorize from the user.")

                     when InsufficientScopeError
                       # FIXME: ForbiddenError (inherited from Bearer::Forbidden of Rack::Oauth2)
                       # does not include WWW-Authenticate header, which breaks the standard.
                       Rack::OAuth2::Server::Resource::Bearer::Forbidden.new(
                           :insufficient_scope,
                           Rack::OAuth2::Server::Resource::ErrorMethods::DEFAULT_DESCRIPTION[:insufficient_scope],
                           {:scope => e.scopes})
                   end

        response.finish
      }
    end
  end


  #
  # Exceptions
  #

  class NoAuthError<StandardError;
  end
  class BasicAuthError<StandardError;
  end
  class MissingTokenError < StandardError;
  end

  class TokenNotFoundError < StandardError;
  end

  class ExpiredError < StandardError;
  end

  class RevokedError < StandardError;
  end

  class InsufficientScopeError < StandardError
    attr_reader :scopes

    def initialize(scopes)
      @scopes = scopes
    end
  end
end
