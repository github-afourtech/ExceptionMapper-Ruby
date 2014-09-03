 ## ExceptionInfo class is used to set values 
 #  className, Message,stackTrace,exceptionType,alternateText,statusCode  
 #
 # @author AFour Technologies
 # @version 0.0.0.1
 # @package AFourTech.ExceptionMapper
 #
# This is class show general information of exception

class ExceptionInfo
  # setter Properties
   # Set the values  for class_name
  def class_name=(value)
    @class_name=value      
   end
  
   # Set the values for message
  def message=(value)
    @message=value  
  end
    
    # Set the values  for  alternate_text
  def alternate_text=(value)
    @alternate_text=value
  end
 
  # Set the values  for  exception_type
  def exception_type=(value)
    @exception_type=value
  end
  
   # Set the values  for stack_trace
  def stack_trace=(value)
    @stack_trace=value
  end
  
  
  # Set the values  for stack_trace
  def status_code=(value)
    @status_code=value
  end 
  
  # Getter Properties
   # Get the values for class_name
   def class_name
     @class_name
   end
   
    # Get the values for message
   def message
     @message
   end
   
    # Get the values for alternate_text
   def alternate_text
     @alternate_text
   end
   
    # Get the values for exception_type
   def exception_type
     @exception_type
   end
   
    # Get the values for stack_trace
   def stack_trace
     @stack_trace
   end
   
   # Get the values for stack_trace
   def status_code
     @status_code
   end
   
   
end