require "rails"

module MightbuyModels
  class Engine < Rails::Engine
    initializer "mightbuy_models.load_app_instance_data" do |app|
      app.class.configure do
        #Pull in all the migrations from Commons to the application
        config.paths['db/migrate'] += MightbuyModels::Engine.paths['db/migrate'].existent
      end
    end
  end
end
