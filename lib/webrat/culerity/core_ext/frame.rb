# class Celerity::Frame
#   # Fixes an exception that is raised when setting a field in a frame.
#   # Fixed in kamal-celerity. Will remove when applied upstream.
#   def locate
#     super
#     if @object
#       @inline_frame_object = @object.getEnclosedWindow.getFrameElement
#       self.page            = @object.getEnclosedPage
#       if (frame = self.page.getDocumentElement)
#         @object = frame
#       end
#     end
#   end
# end
