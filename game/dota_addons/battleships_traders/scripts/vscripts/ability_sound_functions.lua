
function pistolSound(keys)
	local casterUnit = keys.caster
	--Very simple now. All coal-type impacts have the same sound.
	--The coal-type ult has a stun sound for the proc in a different function.
	EmitSoundOn("Hero_Sniper.ProjectileImpact", casterUnit)
end

function bailWaterSound(keys)
	local casterUnit = keys.caster
	--Very simple now. All coal-type impacts have the same sound.
	--The coal-type ult has a stun sound for the proc in a different function.
	EmitSoundOn("Hero_NagaSiren.Riptide.Cast", casterUnit)
end

function startDiscoSound(keys)
	local casterUnit = keys.caster
	EmitSoundOn("dsadowski_01.music.laning_01_layer_03", casterUnit)
end

function stopDiscoSound(keys)
	local casterUnit = keys.caster
	StopSoundOn("dsadowski_01.music.laning_01_layer_03", casterUnit)
end

function diveSound(keys)
	 --print("diveSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_NyxAssassin.Burrow.Out.River", casterUnit)
end

function ramSound(keys)
	
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Shared.WaterFootsteps", casterUnit)
end

function headAboveWaterSoundStart(keys)
	 --print("headAboveWaterSoundStart")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Dark_Seer.Ion_Shield_lp", casterUnit)
end

function headAboveWaterSoundStop(keys)
	 --print("headAboveWaterSoundStop")
	local casterUnit = keys.caster
	StopSoundOn("Hero_Dark_Seer.Ion_Shield_lp", casterUnit)
end

function gunItSound(keys)
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Gyrocopter.IdleLoop", casterUnit)
end
function gunItSoundOff(keys)
	local casterUnit = keys.caster
	StopSoundOn("Hero_Gyrocopter.IdleLoop", casterUnit)
end

function bomberSound(keys)
	 --print("bomberSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Gyrocopter.HomingMissile.Enemy", casterUnit)
end

function launchSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("DOTA_Item.Butterfly", casterUnit)
end

function pillageSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("tusk_tusk_attack_06", casterUnit)
end

function vahSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_LegionCommander.Duel.FP", casterUnit)
end
function vahBoomSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Phoenix.SuperNova.Explode", casterUnit)
end
function dropCraftSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	local i = RandomInt(0, 5)
	if i==5 then
		EmitSoundOn("announcer_dlc_workshop_pirate_announcer_capn_spec_seemyboat", casterUnit)
	else
		EmitSoundOn("Hero_Furion.TreantSpawn", casterUnit)
	end
end

function hitSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_SkywrathMage.MysticFlare.Cast", casterUnit)
end

function pingSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_EarthSpirit.RollingBoulder.StoneBell", casterUnit)
end

function rainbowSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Oracle.FalsePromise.Healed", casterUnit)
end

function rainbowSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Oracle.FalsePromise.Healed", casterUnit)
end

function mountainSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Ability.Avalanche", casterUnit)
end

function maydaySound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("n_creep_ForestTrollHighPriest.Heal", casterUnit)
end

function teleSoundStart(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Portal.Loop_Appear", casterUnit)
end
function teleSoundStop(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	StopSoundOn("Portal.Loop_Appear", casterUnit)
end
function swimSoundStart(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Morphling.MorphAgility", casterUnit)
end
function swimSoundStop(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	StopSoundOn("Hero_Morphling.MorphAgility", casterUnit)
end

function monkeySound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_WitchDoctor.Bonkers.Call", casterUnit)
end

function subDiveSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Morphling.Death", casterUnit)
end

function holdSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Tinker.March_of_the_Machines.Cast", casterUnit)
end


function salvageSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_DeathProphet.Attack", casterUnit)
end

function turretSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Venomancer.Plague_Ward", casterUnit)
end

function shoveSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Tiny.Toss.Target", casterUnit)
end

function ruseSoundStart(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Slark.RazorFlip", casterUnit)
end
function ruseSoundStop(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	StopSoundOn("techies_tech_focuseddetonate_15", casterUnit)
end

function drumSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_TrollWarlord.Taunt.TrollGroove", casterUnit)
end

function mightSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("DOTA_Item.DoE.Activate", casterUnit)
end

function swampSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Venomancer.PoisonNova", casterUnit)
end

function fanSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Shredder.WhirlingDeath.Cast", casterUnit)
end
function dragonHitSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Lina.DragonSlave", casterUnit)
end
function fireworkSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Explode", casterUnit)
end
function navHackSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Oracle.PurifyingFlames", casterUnit)
end
function icebergSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Lich.ChainFrost", casterUnit)
end

function icebergSoundHit(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Lich.ChainFrostImpact.Hero", casterUnit)
end

function estabRouteSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("DOTA_Item.SentryWard.Activate", casterUnit)
end

function ceaseFireSound(keys)
	 --print("launchSound")
	local casterUnit = keys.caster
	EmitSoundOn("Hero_Slark.Pounce.Cast.Immortal", casterUnit)
end


function sevenSound(keys)
	print("sevenSound")
   local casterUnit = keys.caster
   EmitSoundOn("Hero_SkywrathMage.ConcussiveShot.Cast", casterUnit)
end

function sevenSoundhit(keys)
	print("sevenSoundhit")
   local casterUnit = keys.target
   EmitSoundOn("Hero_SkywrathMage.ConcussiveShot.Target", casterUnit)
end


function cherryLaunchSound(keys)
	print("cherryLaunchSound")
   local casterUnit = keys.caster
   EmitSoundOn("Hero_ChaosKnight.idle_throw", casterUnit)
end

function cherryExplodeSound(keys)
	print("cherryExplodeSound")
   local casterUnit = keys.target
   EmitSoundOn("ParticleDriven.Rocket.Explode", casterUnit)
end

function bellLaunchSound(keys)
	print("bellLaunchSound")
   local casterUnit = keys.caster
   EmitSoundOn("Hero_Sven.Attack.Ring", casterUnit)
end

function bellHitSound(keys)
	print("bellHitSound")
   local casterUnit = keys.target
   EmitSoundOn("Hero_Meepo.Poof.End.Crystal04", casterUnit)
end
