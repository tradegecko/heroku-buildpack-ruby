require "language_pack"
require "language_pack/rails3"

class LanguagePack::Custom < LanguagePack::Rails3
  def compile
    super
    allow_git do
      fetch_xero_certs_task
    end
  end

private
  def fetch_xero_certs_task
    log("xero_certs") do
      topic('Importing Xero Certs')
      puts "Running: rake deploy:xero"

      require 'benchmark'
      time = Benchmark.realtime { pipe("env PATH=$PATH:bin bundle exec rake deploy:xero 2>&1") }
      if $?.success?
        log "deploy_xero", :status => "success"
        puts "Importing certificates completed (#{"%.2f" % time}s)"
      else
        log "deploy_xero", :status => "failure"
        error "Importing Certs failed"
      end
    end
  end
end