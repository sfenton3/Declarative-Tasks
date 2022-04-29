public with sharing class CreateTaskController {
    public void run() {   
        if(ValidateTaskFields.isActive()){
            try{
            ValidateTaskFields.generateTask();
            }catch(Exception e){
                Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR , e.getMessage()) );
            }
        }else {
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR , 'No Active Declarative Task Record for this Sobject Type.') );
            Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR , 'Configure an Declarative Task or Activate a Declarative Task.') );
        }
    }
}