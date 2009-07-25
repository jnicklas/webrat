module Webrat
  class CulerityLocator
    def initialize(container, value, element_type, *how)
      @container    = container
      @value        = value
      @element_type = element_type
      @how          = how.blank? ? [:id, :name, :label] : how
    end

    def locate
      @how.each do |how|
        e = @container.send(@element_type, how => @value)
        return e if e.exists?
      end
      nil
    end

    def locate!
      locate || raise(NotFoundError.new("#{@element_type} matching \"#{@value}\" not found"))
    end
  end
end
