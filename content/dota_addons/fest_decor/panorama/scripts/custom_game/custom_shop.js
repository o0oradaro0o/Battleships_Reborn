"use strict";

var NewShopUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop");

  var catigoriesUI;
var currentDeg = 0
var targetDeg = 0
var shipShopShow=false;


var PlayerColors = [
 "rgb(46, 106, 230)",

 "rgb(92, 230, 173)",

 "rgb(173, 0, 173)",

 "rgb(220,217,10)",

 "rgb(230, 98, 0)",

 "rgb(230, 122, 176)",

 "rgb(146, 164, 64)",
 
 "rgb(92, 197, 224)",
 
 "rgb(0, 119, 31)",
 
 "rgb(149, 96, 0)"
]

function fixUI( ) 
{
	
	
	
	$.Msg("in fix ui--------------------------------------");
	
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false );     //Hero actions UI.
	
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );      //Time of day (clock).
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );     //Heroes and team score at the top of the HUD.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );      //Lefthand flyout scoreboard.

GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, true );     //Minimap.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PANEL, false );      //Entire Inventory UI
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false );     //Shop portion of the Inventory.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_ITEMS, false );      //Player items.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_QUICKBUY, false );     //Quickbuy.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_COURIER, false );      //Courier controls.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_PROTECT, false );      //Glyph.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_GOLD, false );     //Gold display.
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS, false );      //Suggested items shop panel.

GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );      //Endgame scoreboard.    
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );


GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );



		
}
	function fillShop( ) 
{
	
	
			
		 fixUI( ) 
		//closeShipShop()
		
		
	}
	


function PingLoc(data)
	{
		if(data.player_id==Players.GetLocalPlayer())
			{
				var v=[data.x,data.y,data.z]
				GameUI.PingMinimapAtLocation(v);
			}
	}
	
	
	function ShowScore(data)
	{
		var totalSccore = data.good_score+data.bad_score

		 var tGameTime = (Math.floor(data.Game_Time/60)) + ":" + (data.Game_Time % 60 >= 10 ? "": "0") +  (data.Game_Time % 60);    
		$( "#TimeLeft" ).text = tGameTime;
		targetDeg =  data.good_score/totalSccore*180-90
			$.Schedule( .1, GoToScore );
			
			
			var goodToSort = goodTeamScores
			var badToSort = badTeamScores
			if(goodToSort.length>0)
			{
				var count = 0
				goodToSort.sort(compareSecondColumn);
				goodToSort.forEach(function(element) 
				{
					count++;
					if(element[0].length>8)
					{
						var name = element[0].substring(0,8)
					}
					else
					{
						name = element[0]
						while(name.length<7)
						{
							name=name+"."
						}
					}
					$( "#goodScore" + count ).text =  name + " " + element[1] + " ("+ element[2]+")" ;
					$( "#goodScore" + count ).style.color = PlayerColors[ element[3]]
				});
			}
			if(badToSort.length>0)
			{
				var count = 0
				badToSort.sort(compareSecondColumn);
				badToSort.forEach(function(element) 
				{
					count++;
					if(element[0].length>8)
					{
						var name = element[0].substring(0,8)
					}
					else
					{
						name = element[0]
						while(name.length<7)
						{
							name=name+"."
						}
					}
						$( "#badScore" + count ).text =name + " " + element[1] + " (" +element[2]+")" ;
					$( "#badScore" + count ).style.color = PlayerColors[ element[3]]
				});
			}
			
			
	}


	function GoToScore()
	{
		if(targetDeg<currentDeg)
		{
			currentDeg=currentDeg-.1;
		}
		if(targetDeg>currentDeg)
		{
			currentDeg=currentDeg+.1;
		}
		$( "#Tree" ).style.transform="rotateZ("+ currentDeg+"deg ) ;"
		if(targetDeg>currentDeg+1 || targetDeg<currentDeg-1)
		{
		$.Schedule( .1, GoToScore );
		}
	}
	
	
function TopNotification( msg ) {
		
  AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
  AddNotificationbot(msg, $('#BottomNotifications'));
}

function TopRemoveNotification(msg){
  RemoveNotification(msg, $('#TopNotifications'));
}

