class RequestCallbackJob < ActiveJob::Base
  queue_as :default
  def perform(name, mobile_number, reason_for_call)
    client = Postmark::ApiClient.new('cfbdef15-01ab-457a-b0af-78fa8faad043', http_open_timeout: 15)
    client.deliver_with_template(from: 'Lakeer <platform@lakeer.org>',
                   to: "dipika@lakeer.org",
                   template_id: 9331498,
                   template_model:{
                    name: name,
                    mobile_number: mobile_number,
                    reason_for_call: reason_for_call
                   })
  end
end
