"use strict";

// Global list of panels representing each of the teams
var g_TeamPanels = [];
var hostToggle;
var myToggle;
// Global list of panels representing each of the players (1 per-player). These are reparented
// to the appropriate team panel to indicate which team the player is on.
var g_PlayerPanels = [];
var g_HatChoice = [];
var g_MMRValues = [];

var g_TEAM_SPECATOR = 1;
var g_myPts = 75;
var specialHatOwners = [
  35695824, 6883638, 72562802, 65507855, 64744363, 92315095, 82360838, 93116118,
  70585706, 40159914, 13375544, 5879425, 138997389,
];

//--------------------------------------------------------------------------------------------------
// Handeler for when the unssigned players panel is clicked that causes the player to be reassigned
// to the unssigned players team
//--------------------------------------------------------------------------------------------------
function OnLeaveTeamPressed() {
  Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_NOTEAM);
}

//--------------------------------------------------------------------------------------------------
// Handler for when the Lock and Start button is pressed
//--------------------------------------------------------------------------------------------------
function OnLockAndStartPressed() {
  // Don't allow a forced start if there are unassigned players
  if (Game.GetUnassignedPlayerIDs().length > 0) return;

  // Lock the team selection so that no more team changes can be made
  Game.SetTeamSelectionLocked(true);

  // Disable the auto start count down
  Game.SetAutoLaunchEnabled(false);

  // Set the remaining time before the game starts
  Game.SetRemainingSetupTime(3);
}

//--------------------------------------------------------------------------------------------------
// Handler for when the Cancel and Unlock button is pressed
//--------------------------------------------------------------------------------------------------
function OnCancelAndUnlockPressed() {
  // Unlock the team selection, allowing the players to change teams again
  Game.SetTeamSelectionLocked(false);

  // Stop the countdown timer
  Game.SetRemainingSetupTime(-1);
}

//--------------------------------------------------------------------------------------------------
// Handler for the auto assign button being pressed
//--------------------------------------------------------------------------------------------------
function OnAutoAssignPressed() {
  // Assign all of the currently unassigned players to a team, trying
  // to keep any players that are in a party on the same team.
  Game.AutoAssignPlayersToTeams();
}

//--------------------------------------------------------------------------------------------------
// Handler for the shuffle player teams button being pressed
//--------------------------------------------------------------------------------------------------
function OnShufflePlayersPressed() {
  //now a balanced shuffle

  if (g_MMRValues) {
    GameEvents.SendCustomGameEventToServer("CreateEvenTeams", {});
  } else {
    Game.ShufflePlayerTeamAssignments();
  }
}

//--------------------------------------------------------------------------------------------------
// Find the player panel for the specified player in the global list or create the panel if there
// is not already one in the global list. Make the new or existing panel a child panel of the
// specified parent panel
//--------------------------------------------------------------------------------------------------
function FindOrCreatePanelForPlayer(playerId, parent) {
  // Search the list of player player panels for one witht the specified player id
  for (var i = 0; i < g_PlayerPanels.length; ++i) {
    var playerPanel = g_PlayerPanels[i];

    if (playerPanel.GetAttributeInt("player_id", -1) == playerId) {
      playerPanel.SetParent(parent);
      return playerPanel;
    }
  }

  // Create a new player panel for the specified player id if an existing one was not found
  var newPlayerPanel = $.CreatePanel("Panel", parent, "player_root");
  newPlayerPanel.SetAttributeInt("player_id", playerId);
  newPlayerPanel.BLoadLayout(
    "file://{resources}/layout/custom_game/team_select_player.xml",
    false,
    false
  );

  // Add the panel to the global list of player planels so that we will find it next time
  g_PlayerPanels.push(newPlayerPanel);

  return newPlayerPanel;
}

//--------------------------------------------------------------------------------------------------
// Find player slot n in the specified team panel
//--------------------------------------------------------------------------------------------------
function FindPlayerSlotInTeamPanel(teamPanel, playerSlot) {
  var playerListNode = teamPanel.FindChildInLayoutFile("PlayerList");
  if (playerListNode == null) return null;

  var nNumChildren = playerListNode.GetChildCount();
  for (var i = 0; i < nNumChildren; ++i) {
    var panel = playerListNode.GetChild(i);
    if (panel.GetAttributeInt("player_slot", -1) == playerSlot) {
      return panel;
    }
  }

  return null;
}

