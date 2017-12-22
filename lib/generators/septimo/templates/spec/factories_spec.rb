# frozen_string_literal: true

require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe 'FactoryGirl' do
    describe "factory #{factory_name}" do
      it 'build_stubbed is valid' do
        begin
          factory = FactoryGirl.build_stubbed(factory_name)

          if factory.respond_to?(:valid?)
            expect(factory).to be_valid, -> { factory.errors.full_messages.join(',') }
            # the lamba syntax only works with rspec 2.14 or newer;  for earlier versions, you have to call #valid? before calling the matcher, otherwise the errors will be empty
          end
        rescue ActiveRecord::StatementInvalid
          puts "#{__FILE__} did not find table corresponding to #{factory_name}#{factory_name}. Maybe you should check your migrations?"
        end
        # rubocop:enable Lint/UselessAssignment
      end
      it 'build is valid' do
        begin
          factory = FactoryGirl.build(factory_name)

          if factory.respond_to?(:valid?)
            expect(factory).to be_valid, -> { factory.errors.full_messages.join(',') }
            # the lamba syntax only works with rspec 2.14 or newer;  for earlier versions, you have to call #valid? before calling the matcher, otherwise the errors will be empty
          end
        rescue ActiveRecord::StatementInvalid
          puts "#{__FILE__} did not find table corresponding to #{factory_name}#{factory_name}. Maybe you should check your migrations?"
        end
        # rubocop:enable Lint/UselessAssignment
      end
    end

    describe 'trait' do
      FactoryGirl.factories[factory_name].definition.defined_traits.map(&:name).each do |trait_name|
        it "#{trait_name} is valid" do
          factory = FactoryGirl.build(factory_name, trait_name)

          if factory.respond_to?(:valid?)
            expect(factory).to be_valid, -> { factory.errors.full_messages.join(',') } # see above
          end
        end
      end
    end
  end
end
