require "culerity"
require "forwardable"

module Webrat #:nodoc:
  class CulerityResponse
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end

  class CuleritySession #:nodoc:
    extend Forwardable

    attr_reader :current_url

    def initialize(*args) # :nodoc:
    end

    def response
      CulerityResponse.new(response_body)
    end

    def visit(url = nil, http_method = :get, data = {})
      reset
      # TODO querify data
      @current_url = container.goto(absolute_url(url))
    end

    webrat_deprecate :visits, :visit

    def click_link_within(selector, text_or_title_or_id)
      within(selector) do
        click_link(text_or_title_or_id)
      end
    end

    webrat_deprecate :clicks_link_within, :click_link_within

    def reload
      reset
      container.refresh
    end

    webrat_deprecate :reloads, :reload

    def clear_cookies
      container.clear_cookies
    end

    def execute_script(source)
      container.execute_script(source)
    end

    def current_scope
      scopes.last || base_scope
    end

    def scopes
      @_scopes ||= []
    end

    def base_scope
      @_base_scope ||= CulerityScope.new(container)
    end

    def within(selector)
      xpath = Webrat::XML.css_to_xpath(selector).first
      scope = CulerityScope.new(container.element_by_xpath(xpath))
      scopes.push(scope)
      ret = yield
      scopes.pop
      return ret
    end

    def within_frame(name)
      scope = CulerityScope.new(container.frame(:name => name))
      scopes.push(scope)
      if block_given?
        ret = yield
        scopes.pop
        return ret
      end
      scope
    end

    def_delegators :current_scope, :check,         :checks
    def_delegators :current_scope, :choose,        :chooses
    def_delegators :current_scope, :click_button,  :clicks_button
    def_delegators :current_scope, :click_link,    :clicks_link
    def_delegators :current_scope, :fill_in,       :fills_in
    def_delegators :current_scope, :field_by_xpath
    def_delegators :current_scope, :field_labeled
    def_delegators :current_scope, :field_with_id
    def_delegators :current_scope, :response_body
    def_delegators :current_scope, :select,        :selects
    def_delegators :current_scope, :uncheck,       :unchecks

  protected

    def container
      setup unless $setup_done
      unless @_browser
        @_server = ::Culerity::run_server
        @_browser = ::Culerity::RemoteBrowserProxy.new @_server, {:browser => :firefox}
        at_exit do
          @_browser.exit
          @_server.close
        end
      end
      @_browser
    end

    def absolute_url(url) #:nodoc:
      if url =~ Regexp.new('^https?://')
        url
      elsif url =~ Regexp.new('^/')
        "#{current_host}#{url}"
      else
        "#{current_host}/#{url}"
      end
    end

    def current_host
      @_current_host ||= [Webrat.configuration.application_address, Webrat.configuration.application_port].join(":")
    end

    def setup #:nodoc:
      silence_stream(STDOUT) do
        Webrat.start_app_server
      end
      teardown_at_exit
      $setup_done = true
    end

    def teardown_at_exit #:nodoc:
      at_exit do
        silence_stream(STDOUT) do
          Webrat.stop_app_server
        end
      end
    end

  private

    def reset
      @_scopes     = nil
      @_base_scope = nil
    end

  end
end
