public with sharing class LeadInfoService {
    private static final String API_KEY = '4qFktmG1UOYpxD7I07tK7g'; 
    private static final String BASE_URL = 'https://api.apollo.io/v1/organizations/enrich';

    public static LeadInfoResponse getLeadInfo(String domain) {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(BASE_URL);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-Api-Key', API_KEY);
        req.setTimeout(20000);
        
        Map<String, Object> requestBody = new Map<String, Object>{
            'domain' => domain
        };
        req.setBody(JSON.serialize(requestBody));
        
        try {
            HttpResponse res = http.send(req);
            
            if (res.getStatusCode() == 200) {
                Map<String, Object> parsed = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                return mapApolloResponse(parsed);
            } else {
                throw new AuraHandledException('Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error calling API: ' + e.getMessage());
        }
    }

    private static LeadInfoResponse mapApolloResponse(Map<String, Object> parsed) {
        LeadInfoResponse response = new LeadInfoResponse(); 
        Map<String, Object> org = findOrganizationData(parsed);
        
        if (org == null) {
            response.status = 'not_found';
            response.message = 'No se encontró información para el dominio proporcionado.'; 
            return response;
        }
        
        response.status = 'success';
        response.country = getStringValue(org, 'country');
        response.city = getStringValue(org, 'city');
        response.industry = getStringValue(org, 'industry');
        response.logo = getStringValue(org, 'logo_url');
        
        return response;
    }

    private static Map<String, Object> findOrganizationData(Map<String, Object> parsed) {
        if (parsed.containsKey('organization')) {
            return (Map<String, Object>) parsed.get('organization');
        }        
        return null;
    }

    private static String getStringValue(Map<String, Object> data, String key) {
        if (data == null || !data.containsKey(key) || data.get(key) == null) {
            return '';
        }
        return String.valueOf(data.get(key));
    }
 
    public class LeadInfoResponse {
        @AuraEnabled public String status;
        @AuraEnabled public String message;
        @AuraEnabled public String country;
        @AuraEnabled public String city;
        @AuraEnabled public String website;
        @AuraEnabled public String industry;
        @AuraEnabled public String logo;
    }
}
