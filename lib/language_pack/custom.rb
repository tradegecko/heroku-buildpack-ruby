require "language_pack"
require "language_pack/rails41"

class LanguagePack::Custom < LanguagePack::Rails41
  def compile
    super
    instrument "rails4.import_xero" do
      allow_git do
        fetch_xero_certs_task
      end
    end
  end

private
  def fetch_xero_certs_task
    log("xero_certs") do
      topic 'Importing Xero Certs'
      task = rake.task("deploy:xero")
      task.invoke(env: aws_env)
      if task.success?
        log "deploy_xero", :status => "success"
        puts "Xero certs imported (#{"%.2f" % task.time}s)"
      else
        log "deploy_xero", :status => "failure"
        error "Importing Xero certs failed"
      end
    end
  end

  def aws_env
    {
      "AWS_ACCESS_KEY"        => env("AWS_ACCESS_KEY"),
      "AWS_SECRET_ACCESS_KEY" => env("AWS_SECRET_ACCESS_KEY")
    }
  end
end
