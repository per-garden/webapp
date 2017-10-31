# Deploy react assets and components. Expects 'npm run build' to have been run.
# Run like: rake npm:deploy

require 'rake'

web_frontend_path = '../web_frontend'

namespace :npm do
  desc 'Deploy react assets and components.'
  task :deploy do
    # Public assets (TODO: What if ext and int differ?)
    system("cp #{web_frontend_path}/build/asset-manifest.json public")
    system("cp #{web_frontend_path}/build/service-worker.js public")
    system("cp -R #{web_frontend_path}/build/static public")
    # Components
    system("cp #{web_frontend_path}/build/index.html app/views/home")
  end
end
