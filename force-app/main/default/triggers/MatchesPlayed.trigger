trigger MatchesPlayed on Match__c (after insert, after delete, after undelete, after update) {
    
    // Map to store the match count adjustments for each team
    Map<Id, Integer> teamMatchCountMap = new Map<Id, Integer>();

    // Helper method to increment/decrement match count in the map
    void adjustTeamMatchCount(Map<Id, Integer> countMap, Id teamId, Integer adjustment) {
        if (teamId != null) {
            if (countMap.containsKey(teamId)) {
                countMap.put(teamId, countMap.get(teamId) + adjustment);
            } else {
                countMap.put(teamId, adjustment);
            }
        }
    }

    // Handle after insert and after undelete events
    if (Trigger.isInsert || Trigger.isUndelete) {
        for (Match__c match : Trigger.new) {
            // Increment count for both Home Team and Away Team
            adjustTeamMatchCount(teamMatchCountMap, match.Home_Team__c, 1);
            adjustTeamMatchCount(teamMatchCountMap, match.Away_Team__c, 1);
        }
    }

    // Handle after delete event
    if (Trigger.isDelete) {
        for (Match__c match : Trigger.old) {
            // Decrement count for both Home Team and Away Team
            adjustTeamMatchCount(teamMatchCountMap, match.Home_Team__c, -1);
            adjustTeamMatchCount(teamMatchCountMap, match.Away_Team__c, -1);
        }
    }

    // Handle after update event for reassigned teams
    if (Trigger.isUpdate) {
        for (Match__c match : Trigger.new) {
            Match__c oldMatch = Trigger.oldMap.get(match.Id);

            // Check if the Home Team was reassigned
            if (match.Home_Team__c != oldMatch.Home_Team__c) {
                // Decrement the old Home Team count and increment the new Home Team count
                adjustTeamMatchCount(teamMatchCountMap, oldMatch.Home_Team__c, -1);
                adjustTeamMatchCount(teamMatchCountMap, match.Home_Team__c, 1);
            }

            // Check if the Away Team was reassigned
            if (match.Away_Team__c != oldMatch.Away_Team__c) {
                // Decrement the old Away Team count and increment the new Away Team count
                adjustTeamMatchCount(teamMatchCountMap, oldMatch.Away_Team__c, -1);
                adjustTeamMatchCount(teamMatchCountMap, match.Away_Team__c, 1);
            }
        }
    }

    // Update the Matches Played field on the Team records
    if (!teamMatchCountMap.isEmpty()) {
        List<Team__c> teamsToUpdate = new List<Team__c>();

        // Query existing match counts for each team to calculate new values
        for (Team__c team : [SELECT Id, Matches_Played__c FROM Team__c WHERE Id IN :teamMatchCountMap.keySet()]) {
            Integer matchCountChange = teamMatchCountMap.get(team.Id);
            team.Matches_Played__c += matchCountChange;
            teamsToUpdate.add(team);
        }

        // Perform bulk update on Team records
        if (!teamsToUpdate.isEmpty()) {
            update teamsToUpdate;
        }
    }
}
