local rotationName = "Fiskee - 8.0.1"

local dsInterrupt = false
---------------
--- Toggles ---
---------------
local function createToggles()
-- Rotation Button
    RotationModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Automatic Rotation", tip = "Swaps between Single and Multiple based on number of targets in range.", highlight = 1, icon = br.player.spell.chaosBolt},
        [2] = { mode = "Mult", value = 2 , overlay = "Multiple Target Rotation", tip = "Multiple target rotation used.", highlight = 0, icon = br.player.spell.cataclysm},
        [3] = { mode = "Sing", value = 3 , overlay = "Single Target Rotation", tip = "Single target rotation used.", highlight = 0, icon = br.player.spell.drainSoul},
        [4] = { mode = "Off", value = 4 , overlay = "DPS Rotation Disabled", tip = "Disable DPS Rotation", highlight = 0, icon = br.player.spell.healthFunnel}
    };
    CreateButton("Rotation",1,0)
-- Cooldown Button
    CooldownModes = {
        [1] = { mode = "Auto", value = 1 , overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.summonDoomguard},
        [2] = { mode = "On", value = 1 , overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.summonDoomguard},
        [3] = { mode = "Off", value = 3 , overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.summonDoomguard}
    };
   	CreateButton("Cooldown",2,0)
-- Defensive Button
    DefensiveModes = {
        [1] = { mode = "On", value = 1 , overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.unendingResolve},
        [2] = { mode = "Off", value = 2 , overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.unendingResolve}
    };
    CreateButton("Defensive",3,0)
-- Interrupt Button
    InterruptModes = {
        [1] = { mode = "On", value = 1 , overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.fear},
        [2] = { mode = "Off", value = 2 , overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.fear}
    };
    CreateButton("Interrupt",4,0)
end

