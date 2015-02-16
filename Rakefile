def timestamp
  Time.new.strftime('%Y.%m.%d-%H.%M.%S')
end

def prepare(id)
  path = "target/kafka-aws-#{id}"
  run_command "mkdir -p #{path}" unless Dir.exist? path
  run_command "cp -r aws/ #{path}"
  path
end

#---------------------------------------------------------------------------

namespace :aws do
  desc 'setup the aws environment'
  task :setup do
    puts 'placeholder to set up the aws environment'
  end

  desc 'stand up the kafka cluster and run tests against it'
  task :run_benchmark => :setup do
    id   = timestamp
    path = prepare(id)

    puts "placeholder to run test-id #{id} in dir #{path}"
  end
end

def run_command(command)
  puts command
  system(command) || raise("unable to execute command - #{command}")
end