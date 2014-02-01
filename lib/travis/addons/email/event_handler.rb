module Travis
  module Addons
    module Email

      # Sends out build notification emails using ActionMailer.
      class EventHandler < Event::Handler
        API_VERSION = 'v2'

        EVENTS = 'build:finished'

        def handle?
          !pull_request? && config.enabled?(:email) && config.send_on_finished_for?(:email) && recipients.present?
        end

        def handle
          Travis::Addons::Email::Task.run(:email, payload, recipients: recipients, broadcasts: broadcasts)
        end

        def recipients
          @recipients ||= begin
            recipients = config.notification_values(:email, :recipients)
            recipients = config.notifications[:recipients] if recipients.blank? # TODO deprecate recipients
            recipients = default_recipients                if recipients.blank?

            remove_opted_out(normalize_recipients(recipients))
          end
        end

        private

          def pull_request?
            build['pull_request']
          end

          def broadcasts
            Broadcast.by_repo(object.repository).map do |broadcast|
              { message: broadcast.message }
            end
          end

          def default_recipients
            recipients = object.repository.users.map {|u| u.emails.map(&:email)}.flatten
            recipients.keep_if do |r|
              r == object.commit.author_email or
              r == object.commit.committer_email
            end
          end

          def normalize_recipients(recipients)
            Array(recipients).join(',').split(',').map(&:strip).select(&:present?).uniq
          end

          def remove_opted_out(recipients)
            recipients.reject { |address| Travis::Mailer::Optout.opted_out?(address) }
          end

          Instruments::EventHandler.attach_to(self)
      end
    end
  end
end
