"use strict";
var hidden = true;
var tradeHidden = true;
var hiddenship = true;
var showMission = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
var firstcall = true;
var starttime = 0;
var NewShopUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop");
var topBarGoodCont = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar").FindChildTraverse("TopBarRadiantTeam").FindChildTraverse("TopBarRadiantPlayers").FindChildTraverse("RadiantTeamScorePlayers").FindChildTraverse("TopBarRadiantPlayersContainer");
var topBarBadCont = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar").FindChildTraverse("TopBarDireTeam").FindChildTraverse("TopBarDirePlayers").FindChildTraverse("DireTeamScorePlayers").FindChildTraverse("TopBarDirePlayersContainer");

var g_BoatName = ""
var catigoriesUI;

var shipShopShow = false;
function hideTrade() {

	$("#missionButton").style.visibility = "collapse";
	$("#traders_tab").style.height = "40px";
	tradeHidden = true;
}

function showTrade() {
	tradeHidden = false;
	$("#missionButton").style.visibility = "visible";
	$("#traders_tab").style.height = "40px";
}


function resetHeroIcons() {
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer0")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer0").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer1")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer1").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer2")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer2").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer3")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer3").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer4")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer4").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer5")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer5").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer6")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer6").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer7")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer7").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer8")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer8").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer9")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer9").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarGoodCont.FindChildTraverse("RadiantPlayer10")) {
		SetImageForPanel(topBarGoodCont.FindChildTraverse("RadiantPlayer10").FindChildTraverse("SlantedContainerPanel"))
	}

	if (topBarBadCont.FindChildTraverse("DirePlayer0")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer0").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer1")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer1").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer2")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer2").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer3")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer3").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer4")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer4").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer5")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer5").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer6")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer6").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer7")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer7").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer8")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer8").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer9")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer9").FindChildTraverse("SlantedContainerPanel"))
	}
	if (topBarBadCont.FindChildTraverse("DirePlayer10")) {
		SetImageForPanel(topBarBadCont.FindChildTraverse("DirePlayer10").FindChildTraverse("SlantedContainerPanel"))
	}
}


function SetImageForPanel(topBarHeroPanel) {
	topBarHeroPanel.FindChildTraverse("HeroImage").style.opacity = 0.01;
	var heroimage;
	if (!topBarHeroPanel.FindChildTraverse("ReplacmentHeroImage")) {
		heroimage = $.CreatePanel('Image', topBarHeroPanel, 'ReplacmentHeroImage');
		heroimage.AddClass('TopBarHeroImage')
	}
	else {
		heroimage = topBarHeroPanel.FindChildTraverse("ReplacmentHeroImage");
	}
	heroimage.hittest = false
	var heroImageName = "file://{images}/custom_game/Boats/" + topBarHeroPanel.FindChildTraverse("HeroImage").heroname + ".png"
	heroimage.SetImage(heroImageName);
}

