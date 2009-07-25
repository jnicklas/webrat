require "webrat/culerity/session"
require "webrat/culerity/scope"
require "webrat/culerity/locator"
require "webrat/culerity/core_ext/button"
require "webrat/culerity/core_ext/container"
require "webrat/culerity/core_ext/frame"
require "webrat/culerity/core_ext/generic_field"
require "webrat/culerity/core_ext/socket"

module Webrat

  def self.start_app_server #:nodoc:
    pid_file = prepare_pid_file("#{RAILS_ROOT}/tmp/pids", "mongrel_culerity.pid")
    system("mongrel_rails start -d --chdir=#{RAILS_ROOT} --port=#{Webrat.configuration.application_port} --environment=#{Webrat.configuration.application_environment} --pid #{pid_file} &")
    TCPSocket.wait_for_service :host => Webrat.configuration.application_address, :port => Webrat.configuration.application_port.to_i
  end

  def self.stop_app_server #:nodoc:
    pid_file = File.expand_path(RAILS_ROOT + "/tmp/pids/mongrel_culerity.pid")
    system "mongrel_rails stop -c #{RAILS_ROOT} --pid #{pid_file}"
  end

  def self.prepare_pid_file(file_path, pid_file_name)
    FileUtils.mkdir_p File.expand_path(file_path)
    File.expand_path("#{file_path}/#{pid_file_name}")
  end

  # To use Webrat's Celerity support, activate it with (for example, in your <tt>env.rb</tt>):
  #
  #   require "webrat"
  #   require "webrat/culerity"
  #
  #   Webrat.configure do |config|
  #     config.mode = :culerity
  #   end
  #
  # == Auto-starting of the mongrel server
  #
  # Webrat will automatically start an instance of Mongrel when a test is run. The Mongrel will
  # run in the "test" environment and will run on port 3001.
  module Culerity
    module Methods
      def response
        webrat_session.response
      end

      def execute_script(source)
        webrat_session.execute_script(source)
      end

      def clear_cookies
        webrat_session.clear_cookies
      end

      def within_frame(name, &block)
        webrat_session.within_frame(name, &block)
      end
    end
  end
end

module ActionController #:nodoc:
  IntegrationTest.class_eval do
    include Webrat::Methods
    include Webrat::Matchers
    include Webrat::HaveTagMatcher
    include Webrat::Culerity::Methods
  end
end
