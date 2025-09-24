public with sharing class LeadInfoController {

    @InvocableMethod(label='Enrich Lead Info')  //flow siempre recibe y devuelve listas
    public static List<Response> enrichLeadInfo(List<Request> requests) {
        List<Response> results = new List<Response>();

        for(Request r : requests) {
            Response resp = new Response();

            try {
                Lead leadRecord = [
                    SELECT Id, Company,
                           LeadInfo_Country__c, LeadInfo_City__c,
                           LeadInfo_Website__c, LeadInfo_Industry__c, LeadInfo_Logo__c
                    FROM Lead 
                    WHERE Id = :r.leadId 
                    LIMIT 1
                ];

                LeadInfoService.LeadInfoResponse info = LeadInfoService.getLeadInfo(leadRecord.Company);

                resp.country = info.country;
                resp.city = info.city;
                resp.industry = info.industry;
                resp.logo = info.logo;

                if (info.status == 'success') {
                    leadRecord.LeadInfo_Country__c = info.country;
                    leadRecord.LeadInfo_City__c = info.city;
                    leadRecord.LeadInfo_Industry__c = info.industry;
                    leadRecord.LeadInfo_Logo__c = info.logo;
                    update leadRecord;
                }

            } catch (Exception e) {
                resp.country = 'Error';
                resp.city = e.getMessage().left(255);
            }

            results.add(resp);
        }

        return results;
    }

    public class Request {
        @InvocableVariable(required=true)
        public Id leadId;
    }

    public class Response {
        @InvocableVariable public String country;
        @InvocableVariable public String city;
        @InvocableVariable public String industry;
        @InvocableVariable public String logo;
    }
}
