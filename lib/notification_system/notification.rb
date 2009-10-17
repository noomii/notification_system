module NotificationSystem
  class Notification < ActiveRecord::Base
    belongs_to :recipient, :class_name => 'User'
    belongs_to :event
    
    validates_presence_of :recipient_id, :date
    named_scope :pending, lambda { { :conditions => ['sent_at IS NULL AND date <= ?', Time.now] } }
        
    def deliver
      Notification.mailer_class.send("deliver_#{self.class.template_name}", self)
      self.update_attributes!(:sent_at => Time.now)
    end

    class << self
      attr_accessor :mailer
             
      def deliver_pending
        pending.each do |notification|
          if notification.recipient.wants_notification?(notification) 
            notification.deliver
          else
            notification.destroy
          end
        end
      end

      def mailer
        @mailer || :notification_mailer
      end
      
      def mailer_class
        mailer.to_s.classify.constantize
      end

      def template_name
        return self.to_s.underscore
      end      
    end
    
  end
end