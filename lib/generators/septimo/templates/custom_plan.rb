require 'zeus/rails'

# our custom plan
class CustomPlan < Zeus::Rails
  def test
    <% if options['simple-cov'] -%>load_simple_cov<% end %>
    <% if options['factory-girl'] -%>load_factory_girl<% end %>
    <% if options['rspec'] -%>Dir['./spec/support/**/*.rb'].each { |file| require file }<% end %>
    <% if options['guard'] -%>
    ENV['GUARD_RSPEC_RESULTS_FILE'] = 'tmp/guard_rspec_results.txt' # can be anything matching Guard::RSpec :results_file option in the Guardfile
    <% end %>
    super
  end

<% if options[:sidekiq] -%>
     # this method smells of :reek:TooManyStatements
  def sidekiq
    # Based on bin/sidekiq
    require 'sidekiq/cli'

    begin
      cli = Sidekiq::CLI.instance
      cli.parse
      cli.run
    rescue => exception
      display_exception(exception)
    end
  rescue LoadError
    # we don't have sidekiq
  end

  def display_exception(exception)
    raise exception if $DEBUG
    STDERR.puts exception.message
    STDERR.puts exception.backtrace.join("\n")
    exit 1
  end

<% end -%>
<% if options[:cucumber] -%>
  def cucumber_environment
    ::Rails.env = ENV['RAILS_ENV'] = 'test'
    require 'cucumber/rspec/disable_option_parser'
    require 'cucumber/cli/main'
    @cucumber_runtime = Cucumber::Runtime.new
  end

  # this method smells of :reek:TooManyStatements
  def cucumber(argv=ARGV)
    <% if options['simple-cov'] -%>load_simple_cov<% end %>
    <% if options['factory-girl'] -%>load_factory_girl<% end %>
    cucumber_main = Cucumber::Cli::Main.new(argv.dup)
    had_failures = cucumber_main.execute!(@cucumber_runtime)
    exit_code = had_failures ? 1 : 0
    exit exit_code
  end
<% end -%>

  protected

<% if options['simple-cov'] -%>
  def load_simple_cov
    require 'simplecov'
    SimpleCov.start 'rails'
    # TODO: add lib properly
    Dir[Rails.root + "/app/**/*.rb"].each { |file| load file }
  rescue LoadError
    # we don't have simple_cov
  end

<% end -%>
<% if options['factory-girl'] -%>
  def load_factory_girl
    require 'factory_girl'
    FactoryGirl.reload
  rescue LoadError
    # we don't have factory_girl
  end
<% end -%>
end

Zeus.plan = CustomPlan.new

