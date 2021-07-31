ability_shard_giver = class({})

function ability_shard_giver:Spawn()
  if IsServer() then
    self:SetLevel(1)
    local caster = self:GetCaster()
    caster:AddNewModifier(nil, nil, "modifier_item_aghanims_shard", {})
  end
end