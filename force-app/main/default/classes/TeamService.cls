public with sharing class TeamService {
    public TeamService() {
        
    }
    @AuraEnabled(cacheable=true)
    public static TeamData getTeamData(Id teamId) {
        // Retrieve recent matches
        List<Match__c> recentMatches = [SELECT Match_Date_Time__c, Score_Home_Team__c, Score_Away_Team__c, 
                                        Home_Team__c, Away_Team__c,Home_Team__r.Name, Away_Team__r.Name, Winner__c 
                                        FROM Match__c 
                                        WHERE (Home_Team__c = :teamId OR Away_Team__c = :teamId) 
                                        AND Match_Date_Time__c < TODAY
                                        ORDER BY Match_Date_Time__c DESC 
                                        LIMIT 5];
        
        List<Map<String, Object>> recentMatchesMapped = TeamService.mapMatchesList(teamId, recentMatches, false);
        
        // Retrieve upcoming matches
        List<Match__c> upcomingMatches = [SELECT Match_Date_Time__c, Home_Team__c, Away_Team__c, Home_Team__r.Name, Away_Team__r.Name
                                          FROM Match__c 
                                          WHERE (Home_Team__c = :teamId OR Away_Team__c = :teamId) 
                                          AND Match_Date_Time__c > TODAY 
                                          ORDER BY Match_Date_Time__c ASC 
                                          LIMIT 5];
        
        List<Map<String, Object>> upcomingMatchesMapped = TeamService.mapMatchesList(teamId, upcomingMatches, true);
        
        
        // Retrieve tournament standings and stats
        Team__c team = [SELECT Name, Wins__c, Losses__c, Draws__c, Goals_For__c, Goals_Against__c 
                        FROM Team__c 
                        WHERE Id = :teamId 
                        LIMIT 1];
        
        return new TeamData(team, recentMatchesMapped, upcomingMatchesMapped);
    }
    
    public static List<Map<String, Object>> mapMatchesList(Id teamId, List<Match__c> matches, Boolean upcoming){
        
        List<Map<String, Object>> result = new List<Map<String, Object>>();
        
        // Process the results to determine the opponent team
        for (Match__c match : matches) {
            Map<String, Object> matchDetails = new Map<String, Object>();
            
            // Check if the teamId is the home team or away team
            if (match.Home_Team__c == teamId) {
                // If the teamId is the home team, the opponent is the away team
                matchDetails.put('Opponent', match.Away_Team__r.Name);
            } else if (match.Away_Team__c == teamId) {
                // If the teamId is the away team, the opponent is the home team
                matchDetails.put('Opponent', match.Home_Team__r.Name);
            }
            
            // Add other match details (score, date, winner, etc.)
            matchDetails.put('MatchDate', match.Match_Date_Time__c);
            
            if (!upcoming) {
                matchDetails.put('ScoreHome', match.Score_Home_Team__c);
                matchDetails.put('ScoreAway', match.Score_Away_Team__c);
                matchDetails.put('Winner', match.Winner__c);

            }
            
            
            // Add the match details to the result list
            result.add(matchDetails);
        }
        return result;
    }
    
    public class TeamData {
        @AuraEnabled public Team__c team;
        @AuraEnabled public List<Map<String, Object>> recentMatchesMapped;
        @AuraEnabled public List<Map<String, Object>> upcomingMatchesMapped;
        
        
        public TeamData(Team__c team, List<Map<String, Object>> recentMatchesMapped, List<Map<String, Object>> upcomingMatchesMapped) {
            this.team = team;
            this.recentMatchesMapped = recentMatchesMapped;
            this.upcomingMatchesMapped = upcomingMatchesMapped;
        }
    }
}