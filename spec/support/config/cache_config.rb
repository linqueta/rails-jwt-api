# frozen_string_literal: true

module CacheConfig
  def self.configure(config)
    config.after(:each) do
      Rails.cache.clear
    end
  end
end
