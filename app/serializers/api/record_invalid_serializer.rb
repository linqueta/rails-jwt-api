# frozen_string_literal: true

module Api
  class RecordInvalidSerializer < ActiveModel::Serializer
    attributes :errors

    def errors
      object.record.errors.full_messages
    end
  end
end
