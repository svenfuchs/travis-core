module Travis
  module Mailer
    module Optout
      def self.opt_out(email)
        Travis.redis.sadd('email_opt_out', email.downcase)
      end

      def self.opted_out?(email)
        Travis.redis.sismember('email_opt_out', email.downcase)
      end
    end
  end
end
