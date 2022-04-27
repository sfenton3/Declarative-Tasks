public with sharing class ValidateTaskFields {

    public static void generateTask(){
        Sobject currentRecord = getCurrentRecord();
        Sobject dt = getDeclarativeTaskRecord();
        List<String> fieldList = getDeclarativeTaskFields();
        Task t = new Task();

        //do I ever query standard fields on cmt?
        //label needs to correspond to task api name 1:1
        for (String fieldname : fieldList) {
            if (isValidField(fieldname) && isCreatable(fieldname)){
                t.put(fieldname, dt.get(fieldname + '__c'));
            }
        }

        //Related info. 
       // User u = [select id from user where id = :]
        t.OwnerId = UserInfo.getUserId();
        t.WhatId = currentRecord.Id;
        insert t;
    }


    //Custom Metadata type record
    public static Sobject getDeclarativeTaskRecord(){
        ID recordId =(Id) ApexPages.currentPage().getParameters().get('id');
        String objectAPIName = recordId.getSObjectType().getDescribe().getName();

        String selectQuery = getFieldString();
        String fromQuery = 'FROM Declarative_task__mdt';
        String whereQuery = 'WHERE objectAPIName__c = :objectAPIName LIMIT 1';
        String query = selectQuery + ' ' + fromQuery + ' ' + whereQuery;
        return Database.query(query)[0];
    }

    //Record as according to button page
    public static Sobject getCurrentRecord(){
        ID recordId =(Id) ApexPages.currentPage().getParameters().get('id');
        String objectAPIName = recordId.getSObjectType().getDescribe().getName();
        String query = 'SELECT id from ' + objectAPIName + ' where id = \''  + recordId +    '\' limit 1 ';
        return Database.query(query)[0];
    }

    //Helper method for querying cmt. 
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

    //helper method for returning all fields on cmt
    public static List<String> getDeclarativeTaskFields(){
        declarative_task__mdt dtm = new declarative_task__mdt();
        Sobjecttype dtmtype = dtm.getSObjectType();
        Map<String,Schema.SObjectField> mfields = dtmtype.getDescribe().fields.getMap();
        List<String> dtfields = new List<String>();

        for(SObjectField token : mfields.values()){
            dtfields.add(token.getDescribe().getLabel());
        }
        return dtfields;
    }
    
    //Utility method for verifying if field excists on object
    public static boolean isValidField(String fieldname){
        Task t = new Task();
        Map<String, Schema.SObjectField> dfsMap = t.getSObjectType().getDescribe().fields.getMap();

        //null pointer exception check
        if (dfsMap.get(fieldname) == null){
            return false;
        }

        return true;
    }

    //Utility method to verify if field is creatable on object
    public static boolean isCreatable(String fieldname){
        Task t = new Task();
        Map<String, Schema.SObjectField> dfsMap = t.getSObjectType().getDescribe().fields.getMap();

        //null pointer exception check
        if (dfsMap.get(fieldname) == null){
            return false;
        }

        Schema.DescribeFieldResult dfr = dfsMap.get(fieldname).getDescribe();
        return dfr.isCreateable();
    }

}