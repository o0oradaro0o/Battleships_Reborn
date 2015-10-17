"use strict";
var hidden=true;
var hiddenship=true;
var showMission=[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
var firstcall=true;
var starttime=0;
function hideTrade()
{
	var numbuildings=0;
	var i=0;
	for (var shop in Entities.GetAllEntities()) 
	{
		i++;
		if(Entities.IsBuilding( i ) && !Entities.IsTower(i))
		{
			numbuildings++;
		}
	}
	if (numbuildings<15)
	{
		$( "#missionButton" ).style.visibility="collapse";
		$( "#ConstStatusRow1" ).style.visibility="collapse";
		$( "#TempStatusRow1" ).style.visibility="collapse";
		$( "#ConstStatusRow2" ).style.visibility="collapse";
		$( "#TempStatusRow2" ).style.visibility="collapse";
	}
	else{
		$( "#missionButton" ).style.visibility="visible";
	}
	
	$.Msg("buildings: "+numbuildings);
}





function showShips()
{
	hideShop()
	if(	hiddenship)
		{
			$( "#ship_shop" ).style.visibility="visible";
			hiddenship=false;
		}
	else
		{
			hideShipShop();
		}
	
}

function showShipsNoHide()
{
	hideShop()
	if(	hiddenship)
		{
			$( "#ship_shop" ).style.visibility="visible";
			hiddenship=false;
		}

}

function show1ks()
{
	$.Msg($( "#one_ks" ).style.height);
	if ($( "#one_ks" ).style.height=="180.0px")
	{
		$( "#one_ks" ).style.height = "0px";

	}
	else
	{
		$( "#one_ks" ).style.height = "180px";
		$( "#three_ks" ).style.height = "0px";
		$( "#six_ks" ).style.height = "0px";
		$( "#ten_ks" ).style.height = "0px";
			$( "#trader_ships" ).style.height = "0px";
	}
}


function show3ks()
{
	$.Msg($( "#three_ks" ).style.height);
	if ($( "#three_ks" ).style.height=="180.0px")
	{
		$( "#three_ks" ).style.height = "0px";

	}
	else
	{
		$( "#three_ks" ).style.height = "180px";
		$( "#one_ks" ).style.height = "0px";
		$( "#six_ks" ).style.height = "0px";
		$( "#ten_ks" ).style.height = "0px";
			$( "#trader_ships" ).style.height = "0px";
	}
}
function show6ks()
{
	$.Msg($( "#six_ks" ).style.height);
	if ($( "#six_ks" ).style.height=="180.0px")
	{
		$( "#six_ks" ).style.height = "0px";

	}
	else
	{
		$( "#six_ks" ).style.height = "180px";
			$( "#one_ks" ).style.height = "0px";
		$( "#three_ks" ).style.height = "0px";
		$( "#ten_ks" ).style.height = "0px";
			$( "#trader_ships" ).style.height = "0px";
	}
}
function show10ks()
{
	$.Msg($( "#ten_ks" ).style.height);
	if ($( "#ten_ks" ).style.height=="180.0px")
	{
		$( "#ten_ks" ).style.height = "0px";

	}
	else
	{
		$( "#ten_ks" ).style.height = "180px";
			$( "#one_ks" ).style.height = "0px";
		$( "#three_ks" ).style.height = "0px";
		$( "#six_ks" ).style.height = "0px";
			$( "#trader_ships" ).style.height = "0px";
	}
}
function showtraders()
{
	$.Msg($( "#trader_ships" ).style.height);
	if ($( "#trader_ships" ).style.height=="180.0px")
	{
		$( "#trader_ships" ).style.height = "0px";

	}
	else
	{
		$( "#trader_ships" ).style.height = "180px";
			$( "#one_ks" ).style.height = "0px";
		$( "#three_ks" ).style.height = "0px";
		$( "#six_ks" ).style.height = "0px";
			$( "#ten_ks" ).style.height = "0px";
	}
}



function showText(BoatName,AbilityName)
{
	$.Msg(AbilityName);
	$( "#"+BoatName+"_ability" ).text=$.Localize("#"+AbilityName);
	$( "#"+BoatName+"_ability_desc" ).text=$.Localize("#"+AbilityName+"_Description");
	
	
}
function showDetails(BoatName)
{
	
	$.Msg(BoatName);
	if ($( "#"+BoatName ).style.height=="650.0px")
	{
		$(  "#"+BoatName ).style.height = "0px";
		$("#ancient_apparition").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#disruptor").style.height = "0px";
		$("#morphling").style.height = "0px";
		$("#storm_spirit").style.height = "0px";
		$("#nevermore").style.height = "0px";
		$("#lion").style.height = "0px";
		$("#meepo").style.height = "0px";
		$("#jakiro").style.height = "0px";
		$("#ember_spirit").style.height = "0px";
		$("#slark").style.height = "0px";
		$("#sniper").style.height = "0px";
		$("#visage").style.height = "0px";
		$("#ursa").style.height = "0px";
		$("#tusk").style.height = "0px";
		$("#windrunner").style.height = "0px";
		$("#pugna").style.height = "0px";
		$("#rattletrap").style.height = "0px";
		$("#tidehunter").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#phantom_lancer").style.height = "0px";
		$("#vengefulspirit").style.height = "0px";
		$("#bane").style.height = "0px";
		$("#enigma").style.height = "0px";
		

	}
	else
	{
		$("#ancient_apparition").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#disruptor").style.height = "0px";
		$("#morphling").style.height = "0px";
		$("#storm_spirit").style.height = "0px";
		$("#nevermore").style.height = "0px";
		$("#lion").style.height = "0px";
		$("#meepo").style.height = "0px";
		$("#jakiro").style.height = "0px";
		$("#ember_spirit").style.height = "0px";
		$("#slark").style.height = "0px";
		$("#sniper").style.height = "0px";
		$("#visage").style.height = "0px";
		$("#ursa").style.height = "0px";
		$("#tusk").style.height = "0px";
		$("#windrunner").style.height = "0px";
		$("#pugna").style.height = "0px";
		$("#rattletrap").style.height = "0px";
		$("#tidehunter").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#phantom_lancer").style.height = "0px";
			$("#vengefulspirit").style.height = "0px";
			$("#bane").style.height = "0px";
			$("#enigma").style.height = "0px";
		$(  "#"+BoatName ).style.height = "650px";
	}
	
}




function buyBoat(BoatName, cost)
{
	GameEvents.SendCustomGameEventToServer( "buyBoat", { "text": BoatName, "cost": cost}); 
	$(  "#"+BoatName ).style.height = "0px";
}






	function fillAndShow()
	{
		$.Msg("inside fillAndShow");
		hideShipShop()
		if(	hidden)
		{
			var heroloc = Entities.GetAbsOrigin(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()));
			
			var closeEnough=false;
			var nearistShop;
			var i=0;
			for (var shop in Entities.GetAllEntities()) 
			{
				i++;
				if(Entities.IsBuilding( i )  && !Entities.IsTower(i))
				{
					var bldgloc=Entities.GetAbsOrigin(i);
					if(bldgloc)
					{
						var dist=Math.sqrt(Math.pow(heroloc[0]-bldgloc[0],2)+Math.pow(heroloc[1]-bldgloc[1],2))
						if(dist<600)
						{
							closeEnough=true;
							nearistShop=i;
						}
					}
				}
			}
			$.Msg(nearistShop);
			if(closeEnough)
			{
				hidden=false;
				if(heroloc[0]>3000)
				{
					if(heroloc[1]<-2000)
					{
						$( "#right_bot_shop" ).style.visibility="visible";
						Game.EmitSound("crystalmaiden_cm_respawn_01");
					}
					else if(heroloc[1]>2000)
					{
							$( "#right_top_shop" ).style.visibility="visible";
							Game.EmitSound("announcer_dlc_stormspirit_announcer_ally_pos_09");
					}
					else
					{
						$( "#right_mid_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_dlc_bastion_announcer_welcome_01");
					}
				}
				else if(heroloc[0]<-2800)
				{
					 if(heroloc[1]<-2000)
					{
						$( "#left_bot_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_dlc_lina_announcer_followup_neg_progress_05");
					}
					else if(heroloc[1]>2000)
					{
						$( "#left_top_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_dlc_bristleback_bris_ann_negative_event_03");
					}
					else
					{
						$( "#left_mid_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_dlc_workshop_pirate_announcer_capn_misc2");
					}
				}
				else
				{
					if(heroloc[1]<-2000 && heroloc[1]>-5000 )
					{
						$( "#mid_bot_shop" ).style.visibility="visible";
						Game.EmitSound("death_prophet_dpro_move_14");
						
					}
					else if(heroloc[1]>2000 && heroloc[1]<5000)
					{
						$( "#mid_top_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_dlc_axe_announcer_ally_pos_11");
					}
					else if(heroloc[1]<5000  && heroloc[1]>-5000)
					{
						$( "#mid_mid_shop" ).style.visibility="visible";
						Game.EmitSound("announcer_announcer_welcome_04");
						
					}
					else
					{
						$( "#empty_guts" ).style.visibility="visible";
						hidden=false;
						$.Schedule( 4.0, hideShop );
					}
				}
				hideMissionsIfNeeded();
			}
			else
			{
				$( "#empty_guts" ).style.visibility="visible";
				hidden=false;
				$.Schedule( 4.0, hideShop );
			}
		}
		else
		{
			hideShop();
		}
	}
	function hideShipShop(data)
	{
		if (Players.GetLocalPlayer() == data.splitscreenplayer)
		{
			 hideShipShop();
		 }
	}
	function hideShop()
	{
		hidden=true;
		$.Msg("inhide");
		$( "#left_top_shop" ).style.visibility="collapse";
		$( "#left_bot_shop" ).style.visibility="collapse";
		$( "#left_mid_shop" ).style.visibility="collapse";
		$( "#right_top_shop" ).style.visibility="collapse";
		$( "#right_bot_shop" ).style.visibility="collapse";
		$( "#right_mid_shop" ).style.visibility="collapse";
		$( "#mid_top_shop" ).style.visibility="collapse";
		$( "#mid_bot_shop" ).style.visibility="collapse";
		$( "#mid_mid_shop" ).style.visibility="collapse";
		$( "#empty_guts" ).style.visibility="collapse";

		Game.EmitSound("ui.chat_close");
		
		
	}
	
		function hideShipShop()
	{
		hiddenship=true;
		$.Msg("inhide");
		$( "#ship_shop" ).style.visibility="collapse";
		$("#ancient_apparition").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#disruptor").style.height = "0px";
		$("#morphling").style.height = "0px";
		$("#storm_spirit").style.height = "0px";
		$("#nevermore").style.height = "0px";
		$("#lion").style.height = "0px";
		$("#meepo").style.height = "0px";
		$("#jakiro").style.height = "0px";
		$("#ember_spirit").style.height = "0px";
		$("#slark").style.height = "0px";
		$("#sniper").style.height = "0px";
		$("#visage").style.height = "0px";
		$("#ursa").style.height = "0px";
		$("#tusk").style.height = "0px";
		$("#windrunner").style.height = "0px";
		$("#pugna").style.height = "0px";
		$("#rattletrap").style.height = "0px";
		$("#tidehunter").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#phantom_lancer").style.height = "0px";
			$("#vengefulspirit").style.height = "0px";
			$("#bane").style.height = "0px";
			$("#enigma").style.height = "0px";
			
		Game.EmitSound("ui.chat_close");
		
		
	}
	function hideMissionsIfNeeded()
	{
		$.Msg("inhideMission");
		$.Msg(Players.GetLocalPlayer());
		$.Msg(showMission[Players.GetLocalPlayer()]);
		if(showMission[Players.GetLocalPlayer()]==1)
		{
			$( "#mission_hider_1" ).style.height="200px";
			$( "#mission_hider_2" ).style.height="200px";
			$( "#mission_hider_3" ).style.height="200px";
			$( "#mission_hider_4" ).style.height="200px";
			$( "#mission_hider_5" ).style.height="200px";
			$( "#mission_hider_6" ).style.height="200px";
			$( "#mission_hider_7" ).style.height="200px";
			$( "#mission_hider_8" ).style.height="200px";
			$( "#mission_hider_9" ).style.height="200px";
		}
		else
		{	
	
			$( "#mission_hider_1" ).style.height="0px";
			$( "#mission_hider_2" ).style.height="0px";
			$( "#mission_hider_3" ).style.height="0px";
			$( "#mission_hider_4" ).style.height="0px";
			$( "#mission_hider_5" ).style.height="0px";
			$( "#mission_hider_6" ).style.height="0px";
			$( "#mission_hider_7" ).style.height="0px";
			$( "#mission_hider_8" ).style.height="0px";
			$( "#mission_hider_9" ).style.height="0px";
		}
		if (showMission[Players.GetLocalPlayer()]==-1)
		{
			$( "#must_be_trader_1" ).style.height="200px";
			$( "#must_be_trader_2" ).style.height="200px";
			$( "#must_be_trader_3" ).style.height="200px";
			$( "#must_be_trader_4" ).style.height="200px";
			$( "#must_be_trader_5" ).style.height="200px";
			$( "#must_be_trader_6" ).style.height="200px";
			$( "#must_be_trader_7" ).style.height="200px";
			$( "#must_be_trader_8" ).style.height="200px";
			$( "#must_be_trader_9" ).style.height="200px";
		}
		else{
			$( "#must_be_trader_1" ).style.height="0px";
			$( "#must_be_trader_2" ).style.height="0px";
			$( "#must_be_trader_3" ).style.height="0px";
			$( "#must_be_trader_4" ).style.height="0px";
			$( "#must_be_trader_5" ).style.height="0px";
			$( "#must_be_trader_6" ).style.height="0px";
			$( "#must_be_trader_7" ).style.height="0px";
			$( "#must_be_trader_8" ).style.height="0px";
			$( "#must_be_trader_9" ).style.height="0px";
		}
		
	}
	function reHideOutOfContracts()
	{
		$( "#out_of_contracts" ).style.visibility="collapse";
		
		//$( "#out_of_contracts" ).SetHasClass( "new_contract", false );
	}
	
	
	function donate(amount)
	{
		GameEvents.SendCustomGameEventToServer( "donate_"+amount, { "text": 'fooBar',}); 
	}
	
	function GiveEasy()
	{
		GameEvents.SendCustomGameEventToServer( "GiveEasy", { "text": 'fooBar',}); 
			
	}
	
	function GiveMedium()
	{
		GameEvents.SendCustomGameEventToServer( "GiveMedium", { "text": 'fooBar',}); 
	}
	
	function Unstick(data)
	{
			$.Msg("in unstick");
		GameEvents.SendCustomGameEventToServer( "Unstick", { "text": 'fooBar',}); 
	
	}
	
	
	var ticksSinceChanged=0
	function handleZoom()
	{
		//get the current zoom number
		var oldval=$("#zoomLblVal").text
		//get the percentage of the slider bar that is filled
		var zoomPer = Math.floor($("#ZoomSlider").GetChild(1).GetChild(1).actuallayoutwidth/($("#ZoomSlider").GetChild(1).GetChild(0).actuallayoutwidth-20)*100)
		
		//if it is not the same as the old zoom value, zoom to it otherwise wait and slowly fade out the zoom box
		//set the +1800 to your min zoom and 1800+2200 will be your max zoom
		if($("#zoomLblVal").text!=zoomPer/100*1300+1800)
		{
			GameUI.SetCameraDistance(zoomPer/100*1300+1800)

			$("#zoomLblVal").text=zoomPer/100*1300+1800;
			ticksSinceChanged=0;
				$("#ZoomSliderBox").style.opacity=1;
		}
		else{
			ticksSinceChanged++;
		}
		if(ticksSinceChanged>60)
		{
			 $("#ZoomSliderBox").style.opacity=$("#ZoomSliderBox").style.opacity-.04;
		}
		if($("#ZoomSliderBox").style.opacity==0)
		{
			toggleZoom();
		}
		//re-call self (i could not find an "onSliderValueChanged" so i resorted to this
		if($("#ZoomSliderBox").style.visibility=="visible")
		{
				$.Schedule( .05, handleZoom );
		}
	}
	
	function setZoom()
	{
		GameUI.SetCameraDistance(1800)
	}
	function toggleZoom()
	{
		if($("#ZoomSliderBox").style.visibility=="visible")
		{
				$("#ZoomSliderBox").style.visibility="collapse";
		}
		else
		{
				$("#ZoomSliderBox").style.visibility="visible";
				ticksSinceChanged=0;
				$("#ZoomSliderBox").style.opacity=1;
				handleZoom();
		}
		
		
	}
	
	
	(function () {
		hideTrade();
	$.Msg("in subscribe");
	GameEvents.Subscribe( "Hero_Near_Shop", NearShop );
	GameEvents.Subscribe( "Hero_Near_Ship_Shop", hideShipShop );
	GameEvents.Subscribe( "Hero_Left_Shop", LeftShop );
	GameEvents.Subscribe( "Team_Can_Buy", CanBuy );
    GameEvents.Subscribe( "Team_Cannot_Buy", CannotBuy );
	GameEvents.Subscribe( "ping_loc", PingLoc );
	GameEvents.Subscribe( "bsui_timer_data", OnBsuiTimer );

	
	GameEvents.Subscribe( "top_notification", TopNotification );
	GameEvents.Subscribe( "bottom_notification", BottomNotification );
	GameEvents.Subscribe( "top_remove_notification", TopRemoveNotification );
	GameEvents.Subscribe( "bottom_remove_notification", BottomRemoveNotification );
	$.Msg("done subscribe");
	
})();

	function test(data)
	{
			$.Msg("data");
	$.Msg(data);
	
	}
	function OnBsuiTimer(eventData)
	{
		if(firstcall)
		{
			firstcall=false;
			starttime=Game.GetDOTATime(true,true);
		}
		var tEmpire = (Math.floor(eventData.nEmpire/60)) + ":" + (eventData.nEmpire % 60 >= 10 ? "": "0") +  (eventData.nEmpire % 60);                 
		var tCreep = (Math.floor(eventData.nCreep/60)) + ":" + (eventData.nCreep % 60 >= 10 ? "": "0") +  (eventData.nCreep % 60);  
		var t=Game.GetDOTATime( true, true )-starttime;
		var tGameTime = (Math.floor(t/60)) + ":" + (t % 60 >= 10 ? "": "0") +  Math.floor(t % 60);                 
		
		
		$( "#GameTimeVal" ).text = tGameTime;
		$( "#CreepSpawnVal" ).text = tCreep;
		$( "#EmpireGoldVal" ).text = tEmpire;
		$( "#NorthEmpVal" ).text = eventData.nNorthGold;
		$( "#SouthEmpVal" ).text = eventData.nSouthGold;
		
	}
	
	function buyItem(itemName, cost)
	{
		if(showMission[Players.GetLocalPlayer()]>-1)
		{
			GameEvents.SendCustomGameEventToServer( "buyItem", { "text": itemName, "cost": cost}); 
		}

	}
	function NearShipShop(data)
	{
	
		$.Msg("in near ship");
		if (Players.GetLocalPlayer() == data.Player_ID)
		{
			 showShipsNoHide();
		 }
	}
	function NearShop(data)
	{
	
		$.Msg("in near");
		if (Players.GetLocalPlayer() == data.Player_ID)
		{
			 fillAndShow();
		 }
	
	}
	

	
	function LeftShop(data)
	{
		$.Msg("in left");
		if (Players.GetLocalPlayer() == data.Player_ID)
		{
			 hideShop();
		 }
	}
	
	function CanBuy(data)
	{
		$.Msg("can buy");
		
			showMission[ data.Player_ID]=1;
			hideMissionsIfNeeded()
		
	}
	
	function CannotBuy(data)
	{
		$.Msg("cannot buy");
		$.Msg("pid "+data.Player_ID);
			showMission[ data.Player_ID]=0;
			hideMissionsIfNeeded();
			
			
			if(showMission[Players.GetLocalPlayer()]==0)
			{
				$.Msg(data);
				var v=[data.x,data.y,data.z]
				if(data.x<999999)
				{
				GameUI.PingMinimapAtLocation(v);
				}
				showMission[Players.GetLocalPlayer()]=data.Ally_ID;
				if(data.Ally_ID == 0)
				{
					$( "#out_of_contracts" ).style.visibility="visible";
					$.Schedule( 4, reHideOutOfContracts );
				}
			}
		
	}
