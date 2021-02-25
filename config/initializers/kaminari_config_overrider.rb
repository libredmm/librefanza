if Rails.env.development? or Rails.env.test?
  Warning.ignore(/PARAM_KEY_EXCEPT_LIST/)
end

module Kaminari
  module Helpers
    PARAM_KEY_EXCEPT_LIST = [:authenticity_token, :utf8, :_method, :script_name, :original_script_name].freeze
  end
end
