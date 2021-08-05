# README

- Ruby -v 2.5.0
- Rails -v 6.0.3
- Clone into desired working directory

-  $ bundle
-  $ rails g rename:into NEW_NAME #(to rename app)
-  $ rails db:create
-  $ rails db:migrate

- * CONFIGURE REDIRECT ON LOGIN
- app/controllers/application_controller.rb

- class ApplicationController < ActionController::Base
-  def after_sign_in_path_for(resource)
-    dashboard_path #Your path here
-  end
- end
