"use strict";

var NewShopUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop");
	var overallScore = []
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
	
	
	$( "#presentclosed" ).style.opacity=1;
	$.Msg("in fix ui--------------------------------------");
	
	
	$.Msg("in fix ui--------------------------------------");
	GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
		 $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar").style.visibility = "visible";
		 
		 
		 var sidenotif =   $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("combat_events");
		 
		
		 var topnotif =   $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("FightRecap");
		 
		 
		 sidenotif.style.visibility = "collapse";
		 topnotif.style.visibility = "collapse";
	
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

//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );      //Endgame scoreboard.    
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_HEROES, false );
GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false );


//GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ENDGAME, false );




		
}
	function fillShop( ) 
{
	
	
			
		 fixUI( ) 
		//closeShipShop()
		
		
	}
	
function  TeamWin(data)
{



	
	overallScore.sort(compareSecondColumn);
		GameUI.SetCameraPitchMin( 24 )
		GameUI.SetCameraPitchMax( 25 )
	var count = 0
	overallScore.forEach(function(element) 
	{
		count++;
		$.Msg("TeamNumber")
		$.Msg(Players.GetTeam(element[3]))
		$( "#ScoreName" + count ).text =element[0];
		$( "#ScorePoints" + count ).text = element[1] ;
		$( "#ScoreChain" + count ).text = "("+element[2]+")" ;
		$( "#ScoreKills" + count ).text =element[4];
		$( "#ScoreName" + count ).style.color = PlayerColors[ element[3]]
		$( "#ScorePoints" + count ).style.color = PlayerColors[ element[3]]
		$( "#ScoreKills" + count ).style.color = PlayerColors[ element[3]]
		$( "#ScoreChain" + count ).style.color = PlayerColors[ element[3]]
		
		if(Players.GetTeam(element[3])==3)
		{
				$( "#ScoreName" + count ).GetParent().style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from(#ff909055 ), to( #cc606055 ) );"
				//$( "#ScoreName" + count ).GetParent().style.backgroundColor = "#a00000;"
		
		}
		else
		{
				$( "#ScoreName" + count ).GetParent().style.backgroundColor = "gradient( linear, 0% 0%, 0% 100%, from(#00900055 ), to( #00600055 ) );"
				//$( "#ScoreName" + count ).GetParent().style.backgroundColor = "#016d00;"
		
		}
		
		
		
		
	});

	
	if( data.team_number	== 3)
	{
		if(Game.GetLocalPlayerInfo().player_team_id==3)
		{
			$( "#WinOrLose" ).text = $.Localize("#winner")
		}
		else
		{
			$( "#WinOrLose" ).text = $.Localize("#loser")
		}
		$( "#mit" ).style.visibility="visible";
		$("#ScoreBoardFinalholder").style.backgroundColor="gradient( linear, 0% 0%, 0% 100%, from(#a67587cc ), to( #86556755 ) );";
		$( "#mit" ).SetParent($( "#mit" ).GetParent().GetParent().GetParent().GetParent());
		
		$.Schedule( .1, SetMitten );
	}
	else if(data.team_number== 2)
	{
		if(Game.GetLocalPlayerInfo().player_team_id==2)
		{
			$( "#WinOrLose" ).text = $.Localize("#winner")
		}
		else
		{
			$( "#WinOrLose" ).text = $.Localize("#loser")
		}
		$( "#sto" ).style.visibility="visible";
			$("#ScoreBoardFinalholder").style.backgroundColor="gradient( linear, 0% 0%, 0% 100%, from(#86c597cc ), to( #465a6755) );";
	$( "#sto" ).SetParent($( "#sto" ).GetParent().GetParent().GetParent().GetParent());
		$.Schedule( .1, SetStocking );
	}
		$( "#ScoreBoardFinalholder" ).style.visibility="visible";
	$( "#ScoreBoardFinalholder" ).SetParent($( "#ScoreBoardFinalholder" ).GetParent().GetParent().GetParent().GetParent());
}

function SetStocking()
{
			
			if($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd"))
			{
				var vicLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd").FindChildTraverse("WinLabelContainer").FindChildTraverse("VictoryLabel");
				$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd").FindChildTraverse("WinLabelContainer").style.visibility="collapse";
				vicLabel.text = "Team Stocking"
			}
		 $.Schedule( .1, SetStocking );
}

function SetMitten()
{
			if($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd"))
			{
					var vicLabel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd").FindChildTraverse("WinLabelContainer").FindChildTraverse("VictoryLabel");
				$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("GameEndContainer").FindChildTraverse("GameEnd").FindChildTraverse("WinLabelContainer").style.visibility="collapse";
				vicLabel.text = "Team Mitten"
			}
		 $.Schedule( .1, SetMitten );
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
				$( "#BadPoints" ).text = data.bad_score-10;
				$( "#GoodPoints" ).text =  data.good_score-10;
			
			var goodToSort = goodTeamScores
			var badToSort = badTeamScores
			if(goodToSort.length>0)
			{
				var count = 0
				goodToSort.sort(compareSecondColumn);
				goodToSort.forEach(function(element) 
				{
					count++;
					
					$( "#goodScoreName" + count ).text =element[0];
					$( "#goodScorePoints" + count ).text = element[1] ;
					$( "#goodScoreChain" + count ).text = "("+element[2]+")" ;
					$( "#goodScoreKills" + count ).text =element[4];
					$( "#goodScoreName" + count ).style.color = PlayerColors[ element[3]]
					$( "#goodScorePoints" + count ).style.color = PlayerColors[ element[3]]
					$( "#goodScoreKills" + count ).style.color = PlayerColors[ element[3]]
					$( "#goodScoreChain" + count ).style.color = PlayerColors[ element[3]]
				});
			}
			if(badToSort.length>0)
			{
				var count = 0
				badToSort.sort(compareSecondColumn);
				badToSort.forEach(function(element) 
				{
					count++;
					
					$( "#badScoreName" + count ).text =element[0];
					$( "#badScorePoints" + count ).text = element[1];
					$( "#badScoreChain" + count ).text = "("+element[2]+")";
					$( "#badScoreKills" + count ).text =element[4];
					$( "#badScoreName" + count ).style.color = PlayerColors[ element[3]]
					$( "#badScorePoints" + count ).style.color = PlayerColors[ element[3]]
					$( "#badScoreKills" + count ).style.color = PlayerColors[ element[3]]
					$( "#badScoreChain" + count ).style.color = PlayerColors[ element[3]]

				});
			}
			overallScore= goodTeamScores.concat(badTeamScores)
			goodTeamScores = []
 
			badTeamScores = []
			
			
	}
	/**function ShowScore(data)
	{
		var totalSccore = data.good_score+data.bad_score

		
		 var tGameTime = (Math.floor(data.Game_Time/60)) + ":" + (data.Game_Time % 60 >= 10 ? "": "0") +  (data.Game_Time % 60);    
		$( "#TimeLeft" ).text = tGameTime;
		targetDeg =  data.good_score/totalSccore*180-90
			$.Schedule( .1, GoToScore );
				$( "#BadPoints" ).text = data.bad_score-10;
				$( "#GoodPoints" ).text =  data.good_score-10;
			
			var goodToSort = goodTeamScores
			var badToSort = badTeamScores
			if(goodToSort.length>0)
			{
				var count = 0
				goodToSort.sort(compareSecondColumn);
				goodToSort.forEach(function(element) 
				{
					count++;
					if(element[0].length>20)
					{
						var name = element[0].substring(0,20)
					}
					else
					{
						name = element[0]
						while(name.length<19)
						{
							name=name+" "
						}
					}
					var spaces="        "
					if(element[1]>9)
					{
						spaces="       "
					}
					if(element[1]>99)
					{
						spaces="      "
					}
					$( "#goodScore" + count ).text =name + " " + element[1] + spaces+"(" +element[2]+")           "+ element[4] ;
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
					if(element[0].length>20)
					{
						var name = element[0].substring(0,20)
					}
					else
					{
						name = element[0]
						while(name.length<19)
						{
							name=name+" "
						}
					}
					var spaces="        "
					if(element[1]>9)
					{
						spaces="       "
					}
					if(element[1]>99)
					{
						spaces="      "
					}
						$( "#badScore" + count ).text =name + " " + element[1] + spaces+"(" +element[2]+")           "+ element[4] ;
					$( "#badScore" + count ).style.color = PlayerColors[ element[3]]
				});
			}
			
			goodTeamScores = []
 
			badTeamScores = []
			
			
	}**/
	var soundHandle
	var musicPlayingTime=0
	function toggleMusic()
	{
		if($( "#bellgrey" ).style.visibility=="visible" || $( "#bellgrey" ).style.visibility == null)
		{
			$( "#bell" ).style.visibility="visible";
			$( "#bellgrey" ).style.visibility="collapse";
			soundHandle= Game.EmitSound("ThemeSong");
			musicPlayingTime = Game.GetGameTime()
			$.Schedule( 68, continueMusic );
				
		}
		else
		{
			$( "#bellgrey" ).style.visibility="visible";
			$( "#bell" ).style.visibility="collapse";
			Game.StopSound(soundHandle);
		}
	}
	function continueMusic()
	{
		if($( "#bellgrey" ).style.visibility=="collapse")
		{
				if(Game.GetGameTime()-musicPlayingTime>66.5)
				{
					soundHandle= Game.EmitSound("ThemeSong");
					$.Schedule( 68, continueMusic );
					musicPlayingTime = Game.GetGameTime()
				}
		}
	}
	var fadebelltimer = 11
	function showbelltooltip()
	{
		fadebelltimer -= 1
		if (fadebelltimer == 10)
		{
			$("#belltooltip").style.opacity=".9";
			$.Schedule(1.5, showbelltooltip)
			
		}
		else if (fadebelltimer < 10 && fadebelltimer > 0)
		{
			$("#belltooltip").style.opacity=$("#belltooltip").style.opacity-.1;
			$.Schedule(.1, showbelltooltip)
		}
		else if (fadebelltimer == 0)
		{
			fadebelltimer = 11
			$("#belltooltip").style.opacity=0;
		}

	}
	var fadeabilitytimer = 15
	
	function showabilitytooltip()
	{
		fadeabilitytimer -= 1
		if (lastability=="skate")
		{
			$( "#abilityhover" ).text = $.Localize("#SkateInfo_lang")+$.Localize("#to_activate_lang");
		}
		if (lastability=="snowball")
		{
			$( "#abilityhover" ).text = $.Localize("#SnowballInfo_lang")+$.Localize("#to_activate_lang");
		}
		if (lastability=="magnet")
		{
			$( "#abilityhover" ).text = $.Localize("#MagnetInfo_lang")+$.Localize("#to_activate_lang");
			$( "#abilityhover" ).text = $.Localize("#MagnetInfo_lang")+$.Localize("#to_activate_lang");
		}	
		if (lastability=="leap")
		{
			$( "#abilityhover" ).text = $.Localize("#LeapInfo_lang")+$.Localize("#to_activate_lang");
		}
		if (lastability=="none")
		{
			$( "#abilityhover" ).text = $.Localize("#closed_tooltip_lang");
		}
		if (fadeabilitytimer > 9)
		{
			$("#abilitytooltip").style.opacity=".9";
			$.Schedule(.2, showabilitytooltip)
			
		}
		else if (fadeabilitytimer < 10 && fadeabilitytimer > 0)
		{
			$("#abilitytooltip").style.opacity=$("#abilitytooltip").style.opacity-.1;
			$.Schedule(.1, showabilitytooltip)
		}
		else if (fadeabilitytimer == 0)
		{
			fadeabilitytimer = 15
			$("#abilitytooltip").style.opacity=0;
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
	
	
	
	


function ToggleSB()
{
	$.Msg("sb toggled");
	$( "#SBToggle" ).ToggleClass("droppedDown")
	$( "#BigHolder" ).ToggleClass("droppedDown")

	
	$( "#SBToggle" ).ToggleClass("poppedUp")
	$( "#BigHolder" ).ToggleClass("poppedUp")


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
var hasability = false;
var lastability = "none";
function SwapAbility(data)
{
	if(data.player_id==Players.GetLocalPlayer())
	{
			$( "#presentclosed" ).style.opacity=0;
			$( "#presentopen" ).style.opacity=0;
			$( "#rocketskate" ).style.opacity=0;
			$( "#magnet" ).style.opacity=0;
			$( "#snowball" ).style.opacity=0;
			$( "#leap" ).style.opacity=0;
			if(data.ability_name == "Rocket_Boots")
			{
				
				lastability = "skate";
				hasability = true;
				$("#presentopen").style.opacity=1;
				$("#Hotkey").style.visibility="visible";
				//$.Msg("skate fade if")
				SkateIn()

			}
			if(data.ability_name == "Magnet")
			{
				
				lastability = "magnet";
				hasability = true;
				$("#presentopen").style.opacity=1;
				$("#Hotkey").style.visibility="visible";
				//$.Msg("magnet fade if")
				MagnetIn()


			}
			if(data.ability_name == "Snow_Ball")
			{
				
				lastability = "snowball";
				hasability = true;
				$("#presentopen").style.opacity=1;
				$("#Hotkey").style.visibility="visible";
				//$.Msg("snow fade if")
				SnowIn()

			}
			if(data.ability_name == "leap")
			{
				
				lastability = "leap";
				hasability = true;
				$("#presentopen").style.opacity=1;
				$("#Hotkey").style.visibility="visible";
				//$.Msg("snow fade if")
				LeapIn()
				

			}
			
			if(data.ability_name == "cast_ability" && hasability==true)
			{
				//$( "#presentclosed" ).style.opacity=1;
				hasability = false;
				UseAbility()
				lastability="none";
				//$("#hotkeyframe").style.visibility="collapse";
			}
			else
			{

					$("#Hotkey").text = Abilities.GetKeybind(Entities.GetAbility( Game.GetPlayerInfo(Players.GetLocalPlayer() ).player_selected_hero_entity_index, 0))
					$( "#presentclosed" ).style.opacity=1;
					$("#hotkeyframe").style.visibility="collapse";
			}
			
	}
}
function SkateIn()
{
	//$("#rocketskate").style.opacity=$("#rocketskate").style.opacity-.1+.2;
	//$("#presentopen").style.opacity=$("#presentopen").style.opacity-.1+.2;
	if($("#rocketskate").style.opacity<1 && hasability == true && lastability == "skate")
	{
		$("#hotkeyframe").style.visibility="visible";
		$("#rocketskate").style.opacity=$("#rocketskate").style.opacity-.1+.2;
		$.Schedule( .1, SkateIn );	
		
	}

}
function MagnetIn()
{
	
	//$("#presentopen").style.opacity=$("#presentopen").style.opacity-.1+.2;
	if($("#magnet").style.opacity<1 && hasability == true && lastability == "magnet")
	{
	$("#hotkeyframe").style.visibility="visible";	
	$("#magnet").style.opacity=$("#magnet").style.opacity-.1+.2;
		$.Schedule( .1, MagnetIn );	
		
	}

}
function SnowIn()
{
	
	//$("#presentopen").style.opacity=$("#presentopen").style.opacity-.1+.2;
	if($("#snowball").style.opacity<1 && hasability == true && lastability == "snowball")
	{
		$("#hotkeyframe").style.visibility="visible";
		$("#snowball").style.opacity=$("#snowball").style.opacity-.1+.2;
		$.Schedule( .1, SnowIn );	
		
	}

}

function LeapIn()
{
	
	//$("#presentopen").style.opacity=$("#presentopen").style.opacity-.1+.2;
	if($("#leap").style.opacity<1 && hasability == true && lastability == "leap")
	{
		$("#hotkeyframe").style.visibility="visible";
		$("#leap").style.opacity=$("#leap").style.opacity-.1+.2;
		$.Schedule( .1, LeapIn );	
		
	}

}

//this horrible mess makes the items bulge when they are used.

var imagePanel={}
function UseAbility()
{
	if (lastability == "skate" && hasability == false)
	{
		imagePanel = $("#rocketskate")
		
	}
	if (lastability == "snowball" && hasability == false)
	{
		imagePanel = $("#snowball")

	}
	
	if (lastability == "leap" && hasability == false)
	{
		imagePanel = $("#leap")

	}
	
	if (lastability == "magnet" && hasability == false)
	{
		imagePanel = $("#magnet")
	}
		imagePanel.style.opacity=1;
		$("#presentopen").style.opacity=1;
		imagePanel.ToggleClass("pulsing")
		lastability="none"
		$.Schedule( .6, finishPulse );
		

			

}

var finishCalls = 0
function finishPulse()
{
	imagePanel.ToggleClass("pulsing")
	imagePanel.style.opacity=0;
		
		if(lastability=="none")
		{
			$( "#presentclosed" ).style.opacity=1;
			$("#hotkeyframe").style.visibility="collapse";
			$("#presentopen").style.opacity=0;
			$( "#presentopen" ).style.opacity=0;
			$( "#rocketskate" ).style.opacity=0;
			$( "#magnet" ).style.opacity=0;
			$( "#snowball" ).style.opacity=0;		
			$( "#leap" ).style.opacity=0;	
			$("#hotkeyframe").style.visibility="collapse";
			$("#Hotkey").style.visibility="collapse";
			$( "#presentclosed" ).style.opacity=1;
			finishCalls = 0
			hasability = false;
		}
		else if( finishCalls < 2)
		{
			$.Schedule( .1, finishPulse );
			finishCalls++;
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
	if( Players.GetTeam( data.player_id )	== 3)
	{
		goodTeamScores[data.player_id] = [data.player_name, data.delivered, data.heald , data.player_id ,  data.kills]
	}
	else if(Players.GetTeam( data.player_id ) == 2)
	{
		badTeamScores[data.player_id] = [data.player_name, data.delivered, data.heald, data.player_id , data.kills  ]
	}
	
}

// Handle Left Button events
function OnLeftButtonPressed()
{
	//$.Msg("LEFT BUTTON CAST")
}



		(function () {
		 
	GameEvents.Subscribe("Player_Spawned", fixUI );
	GameEvents.Subscribe("Score_data", ShowScore );
	GameEvents.Subscribe("grant_ability", SwapAbility );
	GameEvents.Subscribe( "ping_loc", PingLoc );
	GameEvents.Subscribe( "snowball_hit", SnowHit );
	GameEvents.Subscribe("score_info", UpdatePlayerInfo );
	GameEvents.Subscribe("team_win", TeamWin );
	
	
	GameEvents.Subscribe( "top_notification", TopNotification );
	GameEvents.Subscribe( "bottom_notification", BottomNotification );
	GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
	GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
	$.Msg("done subscribe");
	
})();