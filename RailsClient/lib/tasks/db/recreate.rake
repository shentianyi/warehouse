namespace :db do
  desc 'recreate database'
  task :recreate => :environment do
    %w(db:drop db:create db:migrate).each do |task|
      puts "executing #{task}..."
      Rake::Task[task].invoke
    end
  end
end