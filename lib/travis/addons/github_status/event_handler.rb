module Travis
  module Addons
    module GithubStatus

      # Adds a comment with a build notification to the pull-request the request
      # belongs to.
      class EventHandler < Event::Handler
        API_VERSION = 'v2'
        EVENTS = /build:(started|finished)/

        def handle?
          token.present?
        end

        def handle
          Travis::Addons::GithubStatus::Task.run(:github_status, payload, token: token)
        end

        private

          def token
            build_committer_token || admin_token || push_access_token
          end

          def build_committer_token
            build_committer.try(:github_oauth_token)
          end

          def admin_token
            admin.try(:github_oauth_token)
          rescue Travis::AdminMissing => error
            Travis.logger.error error.message
            nil
          end

          def push_access_token
            push_access_user.try(:github_oauth_token)
          end

          def build_committer
            user = User.with_email(object.commit.committer_email)
            user if user && user.permission?(repository_id: object.repository.id, push: true)
          end

          def admin
            @admin ||= Travis.run_service(:find_admin, repository: object.repository)
          end

          def push_access_user
            User.with_github_token.with_permissions(repository_id: object.repository.id, push: true).first
          end

          Instruments::EventHandler.attach_to(self)
      end
    end
  end
end

