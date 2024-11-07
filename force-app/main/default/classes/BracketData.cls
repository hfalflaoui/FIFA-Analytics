public with sharing class BracketData{
    public BracketData() {
        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Map<String,Object>> getBracketData(){
        
        List<Map<String, Object>> bracketData = new List<Map<String, Object>>();
        
        //Round of 16 matches
        String round16 = 'Round of 16';
        List<Match__c> r16matches = getStageMatches(round16);
        Map<String, Object> r16MatchesMapped = mapStageMatches(round16, r16matches);
        BracketData.add(r16MatchesMapped);
        
        
        //Quarter Finals
        String QuarterFinals = 'Quarter Finals';
        List<Match__c> QuarterFinalsMatches = getStageMatches(QuarterFinals);
        Map<String, Object> QFMatchesMapped = mapStageMatches(QuarterFinals, QuarterFinalsMatches);
        BracketData.add(QFMatchesMapped);
        
        //Semi Finals
        String SemiFinals = 'Semi Finals';
        List<Match__c> SemiFinalsMatches = getStageMatches(SemiFinals);
        Map<String, Object> SFMatchesMapped = mapStageMatches(SemiFinals, SemiFinalsMatches);
        BracketData.add(SFMatchesMapped);

        //Finals
        String Finals = 'Finals';
        List<Match__c> FinalsMatches = getStageMatches(Finals);
        Map<String, Object> FinalsMatchesMapped = mapStageMatches(Finals, FinalsMatches);
        BracketData.add(FinalsMatchesMapped);


        //Third Place
        String ThirdPlace = 'Third place';
        List<Match__c> ThirdPlaceMatches = getStageMatches(ThirdPlace);
        Map<String, Object> ThirdPlaceMatchesMapped = mapStageMatches(ThirdPlace, ThirdPlaceMatches);
        BracketData.add(ThirdPlaceMatchesMapped);
        
        
        
        return bracketData;
    }
    
    public static List<Match__c> getStageMatches(String stage){
        List<Match__c> Matches = [SELECT Id, Name, Home_Team__r.Name, Away_Team__r.Name, Score_Home_Team__c, Score_Away_Team__c, Stage__c
        FROM Match__c where Stage__c = :stage];
        
        return Matches;
    }
    
    public static Map<String, Object> mapStageMatches(String StageName, List<Match__c> stageMatches){
        
        // Loop through the stages and prepare the data for the bracket component
        Map<String, Object> stageData = new Map<String, Object>();
        stageData.put('name', StageName);
        
        List<Map<String, Object>> matchData = new List<Map<String, Object>>();
        
        // Loop through the matches for each stage
        for (Match__c match : stageMatches) {
            Map<String, Object> matchDataMap = new Map<String, Object>();
            matchDataMap.put('id', match.Id);
            matchDataMap.put('team1', match.Home_Team__r.Name);
            matchDataMap.put('score1', match.Score_Home_Team__c);
            matchDataMap.put('team2', match.Away_Team__r.Name);
            matchDataMap.put('score2', match.Score_Away_Team__c);
            
            matchData.add(matchDataMap);
        }
        
        // Add the match data to the stage data
        stageData.put('matches', matchData);
        
        return stageData;
    }
    
    
}