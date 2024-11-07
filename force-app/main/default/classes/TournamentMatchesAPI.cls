@RestResource(urlMapping='/Trournament/GroupMatches/*')
global with sharing class TournamentMatchesAPI {
    
    @HttpGet
    global static List<Match__c> getTeamsGroupScore() {
        
        
        RestRequest req = RestContext.request;
        String tournamentId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        List<Match__c> MatchList = [SELECT Name,Away_Team__c,Group__c,Home_Team__c,Location__c,Match_Date_Time__c,
                                    Score_Away_Team__c,Score_Home_Team__c,Stage__c,Winner__c 
                                    FROM Match__c WHERE Stage__c = 'Group' AND Tournament__c = :tournamentId];
        return MatchList;
    }
}