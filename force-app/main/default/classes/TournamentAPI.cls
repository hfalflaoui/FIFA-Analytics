@RestResource(urlMapping='/Trournament/GroupResult/*')
global with sharing class TournamentAPI {
    
    
    @HttpGet
    global static List<Team__c> getTeamsGroupScore() {
        
        
        RestRequest req = RestContext.request;
        String tournamentId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        List<Team__c> teamsList = [SELECT Draws__c,Goals_Against__c,Goals_Difference__c,Goals_For__c,
                                    Group__c,Losses__c,Matches_Played__c,Name,Points__c,Wins__c
                                    FROM Team__c WHERE Group__r.Tounament__c = :tournamentId];
        return teamsList;
    }
    
    
}