//--------------------------------------------------------------------------------------------------
// Update the specified team panel ensuring that it has all of the players currently assigned to its
// team and the the remaining slots are marked as empty
//--------------------------------------------------------------------------------------------------
function UpdateTeamPanel(teamPanel) {
  // Get the id of team this panel is displaying
  var teamId = teamPanel.GetAttributeInt("team_id", -1);
  if (teamId <= 0) return;

  // Add all of the players currently assigned to the team
  var teamPlayers = Game.GetPlayerIDsOnTeam(teamId);
  for (var i = 0; i < teamPlayers.length; ++i) {
    var playerSlot = FindPlayerSlotInTeamPanel(teamPanel, i);
    playerSlot.RemoveAndDeleteChildren();
    FindOrCreatePanelForPlayer(teamPlayers[i], playerSlot);
  }

  // Fill in the remaining player slots with the empty slot indicator
  var teamDetails = Game.GetTeamDetails(teamId);
  var nNumPlayerSlots = teamDetails.team_max_players;
  for (var i = teamPlayers.length; i < nNumPlayerSlots; ++i) {
    var playerSlot = FindPlayerSlotInTeamPanel(teamPanel, i);
    if (playerSlot.GetChildCount() == 0) {
      var empty_slot = $.CreatePanel("Panel", playerSlot, "player_root");
      empty_slot.BLoadLayout(
        "file://{resources}/layout/custom_game/team_select_empty_slot.xml",
        false,
        false
      );
    }
  }

  // Change the display state of the panel to indicate the team is full
  teamPanel.SetHasClass(
    "team_is_full",
    teamPlayers.length === teamDetails.team_max_players
  );

  // If the local player is on this team change team panel to indicate this
  var localPlayerInfo = Game.GetLocalPlayerInfo();
  if (localPlayerInfo) {
    var localPlayerIsOnTeam = localPlayerInfo.player_team_id === teamId;
    teamPanel.SetHasClass("local_player_on_this_team", localPlayerIsOnTeam);
  }
}

//--------------------------------------------------------------------------------------------------
// Update the unassigned players list and all of the team panels whenever a change is made to the
// player team assignments
//--------------------------------------------------------------------------------------------------
function OnTeamPlayerListChanged() {
  var unassignedPlayersContainerNode = $("#UnassignedPlayersContainer");
  if (unassignedPlayersContainerNode === null) return;

  // Move all existing player panels back to the unassigned player list
  for (var i = 0; i < g_PlayerPanels.length; ++i) {
    var playerPanel = g_PlayerPanels[i];
    playerPanel.SetParent(unassignedPlayersContainerNode);
  }

  // Make sure all of the unassigned player have a player panel
  // and that panel is a child of the unassigned player panel.
  var unassignedPlayers = Game.GetUnassignedPlayerIDs();
  for (var i = 0; i < unassignedPlayers.length; ++i) {
    var playerId = unassignedPlayers[i];
    FindOrCreatePanelForPlayer(playerId, unassignedPlayersContainerNode);
  }

  // Update all of the team panels moving the player panels for the
  // players assigned to each team to the corresponding team panel.
  for (var i = 0; i < g_TeamPanels.length; ++i) {
    UpdateTeamPanel(g_TeamPanels[i]);
  }

  // Set the class on the panel to indicate if there are any unassigned players
  $("#GameAndPlayersRoot").SetHasClass(
    "unassigned_players",
    unassignedPlayers.length != 0
  );
  $("#GameAndPlayersRoot").SetHasClass(
    "no_unassigned_players",
    unassignedPlayers.length == 0
  );
}

//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
function OnPlayerSelectedTeam(nPlayerId, nTeamId, bSuccess) {
  var playerInfo = Game.GetLocalPlayerInfo();
  if (!playerInfo) return;

  // Check to see if the event is for the local player
  if (playerInfo.player_id === nPlayerId) {
    // Play a sound to indicate success or failure
    if (bSuccess) {
      Game.EmitSound("ui_team_select_pick_team");
    } else {
      Game.EmitSound("ui_team_select_pick_team_failed");
    }
  }
}

//--------------------------------------------------------------------------------------------------
// Check to see if the local player has host privileges and set the 'player_has_host_privileges' on
// the root panel if so, this allows buttons to only be displayed for the host.
//--------------------------------------------------------------------------------------------------
function CheckForHostPrivileges() {
  var playerInfo = Game.GetLocalPlayerInfo();
  if (!playerInfo) return;

  // Set the "player_has_host_privileges" class on the panel, this can be used
  // to have some sub-panels on display or be enabled for the host player.
  $.GetContextPanel().SetHasClass(
    "player_has_host_privileges",
    playerInfo.player_has_host_privileges
  );
}

