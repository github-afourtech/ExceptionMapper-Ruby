##  
# Copyright 2014 AFour Technologies
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. 


load 'ExceptionInfo.rb'
require 'rexml/document'
include REXML


 ## class Mapper to read and show exception information
 #
 # @author AFour Technologies
 # @version 0.0.0.1
 # @package AFourTech.ExceptionMapper
 
class Mapper
  
  # Declaring the Global variable
  $exceptionType=nil
  $alternateText=nil  
  $defaultExceptionType=nil  
  $tempPath=nil
  $parentTag=nil
  $exceptionTypeGivenWhen=nil
  
  # Default Status code.
  $statusCodeDictionaryFinder=100
    
  # Set xml file path  
  $set_filepath=nil
  
  
  # This Hash table is used for one time caching of XML file.
   $exceptionTypeHashtable=Hash.new{}
  
  
  
   #  initializeErrorCodeDict() is a method in Mapper class that initialize statusCodeDictionary
  def self.initializeErrorCodeDict   
     $statusCodeDictionary=Hash.new{}
     $statusCodeDictionary.store(100,"Success")
     $statusCodeDictionary.store(101,"An Error has occurred in our library please contact AFourTech for further Information on debugging this error.")
     $statusCodeDictionary.store(103,"Syntax Error in file. Please follow Proper Syntax")
     $statusCodeDictionary.store(102,"File not found")
  end
  
  
  
   
  
  ##   Method to cache XML file to Hash table
  #  
  def self.cacheXMLDocument
        initializeErrorCodeDict; 
       
       if($set_filepath==nil)  
           # Set the current working directory for ExceptionMapping.xml
          $tempPath=Dir.pwd+"/"+"ExceptionMapping.xml"   
       else
          $tempPath=$set_filepath             
       end
       
       if(!File.exist?($tempPath))        
          $statusCodeDictionaryFinder=102
       else
        
             #Load XML file
             begin 
                    
                xmlfile = File.new($tempPath)
                xmldoc = Document.new(xmlfile)  
                
              for i in 1..xmldoc.root.elements.count     
                 
                 # Exception Type Loop  
                   xmldoc.elements.each(xmldoc.root.name+"//"+xmldoc.root.elements[i].name){        
                     |element| #puts element.attributes["text"];                 
                      $exceptionType=element.attributes["text"]
                     # Get the parent tag FunctionalException,OtherException  
                    $parentTag=element.root.elements[i].name   
                  

                  # This Hash table is used to store messages from XML file.
                  $messageHashtable=Hash.new{}
                 
               # This will output all the Messages.
               xmldoc.elements.each(xmldoc.root.name+"//"+xmldoc.root.elements[i].name+"//"+"message") {
                 |e| #puts "Message  : " + e.text  
                 
                       
                    # This will Get all the alternate Text
                           xmldoc.elements.each("*/"+xmldoc.root.elements[i].name+"//"+"message") {|element|
                             if(e.text==element.text)
                                
                              if(element.attributes["alternateText"]!="")                     
                                  $alternateText=element.attributes["alternateText"]
                                
                               end                         
                             end
                            
                    } # Alternate Text
                   
                    $messageHashtable.store(e.text,$alternateText)
                          
               } # message  
              $exceptionTypeHashtable.store($exceptionType,$messageHashtable)
              
              
              # For Other Exception Type
              if $parentTag.eql?("OtherException")               
                  $defaultExceptionType=$exceptionType
              end
              
                 
             } 
                     
            end     
            
              
             rescue Exception => e
                $statusCodeDictionaryFinder=103
            
           end  
     
           
     end 
      
  end 
  
  
   
   ## GetExceptionInfo() is a method in Mapper class that shows how to call the method GetExceptionInfo()
   #   
   # objExceptionInfo=Mapper.GetExceptionInfo(e,"given")
   # objExceptionInfo=Mapper.GetExceptionInfo(e,"when")
   # objExceptionInfo=Mapper.GetExceptionInfo(e,"then")
   # @param Exception ex , This is an exception
   # @param string stepString  StepString can be 'given','when','then'
   # @return ExceptionInfo class object i.e objExceptionInfo
   
   def self.GetExceptionInfo(ex,stepString=nil)
     
     flag=0
    
      if $exceptionTypeHashtable.empty?
         Mapper.cacheXMLDocument;
      end
      
      objExceptionInfo=ExceptionInfo.new
      
       $stepTypeConditionChecker=0
       $exceptionType=$defaultExceptionType
      
        # StepString checking
        if stepString!=nil
                 if((stepString).downcase.eql?("given") || (stepString).downcase.eql?("when"))
                    $exceptionType ="Environmental" 
                    $exceptionTypeGivenWhen= $exceptionType
                    $stepTypeConditionChecker=1
                 end
          end       
             
    
      # To Check Hash table has value or not
      if $exceptionTypeHashtable.keys.count>0
           $alternateText=""
             
             begin
              flag=false
             
              $exceptionTypeHashtable.each {|key, value| #puts "#{key}" 
              
              if(flag==false)              
              #  Key can be Functional,Environmental,Other      
              $Type=key
              # Create New MessageHashTable
              $messageHashtable=Hash.new{key}            
              $messageHashtable=$exceptionTypeHashtable[key]
               
               
               #  key=Message and value =Alternate Text
               $messageHashtable.each {|key, value| #puts "#{key} is =#{value}" 
                   if ((ex.message==key) || (ex.message==key && $exceptionType=="Environmental"))
                          $exceptionType=$Type
                          if($exceptionType.eql?("Functional") && $stepTypeConditionChecker.eql?(1))                             
                              $exceptionType=$exceptionTypeGivenWhen
                              $alternateText="" 
                            else
                             $alternateText=value
                          end
                           
                          flag=true
                        break                           
                              
                    end  
                   
                      
               } 
              
             end 
             
            } 
           
            rescue Exception => e
            $statusCodeDictionaryFinder=101
          
         end 
       
          # If message is not matched then set Type="Other" & alternateText=nil
          if($exceptionType==$defaultExceptionType)
                $alternateText=""
          end
     
      end 
      
          
          
     
     
      objExceptionInfo.exception_type=$exceptionType
      objExceptionInfo.class_name=ex.class.name
      objExceptionInfo.message=ex.message
      objExceptionInfo.alternate_text=$alternateText
      objExceptionInfo.stack_trace=ex.backtrace 
      objExceptionInfo.status_code=$statusCodeDictionary[$statusCodeDictionaryFinder]
      
      
      
       # Create the StackLog Folder in which we have to write the log files
      time=Time.new
      folderName="StackLog"
      parentDirName= File.expand_path('../.')
      subDirName=parentDirName+"/"+folderName
      unless(Dir.exists?(subDirName))
        # create the new directory if it not exist
        Dir.mkdir(subDirName)        
      end
      # Create the log file and store it in StackLog Folder
      logFile=subDirName+"/StackTrace_"+time.strftime("%Y-%m-%d-%H-%M-%S-%L")+".log";
           
        p = File.new(logFile, "w+")
        if p          
          p.puts ex.message
          p.puts ex.backtrace        
          p.close      
        end
        
      return objExceptionInfo
      
   end
    
  
  
 end 



