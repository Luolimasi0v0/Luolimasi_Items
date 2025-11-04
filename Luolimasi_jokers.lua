--- STEAMODDED HEADER
--- MOD_NAME: Luolimasi_jokers
--- MOD_ID: Luolimasi_jokers
--- MOD_AUTHOR: [Luolimasi]
--- MOD_DESCRIPTION: Some jokers

----------------------------------------------
------------MOD CODE -------------------------

local localization
local v_dictionary
local rank_to_value
if G.SETTINGS.language == "zh_CN" then
    local localization_config = dofile(SMODS.current_mod.path .. "localization/zh_CN.lua")
    localization = localization_config.joker
    v_dictionary = localization_config.v_dictionary
    rank_to_value = localization_config.rank_to_value
end
if G.SETTINGS.language ~= "zh_CN" then
    local localization_config = dofile(SMODS.current_mod.path .. "localization/en.lua")
    localization = localization_config.joker
    v_dictionary = localization_config.v_dictionary
    rank_to_value = localization_config.rank_to_value
end

SMODS.process_loc_text(G.localization.misc.v_dictionary, 'a_xchips' , v_dictionary.a_xchips)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'balanced' , v_dictionary.balanced)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'transfer' , v_dictionary.transfer)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'transferFailed' , v_dictionary.transferFailed)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'BakaCirnojoker_weaken' , v_dictionary.BakaCirnojoker_weaken)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'XchipsAndXmult' , v_dictionary.XchipsAndXmult)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'a_deposit' , v_dictionary.a_deposit)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'updated' , v_dictionary.updated)
SMODS.process_loc_text(G.localization.misc.v_dictionary, 'create_tag' , v_dictionary.create_tag)

local function Luolimasi_card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    percent = percent or (0.9 + 0.2*math.random())
    if dir == 'down' then 
        percent = 1-percent
    end

    if extra and extra.focus then card = extra.focus end

    local text = ''
    local sound = nil
    local volume = 1
    local card_aligned = 'bm'
    local y_off = 0.15*G.CARD_H

    if card.area == G.jokers or card.area == G.consumeables then
        y_off = 0.05*card.T.h
    elseif card.area == G.hand then
        y_off = -0.05*G.CARD_H
        card_aligned = 'tm'
    elseif card.area == G.play then
        y_off = -0.05*G.CARD_H
        card_aligned = 'tm'
    elseif card.jimbo  then
        y_off = -0.05*G.CARD_H
        card_aligned = 'tm'
    end
    local config = {}
    local delay = 0.65
    local colour = config.colour or (extra and extra.colour) or ( G.C.FILTER )
    local extrafunc = nil

    if eval_type == 'x_chips' then 
        sound = 'chips1'
        amt = amt
        colour = G.C.CHIPS
        text = localize { type = 'variable', key = 'a_xchips', vars = { amt } }
        delay = 0.6
        config.scale = 0.6
    end

    delay = delay*1.25

    if amt > 0 or amt < 0 then
        if extra and extra.instant then
            if extrafunc then extrafunc() end
            attention_text({
                text = text,
                scale = config.scale or 1, 
                hold = delay - 0.2,
                backdrop_colour = colour,
                align = card_aligned,
                major = card,
                offset = {x = 0, y = y_off}
            })
            play_sound(sound, 0.8+percent*0.2, volume)
            if not extra or not extra.no_juice then
                card:juice_up(0.6, 0.1)
                G.ROOM.jiggle = G.ROOM.jiggle + 0.7
            end
        else
            G.E_MANAGER:add_event(Event({ --Add bonus chips from this card
                    trigger = 'before',
                    delay = delay,
                    func = function()
                    if extrafunc then extrafunc() end
                    attention_text({
                        text = text,
                        scale = config.scale or 1, 
                        hold = delay - 0.2,
                        backdrop_colour = colour,
                        align = card_aligned,
                        major = card,
                        offset = {x = 0, y = y_off}
                    })
                    play_sound(sound, 0.8+percent*0.2, volume)
                    if not extra or not extra.no_juice then
                        card:juice_up(0.6, 0.1)
                        G.ROOM.jiggle = G.ROOM.jiggle + 0.7
                    end
                    return true
                    end
            }))
        end
    end
    if extra and extra.playing_cards_created then 
        playing_card_joker_effects(extra.playing_cards_created)
    end
end

function dump_table(t, indent)
    indent = indent or 0
    for key, value in pairs(t) do
        local formatting = string.rep("  ", indent) .. tostring(key) .. ": "
        if type(value) == "table" then
            print(formatting)
            dump_table(value, indent + 1)
        else
            print(formatting .. tostring(value))
        end
    end