//--------------------------------------------------------------------------------------------------
// Update the state for the transition timer periodically
//--------------------------------------------------------------------------------------------------
function UpdateTimer() {
  var gameTime = Game.GetGameTime();
  var transitionTime = Game.GetStateTransitionTime();

  CheckForHostPrivileges();

  var mapInfo = Game.GetMapInfo();
  $("#MapInfo").SetDialogVariable("map_name", mapInfo.map_display_name);
  var timeleft = Math.max(0, Math.floor(transitionTime - gameTime));
  if (transitionTime >= 0) {
    $("#StartGameCountdownTimer").SetDialogVariableInt(
      "countdown_timer_seconds",
      Math.max(0, Math.floor(transitionTime - gameTime))
    );
    $("#StartGameCountdownTimer").SetHasClass("countdown_active", true);
    $("#StartGameCountdownTimer").SetHasClass("countdown_inactive", false);
  } else {
    $("#StartGameCountdownTimer").SetHasClass("countdown_active", false);
    $("#StartGameCountdownTimer").SetHasClass("countdown_inactive", true);
  }

  var autoLaunch = Game.GetAutoLaunchEnabled();
  $("#StartGameCountdownTimer").SetHasClass("auto_start", autoLaunch);
  $("#StartGameCountdownTimer").SetHasClass(
    "forced_start",
    autoLaunch == false
  );

  // Allow the ui to update its state based on team selection being locked or unlocked
  $.GetContextPanel().SetHasClass(
    "teams_locked",
    Game.GetTeamSelectionLocked()
  );
  $.GetContextPanel().SetHasClass(
    "teams_unlocked",
    Game.GetTeamSelectionLocked() == false
  );
  //$.Msg(timeleft)
  if (timeleft > 54 && timeleft < 57) {
    $("#coOpButton").RemoveClass("untoggled");
    $("#coOpButton").SetHasClass("toggled", true);

    var northEmp = $("#TeamsListRoot").GetChild(0);

    northEmp.style.visibility = "collapse";
    $("#ShuffleTeamAssignmentButton").style.visibility = "collapse";
    $("#AutoAssignButton").style.visibility = "collapse";

    Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
    OnTeamPlayerListChanged();
  }
  if (timeleft > 34 && timeleft < 37) {
    $("#coOpButton").RemoveClass("toggled");
    $("#coOpButton").SetHasClass("untoggled", true);
    var northEmp = $("#TeamsListRoot").GetChild(0);
    northEmp.style.visibility = "visible";
    $("#ShuffleTeamAssignmentButton").style.visibility = "visible";
    $("#AutoAssignButton").style.visibility = "visible";
    OnTeamPlayerListChanged();
  }

  if (timeleft > 84 && timeleft < 87) {
    $("#battleLabel").text = "GAME MODE: BATTLE";
    $("#battleButton").RemoveClass("untoggled");
    $("#battleButton").SetHasClass("toggled", true);
  }
  if (timeleft > 94 && timeleft < 97) {
    $("#battleLabel").text = "GAME MODE: NORMAL";
    $("#battleButton").RemoveClass("toggled");
    $("#battleButton").SetHasClass("untoggled", true);
  }

  if (timeleft > 94 && timeleft < 97) {
    $("#battleLabel").text = "GAME MODE: NORMAL";
    $("#battleButton").RemoveClass("toggled");
    $("#battleButton").SetHasClass("untoggled", true);
  }

  if (timeleft > 104 && timeleft < 107) {
    $("#TradeLabel").text = "TRADING: ENABLED";
    $("#tradeButton").RemoveClass("tradetoggled");
    $("#tradeButton").SetHasClass("tradeuntoggled", true);
  }
  if (timeleft > 114 && timeleft < 117) {
    $("#TradeLabel").text = "TRADING: DISABLED";
    $("#tradeButton").RemoveClass("tradeuntoggled");
    $("#tradeButton").SetHasClass("tradetoggled", true);
  }

  $.Schedule(0.1, UpdateTimer);
}
function SetTimerToDefault() {
  Game.SetRemainingSetupTime(30);
}

function OnCoOpButtonPressed() {
  var playerInfo = Game.GetLocalPlayerInfo();
  if (!playerInfo) return;
  if (playerInfo.player_has_host_privileges) {
    if ($("#coOpButton").BHasClass("untoggled")) {
      var mode = "coop";
      Game.SetRemainingSetupTime(56);
      $.Schedule(1.0, SetTimerToDefault);
    } else {
      var mode = "normal";
      Game.SetRemainingSetupTime(36);
    }
    GameEvents.SendCustomGameEventToServer("Activate_Co_Op", { text: mode });
  }
}

