# Undeploy (delete) react assets and components.
# Run like: rake npm:undeploy

require 'rake'

namespace :npm do
  desc 'Undeploy (delete) react assets and components.'
  task :undeploy do
    # Public assets
    system("rm public/asset-manifest.json")
    system("rm public/service-worker.js")
    system("rm -R public/static")
    # Components
    system("rm public/index.html")
  end
end
