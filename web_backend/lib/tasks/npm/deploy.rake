# Deploy react assets and components. Expects 'npm run build' to have been run.
# Run like: rake npm:deploy

require 'rake'

ext_frontend_path = '../ext_frontend'
int_frontend_path = '../int_frontend'

namespace :npm do
  desc 'Deploy react assets and components.'
  task :deploy do
    # Public assets (TODO: What if ext and int differ?)
    system("cp #{ext_frontend_path}/build/asset-manifest.json public")
    system("cp #{ext_frontend_path}/build/service-worker.js public")
    system("cp -R #{ext_frontend_path}/build/static public")
    system("cp -R #{int_frontend_path}/build/static public")
    # Components
    system("cp #{ext_frontend_path}/build/index.html app/views/login")
    system("cp #{int_frontend_path}/build/index.html app/views/home")
  end
end
