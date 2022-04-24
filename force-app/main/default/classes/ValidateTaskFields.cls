public with sharing class ValidateTaskFields {

    public static void generateTask(){
        Sobject currentRecord = getCurrentRecord();
        Sobject taskBlueprint = getTask();
        Set<String> fieldList = getFieldList();
        fieldList = validate(fieldList);
        Task t = new Task();

        for (String fieldname : fieldList) {
            t.put(trimCustomObject(fieldname), taskBlueprint.get(fieldname));
        }

        //Related info
        t.OwnerId = UserInfo.getUserId();
        t.WhatId = currentRecord.Id;
        insert t;

    }

    //trim __c from fieldname to correspond to standard fields on task object
    public static String trimCustomObject(String fieldname){
        return fieldname.substringBefore('__c');
    }

    //remove fields that cannot be mapped to the task object
    public static Set<String> validate(Set<String> fieldList){
        List<String> elementsToRemove = new List<String>{'objectapiname__c','developername', 'masterlabel', 'language', 'namespaceprefix', 'label', 'qualifiedapiname', 'isactive__c', 'id'};
        fieldList.removeAll(elementsToRemove);
        return fieldList;
    }

    @suppressWarnings('pmd')
    public static Sobject getTask(){
        ID recordId =(Id) ApexPages.currentPage().getParameters().get('id');
        String objectAPIName = recordId.getSObjectType().getDescribe().getName();

        String selectQuery = getFieldString();
        String fromQuery = 'FROM Declarative_task__mdt';
        String whereQuery = 'WHERE objectAPIName__c = :objectAPIName LIMIT 1';
        String query = selectQuery + ' ' + fromQuery + ' ' + whereQuery;

        System.debug(query);

        return Database.query(query)[0];
    }

    @suppressWarnings('pmd')
    public static Sobject getCurrentRecord(){
        ID recordId =(Id) ApexPages.currentPage().getParameters().get('id');
        String objectAPIName = recordId.getSObjectType().getDescribe().getName();
        String query = 'SELECT id from ' + objectAPIName + ' where id = \''  + recordId +    '\' limit 1 ';

        System.debug(query);

        return Database.query(query)[0];
    }

    //Helper method to dynamically get all fields on Custom Metadata Type for select statement
    public static String getFieldString(){
        declarative_task__mdt dtm = new declarative_task__mdt();
        Sobjecttype dtmtype = dtm.getSObjectType();
        Map<String,Schema.SObjectField> mfields = dtmtype.getDescribe().fields.getMap();
        
        String dynamicQuery = 'SELECT ';
        for (String s : mfields.keySet()){
            dynamicQuery +=  s + ',';
        }
        dynamicQuery = dynamicQuery.removeEndIgnoreCase(',');

        System.debug(dynamicQuery);

        return dynamicQuery;
    }
    
    //Helper method to dynamically get all fields on custom metadata type for list
    public static set<String> getFieldList(){
        declarative_task__mdt dtm = new declarative_task__mdt();
        Sobjecttype dtmtype = dtm.getSObjectType();
        Map<String,Schema.SObjectField> mfields = dtmtype.getDescribe().fields.getMap();

        System.debug(mfields.keySet());

        return mfields.keySet();
    }
}