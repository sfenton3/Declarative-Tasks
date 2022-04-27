@istest
public with sharing class ValidateTaskFieldsTest {

    @istest
    static void is_field_creatable_test(){

        Boolean createid = ValidateTaskFields.isCreatable('id');
        Boolean createactivitydate = ValidateTaskFields.isCreatable('activitydate');
        Boolean invalidField = ValidateTaskFields.isCreatable('test123');


        System.assertEquals(false, createid, 'id is not createable...');
        System.assertEquals(false, invalidField, 'invalid field cannot be creatable');
        System.assertEquals(true, createactivitydate, 'activitydate is createable...');
    }

    @istest    
    static void is_field_valid_test(){

        //good fields
        Boolean goodId = ValidateTaskFields.isValidField('id');
        Boolean standardfield = ValidateTaskFields.isValidField('activitydate');

        //bad fields
        boolean badId = ValidateTaskFields.isValidField('id123');
        boolean badStandardField = ValidateTaskFields.isValidField('activitydate__c');

        //true
        System.assertEquals(true, goodId, 'id field should be valid for task object');
        System.assertEquals(true, standardfield, 'standard field should be valid for task object');


        //false
        system.assertEquals(false, badId, 'id123 field show be invalid for task object');
        System.assertEquals(false, badStandardField, 'standard field should not be referenced as custom field be valid for task object');

    }

}