function BattleMode() {
  var playerInfo = Game.GetLocalPlayerInfo();
  if (!playerInfo) return;
  if (playerInfo.player_has_host_privileges) {
    if ($("#battleButton").BHasClass("untoggled")) {
      Game.SetRemainingSetupTime(86);
      $.Schedule(1.0, SetTimerToDefault);

      var mode = "battle";
    } else {
      Game.SetRemainingSetupTime(96);
      $.Schedule(1.0, SetTimerToDefault);

      var mode = "normal";
    }
    GameEvents.SendCustomGameEventToServer("BattleMode", { text: mode });
  }
}

function TradeMode() {
  var playerInfo = Game.GetLocalPlayerInfo();
  if (!playerInfo) return;
  if (playerInfo.player_has_host_privileges) {
    if ($("#tradeButton").BHasClass("tradetoggled")) {
      Game.SetRemainingSetupTime(106);
      $.Schedule(1.0, SetTimerToDefault);

      var tmode = "trading";
    } else {
      Game.SetRemainingSetupTime(116);
      $.Schedule(1.0, SetTimerToDefault);

      var tmode = "normal";
    }
    GameEvents.SendCustomGameEventToServer("TradeMode", { text: tmode });
  }
}

function UseMMRData(data) {
  g_MMRValues = data;
}

function handleShuffledTeamResult(data) {
  $("#MMRDifference").text = data.rating.toFixed(1);
  Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_NOTEAM);
  for (var player in data.team) {
    if (data.team[player] + "" == GetSteamID32() + "") {
      $.Schedule(0.1, joinTeamNorth);
      return;
    }
  }

  $.Schedule(0.1, joinTeamSouth);
}
function joinTeamNorth() {
  Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_BADGUYS);
}
function joinTeamSouth() {
  Game.PlayerJoinTeam(DOTATeam_t.DOTA_TEAM_GOODGUYS);
}

//--------------------------------------------------------------------------------------------------
// Entry point called when the team select panel is created
//--------------------------------------------------------------------------------------------------
(function () {
  GameEvents.Subscribe("MMRData", UseMMRData);
  GameEvents.Subscribe("ShuffledTeamResult", handleShuffledTeamResult);

  hostToggle = false;
  myToggle = false;
  var bShowSpectatorTeam = false;
  var bAutoAssignTeams = true;

  // get any custom config
  if (GameUI.CustomUIConfig().team_select) {
    var cfg = GameUI.CustomUIConfig().team_select;
    if (cfg.bShowSpectatorTeam !== undefined) {
      bShowSpectatorTeam = cfg.bShowSpectatorTeam;
    }
    if (cfg.bAutoAssignTeams !== undefined) {
      bAutoAssignTeams = cfg.bAutoAssignTeams;
    }
  }
  var totalPlayers = Game.GetPlayerIDsOnTeam(
    DOTA_GC_TEAM.DOTA_GC_TEAM_NOTEAM
  ).length;
  totalPlayers += Game.GetPlayerIDsOnTeam(
    DOTA_GC_TEAM.DOTA_GC_TEAM_GOOD_GUYS
  ).length;
  totalPlayers += Game.GetPlayerIDsOnTeam(
    DOTA_GC_TEAM.DOTA_GC_TEAM_BAD_GUYS
  ).length;

  if (totalPlayers > 5) {
    $("#coOpButton").style.visibility = "collapse";
  }

  $("#TeamSelectContainer").SetAcceptsFocus(true); // Prevents the chat window from taking focus by default
  var teamsListRootNode = $("#TeamsListRoot");

  // Construct the panels for each team
  var allTeamIDs = Game.GetAllTeamIDs();

  if (bShowSpectatorTeam) {
    allTeamIDs.unshift(g_TEAM_SPECATOR);
  }
  allTeamIDs.reverse();
  for (var teamId of allTeamIDs) {
    var teamNode = $.CreatePanel("Panel", teamsListRootNode, "");
    teamNode.AddClass("team_" + teamId); // team_1, etc.
    teamNode.SetAttributeInt("team_id", teamId);
    teamNode.BLoadLayout(
      "file://{resources}/layout/custom_game/team_select_team.xml",
      false,
      false
    );

    // Add the team panel to the global list so we can get to it easily later to update it
    g_TeamPanels.push(teamNode);
  }

  // Automatically assign players to teams.
  if (bAutoAssignTeams) {
    Game.AutoAssignPlayersToTeams();
  }

  // Do an initial update of the player team assignment
  OnTeamPlayerListChanged();

  // Start updating the timer, this function will schedule itself to be called periodically
  UpdateTimer();
  $.Schedule(2.0, GetLocalPlayerHats);
  GameEvents.SendCustomGameEventToServer("SendMMRsToServer", {
    playerSteamId: GetSteamID32(),
  });

  // Register a listener for the event which is brodcast when the team assignment of a player is actually assigned
  $.RegisterForUnhandledEvent(
    "DOTAGame_TeamPlayerListChanged",
    OnTeamPlayerListChanged
  );

  // Register a listener for the event which is broadcast whenever a player attempts to pick a team
  $.RegisterForUnhandledEvent(
    "DOTAGame_PlayerSelectedCustomTeam",
    OnPlayerSelectedTeam
  );
})();
function ShowHats() {
  $("#PointTracker").text = "My Points: " + g_myPts;
  if ($("#HatListholder").style.width === "400.0px") {
    $("#HatListholder").style.width = "0px";
  } else {
    $("#HatListholder").style.width = "400px";
  }
  specialHatOwners.forEach(function (owner) {
    if (GetSteamID32() == owner) {
      $("#specHat").style.visibility = "visible";
    }
  });
}
function RandHat(cost, hat) {
  if (
    !$("#" + hat + 1).BHasClass("locked") &&
    !$("#" + hat + 2).BHasClass("locked") &&
    !$("#" + hat + 3).BHasClass("locked")
  ) {
    return;
  }

  var done = false;
  while (!done) {
    var i = Math.floor(Math.random() * 3) + 1;
    if ($("#" + hat + i).BHasClass("locked")) {
      PickHat(cost, hat + i);
      done = true;
    }
  }
}

