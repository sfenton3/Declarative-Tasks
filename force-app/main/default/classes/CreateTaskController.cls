public with sharing class CreateTaskController {
    
    Sobject record; 
    String objectAPIName;
    Declarative_task__mdt taskGen;
    
    //Do stuff...
    public void run() {      
        queryRecord();
        createTask();      
    }
    
    private void createTask(){
        Task t = new Task();
        
        t.Status = taskGen.Status__c;
        t.Subject = taskGen.subject__c;
        t.Priority = taskGen.Priority__c;
        
        t.OwnerId = UserInfo.getUserId();
        t.whatid = record.id;

        insert t;            
    }
    
    //query for record...
    private void queryRecord(){
        ID s =(Id) ApexPages.currentPage().getParameters().get('id');
        objectAPIName = s.getSObjectType().getDescribe().getName();
        String query = 'SELECT id from ' + objectAPIName + ' where id = \''  + s +    '\' limit 1 ';
        String taskQuery = getFieldString();
        
        try{
        record = Database.query(query)[0];
        taskGen = [SELECT Fields(STANDARD),
                    Status__c , 
                    subject__c , 
                    Priority__c , 
                    assign_to__c 
                    FROM Declarative_task__mdt where objectAPIName__c = :objectAPIName limit 1][0];

        }catch (exception e){
            //System.debug(e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));    
        }
    }

    //Helper method to dynamically get all fields on Custom Metadata Type
    public static String getFieldString(){
        declarative_task__mdt dtm = new declarative_task__mdt();
        Sobjecttype dtmtype = dtm.getSObjectType();
        Map<String,Schema.SObjectField> mfields = dtmtype.getDescribe().fields.getMap();   
        
        String dynamicQuery = 'SELECT ';
        for (String s : mfields.keySet()){
            dynamicQuery +=  s + ',';
        }
        dynamicQuery = dynamicQuery.removeEndIgnoreCase(',');

        return dynamicQuery;
    }


    
}