if !LotsOfCurrency.HasWorkshopItem("2434175015") then return end

local colors = {
  {"purple", 4, 30, 50},
  {"red", 3, 20, 20},
  {"blue", 2, 15, 5},
  {"green", 1, 10, 1},
}

local sizes = {
  {"colossal", "_x2_5", {"rupee4.wav"}},
  {"enormous", "_x2", {"rupee4.wav"}},
  {"giant", "_x1_5", {"rupee3.wav"}},
  {"big", "", {"rupee2.wav"}},
  {"small", "_x0_5", {"rupee1.wav"}},
}

local collect_noises = {"spyro_gems/GemGet1.wav"}
local bounce_noises = {"spyro_gems/Ping1.wav"}
local spawn_noises = {"spyro_gems/Ping1.wav"}
if LotsOfCurrency.HasWorkshopItem("1234633466") then
  spawn_noises = {"rupeespawn1.wav", "rupeespawn2.wav", "rupeespawn3.wav", "rupeespawn4.wav", "rupeespawn5.wav"}
  bounce_noises = spawn_noises
end

local sharp_ents = {}
local sharp_ent_definitions = {}
local flat_ents = {}
local flat_ent_definitions = {}
local values = {}

for i = 1, #sizes do
  local size = sizes[i]
  local cn = collect_noises
  if LotsOfCurrency.HasWorkshopItem("1234633466") then
    cn = size[3]
  end
  for j = 1, #colors do
    local color = colors[j]
    local worth = math.pow(10, #sizes - i) * color[3]
    if i == #sizes then
      worth = color[4]
    end

    local ent_name = "zelda_force_gem_sharp_" .. size[1] .. "_" .. color[1]
    local fancy_prefix = size[1]:gsub("^%l", string.upper) .. " " .. color[1]:gsub("^%l", string.upper)
    table.insert(sharp_ents, ent_name)
    sharp_ent_definitions[ent_name] = {
      PrintName = fancy_prefix .. " Force Gem",
      Model = "models/botw/force_gem_a" .. size[2] .. ".mdl",
      Skin = color[2],
      Worth = worth,
      CollectNoises = cn,
      SpawnNoises = spawn_noises,
      BounceNoises = bounce_noises,
    }

    ent_name = "zelda_force_gem_flat_" .. size[1] .. "_" .. color[1]
    table.insert(flat_ents, ent_name)
    flat_ent_definitions[ent_name] = {
      PrintName = fancy_prefix .. " Flat Force Gem",
      Model = "models/botw/force_gem_b" .. size[2] .. ".mdl",
      Skin = color[2],
      Worth = worth,
      CollectNoises = cn,
      SpawnNoises = spawn_noises,
      BounceNoises = bounce_noises,
    }

    table.insert(values, worth)
  end
end



LotsOfCurrency.RegisterDenomination(
  "zelda_force_gems_sharp",
  {
    ents = sharp_ents,
    values = values,
  },
  sharp_ent_definitions
)

LotsOfCurrency.RegisterDenomination(
  "zelda_force_gems_flat",
  {
    ents = flat_ents,
    values = values,
  },
  flat_ent_definitions
)
