"use strict";

function OnInvestEvent( event )
{
	$.Msg( "OnInvestEvent:", event, " ? ", teamId );
	var curTimeDS = Game.GetGameTime() * 10;
	var teamPanel = $.GetContextPanel();
	var teamId = $.GetContextPanel().GetAttributeInt( "team_id", -1 );
	
	if ( teamId !== event.team_id )
		return;

	$.Msg( teamPanel.GetChild( 1 ).GetChild( 0 ) );
	var recentScore = teamPanel.GetAttributeInt( "recent_score_count", 0 );
	//recentScore++; //This seems unnecessary
	teamPanel.SetAttributeInt( "recent_score_count", event.invest_amount );
	teamPanel.GetChild( 1 ).GetChild( 0 ).text=event.team_gold;
	teamPanel.SetAttributeInt( "ds_time_of_most_recent_score", curTimeDS );

	var pointsToWinPanel = teamPanel.FindChildInLayoutFile( "PointsToWin" );
	pointsToWinPanel.SetDialogVariableInt( "points_to_win", event.gold_remaining );

	if ( event.victory )
	{
		teamPanel.SetHasClass( "victory", true );
		teamPanel.SetHasClass( "close_to_victory", false );
		teamPanel.SetHasClass( "very_close_to_victory", false );
		pointsToWinPanel.text = $.Localize( "#PointsToWin_Victory", pointsToWinPanel );
	}
	else if ( event.very_close_to_victory ) 
	{
		teamPanel.SetHasClass( "victory", false );
		teamPanel.SetHasClass( "close_to_victory", false );
		teamPanel.SetHasClass( "very_close_to_victory", true );
		pointsToWinPanel.text = $.Localize( "#PointsToWin_VeryCloseToVictory", pointsToWinPanel );
	}
	else if ( event.close_to_victory )
	{
		teamPanel.SetHasClass( "victory", false );
		teamPanel.SetHasClass( "close_to_victory", true );
		teamPanel.SetHasClass( "very_close_to_victory", false );
		pointsToWinPanel.text = $.Localize( "#PointsToWin_CloseToVictory", pointsToWinPanel );
	}

	UpdateRecentScore();
	$.Schedule( 1, UpdateRecentScore );
}

function UpdateRecentScore()
{
	$.Msg( "UpdateRecentScore" );
	var TIME_TO_SHOW_RECENT_SCORE_DS = 10; // 2s
	var teamPanel = $.GetContextPanel();

	var curTimeDS = Game.GetGameTime() * 10;
	var recentScore = teamPanel.GetAttributeInt( "recent_score_count", 0 );
	var timeOfRecentScoreDS = teamPanel.GetAttributeInt( "ds_time_of_most_recent_score", 0 );

	if ( timeOfRecentScoreDS + TIME_TO_SHOW_RECENT_SCORE_DS < curTimeDS )
	{
		teamPanel.SetAttributeInt( "recent_score_count", 0 );
		teamPanel.SetAttributeInt( "ds_time_of_most_recent_score", 0 );
		recentScore = 0;
	}

	var recentScorePanel = teamPanel.FindChildInLayoutFile( "RecentScore" );

	if ( recentScore === 0 ) {
		recentScorePanel.SetHasClass( "recent_score", false );
		recentScorePanel.SetHasClass( "no_recent_score", true );
	}
	else {
		recentScorePanel.SetDialogVariableInt( "score", recentScore );
		recentScorePanel.text = $.Localize( "#RecentScore", recentScorePanel );
		recentScorePanel.SetHasClass( "recent_score", true );
		recentScorePanel.SetHasClass( "no_recent_score", false );
	}
}

(function() { 
	GameEvents.Subscribe( "invest_event", OnInvestEvent );
})();
