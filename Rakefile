# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::TaskManager.class_eval do
  def delete_task(task_name)
    @tasks.delete(task_name.to_s)
  end
  Rake.application.delete_task("db:test:purge")
  Rake.application.delete_task("db:test:prepare")
end

namespace :db do
  namespace :test do
    task :purge do
    end
    task :prepare do
    end
  end
end
