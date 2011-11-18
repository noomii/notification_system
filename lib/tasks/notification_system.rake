namespace :notification_system do
  namespace :notifications do
    # UNTESTED
    desc "Creates and delivers pending notifications"
    task :deliver => :environment do
      if RAILS_ENV == 'production'
        begin
          NotificationSystem::NotificationTypeSubscription.create_scheduled_notifications
          NotificationSystem::Notification.deliver_pending
        rescue Exception => exception
          NotificationSystem.report_exception(exception)
        end
      end
    end  
  end
end
