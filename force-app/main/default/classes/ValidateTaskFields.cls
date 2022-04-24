public with sharing class ValidateTaskFields {

    public Sobject record; 
    public String objectAPIName;
    public Declarative_task__mdt taskGen;

    public static void getTask(){

    
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