function BottomRemoveNotification(msg){
  RemoveNotification(msg, $('#BottomNotifications'));
}


function RemoveNotification(msg, panel){
  var count = msg.count;
  if (count > 0 && panel.GetChildCount() > 0){
    var start = panel.GetChildCount() - count;
    if (start < 0)
      start = 0;

    for (i=start;i<panel.GetChildCount(); i++){
      var lastPanel = panel.GetChild(i);
      //lastPanel.SetAttributeInt("deleted", 1);
      lastPanel.deleted = true;
      lastPanel.DeleteAsync(0);
    }
  }
}

function AddNotification(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  //$.Msg(msg)

  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLine')
    lastNotification.hittest = false;
  }

  var notification = null;
  
  if (msg.hero != null)
    notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');
  else if (msg.image != null)
    notification = $.CreatePanel('Image', lastNotification, '');
  else if (msg.ability != null)
    notification = $.CreatePanel('DOTAAbilityImage', lastNotification, '');
  else if (msg.item != null)
    notification = $.CreatePanel('DOTAItemImage', lastNotification, '');
  else
    notification = $.CreatePanel('Label', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    //$.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      //$.Msg('callback')
      if (lastNotification.deleted)
        return;
      
      lastNotification.DeleteAsync(0);
    });
  }

  
  if (msg.hero != null){
    notification.heroimagestyle = msg.imagestyle || "icon";
    notification.heroname = msg.hero
    notification.hittest = false;
  } else if (msg.image != null){
    notification.SetImage(msg.image);
    notification.hittest = false;
  } else if (msg.ability != null){
    notification.abilityname = msg.ability
    notification.hittest = false;
  } else if (msg.item != null){
    notification.itemname = msg.item
    notification.hittest = false;
  } else{
    notification.html = true;
    var text = msg.text || "No Text provided";
    notification.text = $.Localize(text)
    notification.hittest = false;
    notification.AddClass('TitleText');
  }
  
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('NotificationMessage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}

function AddNotificationbot(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)
  //$.Msg(msg)

  msg.continue = msg.continue || false;
  //msg.continue = true;

  if (lastNotification != null && msg.continue) 
    newNotification = false;

  if (newNotification){
    lastNotification = $.CreatePanel('Panel', panel, '');
    lastNotification.AddClass('NotificationLineBot')
    lastNotification.hittest = false;
  }

  var notification = null;
  
  if (msg.hero != null)
    notification = $.CreatePanel('DOTAHeroImage', lastNotification, '');
  else if (msg.image != null)
    notification = $.CreatePanel('Image', lastNotification, '');
  else if (msg.ability != null)
    notification = $.CreatePanel('DOTAAbilityImage', lastNotification, '');
  else if (msg.item != null)
    notification = $.CreatePanel('DOTAItemImage', lastNotification, '');
  else
    notification = $.CreatePanel('Label', lastNotification, '');

  if (typeof(msg.duration) != "number"){
    //$.Msg("[Notifications] Notification Duration is not a number!");
    msg.duration = 3
  }
  
  if (newNotification){
    $.Schedule(msg.duration, function(){
      //$.Msg('callback')
      if (lastNotification.deleted)
        return;
      
      lastNotification.DeleteAsync(0);
    });
  }

  if (msg.hero != null){
    notification.heroimagestyle = msg.imagestyle || "icon";
    notification.heroname = msg.hero
    notification.hittest = false;
  } else if (msg.image != null){
    notification.SetImage(msg.image);
    notification.hittest = false;
  } else if (msg.ability != null){
    notification.abilityname = msg.ability
    notification.hittest = false;
  } else if (msg.item != null){
    notification.itemname = msg.item
    notification.hittest = false;
  } else{
    notification.html = true;
    var text = msg.text || "No Text provided";
    notification.text = $.Localize(text)
    notification.hittest = false;
    notification.AddClass('TitleText');
  }
  
  if (msg.class)
    notification.AddClass(msg.class);
  else
    notification.AddClass('NotificationMessage');

  if (msg.style){
    for (var key in msg.style){
      var value = msg.style[key]
      notification.style[key] = value;
    }
  }
}
function SwapAbility(data)
{
	var ticks = 0;
	if(data.player_id==Players.GetLocalPlayer())
	{
			$( "#presentclosed" ).style.opacity=0;
			$( "#presentopen" ).style.opacity=0;
			$( "#rocketskate" ).style.opacity=0;
			$( "#magnet" ).style.opacity=0;
			$( "#snowball" ).style.opacity=0;
			if(data.ability_name == "Rocket_Boots")
			{
				$( "#presentopen" ).style.opacity=1;
				$( "#rocketskate" ).style.opacity=1;

			}
			if(data.ability_name == "Magnet")
			{
				$( "#presentopen" ).style.opacity=1;
				$( "#magnet" ).style.opacity=1;
			}
			if(data.ability_name == "Snow_Ball")
			{
				$( "#presentopen" ).style.opacity=1;
				$( "#snowball" ).style.opacity=1;
			}
			if(data.ability_name == "cast_ability")
			{
				$( "#presentclosed" ).style.opacity=1;
			}
			
	}
}
/**function SwapAbility(data)

{
	if(data.player_id==Players.GetLocalPlayer())
	{
			$( "#presentclosed" ).style.visibility="collapse";
			$( "#presentopen" ).style.visibility="collapse";
			$( "#rocketskate" ).style.visibility="collapse";
			$( "#magnet" ).style.visibility="collapse";
			$( "#snowball".style.visibility="collapse";
			if(data.ability_name == "Rocket_Boots")
			{
				$( "#presentopen" ).style.visibility="visible";
				$( "#rocketskate" ).style.visibility="visible";
			}
			if(data.ability_name == "Magnet")
			{
				$( "#presentopen" ).style.visibility="visible";
				$( "#magnet" ).style.visibility="visible";
			}
			if(data.ability_name == "Snow_Ball")
			{
				$( "#presentopen" ).style.visibility="visible";
				$( "#snowball" ).style.visibility="visible";
			}
			if(data.ability_name == "cast_ability")
			{
				$( "#presentclosed" ).style.visibility="visible";
			}
			
	}
}**/
function SnowHit(data)
{
	$.Msg("WeHit!!")
	if(data.player_id==Players.GetLocalPlayer())
	{
		$( "#Splat" ).style.opacity=.7;
	
			$.Schedule( .1, fadeSnow );
			
	}
}

