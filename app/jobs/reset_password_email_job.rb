class ResetPasswordEmailJob < ActiveJob::Base
  queue_as :default
  def perform(user, url)
    action_url = "#{url}?reset_password_token=#{user.reset_password_token}"
    client = Postmark::ApiClient.new('a421fc84-3fda-412c-806e-1802b1e1df5d', http_open_timeout: 15)
    client.deliver_with_template(from: 'mkv@commutatus.com',
                   to: "#{user.full_name} <#{user.email}>",
                   template_id: 8626280,
                   template_model:{
                    name: user.full_name,
                    email: user.email,
                    action_url: action_url,
                   })
  end
end