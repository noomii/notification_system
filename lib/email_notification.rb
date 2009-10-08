class EmailNotification < Notification
  def send_to_recipient
    email_template_name = self.event.class.template_name
    method_name = "deliver_#{email_template_name}"
    CoolNotificationMailer.send(method_name, self) # TODO: spawn || schedule
  end
end