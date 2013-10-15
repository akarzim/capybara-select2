require 'capybara-select2/version'
require 'rspec/core'

module Capybara
  module Select2
    def select2(value, from: nil, xpath: nil, search: false)
      fail "Must pass a hash containing 'from' or 'xpath'" unless from.present? || xpath.present?

      select2_container = first(:xpath, xpath) if xpath.present?
      select2_container ||= first('label', text: from).find(:xpath, '..').find '.select2-container'

      select2_container.find('.select2-choice').click

      if search
        select2_input = 'input.select2-input'
        find(:xpath, '//body').find(select2_input).set value
        page.execute_script(%|$("#{select2_input}:visible").keyup();|)
      end

      drop_container = search ? '.select2-results' : '.select2-drop'
      find(:xpath, '//body').find("#{drop_container} li", text: value).click

      fail unless page.has_no_css? '#select2-drop-mask'
    end

    def select2_ajax(value, from: nil, xpath: nil, search: false, parent: '')
      fail "Must pass a hash containing 'from' or 'xpath'" unless from.present? || xpath.present?

      select2_container = first(:xpath, xpath) if xpath.present?
      select2_container ||= first('label', text: from).find(:xpath, '..').find '.select2-container'

      select2_container.find('.select2-choice').click

      if search
        select2_input = "#{parent} input.select2-input".strip
        find(:xpath, '//body').find(select2_input).set value
        page.execute_script(%|$("#{select2_input}:visible").keyup();|)
      end

      drop_container = search ? '.select2-results' : '.select2-drop'
      find(:xpath, '//body').find("#{drop_container} li", text: value).click

      fail unless page.has_no_css? '#select2-drop-mask'
    end

    def select2_multiple(values, from: nil, xpath: nil)
      fail "Must pass a hash containing 'from' or 'xpath'" unless from.present? || xpath.present?

      select2_container = first(:xpath, xpath) if xpath.present?
      select2_container ||= first('label', text: from).find(:xpath, '..').find '.select2-container'

      [values].flatten.each do |value|
        select2_container.find(:xpath, "a[contains(concat(' ',normalize-space(@class),' '),' select2-choice ')] | ul[contains(concat(' ',normalize-space(@class),' '),' select2-choices ')]").click
        find(:xpath, '//body').find('.select2-drop li', text: value).click
      end

      fail unless page.has_no_css? '#select2-drop-mask'
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::Select2
end
