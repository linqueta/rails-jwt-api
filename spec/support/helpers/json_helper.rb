# frozen_string_literal: true

module JsonHelper
  def body
    JSON.parse(response.body, symbolize_names: true)
  end
end
