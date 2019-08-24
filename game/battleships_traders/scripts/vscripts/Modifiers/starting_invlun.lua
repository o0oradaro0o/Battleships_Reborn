modifier_spawn_invlun = class({})


function modifier_spawn_invlun:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_spawn_invlun:IsHidden()
    return false
end
