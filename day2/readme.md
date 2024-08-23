- In day2 for modules we are specifying the modules/ec2 in which we have defined the modules , which we have imported modules_ec2_example 

- The modules_ec2_example main.tf we have launched the instances by importing 
- The day2 root directory we have main.tf that is not using the modules and using variables, tfvars to directly launch the instance 
- By using the modules we are simplying the process , the modules can be defined anywhere and only needs to be imported so we don't need to rewrite whole files again 

-- We can make these modules for s3, eks etc etc and just import them where we are initialising our resources >_<
