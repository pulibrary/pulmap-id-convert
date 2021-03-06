require 'rubygems'
require 'bundler'
require 'sequel'
require 'yaml'
require 'csv'

namespace :db do
  config = YAML.load_file("#{Dir.pwd}/config/database.yml")
  SEED_FILE = './db/items.csv'
  ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/#{config['database']}.db"

  task :connect do
    if ENV['DATABASE_URL']
      DB = Sequel.connect(ENV['DATABASE_URL'])
    else
      puts 'ABORTING: You must set the DATABASE_URL environment variable!'
      exit false
    end
  end

  desc 'Seed the database'
  task seed: [:connect] do
    dataset = DB[:items]
    CSV.foreach(SEED_FILE,
                headers: true,
                header_converters: :symbol,
                encoding: 'UTF-8') do |item|
      item = item.to_hash
      dataset.insert(ark: item[:noid],
                     guid: item[:guid],
                     image: item[:image_id])
      print '.'
    end
    puts '*** database seeded ***'
  end

  namespace :migrate do
    Sequel.extension :migration

    desc 'Perform migration reset (full erase and migration up).'
    task reset: [:connect] do
      Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrate", target: 0)
      Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrate")
      puts '*** db:migrate:reset executed ***'
    end

    desc 'Perform migration up/down to VERSION.'
    task to: [:connect] do
      version = ENV['VERSION'].to_i
      if version == 0
        puts 'VERSION > 0. Use rake db:migrate:down to erase all data.'
        exit false
      end

      Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrate", target: version)
      puts "*** db:migrate:to VERSION=[#{version}] executed ***"
    end

    desc 'Perform migration up to latest migration available.'
    task up: [:connect] do
      Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrate")
      puts '*** db:migrate:up executed ***'
    end

    desc 'Perform migration down (erase all data).'
    task down: [:connect] do
      Sequel::Migrator.run(DB, "#{Dir.pwd}/db/migrate", target: 0)
      puts '*** db:migrate:down executed ***'
    end
  end

  namespace :test do
    desc 'Prepare test database'
    task :prepare do
      ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/test.db"
      Rake::Task['db:migrate:down'].invoke
      Rake::Task['db:migrate:up'].invoke
      ENV['DATABASE_URL'] = "sqlite://#{Dir.pwd}/master.db"
    end
  end
end
