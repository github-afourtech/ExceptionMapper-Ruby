load "ExceptionMapper.rb"


 ## Programme class
 #
 # @author AFour Technologies
 # @version 0.0.0.1
 # @package AFourTech.ExceptionMapper
 #
 # This is class show general information of exception

class Programme
      
   objMapping = Mapper.new
   objExceptionInfo=ExceptionInfo.new
   # Pass the user defined path of XML file
   #$set_filepath="D:\\Sudhir\\Working Directory\\Eclips Project\\XML\\ExceptionMapping.xml"
      
   
   # Here it throws an ZeroDivisionError            
   a=1/0
  
  # wrong number of arguments (2 for 1)
  # ArgumentError
  #[1, 2, 3].first(4, 5)
  
  
  # [1, 2, 3].first("two")
  #  no implicit conversion of String into Integer
  #  TypeError
  
  
  # undefined method `to_ary' for "hello":String
  # NoMethodError  
  #"hello".to_ary
  
  
   rescue Exception => e    
     
   # Here we pass the Parameter any one from these as "Given" or "when"  or "then" 
   objExceptionInfo=Mapper.GetExceptionInfo(e)

   if objExceptionInfo.exception_type!= nil
     puts "Exception Type ="+objExceptionInfo.exception_type
   end
   
   puts "Message  ="+objExceptionInfo.message
   if objExceptionInfo.alternate_text != nil
     puts "Alternate Text ="+objExceptionInfo.alternate_text
   end
   
   
   puts "Class Name ="+objExceptionInfo.class_name 
   puts "Status Code ="+objExceptionInfo.status_code
   
   puts "Stack Trace :" 
   limit = objExceptionInfo.stack_trace.count
     for i in 0..limit
      puts objExceptionInfo.stack_trace[i]
    end



end
  
   
  