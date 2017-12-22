# frozen_string_literal: true

require_relative 'base'

module Septimo
  class JsonGenerator < Rails::Generators::Base
    include Base

    class_option :api, type: :boolean, default: false, desc: 'jsonapi support'
    class_option :cucumber, type: :boolean, default: true, desc: 'cucumber support'
    class_option :rspec, type: :boolean, default: true, desc: 'rspec support'
    class_option :schema, type: :boolean, default: false, desc: 'json schema support'
    class_option :geo, type: :boolean, default: false, desc: 'geojson schema support'

    def install
      install_gems
      install_rspec_support
      install_schemas
      install_cucumber_support
    end

    private

    # wrapper around frozen Thor::CoreExt::HashWithIndifferentAccess
    def schema_support?
      options[:api] || options[:geo] || options[:schema]
    end

    # this method smells of :reek:DuplicateMethodCall and :reek:RepeatedConditiona
    def install_gems
      gems_installer do
        if options[:api]
          gem 'active_model_serializers'
          if options[:rspec]
            gem_group :test do
              gem 'jsonapi-resources-matchers'
            end
          end
        end
        if options[:rspec]
          gem_group :test do
            gem 'json_spec'
            gem 'json_matchers' if schema_support? # include JSONAPI matchers
          end
        end
      end
    end

    def install_active_model_serializers
      initializer 'active_model_serializers',
                  <<~EOS
                    ActiveModelSerializers.config.adapter = :json_api
        EOS
      run_inside_destination_root('mkdir -p app/serializers')
      install_file('app/serializers/application_serializer.rb')
      install_file('app/controllers/concerns/active_models_serializers_concern.rb')
    end

    def install_schemas
      run_inside_destination_root('mkdir -p spec/support/api/schemas')
      download_file('http://jsonapi.org/schema', 'spec/support/api/schemas/jsonapi.json') if options[:api]
      # download_file('http://jsonapi.org/schema', 'spec/support/api/schemas/jsonapi.json') if options[:geo]
    end

    def install_cucumber_support
      return unless options[:cucumber]
      install_file('features/support/json_spec.rb')
    end

    def install_rspec_support
      return unless options[:rspec]
      install_file('spec/support/json_spec.rb')
      install_file('spec/support/json_matchers.rb') if schema_support?
    end
  end
end