---------------
--- OPTIONS ---
---------------
local function createOptions()
    local optionTable

    local function rotationOptions()
        local section
    -- General Options
        section = br.ui:createSection(br.ui.window.profile, "General")
        -- APL
            br.ui:createDropdownWithout(section, "APL Mode", {"|cffFFFFFFSimC"}, 1, "|cffFFFFFFSet APL Mode to use.")
        -- Dummy DPS Test
            br.ui:createSpinner(section, "DPS Testing",  5,  5,  60,  5,  "|cffFFFFFFSet to desired time for test in minuts. Min: 5 / Max: 60 / Interval: 5")
        -- Pre-Pull Timer
            br.ui:createSpinner(section, "Pre-Pull Timer",  2,  1,  10,  1,  "|cffFFFFFFSet to desired time to start Pre-Pull (DBM Required). Min: 1 / Max: 10 / Interval: 1")
        -- Opener
            --br.ui:createCheckbox(section,"Opener")
        -- Pet Management
            br.ui:createCheckbox(section, "Pet Management", "|cffFFFFFF Select to enable/disable auto pet management")
        -- Summon Pet
            br.ui:createDropdownWithout(section, "Summon Pet", {"Imp","Voidwalker","Felhunter","Succubus", "None"}, 1, "|cffFFFFFFSelect default pet to summon.")
        -- Mana Tap
            br.ui:createSpinner(section, "Life Tap HP Limit", 30, 0, 100, 5, "|cffFFFFFFHP Limit that Life Tap will not cast below.")
        -- Multi-Dot Limit
            br.ui:createSpinnerWithout(section, "Multi-Dot Limit", 8, 0, 10, 1, "|cffFFFFFFUnit Count Limit that DoTs will be cast on.")
      	-- Phantom Singularity
      			br.ui:createSpinnerWithout(section, "Cataclysm Units", 1, 1, 10, 1, "|cffFFFFFFNumber of Units Cataclysm will be cast on.")
        -- Shadowfury key
            br.ui:createDropdown(section,"Shadowfury Key", br.dropOptions.Toggle, 6, "","|cffFFFFFFShadowfury stun with logic to hit most mobs.")
        -- No Dot units
            br.ui:createCheckbox(section, "Dot Blacklist", "|cffFFFFFF Check to ignore certain units for dots")
        br.ui:checkSectionState(section)
    -- Cooldown Options
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        -- Racial
            br.ui:createCheckbox(section,"Racial")
        -- Trinkets
            br.ui:createCheckbox(section,"Trinkets")
        -- PS with CDs
            br.ui:createCheckbox(section,"Ignore Cataclysm units when using CDs")
        br.ui:checkSectionState(section)
    -- Defensive Options
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        -- Healthstone
            br.ui:createSpinner(section, "Pot/Stoned",  60,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
        -- Heirloom Neck
            br.ui:createSpinner(section, "Heirloom Neck",  60,  0,  100,  5,  "|cffFFBB00Health Percentage to use at.");
        -- Gift of The Naaru
            if br.player.race == "Draenei" then
                br.ui:createSpinner(section, "Gift of the Naaru",  50,  0,  100,  5,  "|cffFFFFFFHealth Percent to Cast At")
            end
        -- Dark Pact
            br.ui:createSpinner(section, "Dark Pact", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Drain Life
            br.ui:createSpinner(section, "Drain Life", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Health Funnel
            br.ui:createSpinner(section, "Health Funnel", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
        -- Unending Resolve
            br.ui:createSpinner(section, "Unending Resolve", 50, 0, 100, 5, "|cffFFFFFFHealth Percent to Cast At")
            --Soulstone
            br.ui:createCheckbox(section,"Auto Soulstone Player")
        br.ui:checkSectionState(section)
    -- Interrupt Options
        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
    -- Interrupt Percentage
            br.ui:createSpinner(section, "Interrupt At",  0,  0,  95,  5,  "|cffFFFFFFCast Percent to Cast At")
        br.ui:checkSectionState(section)
    -- Toggle Key Options
        section = br.ui:createSection(br.ui.window.profile, "Toggle Keys")
        -- Single/Multi Toggle
            br.ui:createDropdown(section, "Rotation Mode", br.dropOptions.Toggle,  4)
        -- Cooldown Key Toggle
            br.ui:createDropdown(section, "Cooldown Mode", br.dropOptions.Toggle,  3)
        -- Defensive Key Toggle
            br.ui:createDropdown(section, "Defensive Mode", br.dropOptions.Toggle,  6)
        -- Interrupts Key Toggle
            br.ui:createDropdown(section, "Interrupt Mode", br.dropOptions.Toggle,  6)
        -- Pause Toggle
            br.ui:createDropdown(section, "Pause Mode", br.dropOptions.Toggle,  6)
        br.ui:checkSectionState(section)
    end
    optionTable = {{
        [1] = "Rotation Options",
        [2] = rotationOptions,
    }}
    return optionTable
end
----------------
--- ROTATION ---
----------------
local function runRotation()

---------------
--- Toggles ---
---------------
        UpdateToggle("Rotation",0.25)
        UpdateToggle("Cooldown",0.25)
        UpdateToggle("Defensive",0.25)
        UpdateToggle("Interrupt",0.25)

--------------
--- Locals ---
--------------
        local activePet                                     = br.player.pet
        local activePetId                                   = br.player.petId
        local artifact                                      = br.player.artifact
        local buff                                          = br.player.buff
        local cast                                          = br.player.cast
        local castable                                      = br.player.cast.debug
        local combatTime                                    = getCombatTime()
        local cd                                            = br.player.cd
        local charges                                       = br.player.charges
        local deadMouse                                     = UnitIsDeadOrGhost("mouseover")
        local deadtar, attacktar, hastar, playertar         = deadtar or UnitIsDeadOrGhost("target"), attacktar or UnitCanAttack("target", "player"), hastar or GetObjectExists("target"), UnitIsPlayer("target")
        local debuff                                        = br.player.debuff
        local enemies                                       = br.player.enemies
        local equiped                                       = br.player.equiped
        local falling, swimming, flying, moving             = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player")>0
        local friendly                                      = friendly or GetUnitIsFriend("target", "player")
        local gcd                                           = br.player.gcd
        local hasMouse                                      = GetObjectExists("mouseover")
        local hasteAmount                                   = GetHaste()/100
        local hasPet                                        = IsPetActive()
        local healPot                                       = getHealthPot()
        local heirloomNeck                                  = 122663 or 122664
        local immolateCount                                 = br.player.debuff.immolate.count()
        local inCombat                                      = br.player.inCombat
        local inInstance                                    = br.player.instance=="party"
        local inRaid                                        = br.player.instance=="raid"
        local lastSpell                                     = lastSpellCast
        local level                                         = br.player.level
        local lootDelay                                     = getOptionValue("LootDelay")
        local manaPercent                                   = br.player.power.mana.percent()
        local mode                                          = br.player.mode
        local moving                                        = isMoving("player")
        local pet                                           = br.player.pet.list
        local php                                           = br.player.health
        local playerMouse                                   = UnitIsPlayer("mouseover")
        local power, powmax, powgen, powerDeficit           = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen(), br.player.power.mana.deficit()
        local pullTimer                                     = br.DBM:getPulltimer()
        local race                                          = br.player.race
        local shards                                        = (UnitPowerDisplayMod(Enum.PowerType.SoulShards) ~= 0) and (UnitPower("player", Enum.PowerType.SoulShards, true) / UnitPowerDisplayMod(Enum.PowerType.SoulShards)) or 0
        local summonPet                                     = getOptionValue("Summon Pet")
        local solo                                          = br.player.instance=="none"
        local spell                                         = br.player.spell
        local talent                                        = br.player.talent
        local thp                                           = getHP("target")
        local travelTime                                    = getDistance("target")/16
        local ttd                                           = getTTD
        local ttm                                           = br.player.power.mana.ttm()
        local units                                         = br.player.units

        units.get(40)
        enemies.get(8,"target")
        enemies.get(10,"target")
        enemies.get(40)

		    if leftCombat == nil then leftCombat = GetTime() end
	      if profileStop == nil or not inCombat then profileStop = false end
        if castSummonId == nil then castSummonId = 0 end
        if summonTime == nil then summonTime = 0 end

        -- Blacklist dots
        local noDotUnits = {
          [135824]=true, -- Nerubian Voidweaver
          [139057]=true, -- Nazmani Bloodhexer
          [129359]=true, -- Sawtooth Shark
        }
        local function noDotCheck(unit)
          if isChecked("Dot Blacklist") and noDotUnits[GetObjectID(unit)] then return true end
          return false
        end
        --Infernal
        local infernal = false
        if pet ~= nil then
          for k, v in pairs(pet) do
            local thisUnit = pet[k].id or 0
            if thisUnit == 89 then
              infernal = true
              break
            end
          end
        end
        --Havoc remain
        local havocRemain = 0
        local havocMult = 0
        for i = 1, #enemies.yards40 do
          local thisUnit = enemies.yards40[i]
          local remain = debuff.havoc.remain(thisUnit)
          if remain > havocRemain then havocRemain = remain end
        end
        if 1 + havocRemain > cast.time.chaosBolt() then havocMult = 0 end
        --internalCombustion value
        local icValue = 0
        if talent.internalCombustion then icValue = 1 end
        -- Opener Variables
        if not inCombat and not GetObjectExists("target") then
            -- openerCount = 0
            -- OPN1 = false
            -- AGN1 = false
            -- COR1 = false
            -- SIL1 = false
            -- PHS1 = false
            -- UAF1 = false
            -- UAF2 = false
            -- RES1 = false
            -- UAF3 = false
            -- SOH1 = false
            -- DRN1 = false
            -- opener = false
        end

        -- Pet Data
        if summonPet == 1 then summonId = 416 end
        if summonPet == 2 then summonId = 1860 end
        if summonPet == 3 then summonId = 417 end
        if summonPet == 4 then summonId = 1863 end

--------------------
--- Action Lists ---
--------------------
	-- Action List - Extras
		local function actionList_Extras()
		-- Dummy Test
			if isChecked("DPS Testing") then
				if GetObjectExists("target") then
					if getCombatTime() >= (tonumber(getOptionValue("DPS Testing"))*60) and isDummy() then
            StopAttack()
            ClearTarget()
            if isChecked("Pet Management") then
                PetStopAttack()
                PetFollow()
            end
						Print(tonumber(getOptionValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
						profileStop = true
					end
				end
			end -- End Dummy Test
      if isChecked("Auto Soulstone Player") and not inInstance and not inRaid and (not buff.soulstone.exists("player") or buff.soulstone.remain("player") < 100) and not inCombat and not moving then
        if cast.soulstone("player") then return end
      end
		end -- End Action List - Extras
	-- Action List - Defensive
		local function actionList_Defensive()
		if useDefensive() then
		-- Pot/Stoned
        if isChecked("Pot/Stoned") and php <= getOptionValue("Pot/Stoned") and inCombat and (hasHealthPot() or hasItem(5512))
        then
            if canUse(5512) then
                useItem(5512)
            elseif canUse(healPot) then
                useItem(healPot)
            end
        end
        -- Heirloom Neck
        if isChecked("Heirloom Neck") and php <= getOptionValue("Heirloom Neck") then
            if hasEquiped(heirloomNeck) then
                if GetItemCooldown(heirloomNeck)==0 then
                    useItem(heirloomNeck)
                end
            end
        end
-- Gift of the Naaru
        if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
            if castSpell("player",racial,false,false,false) then return end
        end
-- Dark Pact
        if isChecked("Dark Pact") and php <= getOptionValue("Dark Pact") then
            if cast.darkPact() then return end
        end
-- Drain Life
        if isChecked("Drain Life") and php <= getOptionValue("Drain Life") and isValidTarget("target") and not moving then
            if cast.drainLife() then return end
        end
-- Health Funnel
        if isChecked("Health Funnel") and getHP("pet") <= getOptionValue("Health Funnel") and GetObjectExists("pet") == true and not UnitIsDeadOrGhost("pet") and not moving then
            if cast.healthFunnel("pet") then return end
        end
-- Unending gResolve
        if isChecked("Unending Resolve") and php <= getOptionValue("Unending Resolve") and inCombat then
            if cast.unendingResolve() then return end
        end
    	end -- End Defensive Toggle
		end -- End Action List - Defensive
	-- Action List - Interrupts
		local function actionList_Interrupts()
            if useInterrupts() then
            if talent.grimoireOfSacrifice then
                for i=1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
            if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
                if cast.spellLockgrimoire(thisUnit) then return end
                end
            end

            elseif activePetId ~= nil and (activePetId == 417 or activePetId == 78158) then
              for i=1, #enemies.yards40 do
              thisUnit = enemies.yards40[i]
              if canInterrupt(thisUnit,getOptionValue("Interrupt At")) then
        			  if activePetId == 417 then
                  if cast.spellLock(thisUnit) then return end
                end
              end
            end
        end
      end -- End useInterrupts check
		end -- End Action List - Interrupts
	-- Action List - Cooldowns
		local function actionList_Cooldowns()
			if getDistance(units.dyn40) < 40 then
        -- actions.cds=summon_infernal,if=target.time_to_die>=210|!cooldown.dark_soul_instability.remains|target.time_to_die<=30+gcd|!talent.dark_soul_instability.enabled
        if (ttd("target") >= 210 or ttd("target") == -1 or not cd.darkSoul.exists() or ttd("target") <= 30 + gcd or not talent.darkSoul) then
          if cast.summonInfernal("target", "ground") then return true end
        end
        -- actions.cds+=/dark_soul_instability,if=target.time_to_die>=140|pet.infernal.active|target.time_to_die<=20+gcd
        if ttd("target") >= 140 or infernal or ttd("target") <= 20 + gcd then
          if cast.darkSoul("player") then return true end
        end
        if isChecked("Racial") and not moving then
            if race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei" then
                if race == "LightforgedDraenei" then
                    if cast.racial("target","ground") then return true end
                else
                    if cast.racial("player") then return true end
                end
            end
        end
        if isChecked("Trinkets") then
            if canUse(13) then
                useItem(13)
            end
            if canUse(14) then
                useItem(14)
            end
        end
      end -- End useCDs check
    end -- End Action List - Cooldowns

        local function actionList_cata()
          -- actions.cata=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.cata+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 then
            if cast.rainOfFire("target", "ground") then return true end
          end
          if not moving then
            -- actions.cata+=/cataclysm
            if not isMoving("target") and (ttd("target") > 4 or ttd("target") == -1) then
              if cast.cataclysm("target", "ground") then return true end
            end
            -- actions.cata+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then return true end
            end
            -- actions.cata+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=8&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if #enemies.yards8t <= 8 and talent.grimoireOfSupremacy and infernal then --TODO add infernal remain?
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=8&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if (ttd("target") > 10 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                if cast.havoc() then return true end
              end
            end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=8&((108*spell_targets.rain_of_fire%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if talent.grimoireOfSupremacy and infernal and #enemies.yards40 <= 8 and ((108 * #enemies.yards8t % 3) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not debuff.havoc.exists() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4
            if #enemies.yards8t <= 4 then
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=4
              if (ttd("target") > 10 or ttd("target") == -1) and not debuff.havoc.exists(thisUnit) then
                if cast.havoc() then return true end
              end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4
              if havocRemain > cast.time.chaosBolt() then
                if not debuff.havoc.exists() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemies.yards40 do
                  local thisUnit = enemies.yards40[i]
                  if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.cata+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&remains<=cooldown.cataclysm.remains
            if immolateCount < getOptionValue("Multi-Dot Limit") then
              if not debuff.immolate.exists() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                  if cast.immolate() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.immolate.exists(thisUnit) and (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and not noDotCheck(thisUnit) and not debuff.havoc.exists(thisUnit) then
                    if cast.immolate(thisUnit) then return true end
                end
              end
            end
            if debuff.immolate.exists() and debuff.immolate.refresh() and (ttd("target") > 4 or ttd("target") == -1) and not debuff.havoc.exists() and (not useCDs() or debuff.immolate.remain() <= cd.cataclysm.remain()) then
                if cast.immolate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and not debuff.havoc.exists(thisUnit) and (not useCDs() or debuff.immolate.remain(thisUnit) <= cd.cataclysm.remain()) then
                if cast.immolate(thisUnit) then return true end
              end
            end
          end
          -- actions.cata+=/rain_of_fire
          if cast.rainOfFire("target", "ground") then return true end
          if not moving then
            -- actions.cata+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.soulFire() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.soulFire(thisUnit) then return true end
              end
            end
          end
          -- actions.cata+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
          if not debuff.havoc.exists() or #enemies.yards40 == 1 then
            if cast.conflagrate() then return true end
          end
          for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not debuff.havoc.exists(thisUnit) then
              if cast.conflagrate(thisUnit) then return true end
            end
          end
          -- actions.cata+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.shadowburn() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.shadowburn(thisUnit) then return true end
              end
            end
          end
          if not moving then
            -- actions.cata+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_fnb()
          -- actions.fnb=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.fnb+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 then
            if cast.rainOfFire("target", "ground") then return true end
          end
          if not moving then
            -- actions.fnb+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then return true end
            end
            -- actions.cata+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if #enemies.yards8t <= 4 and talent.grimoireOfSupremacy and infernal then --TODO add infernal remain?
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.fnb+=/havoc,if=spell_targets.rain_of_fire<=4&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if (ttd("target") > 10 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                if cast.havoc() then return true end
              end
            end
            -- actions.fnb+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=4&((108*spell_targets.rain_of_fire%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if talent.grimoireOfSupremacy and infernal and #enemies.yards40 <= 4 and ((108 * #enemies.yards8t % 3) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not debuff.havoc.exists() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4
            if #enemies.yards8t <= 4 then
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=4
              if (ttd("target") > 10 or ttd("target") == -1) and not debuff.havoc.exists(thisUnit) then
                if cast.havoc() then return true end
              end
            -- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4
              if havocRemain > cast.time.chaosBolt() then
                if not debuff.havoc.exists() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemies.yards40 do
                  local thisUnit = enemies.yards40[i]
                  if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.fnb+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&spell_targets.incinerate<=8
            if #enemies.yards10t <= 8 then
              if immolateCount < getOptionValue("Multi-Dot Limit") then
                if not debuff.immolate.exists() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                    if cast.immolate() then return true end
                end
                for i = 1, #enemies.yards40 do
                  local thisUnit = enemies.yards40[i]
                  if not debuff.immolate.exists(thisUnit) and (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and not noDotCheck(thisUnit) and not debuff.havoc.exists(thisUnit) then
                      if cast.immolate(thisUnit) then return true end
                  end
                end
              end
              if debuff.immolate.exists() and debuff.immolate.refresh() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                  if cast.immolate() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and not debuff.havoc.exists(thisUnit) then
                  if cast.immolate(thisUnit) then return true end
                end
              end
            end
          end
          -- actions.fnb+=/rain_of_fire
          if cast.rainOfFire("target", "ground") then return true end
          if not moving then
            -- actions.fnb+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains&spell_targets.incinerate=3
            if #enemies.yards10t == 3 then
              if not debuff.havoc.exists() or #enemies.yards40 == 1 then
                if cast.soulFire() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.havoc.exists(thisUnit) then
                  if cast.soulFire(thisUnit) then return true end
                end
              end
            end
          end
          -- actions.fnb+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&(talent.flashover.enabled&buff.backdraft.stack<=2|spell_targets.incinerate<=7|talent.roaring_blaze.enabled&spell_targets.incinerate<=9)
          if (talent.flashover and buff.backdraft.stack() <= 2) or #enemies.yards10t <= 7 or (#enemies.yards10t <= 9 and talent.roaringBlaze) then
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.conflagrate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.conflagrate(thisUnit) then return true end
              end
            end
          end
          if not moving then
          -- actions.fnb+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_inf()
          -- actions.inf=call_action_list,name=cds
          if useCDs() and not moving then
            if actionList_Cooldowns() then return end
          end
          -- actions.inf+=/rain_of_fire,if=soul_shard>=4.5
          if shards >= 4.5 then
            if cast.rainOfFire("target", "ground") then return true end
          end
          if not moving then
            -- actions.inf+=/cataclysm
            if talent.cataclysm and #enemies.yards8t >= getOptionValue("Cataclysm Units") and not isMoving("target") and (ttd("target") > 4 or ttd("target") == -1) then
              if cast.cataclysm("target", "ground") then return true end
            end
            -- actions.inf+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
            if talent.channelDemonfire and not debuff.immolate.exists() and cd.channelDemonfire.remain() <= cast.time.chaosBolt() then
              if cast.immolate() then return true end
            end
            -- actions.inf+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 then
              if cast.channelDemonfire() then return true end
            end
            -- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
            if #enemies.yards8t <= 4 + icValue and talent.grimoireOfSupremacy and infernal then --TODO add infernal remain?
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
              if (ttd("target") > 10 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                if cast.havoc() then return true end
              end
            end
            -- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&spell_targets.rain_of_fire<=4+talent.internal_combustion.enabled&((108*spell_targets.rain_of_fire%(3-0.16*spell_targets.rain_of_fire))<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
            if talent.grimoireOfSupremacy and infernal and #enemies.yards8t <= 4 + icValue and ((108 * #enemies.yards8t %(3 - 0.16*#enemies.yards8t)) < (240*(1+0.08*buff.grimoireOfSupremacy.stack())%2*havocMult)) then
              if not debuff.havoc.exists() and ttd("target") > 6 then
                if cast.chaosBolt() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                  if cast.chaosBolt(thisUnit) then return true end
                end
              end
            end
            -- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
            if #enemies.yards8t <= 3 and (talent.eradication or talent.internalCombustion) then
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                  if cast.havoc(thisUnit) then return true end
                end
              end
            -- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
              if (ttd("target") > 10 or ttd("target") == -1) and not debuff.havoc.exists(thisUnit) then
                if cast.havoc() then return true end
              end
            -- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=3&(talent.eradication.enabled|talent.internal_combustion.enabled)
              if havocRemain > cast.time.chaosBolt() then
                if not debuff.havoc.exists() and ttd("target") > 6 then
                  if cast.chaosBolt() then return true end
                end
                for i = 1, #enemies.yards40 do
                  local thisUnit = enemies.yards40[i]
                  if not debuff.havoc.exists(thisUnit) and ttd(thisUnit) > 6 then
                    if cast.chaosBolt(thisUnit) then return true end
                  end
                end
              end
            end
            -- actions.inf+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable
            if immolateCount < getOptionValue("Multi-Dot Limit") then
              if not debuff.immolate.exists() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                  if cast.immolate() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.immolate.exists(thisUnit) and (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and not noDotCheck(thisUnit) and not debuff.havoc.exists(thisUnit) then
                    if cast.immolate(thisUnit) then return true end
                end
              end
            end
            if debuff.immolate.exists() and debuff.immolate.refresh() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                if cast.immolate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and not debuff.havoc.exists(thisUnit) then
                if cast.immolate(thisUnit) then return true end
              end
            end
          end
          -- actions.inf+=/rain_of_fire
          if cast.rainOfFire("target", "ground") then return true end
          if not moving then
            -- actions.inf+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.soulFire() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.soulFire(thisUnit) then return true end
              end
            end
          end
          -- actions.inf+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
          if not debuff.havoc.exists() or #enemies.yards40 == 1 then
            if cast.conflagrate() then return true end
          end
          for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if not debuff.havoc.exists(thisUnit) then
              if cast.conflagrate(thisUnit) then return true end
            end
          end
          -- actions.inf+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.shadowburn() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.shadowburn(thisUnit) then return true end
              end
            end
          end
          if not moving then
            -- actions.inf+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_Rotation()
          -- actions=run_action_list,name=cata,if=spell_targets.infernal_awakening>=3&talent.cataclysm.enabled
          if #enemies.yards10t >= 3 then
            if talent.cataclysm then
              if actionList_cata() then return end
          -- actions+=/run_action_list,name=fnb,if=spell_targets.infernal_awakening>=3&talent.fire_and_brimstone.enabled
            elseif talent.fireAndBrimstone then
              if actionList_fnb() then return end
          -- actions+=/run_action_list,name=inf,if=spell_targets.infernal_awakening>=3&talent.inferno.enabled
            elseif talent.inferno then
              if actionList_inf() then return end
            end
          end
          if not moving then
            -- actions+=/cataclysm
            if talent.cataclysm and #enemies.yards8t >= getOptionValue("Cataclysm Units") and not isMoving("target") and (ttd("target") > 4 or ttd("target") == -1) then
              if cast.cataclysm("target", "ground") then return true end
            end
            -- actions+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&(refreshable|talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains-action.chaos_bolt.travel_time-5<duration*0.3)
            if immolateCount < getOptionValue("Multi-Dot Limit") then --TODO Add CB thingy
              if not debuff.immolate.exists() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                  if cast.immolate() then return true end
              end
              for i = 1, #enemies.yards40 do
                local thisUnit = enemies.yards40[i]
                if not debuff.immolate.exists(thisUnit) and (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and not noDotCheck(thisUnit) and not debuff.havoc.exists(thisUnit) then
                    if cast.immolate(thisUnit) then return true end
                end
              end
            end
            if debuff.immolate.exists() and debuff.immolate.refresh() and (ttd("target") > 4 or ttd("target") == -1) and (not debuff.havoc.exists() or #enemies.yards40 == 1) then
                if cast.immolate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if (ttd(thisUnit) > 4 or ttd(thisUnit) == -1) and debuff.immolate.exists(thisUnit) and debuff.immolate.refresh(thisUnit) and not debuff.havoc.exists(thisUnit) then
                if cast.immolate(thisUnit) then return true end
              end
            end
            -- actions+=/call_action_list,name=cds
            if useCDs() and not moving then
              if actionList_Cooldowns() then return true end
            end
            -- actions+=/channel_demonfire
            if talent.channelDemonfire and ttd("target") > 5 then
              if cast.channelDemonfire() then return true end
            end
            -- actions+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if (ttd(thisUnit) > 10 or ttd(thisUnit) == -1) and not debuff.havoc.exists(thisUnit) and not GetUnitIsUnit(thisUnit, "target") then
                if cast.havoc(thisUnit) then return true end
              end
            end
            -- actions+=/havoc,if=active_enemies>1
            if (ttd("target") > 10 or ttd("target") == -1) and #enemies.yards40 > 1 and not debuff.havoc.exists(thisUnit) then
              if cast.havoc() then return true end
            end
            -- actions+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.soulFire() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.soulFire(thisUnit) then return true end
              end
            end
            -- actions+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&(talent.internal_combustion.enabled|!talent.internal_combustion.enabled&soul_shard>=4|(talent.eradication.enabled&debuff.eradication.remains<=cast_time)|buff.dark_soul_instability.remains>cast_time|pet.infernal.active&talent.grimoire_of_supremacy.enabled)
            if not debuff.havoc.exists() and (cast.time.chaosBolt() + (getDistance(thisUnit)/16)) < ttd("target") and (talent.internalCombustion or (not talent.internalCombustion and shards >= 4) or
            (talent.eradication and debuff.eradication.remain() <= cast.time.chaosBolt()) or (buff.darkSoul.remain("player") > cast.time.chaosBolt()) or (infernal and talent.grimoireOfService)) and ttd("target") > 6 then
              if cast.chaosBolt() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) and (cast.time.chaosBolt() + (getDistance(thisUnit)/16)) < ttd(thisUnit) and (talent.internalCombustion or (not talent.internalCombustion and shards >= 4) or
              (talent.eradication and debuff.eradication.remain(thisUnit) <= cast.time.chaosBolt()) or (buff.darkSoul.remain("player") > cast.time.chaosBolt()) or (infernal and talent.grimoireOfService)) and ttd(thisUnit) > 6 then
                if cast.chaosBolt(thisUnit) then return true end
              end
            end
          end
          -- actions+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&((talent.flashover.enabled&buff.backdraft.stack<=2)|(!talent.flashover.enabled&buff.backdraft.stack<2))
          if (talent.flashover and buff.backdraft.stack() <= 2) or (not talent.flashover and buff.backdraft.stack() < 2) then
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.conflagrate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.conflagrate(thisUnit) then return true end
              end
            end
          end
          -- actions+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
          if charges.shadowburn.count() == 2 or not buff.backdraft.exists("player") or (buff.backdraft.remain("player") > (buff.backdraft.stack() * cast.time.incinerate())) then
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.shadowburn() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.shadowburn(thisUnit) then return true end
              end
            end
          end
          if not moving then
            -- actions+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
            if not debuff.havoc.exists() or #enemies.yards40 == 1 then
              if cast.incinerate() then return true end
            end
            for i = 1, #enemies.yards40 do
              local thisUnit = enemies.yards40[i]
              if not debuff.havoc.exists(thisUnit) then
                if cast.incinerate(thisUnit) then return true end
              end
            end
          end
        end

        local function actionList_Opener()
          opener = true
        end

        local function actionList_PreCombat()
        -- Summon Pet
            -- summon_pet,if=!talent.grimoire_of_supremacy.enabled&(!talent.grimoire_of_sacrifice.enabled|buff.demonic_power.down)
            if isChecked("Pet Management") and not (IsFlying() or IsMounted()) and (not talent.grimoireOfSacrifice or not buff.demonicPower.exists()) and level >= 5 and br.timer:useTimer("summonPet", cast.time.summonVoidwalker() + 2) and not moving then
                if (activePetId == 0 or activePetId ~= summonId) and (lastSpell ~= castSummonId or activePetId ~= summonId or activePetId == 0) then
                    if summonPet == 1 then
                      if isKnown(spell.summonFelImp) and (lastSpell ~= spell.summonFelImp or activePetId == 0) then
                          if cast.summonFelImp("player") then castSummonId = spell.summonFelImp; return end
                      elseif lastSpell ~= spell.summonImp then
                          if cast.summonImp("player") then castSummonId = spell.summonImp; return end
                      end
                    end
                    if summonPet == 2 and (lastSpell ~= spell.summonVoidwalker or activePetId == 0) then
                      if cast.summonVoidwalker("player") then castSummonId = spell.summonVoidwalker; return end
                    end
                    if summonPet == 3 and (lastSpell ~= spell.summonFelhunter or activePetId == 0) then
                      if cast.summonFelhunter("player") then castSummonId = spell.summonFelhunter; return end
                    end
                    if summonPet == 4 and (lastSpell ~= spell.summonSuccubus or activePetId == 0) then
                      if cast.summonSuccubus("player") then castSummonId = spell.summonSuccubus; return end
                    end
                    if summonPet == 5 then return end
                end
            end
            if not inCombat and not (IsFlying() or IsMounted()) then
            -- Flask
                -- flask,type=whispered_pact
            -- Food
                -- food,type=azshari_salad
                if (not isChecked("Opener") or opener == true) then
                -- Grimoire of Sacrifice
                    -- grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
                    if talent.grimoireOfSacrifice and GetObjectExists("pet") and not UnitIsDeadOrGhost("pet") then
                        if cast.grimoireOfSacrifice() then return end
                    end
                    if useCDs() and isChecked("Pre-Pull Timer") then --and pullTimer <= getOptionValue("Pre-Pull Timer") then
                        if pullTimer <= getOptionValue("Pre-Pull Timer") - 0.5 then
                            if canUse(142117) and not buff.prolongedPower.exists() then
                                useItem(142117);
                                return true
                            end
                        end
                    end -- End Pre-Pull
                    if isValidUnit("target") and getDistance("target") < 40 and (not isChecked("Opener") or opener == true) then
                -- Life Tap
                      -- life_tap,if=talent.empowered_life_tap.enabled&!buff.empowered_life_tap.remains
                      if talent.empoweredLifeTap and not buff.empoweredLifeTap.exists() then
                          if cast.lifeTap() then return end
                      end
                      -- Pet Attack/Follow
                      if isChecked("Pet Management") and GetUnitExists("target") and not UnitAffectingCombat("pet") then
                          PetAssistMode()
                          PetAttack("target")
                      end
                      -- actions.precombat+=/soul_fire
                      if talent.soulFire then
                        if cast.soulFire() then return true end
                      end
                      -- actions.precombat+=/incinerate,if=!talent.soul_fire.enabled
                      if not talent.soulFire then
                        if cast.incinerate() then return true end
                        end
                    end
                end
            end -- End No Combat
            if actionList_Opener() then return end
        end -- End Action List - PreCombat
---------------------
--- Begin Profile ---
---------------------
    -- Profile Stop | Pause
        if not inCombat and not hastar and profileStop==true then
            profileStop = false
        elseif (inCombat and profileStop==true) or IsMounted() or IsFlying() or pause() or mode.rotation==4 then
            if not pause() and IsPetAttackActive() and isChecked("Pet Management") then
                PetStopAttack()
                PetFollow()
            end
            return true
        else
-----------------------
--- Extras Rotation ---
-----------------------
            if actionList_Extras() then return end
--------------------------
--- Defensive Rotation ---
--------------------------
            if actionList_Defensive() then return end
-----------------------
--- Opener Rotation ---
-----------------------
            if opener == false and isChecked("Opener") and isBoss("target") then
                if actionList_Opener() then return end
            end
---------------------------
--- Pre-Combat Rotation ---
---------------------------
			     if actionList_PreCombat() then return end
--------------------------
--- In Combat Rotation ---
--------------------------
            if inCombat and profileStop==false and isValidUnit(units.dyn40) and getDistance(units.dyn40) < 40
                and (opener == true or not isChecked("Opener") or not isBoss("target")) and (not cast.current.drainLife() or (cast.current.drainLife() and php > 80)) then
    ------------------------------
    --- In Combat - Interrupts ---
    ------------------------------
                if actionList_Interrupts() then return end
    ---------------------------
    --- SimulationCraft APL ---
    ---------------------------
                if getOptionValue("APL Mode") == 1 then
        -- Pet Attack
                    if isChecked("Pet Management") and not GetUnitIsUnit("pettarget","target") then
                        PetAttack()
                    end
                    if isChecked("Shadowfury Key") and (SpecificToggle("Shadowfury Key") and not GetCurrentKeyBoardFocus()) then
                      if cast.shadowfury("best",false,1,8) then return end
                    end
                    -- rotation
                    if actionList_Rotation() then return end

                end -- End SimC APL
			end --End In Combat
		end --End Rotation Logic
    end -- End Timer
-- end -- End runRotation
local id = 267
if br.rotations[id] == nil then br.rotations[id] = {} end
tinsert(br.rotations[id],{
    name = rotationName,
    toggles = createToggles,
    options = createOptions,
    run = runRotation,
})