function replaceShopUI() {

	if ($.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GuideFlyout").FindChildTraverse("ItemsArea")) {
		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GuideFlyout").FindChildTraverse("ItemsArea").FindChildTraverse("ItemBuildContainer").style.visibility = "visible";


		$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("shop").FindChildTraverse("GuideFlyout").FindChildTraverse("ItemsArea").SetParent(NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter"));

	}
	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("GridMainShop").style.visibility = "collapse";
	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("CommonItems").style.visibility = "collapse";

	catigoriesUI = NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ItemsArea").FindChildTraverse("ItemBuildContainer").FindChildTraverse("ItemBuild").FindChildTraverse("Categories");

	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ItemsArea").FindChildTraverse("ItemBuildContainer").FindChildTraverse("ItemBuild").
		GetChild(0).style.visibility = "collapse";
	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ItemsArea").FindChildTraverse("ItemBuildContainer").FindChildTraverse("ItemBuild").
		GetChild(1).style.visibility = "collapse";


	catigoriesUI.style.flowChildren = "right";
	catigoriesUI.style.marginTop = "55px";
	catigoriesUI.GetChild(0).GetChild(0).style.visibility = "collapse";
	catigoriesUI.GetChild(0).GetChild(1).style.flowChildren = "down";
	catigoriesUI.GetChild(0).GetChild(1).GetChild(11).style.marginTop = "40px";
	catigoriesUI.GetChild(0).style.width = "25%"
	catigoriesUI.GetChild(1).GetChild(0).style.visibility = "collapse";
	catigoriesUI.GetChild(1).GetChild(1).style.flowChildren = "down";
	catigoriesUI.GetChild(1).GetChild(1).GetChild(11).style.marginTop = "40px";
	catigoriesUI.GetChild(1).style.width = "25%"
	catigoriesUI.GetChild(2).GetChild(0).style.visibility = "collapse";
	catigoriesUI.GetChild(2).GetChild(1).style.flowChildren = "down";
	catigoriesUI.GetChild(2).GetChild(1).GetChild(11).style.marginTop = "40px";
	catigoriesUI.GetChild(2).style.width = "25%"
	catigoriesUI.GetChild(3).GetChild(0).style.visibility = "collapse";
	catigoriesUI.GetChild(3).GetChild(1).style.flowChildren = "down";
	catigoriesUI.GetChild(3).GetChild(1).GetChild(11).style.marginTop = "40px";
	catigoriesUI.GetChild(3).style.width = "25%"
}
function fixUI() {
	resetHeroIcons()
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_TIMEOFDAY, false);
	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("CommonItems").style.visibility = "collapse";


	var sidenotif = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("combat_events");

	var topnotif = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("FightRecap");

	var buyback = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("FightRecap");

	var newCenterUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");

	newCenterUI.FindChildTraverse("death_panel_buyback").FindChildTraverse("BuybackButton").style.visibility = "collapse";

	sidenotif.style.visibility = "collapse";
	topnotif.style.visibility = "collapse";


	//---------------------------shop stuff--------------------

	var shipShopShow = false;
	var topBar = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar");
	NewShopUI.FindChildTraverse("GuidesButton").style.visibility = "collapse";
	NewShopUI.FindChildTraverse("GuideFlyout").style.visibility = "collapse";



	//------------------------------hero panel stuff--------------------------------

	//try the neat way to remove the tree itself
	newCenterUI.FindChildTraverse("stats_container").style.visibility = "visible";
	//that bar that grows from level 1 to 25 is annoying
	newCenterUI.FindChildTraverse("AbilitiesAndStatBranch").FindChildTraverse("StatBranch").style.visibility = "collapse";
	//fuck backpack UI
	newCenterUI.FindChildTraverse("inventory").FindChildTraverse("inventory_items").FindChildTraverse("inventory_backpack_list").style.visibility = "collapse";
	//--------------bot right -----------------

	var newBotRightUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("shop_launcher_block");

	newBotRightUI.FindChildTraverse("shop_launcher_bg").style.width = "440px"

	newBotRightUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").FindChildTraverse("courier").style.visibility = "collapse";
	newBotRightUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").FindChildTraverse("ShopButton").style.horizontalAlign = "right";

	newBotRightUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").style.width = "100%";

	newBotRightUI.FindChildTraverse("quickbuy").FindChildTraverse("ShopCourierControls").style.marginRight = "12px";



	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "collapse";

	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "40px"

	if (g_BoatName == "sniper") {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaLabel").style.visibility = "collapse";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	}
	// else if (g_BoatName == "crystal_maiden") {
	// 	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
	// 	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaLabel").style.visibility = "visible";
	// 	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


	// 	newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	// }
	else if (g_BoatName == "razor") {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	}


}
function fillShop() {
	fixUI()
	//closeShipShop()
}




function showShips() {

	$.Msg(NewShopUI.BHasClass("ShopOpen"))
	if (shipShopShow == false) {
		if (!NewShopUI.BHasClass("ShopOpen")) {
			$.DispatchEvent("DOTAHUDToggleShop");
		}
		if (!NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder")) {
			$("#ship_shop_content_holder").SetParent(NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter"));
		}
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").style.visibility = "visible";
		//catigoriesUI.style.visibility="collapse";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("GridMainShop").style.visibility = "collapse";
		shipShopShow = true;
	}
	else {
		$.Msg("callinghidedamn it");
		hideShipShop();
	}
}

function showShipsNoHide() {
	$.Msg("showShipsNoHide");
	hideShop()
	if (hiddenship) {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").style.visibility = "visible";
		hiddenship = false;
	}

}

function show1ks() {


	if (NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height == "240.0px") {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "0px";

	}
	else {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "240px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "0px";
	}
}


function show3ks() {

	if (NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height == "240.0px") {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "0px";

	}
	else {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "240px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "0px";
	}
}
function show6ks() {

	if (NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height == "240.0px") {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "0px";

	}
	else {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "240px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "0px";
	}
}
function show10ks() {

	if (NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height == "240.0px") {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "0px";

	}
	else {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "240px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "0px";
	}
}

function showtraders() {

	if (NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height == "240.0px") {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "0px";

	}
	else if (!tradeHidden) {
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("trader_ships").style.height = "240px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("one_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("three_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("six_ks").style.height = "0px";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("ten_ks").style.height = "0px";
	}
}



function showText(BoatName, AbilityName) {
	$.Msg(AbilityName);
	$("#" + BoatName + "_ability").text = $.Localize("#" + AbilityName);
	$("#" + BoatName + "_ability_desc").text = $.Localize("#" + AbilityName + "_Description");
}

function showDetails(BoatName) {

	$.Msg(BoatName);
	if (BoatName == "hide" || $("#" + BoatName).style.height == "650.0px") {
		$("#ancient_apparition").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#disruptor").style.height = "0px";
		$("#morphling").style.height = "0px";
		$("#storm_spirit").style.height = "0px";
		$("#brewmaster").style.height = "0px";
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
		$("#razor").style.height = "0px";
		$("#rattletrap").style.height = "0px";
		$("#batrider").style.height = "0px";
		$("#tidehunter").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#phantom_lancer").style.height = "0px";
		$("#vengefulspirit").style.height = "0px";
		$("#bane").style.height = "0px";
		$("#enigma").style.height = "0px";
	}
	else {
		$("#ancient_apparition").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#disruptor").style.height = "0px";
		$("#morphling").style.height = "0px";
		$("#storm_spirit").style.height = "0px";
		$("#brewmaster").style.height = "0px";
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
		$("#razor").style.height = "0px";
		$("#rattletrap").style.height = "0px";
		$("#batrider").style.height = "0px";
		$("#tidehunter").style.height = "0px";
		$("#crystal_maiden").style.height = "0px";
		$("#phantom_lancer").style.height = "0px";
		$("#vengefulspirit").style.height = "0px";
		$("#bane").style.height = "0px";
		$("#enigma").style.height = "0px";
		$("#" + BoatName).style.height = "650px";
	}

}


var FadeTrade = true;
var ticksOfFade = 0;
function buyBoat(BoatName, cost) {

	g_BoatName = BoatName
	var newCenterUI = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("lower_hud").FindChildTraverse("center_with_stats").FindChildTraverse("center_block");

	if (BoatName == "sniper") {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaLabel").style.visibility = "collapse";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	}
	else if (BoatName == "crystal_maiden") {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaLabel").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	}
	else if (BoatName == "razor") {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "visible";
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").FindChildTraverse("ManaRegenLabel").style.visibility = "collapse";


		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "20px"
	}
	else {
		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("ManaContainer").style.visibility = "collapse";

		newCenterUI.FindChildTraverse("health_mana").FindChildTraverse("HealthManaContainer").FindChildTraverse("HealthContainer").style.height = "40px"
	}
	
	GameEvents.SendCustomGameEventToServer("buyBoat", { "text": BoatName, "cost": cost });
	$("#" + BoatName).style.height = "0px";
	$.Schedule(.2, setSellValue);
	
	$.Schedule(.2, resetHeroIcons);
}
function setSellValue()
{
	NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").FindChildTraverse("SellValueHoplder").FindChildTraverse("SellValue").text = GetBoatValue(Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer())))*.75 
	
}
function NoFadeMap() {
	$("#empty_guts").style.opacity = 1;
	ticksOfFade = 0
	FadeTrade = false;
}

function okayToFade() {
	$("#empty_guts").style.opacity = 1;
	ticksOfFade = 0
	FadeTrade = true;
}

function GetBoatValue(BoatName) {
	$.Msg(BoatName)

if (BoatName.indexOf("disruptor")!==-1) 
  return 3000
else if (BoatName.indexOf("ursa")!==-1)
  return 12000
else if (BoatName.indexOf("meepo")!==-1) 
  return 6000
else if (BoatName.indexOf("tidehunter")!==-1) 
  return 1000
else if (BoatName.indexOf("apparition")!==-1) 
  return 1000
else if (BoatName.indexOf("rattletrap")!==-1) 
  return 1000
else if (BoatName.indexOf("batrider")!==-1) 
  return 1000
else if (BoatName.indexOf("winter_wyvern")!==-1) 
  return 3000
else if (BoatName.indexOf("storm_spirit")!==-1) 
  return 3000
else if (BoatName.indexOf("brewmaster")!==-1) 
  return 3000
else if (BoatName.indexOf("ember_spirit")!==-1) 
  return 6000
else if (BoatName.indexOf("slark")!==-1) 
  return 6000
else if (BoatName.indexOf("jakiro")!==-1) 
  return 6000
else if (BoatName.indexOf("lion")!==-1) 
  return 3000
else if (BoatName.indexOf("tusk")!==-1) 
  return 12000
else if (BoatName.indexOf("visage")!==-1) 
  return 12000
else if (BoatName.indexOf("nevermore")!==-1) 
  return 3000
else if (BoatName.indexOf("sniper")!==-1) 
  return 6000
else if (BoatName.indexOf("wind")!==-1) 
  return 12000
else if (BoatName.indexOf("crystal")!==-1) 
  return 1000
else if (BoatName.indexOf("phantom")!==-1) 
  return 1000
else if (BoatName.indexOf("vengefulspirit")!==-1) 
  return 750
else if (BoatName.indexOf("enigma")!==-1) 
  return 8000
else if (BoatName.indexOf("bane")!==-1) 
  return 4000
else if (BoatName.indexOf("pugna")!==-1) 
  return 12000
else if (BoatName.indexOf("razor")!==-1) 
  return 12000
else
  return 0
}



function FadeShop() {
	ticksOfFade++;
	if (ticksOfFade > 10 && FadeTrade) {
		$("#empty_guts").style.opacity = $("#empty_guts").style.opacity - .02;
	}
	if ($("#empty_guts").style.opacity == 0) {
		hideShop();
	}
	//re-call self (i could not find an "onSliderValueChanged" so i resorted to this
	if ($("#empty_guts").style.visibility == "visible") {
		$.Schedule(.04, FadeShop);
	}

}
function fillAndShow() {
	$.Msg("inside fillAndShow");
	closeShipShop()
	var heroloc = Entities.GetAbsOrigin(Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer()));
	var closeEnough = false;
	var nearistShop;
	var i = 0;
	var buildings = Entities.GetAllEntitiesByClassname('npc_dota_building')
	for (var i = 0; i < buildings.length; i++) {
	
		if (!Entities.IsTower(buildings[i])) {

			var bldgloc = Entities.GetAbsOrigin((buildings[i]));
			if (bldgloc) {

				var dist = Math.sqrt(Math.pow(heroloc[0] - bldgloc[0], 2) + Math.pow(heroloc[1] - bldgloc[1], 2))
				if (dist < 600) {
					$.Msg("building + " + Entities.IsDisarmed((buildings[i])))
					closeEnough = true;
					nearistShop = buildings[i];
				}
			}
		}
	}
	var hide = true;
	if (Math.abs(heroloc[1]) < 5000 && Math.abs(heroloc[0]) > 1000 && Math.abs(heroloc[0]) < 4000 && closeEnough) {
		$("#side_shop").style.visibility = "visible";
		Game.EmitSound("announcer_dlc_bristleback_bris_ann_negative_event_03");
		$.Msg("showing side shop");
		hide = false;
	}
	else {

		if (hidden && !tradeHidden) {

			$.Msg(nearistShop);
			if (closeEnough) {
				hidden = false;
				if (heroloc[0] > 3000) {
					if (heroloc[1] < -2000) {
						$("#right_bot_shop").style.visibility = "visible";
						Game.EmitSound("crystalmaiden_cm_respawn_01");
					}
					else if (heroloc[1] > 2000) {
						$("#right_top_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_stormspirit_announcer_ally_pos_09");
					}
					else {
						$("#right_mid_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_bastion_announcer_welcome_01");
					}
				}
				else if (heroloc[0] < -2800) {
					if (heroloc[1] < -2000) {
						$("#left_bot_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_lina_announcer_followup_neg_progress_05");
					}
					else if (heroloc[1] > 2000) {
						$("#left_top_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_bristleback_bris_ann_negative_event_03");
					}
					else {
						$("#left_mid_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_workshop_pirate_announcer_capn_misc2");
					}
				}
				else {
					if (heroloc[1] < -2000 && heroloc[1] > -5000) {
						$("#mid_bot_shop").style.visibility = "visible";
						Game.EmitSound("death_prophet_dpro_move_14");

					}
					else if (heroloc[1] > 2000 && heroloc[1] < 5000) {
						$("#mid_top_shop").style.visibility = "visible";
						Game.EmitSound("announcer_dlc_axe_announcer_ally_pos_11");
					}
					else if (heroloc[1] < 5000 && heroloc[1] > -5000 && Math.abs(heroloc[0]) < 1000) {
						$("#mid_mid_shop").style.visibility = "visible";
						Game.EmitSound("announcer_announcer_welcome_04");

					}
					else {
						$("#empty_guts").style.visibility = "visible";
						$("#empty_guts").style.opacity = 1;
						hidden = false;
						$.Schedule(4.0, FadeShop);
					}
				}
				hideMissionsIfNeeded();
			}
			else {
				$("#empty_guts").style.visibility = "visible";
				$("#empty_guts").style.opacity = 1;
				hidden = false;
				$.Schedule(4.0, FadeShop);
			}
		}
		else if (hide) {
			hideShop();
		}
	}
}

function hideShop() {
	hidden = true;
	$.Msg("inhide");
	$("#left_top_shop").style.visibility = "collapse";
	$("#left_bot_shop").style.visibility = "collapse";
	$("#left_mid_shop").style.visibility = "collapse";
	$("#right_top_shop").style.visibility = "collapse";
	$("#right_bot_shop").style.visibility = "collapse";
	$("#right_mid_shop").style.visibility = "collapse";
	$("#mid_top_shop").style.visibility = "collapse";
	$("#mid_bot_shop").style.visibility = "collapse";
	$("#mid_mid_shop").style.visibility = "collapse";
	$("#side_shop").style.visibility = "collapse";
	$("#empty_guts").style.visibility = "collapse";

	Game.EmitSound("ui.chat_close");
}

function hideShipShop() {
	$.Msg("---hideShipShop--------");
	if (NewShopUI.BHasClass("ShopOpen")) {
		$.Msg("shop Open");
		$.DispatchEvent("DOTAHUDToggleShop");
		closeShipShop()
	}
	else {
		shipShopShow = false;
		showShips();
		return;
	}
}

function closeShipShop() {

	$.Msg("inhide ship shop");
	if (shipShopShow) {

		if (!NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder")) {
			$("#ship_shop_content_holder").SetParent(NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter"));
		}
		$.Msg(NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder"))
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("ship_shop_content_holder").style.visibility = "collapse";
		//catigoriesUI.style.visibility="visible";
		NewShopUI.FindChildTraverse("Main").FindChildTraverse("HeightLimiter").FindChildTraverse("GridMainShop").style.visibility = "visible";
	}
	shipShopShow = false;

	hiddenship = true;
	$.Msg("inhide");
	$("#ship_shop").style.visibility = "collapse";
	$("#ancient_apparition").style.height = "0px";
	$("#crystal_maiden").style.height = "0px";
	$("#disruptor").style.height = "0px";
	$("#morphling").style.height = "0px";
	$("#storm_spirit").style.height = "0px";
	$("#brewmaster").style.height = "0px";
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
	$("#razor").style.height = "0px";
	$("#rattletrap").style.height = "0px";
	$("#batrider").style.height = "0px";
	$("#tidehunter").style.height = "0px";
	$("#crystal_maiden").style.height = "0px";
	$("#phantom_lancer").style.height = "0px";
	$("#vengefulspirit").style.height = "0px";
	$("#bane").style.height = "0px";
	$("#enigma").style.height = "0px";

	Game.EmitSound("ui.chat_close");


}
function hideMissionsIfNeeded() {
	$.Msg("inhideMission");
	$.Msg(Players.GetLocalPlayer());
	$.Msg(showMission[Players.GetLocalPlayer()]);
	if (showMission[Players.GetLocalPlayer()] == 1) {
		$("#mission_hider_1").style.height = "170px";
		$("#mission_hider_2").style.height = "170px";
		$("#mission_hider_3").style.height = "170px";
		$("#mission_hider_4").style.height = "170px";
		$("#mission_hider_5").style.height = "170px";
		$("#mission_hider_6").style.height = "170px";
		$("#mission_hider_7").style.height = "170px";
		$("#mission_hider_8").style.height = "170px";
		$("#mission_hider_9").style.height = "170px";
	}
	else {

		$("#mission_hider_1").style.height = "0px";
		$("#mission_hider_2").style.height = "0px";
		$("#mission_hider_3").style.height = "0px";
		$("#mission_hider_4").style.height = "0px";
		$("#mission_hider_5").style.height = "0px";
		$("#mission_hider_6").style.height = "0px";
		$("#mission_hider_7").style.height = "0px";
		$("#mission_hider_8").style.height = "0px";
		$("#mission_hider_9").style.height = "0px";
	}
	if (showMission[Players.GetLocalPlayer()] == -1) {
		$("#must_be_trader_1").style.height = "170px";
		$("#must_be_trader_2").style.height = "170px";
		$("#must_be_trader_3").style.height = "170px";
		$("#must_be_trader_4").style.height = "170px";
		$("#must_be_trader_5").style.height = "170px";
		$("#must_be_trader_6").style.height = "170px";
		$("#must_be_trader_7").style.height = "170px";
		$("#must_be_trader_8").style.height = "170px";
		$("#must_be_trader_9").style.height = "170px";
	}
	else {
		$("#must_be_trader_1").style.height = "0px";
		$("#must_be_trader_2").style.height = "0px";
		$("#must_be_trader_3").style.height = "0px";
		$("#must_be_trader_4").style.height = "0px";
		$("#must_be_trader_5").style.height = "0px";
		$("#must_be_trader_6").style.height = "0px";
		$("#must_be_trader_7").style.height = "0px";
		$("#must_be_trader_8").style.height = "0px";
		$("#must_be_trader_9").style.height = "0px";
	}

}
function reHideOutOfContracts() {
	$("#out_of_contracts").style.visibility = "collapse";

	//$( "#out_of_contracts" ).SetHasClass( "new_contract", false );
}


function donate(amount) {
	GameEvents.SendCustomGameEventToServer("donate_" + amount, { "text": 'fooBar', });
}

function GiveEasy() {
	GameEvents.SendCustomGameEventToServer("GiveEasy", { "text": 'fooBar', });

}

function GiveMedium() {
	GameEvents.SendCustomGameEventToServer("GiveMedium", { "text": 'fooBar', });
}

function Unstick(data) {
	$.Msg("in unstick");
	GameEvents.SendCustomGameEventToServer("Unstick", { "text": 'fooBar', });

}


var ticksSinceChanged = 0
function handleZoom() {
	//get the current zoom number
	var oldval = $("#zoomLblVal").text
	$.Msg($("#ZoomSlider").GetChild(1).value);
	//get the percentage of the slider bar that is filled
	var zoomPer = Math.floor($("#ZoomSlider").GetChild(1).value * 100)

	//if it is not the same as the old zoom value, zoom to it otherwise wait and slowly fade out the zoom box
	//set the +1800 to your min zoom and 1800+2200 will be your max zoom
	if ($("#zoomLblVal").text != zoomPer / 100 * 1300 + 1600) {
		GameUI.SetCameraDistance(zoomPer / 100 * 1300 + 1600)

		$("#zoomLblVal").text = zoomPer / 100 * 1300 + 1600;
		ticksSinceChanged = 0;
		$("#ZoomSliderBox").style.opacity = 1;
	}
	else {
		ticksSinceChanged++;
	}
	if (ticksSinceChanged > 60) {
		$("#ZoomSliderBox").style.opacity = $("#ZoomSliderBox").style.opacity - .04;
	}
	if ($("#ZoomSliderBox").style.opacity == 0) {
		toggleZoom();
	}
	//re-call self (i could not find an "onSliderValueChanged" so i resorted to this
	if ($("#ZoomSliderBox").style.visibility == "visible") {
		$.Schedule(.05, handleZoom);
	}
}

function setZoom() {
	GameUI.SetCameraDistance(1600)
}
function toggleZoom() {
	if ($("#ZoomSliderBox").style.visibility == "visible") {
		$("#ZoomSliderBox").style.visibility = "collapse";
	}
	else {
		$("#ZoomSliderBox").style.visibility = "visible";
		ticksSinceChanged = 0;
		$("#ZoomSliderBox").style.opacity = 1;
		handleZoom();
	}


}





function test(data) {
	$.Msg("data");
	$.Msg(data);

}

function OnBattleStarted(eventData) {
	$("#battleTimerPanel").style.visibility = "collapse";
	$("#battleProgressTimerPanel").style.visibility = "visible";

}

function OnBattleOver(eventData) {
	$("#battleTimerPanel").style.visibility = "visible";
	$("#battleProgressTimerPanel").style.visibility = "collapse";

}


function OnBattleProgressTimer(eventData) {

	$("#BattleProgressTimeVal").text = eventData.TimeInBattle;
	$("#NorthScoreVal").text = eventData.NorthScore;
	$("#SouthScoreVal").text = eventData.SouthScore;
	$("#gptvaln").text = eventData.gptn;
	$("#gptvals").text = eventData.gpts;

}

function OnBattleTimer(eventData) {
	$.Msg(eventData)
	var tBattle = (Math.floor(eventData.TimeTillBattle / 60)) + ":" + (eventData.TimeTillBattle % 60 >= 10 ? "" : "0") + (eventData.TimeTillBattle % 60);
	$("#BattleTimeVal").text = tBattle;


}

function OnBsuiTimer(eventData) {
	if (firstcall) {
		firstcall = false;
		starttime = Game.GetDOTATime(true, true);
	}
	var tEmpire = (Math.floor(eventData.nEmpire / 60)) + ":" + (eventData.nEmpire % 60 >= 10 ? "" : "0") + (eventData.nEmpire % 60);
	var tCreep = (Math.floor(eventData.nCreep / 60)) + ":" + (eventData.nCreep % 60 >= 10 ? "" : "0") + (eventData.nCreep % 60);
	var t = Game.GetDOTATime(true, true) - starttime;
	var tGameTime = (Math.floor(t / 60)) + ":" + (t % 60 >= 10 ? "" : "0") + Math.floor(t % 60);


	$("#GameTimeVal").text = tGameTime;
	$("#CreepSpawnVal").text = tCreep;
	$("#EmpireGoldVal").text = tEmpire;
	$("#NorthEmpVal").text = eventData.nNorthGold;
	$("#SouthEmpVal").text = eventData.nSouthGold;



	$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("HUDElements").FindChildTraverse("topbar")
}

function buyItem(itemName, cost) {
	if (showMission[Players.GetLocalPlayer()] > -1 || itemName == "spys" || itemName == "heals") {
		GameEvents.SendCustomGameEventToServer("buyItem", { "text": itemName, "cost": cost });
	}
}



function diffCoOp(DiffSelection) {

	GameEvents.SendCustomGameEventToServer("DiffSelection", { "diff": DiffSelection });
	$("#coOpVoteBox").style.visibility = "collapse";
}

function handleCoOp(data) {
	$.Msg("handling co op, leader is " + data.Player_ID);
	if (data.Player_ID == Players.GetLocalPlayer()) {
		$("#coOpVoteBox").style.visibility = "visible";
	}

}

function NearShipShop(data) {

	$.Msg("in near ship");
	if (Players.GetLocalPlayer() == data.Player_ID) {
		showShipsNoHide();
	}
}
function NearShop(data) {

	$.Msg("in near");
	if (Players.GetLocalPlayer() == data.Player_ID) {
		fillAndShow();
	}

}



function LeftShop(data) {
	$.Msg("in left");
	if (Players.GetLocalPlayer() == data.Player_ID) {
		hideShop();
	}
}

function CanBuy(data) {
	$.Msg("can buy");

	showMission[data.Player_ID] = 1;
	hideMissionsIfNeeded()

}

function CannotBuy(data) {
	$.Msg("cannot buy test");
	$.Msg("pid " + data.Player_ID);
	$.Msg("this id " + Players.GetLocalPlayer());
	$.Msg(data.Player_ID == Players.GetLocalPlayer());
	showMission[data.Player_ID] = 0;

	if (showMission[Players.GetLocalPlayer()] == 0 && data.Player_ID == Players.GetLocalPlayer()) {
		$.Msg(data);
		$.Msg("1");
		var v = [data.x, data.y, data.z]
		if (data.x < 999999) {
			$.Msg("2");
			GameUI.PingMinimapAtLocation(v);
		}
		showMission[Players.GetLocalPlayer()] = data.Ally_ID;
		if (data.Ally_ID == 0) {
			$("#out_of_contracts").style.visibility = "visible";
			$.Schedule(4, reHideOutOfContracts);
		}
	}
	hideMissionsIfNeeded();



}
function PingLoc(data) {
	if (data.player_id == Players.GetLocalPlayer()) {
		var v = [data.x, data.y, data.z]
		GameUI.PingMinimapAtLocation(v);
	}
}




function TopNotification(msg) {
	AddNotification(msg, $('#TopNotifications'));
}

function BottomNotification(msg) {
	AddNotificationbot(msg, $('#BottomNotifications'));
}

function TopRemoveNotification(msg) {
	RemoveNotification(msg, $('#TopNotifications'));
}

function BottomRemoveNotification(msg) {
	RemoveNotification(msg, $('#BottomNotifications'));
}


function RemoveNotification(msg, panel) {
	var count = msg.count;
	if (count > 0 && panel.GetChildCount() > 0) {
		var start = panel.GetChildCount() - count;
		if (start < 0)
			start = 0;

		for (i = start; i < panel.GetChildCount(); i++) {
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

	if (newNotification) {
		lastNotification = $.CreatePanel('Panel', panel, '');
		lastNotification.AddClass('NotificationLine')
		lastNotification.hittest = true;
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

	if (typeof (msg.duration) != "number") {
		//$.Msg("[Notifications] Notification Duration is not a number!");
		msg.duration = 3
	}

	if (newNotification) {
		$.Schedule(msg.duration, function () {
			//$.Msg('callback')
			if (lastNotification.deleted)
				return;

			lastNotification.DeleteAsync(0);
		});
	}


	if (msg.hero != null) {
		notification.heroimagestyle = msg.imagestyle || "icon";
		notification.heroname = msg.hero
		notification.hittest = false;
	} else if (msg.image != null) {
		notification.SetImage(msg.image);
		notification.hittest = false;
	} else if (msg.ability != null) {
		notification.abilityname = msg.ability
		notification.hittest = false;
	} else if (msg.item != null) {
		notification.itemname = msg.item
		notification.hittest = false;
	} else {
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

	if (msg.style) {
		for (var key in msg.style) {
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

	if (newNotification) {
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

	if (typeof (msg.duration) != "number") {
		//$.Msg("[Notifications] Notification Duration is not a number!");
		msg.duration = 3
	}

	if (newNotification) {
		$.Schedule(msg.duration, function () {
			//$.Msg('callback')
			if (lastNotification.deleted)
				return;

			lastNotification.DeleteAsync(0);
		});
	}

	if (msg.hero != null) {
		notification.heroimagestyle = msg.imagestyle || "icon";
		notification.heroname = msg.hero
		notification.hittest = false;
	} else if (msg.image != null) {
		notification.SetImage(msg.image);
		notification.hittest = false;
	} else if (msg.ability != null) {
		notification.abilityname = msg.ability
		notification.hittest = false;
	} else if (msg.item != null) {
		notification.itemname = msg.item
		notification.hittest = false;
	} else {
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

	if (msg.style) {
		for (var key in msg.style) {
			var value = msg.style[key]
			notification.style[key] = value;
		}
	}
}






var CONSUME_EVENT = true;
var CONTINUE_PROCESSING_EVENT = false;

// Handle Left Button events
function OnLeftButtonPressed() {
	//$.Msg("LEFT BUTTON CAST")
}



// Handle Right Button events
// Find any entities right-clicked on
// if the units are invuln, modify the right-click behaviour
function OnRightButtonPressed() {
	//$.Msg("RIGHT BUTTON CAST")
	var localHeroIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	var mouseEntities = GameUI.FindScreenEntities(GameUI.GetCursorPosition());
	mouseEntities = mouseEntities.filter(function (e) { return e.entityIndex != localHeroIndex; });

	var accurateEntities = mouseEntities.filter(function (e) { return e.accurateCollision; });
	if (accurateEntities.length > 0) {
		for (var e of accurateEntities) {
			if (Entities.IsDisarmed(e.entityIndex) && Entities.NoHealthBar(e.entityIndex)) {
				//$.Msg("INVULNERABLE UNIT CLICKED")
				fillAndShow();
				return CONSUME_EVENT;
			}
			if (Entities.IsHexed(e.entityIndex) && Entities.NoHealthBar(e.entityIndex)) {
				//$.Msg("INVULNERABLE UNIT CLICKED")
				showShips();
				return CONSUME_EVENT;
			}
		}
	}

	if (mouseEntities.length > 0) {
		//$.Msg("ENTITY")
		var e = mouseEntities[0];
		if (Entities.IsFrozen(e.entityIndex) && Entities.NoHealthBar(e.entityIndex)) {
			$.Msg("IsFrozen UNIT CLICKED")
			fillAndShow();
			return CONSUME_EVENT;
		}
		if (Entities.IsHexed(e.entityIndex) && Entities.NoHealthBar(e.entityIndex)) {
			$.Msg("IsHexed UNIT CLICKED")
			showShips();
			return CONSUME_EVENT;
		}
	}

	return CONTINUE_PROCESSING_EVENT;
}


// Main mouse event callback
GameUI.SetMouseCallback(function (eventName, arg) {

	//$.Msg("MOUSE: ", eventName, " -- ", arg, " -- ", GameUI.GetClickBehaviors())

	if (GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE)
		return CONTINUE_PROCESSING_EVENT;

	if (eventName === "pressed") {
		//$.Msg("MOUSE: ", eventName, " -- ", arg, " -- ", GameUI.GetClickBehaviors())
		if (arg === 0) {
			//$.Msg("RIGHT BUTTON CAST")
			return OnRightButtonPressed();
		}
		// on right click, call the right-click function
		if (arg === 1) {
			//$.Msg("RIGHT BUTTON CAST")
			return OnRightButtonPressed();
		}
	}
	return CONTINUE_PROCESSING_EVENT;
});

(function () {
	if (GameUI.CustomUIConfig().DebugMessagesEnabled == true)
		$.Msg("Right Click Override JS Loaded.");

})();


(function () {
	hideTrade();
	resetHeroIcons();
	$.Msg("in subscribe");
	GameEvents.Subscribe("Boat_Spawned", fillShop);
	GameEvents.Subscribe("Trade_Mode_Enabled", showTrade);

	GameEvents.Subscribe("Hero_Near_Shop", NearShop);
	GameEvents.Subscribe("Hero_Near_Ship_Shop", showShips);
	GameEvents.Subscribe("Hero_Left_Shop", LeftShop);
	GameEvents.Subscribe("Team_Can_Buy", CanBuy);
	GameEvents.Subscribe("Team_Cannot_Buy", CannotBuy);
	GameEvents.Subscribe("ping_loc", PingLoc);
	GameEvents.Subscribe("bsui_timer_data", OnBsuiTimer);

	GameEvents.Subscribe("Battle_in_Progress", OnBattleProgressTimer);

	GameEvents.Subscribe("Battle_Timer", OnBattleTimer);
	GameEvents.Subscribe("Battle_Started", OnBattleStarted);
	GameEvents.Subscribe("Battle_Over", OnBattleOver);


	GameEvents.Subscribe("co_op_mode", handleCoOp);

	GameEvents.Subscribe("top_notification", TopNotification);
	GameEvents.Subscribe("bottom_notification", BottomNotification);
	GameEvents.Subscribe("top_remove_notification", TopRemoveNotification);
	GameEvents.Subscribe("bottom_remove_notification", BottomRemoveNotification);
	$.Msg("done subscribe");

})();