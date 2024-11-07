public with sharing class ReportSummaryController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getReportSummary(String reportId) {
        HttpRequest req = new HttpRequest();
        
        // Use Named Credential as the endpoint
        req.setEndpoint('callout:Salesforce_Analytics_API/services/data/v58.0/analytics/reports/' + reportId);
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> reportData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            // Extract summary data (e.g., totals, averages)
            Map<String, Object> reportSummary = new Map<String, Object>();
            Map<String, Object> factMap = (Map<String, Object>) reportData.get('factMap');
            if (factMap != null) {
                for (String key : factMap.keySet()) {
                    Map<String, Object> summary = (Map<String, Object>) factMap.get(key);
                    reportSummary.put(key, summary.get('aggregates'));
                }
            }
            return reportSummary;
        } else {
            throw new AuraHandledException('Error fetching report data: ' + res.getStatus());
        }
    }
}