end

local jokers = {
    BakaCirnojoker = {
        name = localization.BakaCirnojoker.name,
        text = localization.BakaCirnojoker.text,
        config = { extra = { chips = 129 , odds = 3 , if_have_end_of_round_test = 0 } },
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 3,
        blueprint_compat = true,                        --can joker be blueprint
        eternal_compat = true,                          --can joker be eternal
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if not context.repetition and SMODS.end_calculate_context(context) then
                return {
                    chip_mod = self.ability.extra.chips,
                    message = localize { type = 'variable', key = 'a_chips', vars = { self.ability.extra.chips } }
                }
            end
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then 
                self.ability.extra.if_have_end_of_round_test = 0
            end
            if context.end_of_round and not self.debuff and not self.getting_sliced and self.ability.extra.chips ~= 0 and self.ability.extra.if_have_end_of_round_test == 0 and not context.blueprint then 
                if pseudorandom('seed') < G.GAME.probabilities.normal/self.ability.extra.odds then
                    self.ability.extra.if_have_end_of_round_test = 1
                    if self.ability.extra.chips == 129 then
                        self.ability.extra.chips = 29
                    elseif self.ability.extra.chips == 29 then
                        self.ability.extra.chips = 9
                    else
                        self.ability.extra.chips = 0
                    end
                    return {
                        message = localize { type = 'variable', key = 'BakaCirnojoker_weaken', vars = { self.ability.extra.chips } }
                    }
                else
                    self.ability.extra.if_have_end_of_round_test = 1
                    return {
                        message = localize('k_safe_ex')
                    }
                end
            end
        end,

        loc_def = function(self) 
            return { self.ability.extra.chips , (G.GAME and G.GAME.probabilities.normal or 1) , self.ability.extra.odds }
        end
    },
    GeniusCirnojoker = {
        name = localization.GeniusCirnojoker.name,
        text = localization.GeniusCirnojoker.text,
        config = { extra = { x_chips = 1 , x_chips_increase_1 = 0.09, x_chips_increase_2 = 0.03} },
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 6,
        blueprint_compat = true,                        --canjoker be blueprint
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.individual and not self.debuff and not context.blueprint then
                if context.cardarea == G.play then
                    if context.other_card:get_id() == 3 then
                        self.ability.extra.x_chips = self.ability.extra.x_chips + self.ability.extra.x_chips_increase_1
                        Luolimasi_card_eval_status_text(self, 'x_chips', self.ability.extra.x_chips, nil, nil, { message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.x_chips } } } )
                    end
                    if context.other_card:get_id() == 9 then 
                        self.ability.extra.x_chips = self.ability.extra.x_chips + self.ability.extra.x_chips_increase_2
                        Luolimasi_card_eval_status_text(self, 'x_chips', self.ability.extra.x_chips, nil, nil, { message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.x_chips } } } )
                    end
                end
            end
            if not context.repetition and SMODS.end_calculate_context(context) then
                return {
                    chip_mod = (self.ability.extra.x_chips * (hand_chips or 0) - (hand_chips or 0)) or 0 ,
                    message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.extra.x_chips } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.extra.x_chips , self.ability.extra.x_chips_increase_1 , self.ability.extra.x_chips_increase_2}
        end
    },
    Money_obsessedjoker = {
        name = localization.Money_obsessedjoker.name,
        text = localization.Money_obsessedjoker.text,
        config = { extra = { dollar = 1 , min_rank = 10 , rank_value = '10'} },
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 6,
        blueprint_compat = true,                        --can joker beblueprint
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        set_ability = function(self)
            self.ability.extra.min_rank = pseudorandom('Moneyobsessed', 2, 14)
        end,

        calculate = function(self,context)
            if context.individual and context.cardarea == G.play and not self.debuff then
                if context.other_card:get_id() > self.ability.extra.min_rank then
                    ease_dollars(self.ability.extra.dollar)
                end
            end

            if context.end_of_round and not context.blueprint then
                local old_rank = self.ability.extra.min_rank
                while self.ability.extra.min_rank == old_rank do
                    self.ability.extra.min_rank = pseudorandom('Moneyobsessed', 2, 14)
                end
                self.ability.extra.rank_value = rank_to_value[self.ability.extra.min_rank]
            end
        end,

        loc_def = function(self) 
            return { self.ability.extra.dollar , self.ability.extra.rank_value }
        end
    },
    Stargazing = {
        name = localization.Stargazing.name,
        text = localization.Stargazing.text,
        config = { extra = { update_count = 0 , dollar = 2 , poker_hand = 'High score' , end_flag = false } },
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 5,
        blueprint_compat = false,                        
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.before and context.cardarea == G.jokers then
                self.ability.extra.poker_hand = context.scoring_name
            end
            if context.end_of_round and not context.blueprint and not self.debuff and not self.getting_sliced then
                local exact_num = pseudorandom('seed')
                while G.GAME.dollars >= self.ability.extra.dollar and not self.ability.extra.end_flag do
                    if exact_num < G.GAME.probabilities.normal/(self.ability.extra.update_count + 2) then 
                        exact_num = pseudorandom('seed')
                        self.ability.extra.update_count = self.ability.extra.update_count + 1
                        local text = self.ability.extra.poker_hand
                        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = G.GAME.hands[text].chips, mult = G.GAME.hands[text].mult, level=G.GAME.hands[text].level})
                        level_up_hand(context.blueprint_card or self, self.ability.extra.poker_hand, nil, 1)
                        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
                        ease_dollars(-self.ability.extra.dollar)
                    else 
                        self.ability.extra.end_flag = true
                    end
                end
            end
            if context.setting_blind and not self.getting_sliced then
                self.ability.extra.update_count = 0
                self.ability.extra.end_flag = false
            end
        end,

        loc_def = function(self) 
            return { self.ability.extra.dollar , self.ability.extra.update_count  }
        end
    },
    PlasmaJoker = {
        name = localization.PlasmaJoker.name,
        text = localization.PlasmaJoker.text,
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 3, 
        cost = 5,
        blueprint_compat = true,                        --can joker beblueprint
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self,context)
            if not context.repetition and SMODS.end_calculate_context(context) then
                local difference
                if hand_chips > mult then 
                    difference = (hand_chips - mult) / 2
                    if difference > hand_chips / 3 then
                        difference = hand_chips / 3
                    end
                    return {
                        chip_mod = -(difference),
                        mult_mod = difference,
                        message = localize {type = 'variable', key = 'balanced'}
                    }
                else
                    difference = (mult - hand_chips) / 2
                    if difference > mult / 3 then
                        difference = mult / 3
                    end
                    return {
                        chip_mod = difference,
                        mult_mod = -(difference),
                        message = localize {type = 'variable', key = 'balanced'}
                    }
                end
            end
        end,
    },
    NegativeJoker = {
        name = localization.NegativeJoker.name,
        text = localization.NegativeJoker.text,
        config = {extra = {odds = 4,flag = 1}},
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 6,
        blueprint_compat = false,
        eternal_compat = false,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            edition = {negative = true}
            if context.end_of_round and not self.debuff and self.ability.extra.flag == 1 and not self.getting_sliced then
                local eligible_editionless_jokers = {}
                for k, v in pairs(G.jokers.cards) do
                    if v.ability.set == 'Joker' and v ~= self and (not v.edition) then
                        table.insert(eligible_editionless_jokers, v)
                    end
                end
                if pseudorandom('NegativeJoker') < G.GAME.probabilities.normal/self.ability.extra.odds then
                    local eligible_card = pseudorandom_element(eligible_editionless_jokers, pseudoseed('NegativeJoker'))
                    if eligible_card then
                        eligible_card:set_edition(edition, true)
                        G.jokers:remove_card(self)
                        self:remove()
                        self = nil
                        return {
                            message = localize {type = 'variable', key = 'transfer'}
                        }
                    end
                else
                    self.ability.extra.odds = self.ability.extra.odds - 1
                    self.ability.extra.flag = 0
                    return {
                        message = localize {type = 'variable', key = 'transferFailed'}
                    }
                end
            end
            if context.setting_blind and not self.getting_sliced then
                self.ability.extra.flag = 1
            end
        end,

        loc_def = function(self) 
            return { (G.GAME and G.GAME.probabilities.normal or 1), self.ability.extra.odds }
        end
    },
    CasinoEntryCard = {
        name = localization.CasinoEntryCard.name,
        text = localization.CasinoEntryCard.text,
        config = {num1 = 45, num2 = 20, num_count = 0, min = 1.5, max = 3.0, uncommon_flag = 0, rare_flag = 0},
        pos = { x = 0, y = 0 },
        rarity = 3, 
        cost = 10,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not self.getting_sliced and not context.blueprint then
                self.ability.num2 = pseudorandom('CasinoEntryCard', 15, 24)
                local random_float = pseudorandom('CasinoEntryCard') * (self.ability.max - self.ability.min) + self.ability.min
                if self.ability.num2 * random_float > 69 then
                    self.ability.num2 = 69
                else
                    local num1 = self.ability.num2 * random_float
                    if num1 % 1 > 0 then
                        num1 = num1 - num1 % 1
                    end
                    self.ability.num1 = num1
                end
                self.ability.uncommon_flag = 0
                self.ability.rare_flag = 0
                return {
                    message = localize {type = 'variable', key = 'updated'}
                }
            end
            if context.cardarea == G.jokers and context.before then
                local sum_id = 0
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i].ability.name ~= 'Stone Card' then
                       sum_id = sum_id + context.scoring_hand[i]:get_id() 
                    end
                end
                self.ability.num_count = sum_id
            end
            if context.cardarea == G.jokers and context.after and not self.debuff then 
                if self.ability.num_count > self.ability.num1 and self.ability.rare_flag == 0 then
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                for i = 1, jokers_to_create do
                                    local card = create_card('Joker', G.jokers, nil, 0.97, nil, nil, nil, 'CasinoEntryCard')
                                    card:add_to_deck()
                                    G.jokers:emplace(card)
                                    card:start_materialize()
                                    G.GAME.joker_buffer = 0
                                end
                                return true
                            end}))
                        self.ability.rare_flag = 1
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                    end
                elseif self.ability.num_count > self.ability.num2 and self.ability.uncommon_flag == 0 then
                    if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                        local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                for i = 1, jokers_to_create do
                                    local card = create_card('Joker', G.jokers, nil, 0.75, nil, nil, nil, 'CasinoEntryCard')
                                    card:add_to_deck()
                                    G.jokers:emplace(card)
                                    card:start_materialize()
                                    G.GAME.joker_buffer = 0
                                end
                                return true
                            end}))
                        self.ability.uncommon_flag = 1
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE})
                    end
                end
            end
        end,

        loc_def = function(self) 
            return { self.ability.num1, self.ability.num2, self.ability.rare_flag, self.ability.uncommon_flag }
        end
    },
    Mod3Limit = {
        name = localization.Mod3Limit.name,
        text = localization.Mod3Limit.text,
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.repetition and context.cardarea == G.play then
                return {
                    message = localize('k_again_ex'),
                    repetitions = context.other_card:get_id() % 3,
                }
           end
        end
    },
    ChipSquirrel = {
        name = localization.ChipSquirrel.name,
        text = localization.ChipSquirrel.text,
        config = { extra = {x_chips = 1, x_chips_increase = 0.05, if_have_end_of_round_test = false} },
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.end_of_round and not self.debuff and not self.getting_sliced and not context.blueprint and not self.ability.extra.if_have_end_of_round_test then
                self.ability.extra.if_have_end_of_round_test = true
                local enhanced_count = 0
                for i = 1, #G.hand.cards do
                    local card = G.hand.cards[i]

                    if card.config.center ~= G.P_CENTERS.c_base and not card.debuff then
                        enhanced_count = enhanced_count + 1
                    end
                end
                if enhanced_count > 0 then
                    self.ability.extra.x_chips = self.ability.extra.x_chips + self.ability.extra.x_chips_increase * enhanced_count
                    Luolimasi_card_eval_status_text(self, 'x_chips', self.ability.extra.x_chips, nil, nil, { message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.x_chips } } } )
                end
            end
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then 
                self.ability.extra.if_have_end_of_round_test = false
            end
            if not context.repetition and SMODS.end_calculate_context(context) and self.ability.extra.x_chips > 1 then
                return {
                    chip_mod = (self.ability.extra.x_chips * (hand_chips or 0) - (hand_chips or 0)) or 0 ,
                    message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.extra.x_chips } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.extra.x_chips, self.ability.extra.x_chips_increase }
        end
    },
    TarotDealer = {
        name = localization.TarotDealer.name,
        text = localization.TarotDealer.text,
        config = {Xchips = 1, Xchips_increase = 0.35},
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.open_booster and not context.blueprint then 
                if context.card.ability.name:find("Arcana") then
                    self.ability.Xchips = self.ability.Xchips + self.ability.Xchips_increase
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        card = self
                    }
                end
            end
            if not context.repetition and SMODS.end_calculate_context(context) and self.ability.Xchips > 1 then
                return {
                    chip_mod = (self.ability.Xchips * (hand_chips or 0) - (hand_chips or 0)) or 0 ,
                    message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.Xchips } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.Xchips, self.ability.Xchips_increase }
        end
    },
    TheAstrologer = {
        name = localization.TheAstrologer.name,
        text = localization.TheAstrologer.text,
        config = {Xchips = 1, Xmult = 1, Xchips_increase = 0.07, Xmult_increase = 0.05},
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.using_consumeable and not context.blueprint and context.consumeable then
                if context.consumeable.ability.set == 'Planet' then
                    self.ability.Xchips = self.ability.Xchips + self.ability.Xchips_increase
                    Luolimasi_card_eval_status_text(self, 'x_chips', self.ability.Xchips, nil, nil, { message = localize { type = 'variable', key = 'a_xchips', vars = { self.ability.Xchips } } } )
                end
                if context.consumeable.ability.set == 'Tarot' then
                    self.ability.Xmult = self.ability.Xmult + self.ability.Xmult_increase
                    card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.Xmult } } } )
                end
            end
            if not context.repetition and SMODS.end_calculate_context(context) and (self.ability.Xchips > 1 or self.ability.Xmult > 1) then
                return {
                    chip_mod = (self.ability.Xchips * (hand_chips or 0) - (hand_chips or 0)) or 0 ,
                    Xmult_mod = self.ability.Xmult,
                    message = localize { type = 'variable', key = 'XchipsAndXmult', vars = { self.ability.Xchips , self.ability.Xmult } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.Xchips, self.ability.Xmult, self.ability.Xchips_increase, self.ability.Xmult_increase }
        end
    },
    TheShowman = {
        name = localization.TheShowman.name,
        text = localization.TheShowman.text,
        config = {Xmult = 1, min_increase = 0.05, max_increase = 0.5, end_of_round_flag},
        pos = { x = 0, y = 0 },
        rarity = 3, 
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            -- if context.individual and context.cardarea == G.play then
            --     self.ability.blind_chips = G.GAME.blind.chips
            -- end
            if context.end_of_round and not self.debuff and not context.blueprint and not self.ability.end_of_round_flag and not self.getting_sliced then
                self.ability.end_of_round_flag = true
                local increasement = (G.GAME.chips - 1.5 * G.GAME.blind.chips) / G.GAME.blind.chips
                if increasement < self.ability.min_increase then
                    increasement = self.ability.min_increase
                end
                if increasement > self.ability.max_increase then
                    increasement = self.ability.max_increase
                end
                self.ability.Xmult = self.ability.Xmult + increasement
                card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.Xmult } } } )
            end
            if not context.repetition and SMODS.end_calculate_context(context) and self.ability.Xmult > 1 then
                return {
                    Xmult_mod = self.ability.Xmult,
                    message = localize { type = 'variable', key = 'a_xmult', vars = { self.ability.Xmult } }
                }
            end
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced then 
                self.ability.end_of_round_flag = false
            end
        end,

        loc_def = function(self) 
            return { self.ability.Xmult, self.ability.min_increase , self.ability.max_increase }
        end
    },
    JokerBank = {
        name = localization.JokerBank.name,
        text = localization.JokerBank.text,
        config = {chips = 0, increase_mult = 3, deposit = 0, end_of_round_flag = false},
        pos = { x = 0, y = 0 },
        rarity = 2, 
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced and not context.blueprint then
                self.ability.end_of_round_flag = false
                local deposit = G.GAME.dollars / 2
                if (deposit % 1 > 0) then
                    deposit = deposit - deposit % 1
                end
                self.ability.extra_value = self.ability.extra_value + deposit
                self:set_cost()
                ease_dollars(-deposit)
                self.ability.deposit = self.ability.deposit + deposit
                return {
                    message = localize { type = 'variable', key = 'a_deposit', vars = { deposit } },
                }
            end
            if context.end_of_round and G.GAME.blind.boss and not self.debuff and not context.blueprint and not self.ability.end_of_round_flag then
                self.ability.end_of_round_flag = true
                self.ability.chips = self.ability.chips + self.ability.deposit * self.ability.increase_mult
                self.ability.extra_value = self.ability.extra_value - self.ability.deposit
                local deposit = self.ability.deposit / 2
                if (deposit % 1 > 0) then
                    deposit = deposit - deposit % 1 + 1
                end
                self.ability.deposit = 0
                self:set_cost()
                ease_dollars(deposit)
                return {
                    message = localize{ type = 'variable', key = 'a_chips', vars = { deposit * self.ability.increase_mult } },
                    colour = G.C.CHIPS
                }
            end
            if not context.repetition and SMODS.end_calculate_context(context) and self.ability.chips > 0 then
                return {
                    chip_mod = self.ability.chips,
                    message = localize { type = 'variable', key = 'a_chips', vars = { self.ability.chips } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.chips, self.ability.increase_mult, self.ability.deposit }
        end
    },
    TheQuasar = {
        name = localization.TheQuasar.name,
        text = localization.TheQuasar.text,
        config = {mult = 0, hand_count = 0},
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 4,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.cardarea == G.jokers and context.before and G.GAME.current_round.hands_played < 2 and not context.blueprint then
                local played_times_rank = 0
                local times_played = G.GAME.hands[context.scoring_name].played
                for hand_name, hand_data in pairs(G.GAME.hands) do
                    if hand_data.played >= times_played then
                        played_times_rank = played_times_rank + 1
                    end
                end
                if played_times_rank > 5 then
                    played_times_rank = 5
                end
                self.ability.mult = self.ability.mult + played_times_rank
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { played_times_rank } },
                }
            end
            if not context.repetition and SMODS.end_calculate_context(context) and self.ability.mult > 0 then
                return {
                    mult_mod = self.ability.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = { self.ability.mult } }
                }
            end
        end,

        loc_def = function(self) 
            return { self.ability.mult }
        end
    },
    BlackMarketBroker = {
        name = localization.BlackMarketBroker.name,
        text = localization.BlackMarketBroker.text,
        config = {pack_money = 5, money = 0, end_of_round_flag = false},
        pos = { x = 0, y = 0 },
        rarity = 1, 
        cost = 4,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,   
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not (context.blueprint_card or self).getting_sliced and not context.blueprint then 
                self.ability.end_of_round_flag = false
            end
            if context.end_of_round and not self.debuff and not context.blueprint and not self.ability.end_of_round_flag then
                self.ability.end_of_round_flag = true
                local sliced_card = nil
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == self then sliced_card = G.jokers.cards[i + 1] end
                end
                if sliced_card and sliced_card ~= self then
                    sliced_card.getting_sliced = true
                    local sell_cost = sliced_card.sell_cost
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        self.ability.money = self.ability.money + sell_cost
                        self:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('coin1', 0.96+math.random()*0.08)
                    return true end }))
                    self.ability.extra_value = self.ability.extra_value + sell_cost
                    self:set_cost()
                    card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'a_deposit', vars = { sell_cost } } } )
                end
            end
            if context.ending_shop and not self.debuff and not context.blueprint and self.ability.money >= self.ability.pack_money then
                print("triggered")
                local money = self.ability.money
                local pack_money = self.ability.pack_money
                while money >= pack_money do
                    money = money - pack_money
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            add_tag(Tag('tag_buffoon'))
                            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                            return true
                        end)
                    }))
                    self.ability.extra_value = self.ability.extra_value - pack_money
                    self:set_cost()
                end
                self.ability.money = money
                card_eval_status_text(self, 'extra', nil, nil, nil, { message = localize { type = 'variable', key = 'create_tag' } } )
            end
        end,

        loc_def = function(self) 
            return { self.ability.pack_money, self.ability.money }
        end
    }
}

