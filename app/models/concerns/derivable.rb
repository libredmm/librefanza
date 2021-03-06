module Derivable
  extend ActiveSupport::Concern

  included do
    before_validation :derive_fields, on: :create
    after_touch :derive_fields!
  end

  def derive_fields!
    derive_fields
    if changed?
      save || destroy
    end
  end
end
