const particles = {};

// check if the alt key is pressed
function checkAltPressed() {
  const altPressed = GameUI.IsAltDown();
  if (!altPressed) {
    for (let i = 0; i < 10; i++) {
      if (particles[i]) {
        $.Msg("Destroy", particles[i]);
        Particles.DestroyParticleEffect(particles[i], true);
        particles[i] = undefined;
      }
    }
    $.Schedule(1 / 30, checkAltPressed);
    return;
  }

  const localHeroIndex = Players.GetPlayerHeroEntityIndex(
    Players.GetLocalPlayer()
  );
  const localHero = Players.GetLocalPlayerPortraitUnit();

  // get the cast range of all items
  for (let i = 0; i < 10; i++) {
    const item = Entities.GetItemInSlot(localHeroIndex, i);
    if (item === -1) {
      if (particles[i]) {
        $.Msg("Destroy", particles[i]);
        Particles.DestroyParticleEffect(particles[i], true);
        particles[i] = undefined;
      }
      continue;
    }
    const itemName = Abilities.GetAbilityName(item);
    const itemCastRange = Abilities.GetCastRange(item);
    const itemCastRangeTooltip = itemCastRange > 0 ? itemCastRange : "N/A";
    if (!itemCastRange) continue;
    if (particles[i]) continue;
    $.Msg(`Item: ${itemName} - Cast Range: ${itemCastRangeTooltip}`);
    // create the range circle particle
    const rangeCircleParticle = Particles.CreateParticle(
      "particles/ui_mouseactions/range_display.vpcf",
      ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW,
      localHero
    );
    // set the range circle particle
    Particles.SetParticleControl(rangeCircleParticle, 1, [itemCastRange, 0, 0]);

    // scale the color depending on ranger, past 1000 is red
    const redColor = itemCastRange > 1000 ? 1 : 0;
    const greenColor = itemCastRange > 1000 ? 0 : 1;
    Particles.SetParticleControl(rangeCircleParticle, 2, [
      redColor,
      greenColor,
      0,
    ]);

    particles[i] = rangeCircleParticle;
  }

  $.Schedule(1 / 30, checkAltPressed);
}

(function () {
  $.Msg("Range Circles Loaded");
  checkAltPressed();
})();