function SMODS.INIT.Luolimasi_jokers()

    G.localization.descriptions.Other["your_key"] = {
        name = "Example", --tooltip name
        text = {
            "TEXT L1",   --tooltip text.		
            "TEXT L2",   --you can add as many lines as you want
            "TEXT L3"    --more than 5 lines look odd
        }
    }
    init_localization()

    --Create and register jokers
    for k, v in pairs(jokers) do --for every object in 'jokers'
        local joker = SMODS.Joker:new(v.name, k, v.config, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost,
            v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat, v.effect, v.atlas, v.soul_pos)
        joker:register()

        if not v.atlas then --if atlas=nil then use single sprites. In this case you have to save your sprite as slug.png (for example j_examplejoker.png)
            SMODS.Sprite:new("j_" .. k, SMODS.findModByID("Luolimasi_jokers").path, "j_" .. k .. ".png", 71, 95, "asset_atli")
                :register()
        end

        --add jokers calculate function:
        SMODS.Jokers[joker.slug].calculate = v.calculate
        --add jokers loc_def:
        SMODS.Jokers[joker.slug].loc_def = v.loc_def
        --if tooltip is present, add jokers tooltip
        if (v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip = v.tooltip
        end
    end
end

----------------------------------------------
------------MOD CODE END----------------------