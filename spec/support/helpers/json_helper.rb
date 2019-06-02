# frozen_string_literal: true

module Helpers
  module JsonHelper
    def body
      { body: JSON.parse(response.body) }.deep_symbolize_keys[:body]
    end
  end
end
