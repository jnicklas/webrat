# Webrat matches button with alt as well, but Celerity doesn't list alt as a valid attribute
# for a button.
# class ::Celerity::Button
#   remove_const :ATTRIBUTES if defined?(ATTRIBUTES) # shushes the warning
#   ATTRIBUTES = BASE_ATTRIBUTES | [:type, :disabled, :tabindex, :accesskey, :onfocus, :onblur] | [:src, :usemap, :ismap] | [:alt]
# end
