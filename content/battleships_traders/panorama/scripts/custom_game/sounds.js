let currentSong;

function EmitClientSound(data) {
  if (data.sound) {
    Game.EmitSound(data.sound);
  }
}

function StartSong(data) {
  $.Msg(data);
  if (currentSong) EndSong();
  if (data.sound) {
    $.Msg("StartSong");
    currentSong = Game.EmitSound(data.sound);
  }
}

function EndSong() {
  $.Msg("EndSong");
  if (currentSong !== null) {
    Game.StopSound(currentSong);
    currentSong = null;
  }
}

$.Msg("Sounds libarary loaded");

(function () {
  GameEvents.Subscribe("emit_client_sound", EmitClientSound);
  GameEvents.Subscribe("start_song", StartSong);
  GameEvents.Subscribe("end_song", EndSong);
})();
