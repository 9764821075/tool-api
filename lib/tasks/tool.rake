namespace :tool do
  namespace :db do
    task setup: :environment do
      if ActiveRecord::Base.connection.tables.empty?
        Rake::Task["db:schema:load"].invoke
      end
      Rake::Task["db:migrate"].invoke
    end
  end
end
