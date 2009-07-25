module Webrat
  class CulerityScope
    attr_reader :container

    def initialize(container)
      @container = container
    end

    def check(id_or_name_or_label, value = true)
      elem = element_locator(id_or_name_or_label, :check_box)
      elem.set(value)
    end

    webrat_deprecate :checks, :check

    def choose(id_or_name_or_label)
      elem = element_locator(id_or_name_or_label, :radio)
      elem.set
    end

    webrat_deprecate :chooses, :choose

    def click_button(value_or_id_or_alt = nil, options = {})
      options = value_or_id_or_alt if value_or_id_or_alt.is_a?(Hash)

      with_handler options.delete(:confirm) do
        if value_or_id_or_alt
          elem = element_locator(value_or_id_or_alt, :button, :value, :id, :text, :alt)
        else
          elem = container.buttons[0] # celerity should really include Enumerable here
        end
        elem.click
      end
    end

    webrat_deprecate :clicks_button, :click_button

    def click_link(text_or_title_or_id, options = {})
      with_handler options.delete(:confirm) do
        elem = element_locator(text_or_title_or_id, :link, :text, :title, :id)
        elem.click
      end
    end

    webrat_deprecate :clicks_link, :click_link

    def field_by_xpath(xpath)
      element_locator(xpath, :generic_field, :xpath)
    end

    def field_labeled(label)
      element_locator(label, :generic_field, :label)
    end

    def field_with_id(id)
      element_locator(id, :generic_field, :id)
    end

    def fill_in(id_or_name_or_label, options = {})
      elem = element_locator(id_or_name_or_label, :text_field)
      elem.set(options[:with])
    end

    webrat_deprecate :fills_in, :fill_in

    def response_body
      container.html
    end

    def select(option_text, options = {})
      elem = element_locator(options[:from], :select_list)
      elem.select(option_text)
    end

    webrat_deprecate :selects, :select

    def uncheck(id_or_name_or_label)
      check(id_or_name_or_label, false)
    end

    webrat_deprecate :unchecks, :uncheck

  protected

    # Returns a +Culerity::Element+
    def element_locator(locator, element, *how)
      CulerityLocator.new(container, locator, element, *how).locate!
    end

    def with_handler(proc, &block)
      old_handler = container.browser.webclient.confirm_handler
      container.browser.webclient.confirm_handler = proc
      block.call
      container.browser.webclient.confirm_handler = old_handler
    end
  end
end
