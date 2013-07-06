module Travis
  module Addons
    module GithubStatus

      # Adds a comment with a build notification to the pull-request the request
      # belongs to.
      class EventHandler < Event::Handler
        API_VERSION = 'v2'
        EVENTS = /build:(started|finished)/

        def handle?
          token(potential_admin).present? or token(validated_admin).present?
        end

        def handle
          Travis::Addons::GithubStatus::Task.run(:github_status, payload, token: token(potential_admin))
        rescue GH::Error
          Travis::Addons::GithubStatus::Task.run(:github_status, payload, token: token(validated_admin))
        end

        private

          def token(user)
            user.try(:github_oauth_token)
          rescue Travis::AdminMissing => error
            Travis.logger.error error.message
            nil
          end

          def potential_admin
            @potential_admin ||= find_admin(false)
          end


          def validated_admin
            @validated_admin ||= find_admin(true)
          end

          def find_admin(validate)
            Travis.run_service(:find_admin, repository: object.repository, validate: validate)
          end

          Instruments::EventHandler.attach_to(self)
      end
    end
  end
end

