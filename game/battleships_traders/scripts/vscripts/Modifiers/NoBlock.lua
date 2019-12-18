modifier_no_block = class({})


function modifier_no_block:CheckState()
	local state = {
	[MODIFIER_STATE_BLOCK_DISABLED] = true,
	}
	return state
end


function modifier_no_block:IsHidden()
    return true
end

function modifier_no_block:RemoveOnDeath()
    return false
end

function modifier_no_block:RemoveOnDeath(  )
    return false
end