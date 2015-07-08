module Uuidable
  extend ActiveSupport::Concern

  included do
#    class_attribute :uuid
    before_create :before_create_generate_uuid
  end

  def before_create_generate_uuid
    self.uuid = SecureRandom.uuid
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods

  end

end
