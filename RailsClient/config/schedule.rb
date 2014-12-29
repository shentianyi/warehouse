# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :environment, 'development'
set :output, {:error => 'log/cron_error_log.log', :standard => 'log/cron_log.log'}
# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 2.minute do
  rake 'sync:execute'
end

every 10.second do
  sender = User.where({role_id:Role.sender}).first

  package_id = "WI#{Time.now.to_milli}"

  package = PackageService.create({id:package_id,part_id:Part.first,check_in_time:"12 15 13"},sender).object

  forklift = ForkliftService.create({destinationable_id:Whouse.first.id},sender).object

  forklift.add(package)

  delivery = DeliveryService.create({},sender).object

  delivery.add(forklift)
end
