# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "admin@libredmm.com"
  layout "mailer"
end
