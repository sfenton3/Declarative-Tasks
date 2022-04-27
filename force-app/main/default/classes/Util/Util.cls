public with sharing class Util {

    //do I need this if fields are not creatable? or unvalidated
    public static Set<String> validate(Set<String> fieldList){
        List<String> elementsToRemove = new List<String>{'objectapiname__c','developername', 'masterlabel', 'language', 'namespaceprefix', 'label', 'qualifiedapiname', 'isactive__c', 'id'};
        fieldList.removeAll(elementsToRemove);
        return fieldList;
    }
}
