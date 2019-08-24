"use strict";

function UpdateTimer( data ) {
	$( "#Timer" ).text = data.timer_minute_10 + data.timer_minute_01 + ":" + data.timer_second_10 + data.timer_second_01;
}

function ShowTimer( data ) {
	$( "#Timer" ).AddClass( "timer_visible" );
}

function AlertTimer( data ) {
	$( "#Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data ) {
	$( "#Timer" ).AddClass( "timer_hidden" );
}

function UpdateKillsToWin() {
	var victory_condition = CustomNetTables.GetTableValue( "game_state", "victory_condition" );
	if ( victory_condition ) {
		$("#VictoryPoints").text = victory_condition.kills_to_win;
	}
}

function OnGameStateChanged( table, key, data ) {
	$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	UpdateKillsToWin();
}

( function() {} )();
