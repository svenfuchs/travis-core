class UrlsRemoveCode < ActiveRecord::Migration
  def self.up
    change_table :urls do |t|
      t.remove :code
    end
  end

  def self.down
    change_table :urls do |t|
      t.string :code
    end
  end
end

