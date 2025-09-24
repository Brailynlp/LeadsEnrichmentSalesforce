public with sharing class relatedCaseController {

    @AuraEnabled
    public static Id createChildCase(Id parentId) {
        Case newCase = new Case(
            Subject = 'New Case',
            Status  = 'New',
            Origin  = 'Phone'
        );

        //si no es nulo entonces asignamos los valores heredados al nuevo.
        if (parentId != null) {
            Case parentCase = [
                SELECT ContactId, AccountId, Origin, CaseNumber, Subject
                FROM Case
                WHERE Id =:parentId
                LIMIT 1
            ];
            newCase.ParentId  = parentId;
            newCase.Subject   = 'Heredado de ' + parentCase.CaseNumber + ' - ' + parentCase.Subject;
            newCase.ContactId = parentCase.ContactId;
            newCase.AccountId = parentCase.AccountId;
            newCase.Origin    = parentCase.Origin;
        }

        insert newCase;
        return newCase.Id;
    }
}