function PickHat(cost, hat) {
  if ($("#" + hat).BHasClass("locked")) {
    if (g_myPts >= cost) {
      g_myPts = g_myPts - cost;
      $("#PointTracker").text = "My Pts: " + g_myPts;
      $("#" + hat).RemoveClass("locked");
      $("#" + hat).GetChild(0).style.visibility = "collapse";
      GameEvents.SendCustomGameEventToServer("BuyPlayerHat", {
        playerSteamId: GetSteamID32(),
        text: hat,
        cost: cost,
      });
    } else {
      return;
    }
  }
  var childimage = 1;

  if (g_HatChoice[GetSteamID32()]) {
    if (g_HatChoice[GetSteamID32()] === "noHat") {
      childimage = 0;
    }
    $("#" + g_HatChoice[GetSteamID32()])
      .GetChild(childimage)
      .RemoveClass("SelectedHat");
  }
  if (hat === "noHat") {
    childimage = 0;
  } else {
    childimage = 1;
  }
  //$( "#coOpButton" ).SetHasClass( "toggled", true);
  g_HatChoice[GetSteamID32()] = hat;
  $("#" + hat)
    .GetChild(childimage)
    .SetHasClass("SelectedHat", true);
  $("#CurrentHat").SetImage("file://{images}/custom_game/hats/" + hat + ".png");
  GameEvents.SendCustomGameEventToServer("SendPlayerHat", {
    playerSteamId: GetSteamID32(),
    text: hat,
  });
}

function GetSteamID32() {
  var playerInfo = Game.GetPlayerInfo(Game.GetLocalPlayerID());

  var steamID64 = playerInfo.player_steamid,
    steamIDPart = Number(steamID64.substring(3)),
    steamID32 = String(steamIDPart - 61197960265728);

  return steamID32;
}

var url = "https://grdxgi2qm1.execute-api.us-east-1.amazonaws.com/battleships";
var LocalPlayerHatInfo = {};
function GetLocalPlayerHats() {
  var request = url + "/battleships_players/" + GetSteamID32();
  $.AsyncWebRequest(request, {
    type: "GET",
    headers: {
      "x-api-key": "FX5Tqd1joL2CC3p1tjCoF7hJCIoRrNDv4m0tqmvo",
    },
    success: function (data) {
      LocalPlayerHatInfo = data;
      g_myPts = data.Content[0].points;
      $("#PointTracker").text = "My Points: " + g_myPts;
      data.Content[0].hats.forEach(function (hat) {
        if ($("#" + hat).BHasClass("locked")) {
          $("#" + hat).RemoveClass("locked");
          $("#" + hat).GetChild(0).style.visibility = "collapse";
        }
      });
      if ("undefined" !== typeof data.Content[0].CurHat) {
        PickHat(0, data.Content[0].CurHat);
      }
    },
    error: function () {
      $.Schedule(1.0, GetLocalPlayerHats);
    },
  });
}