function fadeSnow()
{

		 $("#Splat").style.opacity=$("#Splat").style.opacity-.02;
		 if($("#Splat").style.opacity>0)
		 {
		$.Schedule( .03, fadeSnow );
		 }
}


var CONSUME_EVENT = true;
var CONTINUE_PROCESSING_EVENT = false;



function compareSecondColumn(a, b) {
    if (a[1] === b[1]) {
        return 0;
    }
    else {
        return (a[1] > b[1]) ? -1 : 1;
    }
}

var goodTeamScores =[]

var badTeamScores = []

function UpdatePlayerInfo(data)
{
	 $.Msg(Players.GetTeam( data.player_id ))
	if( Players.GetTeam( data.player_id )	== 3)
	{
		goodTeamScores[data.player_id] = [data.player_name, data.delivered, data.heald , data.player_id  ]
	}
	else if(Players.GetTeam( data.player_id ) == 2)
	{
		badTeamScores[data.player_id] = [data.player_name, data.delivered, data.heald, data.player_id   ]
	}
	
}

// Handle Left Button events
function OnLeftButtonPressed()
{
	//$.Msg("LEFT BUTTON CAST")
}



		(function () {
	$.Msg("in subscribe");
	GameEvents.Subscribe("Player_Spawned", fixUI );
	GameEvents.Subscribe("Score_data", ShowScore );
	GameEvents.Subscribe("grant_ability", SwapAbility );
	GameEvents.Subscribe( "ping_loc", PingLoc );
	GameEvents.Subscribe( "snowball_hit", SnowHit );
	GameEvents.Subscribe("score_info", UpdatePlayerInfo );
	
	GameEvents.Subscribe( "top_notification", TopNotification );
	GameEvents.Subscribe( "bottom_notification", BottomNotification );
	GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
	GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
	$.Msg("done subscribe");
	
})();