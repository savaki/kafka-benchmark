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

namespace :test do

  desc 'run the service in amazon'
  task :aws do
    id   = timestamp
    path = prepare(id)
  end
end

def run_command(command)
  puts command
  system(command) || raise("unable to execute command - #{command}")
end