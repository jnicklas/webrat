# module Celerity
#   class GenericField < Element
#     include Container
#     RADIO_CHECK = CheckBox::TAGS | Radio::TAGS
#     TAGS = TextField::TAGS | Hidden::TAGS | RADIO_CHECK
#     DEFAULT_HOW = :name
# 
#     def set?
#       assert_exists
#       assert_radio_check
#       @object.isChecked
#     end
#     alias_method :checked?, :set?
# 
#   protected
#     def assert_radio_check
#       locator = ElementLocator.new(@container, self.class)
#       raise "Not a radio or checkbox" unless RADIO_CHECK.any? { |ident| locator.send(:element_matches_ident?, @object, ident) }
#     end
#   end
# end