function PingLoc(data)
	{
	$.Msg(data);
			showMission[ data.player_id]=0;
			if(showMission[Players.GetLocalPlayer()]==0)
			{
				
				var v=[data.x,data.y,data.z]
				GameUI.PingMinimapAtLocation(v);
				showMission[Players.GetLocalPlayer()]=-1;
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






var CONSUME_EVENT = true;
var CONTINUE_PROCESSING_EVENT = false;

// Handle Left Button events
function OnLeftButtonPressed()
{
	//$.Msg("LEFT BUTTON CAST")
}



// Handle Right Button events
// Find any entities right-clicked on
// if the units are invuln, modify the right-click behaviour
function OnRightButtonPressed()
{
	//$.Msg("RIGHT BUTTON CAST")
	var localHeroIndex = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() );
	var mouseEntities = GameUI.FindScreenEntities( GameUI.GetCursorPosition() );
	mouseEntities = mouseEntities.filter( function(e) { return e.entityIndex != localHeroIndex; } );

	var accurateEntities = mouseEntities.filter( function( e ) { return e.accurateCollision; } );
	if ( accurateEntities.length > 0 )
	{
		for ( var e of accurateEntities )
		{
			$.Msg("ACCURATE ENTITY")
			if ( Entities.IsDisarmed( e.entityIndex ) )
			{
				//$.Msg("INVULNERABLE UNIT CLICKED")
				fillAndShow();
				return CONSUME_EVENT;
			}
			if ( Entities.IsHexed( e.entityIndex ) )
			{
				//$.Msg("INVULNERABLE UNIT CLICKED")
				showShips();
				return CONSUME_EVENT;
			}
		}
	}

	if ( mouseEntities.length > 0 )
	{
		//$.Msg("ENTITY")
		var e = mouseEntities[0];
		if ( Entities.IsFrozen( e.entityIndex ) )
			{
				//$.Msg("INVULNERABLE UNIT CLICKED")
				fillAndShow();
				return CONSUME_EVENT;
			}
			if ( Entities.IsHexed( e.entityIndex ) )
			{
				//$.Msg("INVULNERABLE UNIT CLICKED")
				showShips();
				return CONSUME_EVENT;
			}
	}

	return CONTINUE_PROCESSING_EVENT;
}


// Main mouse event callback
GameUI.SetMouseCallback( function( eventName, arg ) {

	//$.Msg("MOUSE: ", eventName, " -- ", arg, " -- ", GameUI.GetClickBehaviors())

	if ( GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE )
		return CONTINUE_PROCESSING_EVENT;

	if ( eventName === "pressed" )		
	{
		//$.Msg("MOUSE: ", eventName, " -- ", arg, " -- ", GameUI.GetClickBehaviors())
		if ( arg === 0 )
		{	
			//$.Msg("RIGHT BUTTON CAST")
			return OnRightButtonPressed();
		}
		// on right click, call the right-click function
		if ( arg === 1 )
		{	
			//$.Msg("RIGHT BUTTON CAST")
			return OnRightButtonPressed();
		}
	}
	return CONTINUE_PROCESSING_EVENT;
} );

(function() {
	if (GameUI.CustomUIConfig().DebugMessagesEnabled == true)
		$.Msg("Right Click Override JS Loaded.");
	
})();
	
	
	