# frozen_string_literal: true

module FactoryBotConfig
  def self.configure(config)
    config.include FactoryBot::Syntax::Methods
  end
end
