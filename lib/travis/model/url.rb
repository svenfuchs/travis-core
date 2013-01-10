require 'digest/sha1'
require 'active_record'

class Url < Travis::Model
  DIGITS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

  validates :url,  :presence => true, :uniqueness => true

  def self.shorten(url)
    find_or_create_by_url(url)
  end

  def self.find_by_code(code)
    id = 0

    code.reverse.split(//).each.with_index do |char, index|
      id += DIGITS.length ** index * DIGITS.index(char)
    end

    self.find_by_id(id)
  end

  def short_url
    [Travis.config.http_shorten_host, code].join('/')
  end

  def code
    return "0" if self.id == 0

    id = self.id

    code = ""
    while id > 0
      code = "#{DIGITS[id % DIGITS.length]}#{code}"
      id /= DIGITS.length
    end

    code
  end
end
