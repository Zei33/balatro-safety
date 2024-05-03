local logging = require("logging")
local logger = logging.getLogger("balatro-safety")

local function create_multiline_text(text, text_scale, alignment, padding)
	local text = text or { }
	for i, v in ipairs(text) do
		text[i] = {
			n = G.UIT.R,
			config = {
				align = alignment or "cm",
				padding = padding or 0.05
			},
			nodes = {
				{
					n = G.UIT.T,
					config = {
						text = v,
						scale = text_scale or 1,
						colour = G.C.UI.TEXT_LIGHT,
						shadow = true
					}
				}
			}
		};
	end;

	return text
end

local function create_UIBox_generic_container(options)
    options = options or {
		content = {}
	}

    return {
		{
			n = G.UIT.R,
			config = {
				align = "cm",
				padding = 0.03,
				colour = G.C.UI.TRANSPARENT_LIGHT,
				r = 1
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						padding = 0.05,
						colour = G.C.DYN_UI.MAIN,
						r = 1
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								colour = G.C.DYN_UI.BOSS_DARK,
								minw = options.width or 10,
								minh = options.height or 4,
								r = 1,
								padding = 0.08
							},
							nodes = options.content
						}
					}
				}
			}
		}
	}
end

local function create_UIBox_confirmation(options)
	options = options or {}

	return {
		{
			n = G.UIT.C,
			config = {
				align = "cm",
				padding = 0,
				minw = 5,
				minh = 4,
				r = 1,
				--colour = G.C.GREEN
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						padding = 0,
						minw = 5,
						minh = 4,
						r = 1,
						--colour = G.C.UI.BACKGROUND_DARK
					},
					nodes = {
						{
							n = G.UIT.O,
							config = {
								align = "cm",
								object = options.card
							}
						}
					}
				},
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						padding = 0,
						minw = 5,
						minh = 2.4,
						r = 1,
						colour = G.C.UI.BACKGROUND_LIGHT
					},
					nodes = {
						{
							n = G.UIT.T,
							config = {
								text = "This is a very dangerous card",
								scale = 0.25,
								colour = G.C.SO_2.HEARTS,
								shadow = true
							}
						}
					}
				}
			}
		},
		{
			n = G.UIT.C,
			config = {
				align = "cr",
				padding = 0,
				minw = 5,
				minh = 4,
				r = 1,
				colour = G.C.UI.BACKGROUND_DARK
			},
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						padding = 0.025,
						minw = 5,
						minh = 4,
						maxw = 5,
						r = 1
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								padding = 0.3,
								minw = 5,
								minh = 2,
								maxw = 5,
								r = 1,
								--colour = G.C.BLUE
							},
							nodes = create_multiline_text({
								"Are you SURE",
								"you want to do this?"
							}, 0.75, "cm", 0.02, 1)
						}
					}
				},
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						padding = 0.025,
						minw = 5,
						minh = 2,
						maxw = 5,
						r = 1
					},
					nodes = {
						{
							n = G.UIT.R,
							config = {
								align = "cm",
								padding = 0.025,
								minw = 5,
								minh = 2,
								maxw = 5,
								r = 1,
								--colour = G.C.RED
							},
							nodes = {
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										padding = 0.05,
										minw = 4.75,
										minh = 1,
										maxw = 4.75,
										r = 1
									},
									nodes = {
										UIBox_button({
											button = 'safety_confirm', 
											label = { "CONFIRM" },
											minw = 4.75, 
											minh = 0.95, 
											scale = 0.5, 
											colour = G.C.GREEN,
											id = 'safety_confirm'
										})
									}
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										padding = 0.05,
										minw = 4.75,
										minh = 1,
										maxw = 5,
										r = 1
									},
									nodes = {
										UIBox_button({
											button = 'safety_cancel', 
											label = { "CANCEL" },
											minw = 4.75, 
											minh = 0.95, 
											scale = 0.5, 
											colour = G.C.RED,
											id = 'safety_cancel'
										})
									}
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
										padding = 0,
										minw = 4.5,
										minh = 0.1,
										maxw = 5,
										r = 1
									}
								}
							}
						}
					}
				}
			}
		}
	}
end

local function on_enable()
	G.UIDEF.safety_box = function(card)
		return {
			n = G.UIT.ROOT,
			config = {
				align = "cm",
				padding = 0.1,
				r = 2
			},
			nodes = create_UIBox_generic_container({
				content = create_UIBox_confirmation({
					card = card
				})
			})
		}
	end

	--area = CardArea()

	--Card:set_card_area(area)
	--pseudorandom_element(G.P_CARDS, pseudoseed('front'))
	card = Card(0, 0, G.CARD_W, G.CARD_H, G.P_CENTERS.c_hex, G.P_CENTERS.c_hex)
	card.no_ui = true
	logger:info("---------------------------------------------")
	--logger:info(card.generate_UIBox_ability_table())
	--test = generate_card_ui(card.config.center, )
	--ability_table = card:generate_UIBox_ability_table()
	generate_ability_table(card)
	logger:info("---------------------------------------------")

	G.FUNCS.overlay_menu({definition = G.UIDEF.safety_box(card)})
end

function generate_ability_table(_card)
    local card_type, hide_desc = _card.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil,nil
    local no_badge = nil
    
    if not _card.bypass_lock and _card.config.center.unlocked ~= false and
    (_card.ability.set == 'Joker' or _card.ability.set == 'Edition' or _card.ability.consumeable or _card.ability.set == 'Voucher' or _card.ability.set == 'Booster') and
    not _card.config.center.discovered and 
    ((_card.area ~= G.jokers and _card.area ~= G.consumeables and _card.area) or not _card.area) then
        card_type = 'Undiscovered'
    end    
    if _card.config.center.unlocked == false and not _card.bypass_lock then --For everyting that is locked
        card_type = "Locked"
        if _card.area and _card.area == G.shop_demo then loc_vars = {}; no_badge = true end
    elseif card_type == 'Undiscovered' and not _card.bypass_discovery_ui then -- Any Joker or tarot/planet/voucher that is not yet discovered
        hide_desc = true
    elseif _card.debuff then
        loc_vars = { debuffed = true, playing_card = not not _card.base.colour, value = _card.base.value, suit = _card.base.suit, colour = _card.base.colour }
    elseif card_type == 'Default' or card_type == 'Enhanced' then
        loc_vars = { playing_card = not not _card.base.colour, value = _card.base.value, suit = _card.base.suit, colour = _card.base.colour,
                    nominal_chips = _card.base.nominal > 0 and _card.base.nominal or nil,
                    bonus_chips = (_card.ability.bonus + (_card.ability.perma_bonus or 0)) > 0 and (_card.ability.bonus + (_card.ability.perma_bonus or 0)) or nil,
                }
    elseif _card.ability.set == 'Joker' then -- all remaining jokers
        if _card.ability.name == 'Joker' then loc_vars = {_card.ability.mult}
        elseif _card.ability.name == 'Jolly Joker' or _card.ability.name == 'Zany Joker' or
            _card.ability.name == 'Mad Joker' or _card.ability.name == 'Crazy Joker'  or 
            _card.ability.name == 'Droll Joker' then 
            loc_vars = {_card.ability.t_mult, localize(_card.ability.type, 'poker_hands')}
        elseif _card.ability.name == 'Sly Joker' or _card.ability.name == 'Wily Joker' or
        _card.ability.name == 'Clever Joker' or _card.ability.name == 'Devious Joker'  or 
        _card.ability.name == 'Crafty Joker' then 
            loc_vars = {_card.ability.t_chips, localize(_card.ability.type, 'poker_hands')}
        elseif _card.ability.name == 'Half Joker' then loc_vars = {_card.ability.extra.mult, _card.ability.extra.size}
        elseif _card.ability.name == 'Fortune Teller' then loc_vars = {_card.ability.extra, (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}
        elseif _card.ability.name == 'Steel Joker' then loc_vars = {_card.ability.extra, 1 + _card.ability.extra*(_card.ability.steel_tally or 0)}
        elseif _card.ability.name == 'Chaos the Clown' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Space Joker' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra}
        elseif _card.ability.name == 'Stone Joker' then loc_vars = {_card.ability.extra, _card.ability.extra*(_card.ability.stone_tally or 0)}
        elseif _card.ability.name == 'Drunkard' then loc_vars = {_card.ability.d_size}
        elseif _card.ability.name == 'Green Joker' then loc_vars = {_card.ability.extra.hand_add, _card.ability.extra.discard_sub, _card.ability.mult}
        elseif _card.ability.name == 'Credit Card' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Greedy Joker' or _card.ability.name == 'Lusty Joker' or
            _card.ability.name == 'Wrathful Joker' or _card.ability.name == 'Gluttonous Joker' then loc_vars = {_card.ability.extra.s_mult, localize(_card.ability.extra.suit, 'suits_singular')}
        elseif _card.ability.name == 'Blue Joker' then loc_vars = {_card.ability.extra, _card.ability.extra*((G.deck and G.deck.cards) and #G.deck.cards or 52)}
        elseif _card.ability.name == 'Sixth Sense' then loc_vars = {}
        elseif _card.ability.name == 'Mime' then
        elseif _card.ability.name == 'Hack' then loc_vars = {_card.ability.extra+1}
        elseif _card.ability.name == 'Pareidolia' then 
        elseif _card.ability.name == 'Faceless Joker' then loc_vars = {_card.ability.extra.dollars, _card.ability.extra.faces}
        elseif _card.ability.name == 'Oops! All 6s' then
        elseif _card.ability.name == 'Juggler' then loc_vars = {_card.ability.h_size}
        elseif _card.ability.name == 'Golden Joker' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Joker Stencil' then loc_vars = {_card.ability.x_mult}
        elseif _card.ability.name == 'Four Fingers' then
        elseif _card.ability.name == 'Ceremonial Dagger' then loc_vars = {_card.ability.mult}
        elseif _card.ability.name == 'Banner' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Misprint' then
            local r_mults = {}
            for i = _card.ability.extra.min, _card.ability.extra.max do
                r_mults[#r_mults+1] = tostring(i)
            end
            local loc_mult = ' '..(localize('k_mult'))..' '
            main_start = {
                {n=G.UIT.T, config={text = '  +',colour = G.C.MULT, scale = 0.32}},
                {n=G.UIT.O, config={object = DynaText({string = r_mults, colours = {G.C.RED},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0})}},
                {n=G.UIT.O, config={object = DynaText({string = {
                    {string = 'rand()', colour = G.C.JOKER_GREY},{string = "#@"..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11)..(G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1,1) or 'D'), colour = G.C.RED},
                    loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult},
                colours = {G.C.UI.TEXT_DARK},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.2011, scale = 0.32, min_cycle_time = 0})}},
            }
        elseif _card.ability.name == 'Mystic Summit' then loc_vars = {_card.ability.extra.mult, _card.ability.extra.d_remaining}
        elseif _card.ability.name == 'Marble Joker' then
        elseif _card.ability.name == 'Loyalty Card' then loc_vars = {_card.ability.extra.Xmult, _card.ability.extra.every + 1, localize{type = 'variable', key = (_card.ability.loyalty_remaining == 0 and 'loyalty_active' or 'loyalty_inactive'), vars = {_card.ability.loyalty_remaining}}}
        elseif _card.ability.name == '8 Ball' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1),_card.ability.extra}
        elseif _card.ability.name == 'Dusk' then loc_vars = {_card.ability.extra+1}
        elseif _card.ability.name == 'Raised Fist' then
        elseif _card.ability.name == 'Fibonacci' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Scary Face' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Abstract Joker' then loc_vars = {_card.ability.extra, (G.jokers and G.jokers.cards and #G.jokers.cards or 0)*_card.ability.extra}
        elseif _card.ability.name == 'Delayed Gratification' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Gros Michel' then loc_vars = {_card.ability.extra.mult, ''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra.odds}
        elseif _card.ability.name == 'Even Steven' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Odd Todd' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Scholar' then loc_vars = {_card.ability.extra.mult, _card.ability.extra.chips}
        elseif _card.ability.name == 'Business Card' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra}
        elseif _card.ability.name == 'Supernova' then
        elseif _card.ability.name == 'Spare Trousers' then loc_vars = {_card.ability.extra, localize('Two Pair', 'poker_hands'), _card.ability.mult}
        elseif _card.ability.name == 'Superposition' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Ride the Bus' then loc_vars = {_card.ability.extra, _card.ability.mult}
        elseif _card.ability.name == 'Egg' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Burglar' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Blackboard' then loc_vars = {_card.ability.extra, localize('Spades', 'suits_plural'), localize('Clubs', 'suits_plural')}
        elseif _card.ability.name == 'Runner' then loc_vars = {_card.ability.extra.chips, _card.ability.extra.chip_mod}
        elseif _card.ability.name == 'Ice Cream' then loc_vars = {_card.ability.extra.chips, _card.ability.extra.chip_mod}
        elseif _card.ability.name == 'DNA' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Splash' then
        elseif _card.ability.name == 'Constellation' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Hiker' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'To Do List' then loc_vars = {_card.ability.extra.dollars, localize(_card.ability.to_do_poker_hand, 'poker_hands')}
        elseif _card.ability.name == 'Smeared Joker' then
        elseif _card.ability.name == 'Blueprint' then
            _card.ability.blueprint_compat_ui = _card.ability.blueprint_compat_ui or ''; _card.ability.blueprint_compat_check = nil
            main_end = (_card.area and _card.area == G.jokers) and {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = _card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                        {n=G.UIT.T, config={ref_table = _card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                    }}
                }}
            } or nil
        elseif _card.ability.name == 'Cartomancer' then
        elseif _card.ability.name == 'Astronomer' then loc_vars = {_card.ability.extra}
        
        elseif _card.ability.name == 'Golden Ticket' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Mr. Bones' then
        elseif _card.ability.name == 'Acrobat' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Sock and Buskin' then loc_vars = {_card.ability.extra+1}
        elseif _card.ability.name == 'Swashbuckler' then loc_vars = {_card.ability.mult}
        elseif _card.ability.name == 'Troubadour' then loc_vars = {_card.ability.extra.h_size, -_card.ability.extra.h_plays}
        elseif _card.ability.name == 'Certificate' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Throwback' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Hanging Chad' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Rough Gem' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Bloodstone' then loc_vars = {''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra.odds, _card.ability.extra.Xmult}
        elseif _card.ability.name == 'Arrowhead' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Onyx Agate' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Glass Joker' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Showman' then
        elseif _card.ability.name == 'Flower Pot' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Wee Joker' then loc_vars = {_card.ability.extra.chips, _card.ability.extra.chip_mod}
        elseif _card.ability.name == 'Merry Andy' then loc_vars = {_card.ability.d_size, _card.ability.h_size}
        elseif _card.ability.name == 'The Idol' then loc_vars = {_card.ability.extra, localize(G.GAME.current_round.idol_card.rank, 'ranks'), localize(G.GAME.current_round.idol_card.suit, 'suits_plural'), colours = {G.C.SUITS[G.GAME.current_round.idol_card.suit]}}
        elseif _card.ability.name == 'Seeing Double' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Matador' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Hit the Road' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'The Duo' or _card.ability.name == 'The Trio'
            or _card.ability.name == 'The Family' or _card.ability.name == 'The Order' or _card.ability.name == 'The Tribe' then loc_vars = {_card.ability.x_mult, localize(_card.ability.type, 'poker_hands')}
        
        elseif _card.ability.name == 'Cavendish' then loc_vars = {_card.ability.extra.Xmult, ''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra.odds}
        elseif _card.ability.name == 'Card Sharp' then loc_vars = {_card.ability.extra.Xmult}
        elseif _card.ability.name == 'Red Card' then loc_vars = {_card.ability.extra, _card.ability.mult}
        elseif _card.ability.name == 'Madness' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Square Joker' then loc_vars = {_card.ability.extra.chips, _card.ability.extra.chip_mod}
        elseif _card.ability.name == 'Seance' then loc_vars = {localize(_card.ability.extra.poker_hand, 'poker_hands')}
        elseif _card.ability.name == 'Riff-raff' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Vampire' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Shortcut' then
        elseif _card.ability.name == 'Hologram' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Vagabond' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Baron' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Cloud 9' then loc_vars = {_card.ability.extra, _card.ability.extra*(_card.ability.nine_tally or 0)}
        elseif _card.ability.name == 'Rocket' then loc_vars = {_card.ability.extra.dollars, _card.ability.extra.increase}
        elseif _card.ability.name == 'Obelisk' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Midas Mask' then
        elseif _card.ability.name == 'Luchador' then
            local has_message= (G.GAME and _card.area and (_card.area == G.jokers))
            if has_message then
                local disableable = G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
                main_end = {
                    {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                        {n=G.UIT.C, config={ref_table = _card, align = "m", colour = disableable and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                            {n=G.UIT.T, config={text = ' '..localize(disableable and 'k_active' or 'ph_no_boss_active')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                        }}
                    }}
                }
            end
        elseif _card.ability.name == 'Photograph' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Gift Card' then  loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Turtle Bean' then loc_vars = {_card.ability.extra.h_size, _card.ability.extra.h_mod}
        elseif _card.ability.name == 'Erosion' then loc_vars = {_card.ability.extra, math.max(0,_card.ability.extra*(G.playing_cards and (G.GAME.starting_deck_size - #G.playing_cards) or 0)), G.GAME.starting_deck_size}
        elseif _card.ability.name == 'Reserved Parking' then loc_vars = {_card.ability.extra.dollars, ''..(G.GAME and G.GAME.probabilities.normal or 1), _card.ability.extra.odds}
        elseif _card.ability.name == 'Mail-In Rebate' then loc_vars = {_card.ability.extra, localize(G.GAME.current_round.mail_card.rank, 'ranks')}
        elseif _card.ability.name == 'To the Moon' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Hallucination' then loc_vars = {G.GAME.probabilities.normal, _card.ability.extra}
        elseif _card.ability.name == 'Lucky Cat' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Baseball Card' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Bull' then loc_vars = {_card.ability.extra, _card.ability.extra*math.max(0,G.GAME.dollars) or 0}
        elseif _card.ability.name == 'Diet Cola' then loc_vars = {localize{type = 'name_text', set = 'Tag', key = 'tag_double', nodes = {}}}
        elseif _card.ability.name == 'Trading Card' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Flash Card' then loc_vars = {_card.ability.extra, _card.ability.mult}
        elseif _card.ability.name == 'Popcorn' then loc_vars = {_card.ability.mult, _card.ability.extra}
        elseif _card.ability.name == 'Ramen' then loc_vars = {_card.ability.x_mult, _card.ability.extra}
        elseif _card.ability.name == 'Ancient Joker' then loc_vars = {_card.ability.extra, localize(G.GAME.current_round.ancient_card.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.ancient_card.suit]}}
        elseif _card.ability.name == 'Walkie Talkie' then loc_vars = {_card.ability.extra.chips, _card.ability.extra.mult}
        elseif _card.ability.name == 'Seltzer' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Castle' then loc_vars = {_card.ability.extra.chip_mod, localize(G.GAME.current_round.castle_card.suit, 'suits_singular'), _card.ability.extra.chips, colours = {G.C.SUITS[G.GAME.current_round.castle_card.suit]}}
        elseif _card.ability.name == 'Smiley Face' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Campfire' then loc_vars = {_card.ability.extra, _card.ability.x_mult}
        elseif _card.ability.name == 'Stuntman' then loc_vars = {_card.ability.extra.chip_mod, _card.ability.extra.h_size}
        elseif _card.ability.name == 'Invisible Joker' then loc_vars = {_card.ability.extra, _card.ability.invis_rounds}
        elseif _card.ability.name == 'Brainstorm' then
            _card.ability.blueprint_compat_ui = _card.ability.blueprint_compat_ui or ''; _card.ability.blueprint_compat_check = nil
            main_end = (_card.area and _card.area == G.jokers) and {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={ref_table = _card, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat'}, nodes={
                        {n=G.UIT.T, config={ref_table = _card.ability, ref_value = 'blueprint_compat_ui',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                    }}
                }}
            } or nil
        elseif _card.ability.name == 'Satellite' then
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Planet' then planets_used = planets_used + 1 end end
            loc_vars = {_card.ability.extra, planets_used*_card.ability.extra}
        elseif _card.ability.name == 'Shoot the Moon' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == "Driver's License" then loc_vars = {_card.ability.extra, _card.ability.driver_tally or '0'}
        elseif _card.ability.name == 'Burnt Joker' then
        elseif _card.ability.name == 'Bootstraps' then loc_vars = {_card.ability.extra.mult, _card.ability.extra.dollars, _card.ability.extra.mult*math.floor((G.GAME.dollars + (G.GAME.dollar_buffer or 0))/_card.ability.extra.dollars)}
        elseif _card.ability.name == 'Caino' then loc_vars = {_card.ability.extra, _card.ability.caino_xmult}
        elseif _card.ability.name == 'Triboulet' then loc_vars = {_card.ability.extra}
        elseif _card.ability.name == 'Yorick' then loc_vars = {_card.ability.extra.xmult, _card.ability.extra.discards, _card.ability.yorick_discards, _card.ability.x_mult}
        elseif _card.ability.name == 'Chicot' then
        elseif _card.ability.name == 'Perkeo' then loc_vars = {_card.ability.extra}
        end
    end
    local badges = {}
    if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or _card.debuff then
        badges.card_type = card_type
    end
    if _card.ability.set == 'Joker' and _card.bypass_discovery_ui and (not no_badge) then
        badges.force_rarity = true
    end
    if _card.edition then
        if _card.edition.type == 'negative' and _card.ability.consumeable then
            badges[#badges + 1] = 'negative_consumable'
        else
            badges[#badges + 1] = (_card.edition.type == 'holo' and 'holographic' or _card.edition.type)
        end
    end
    if _card.seal then badges[#badges + 1] = string.lower(_card.seal)..'_seal' end
    if _card.ability.eternal then badges[#badges + 1] = 'eternal' end
    if _card.ability.perishable then
        loc_vars = loc_vars or {}; loc_vars.perish_tally=_card.ability.perish_tally
        badges[#badges + 1] = 'perishable'
    end
    if _card.ability.rental then badges[#badges + 1] = 'rental' end
    if _card.pinned then badges[#badges + 1] = 'pinned_left' end

    if _card.sticker then loc_vars = loc_vars or {}; loc_vars.sticker=_card.sticker end
	
	logger:info(card_type)
	logger:info(badges)
	logger:info(hide_desc)
	logger:info(main_start)
	logger:info(main_end)
	logger:info("--------------------mid----------------------")

    return generate_card_ui_custom(_card.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start, main_end)
end

function generate_card_ui_custom(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end)
    local first_pass = nil
    if not full_UI_table then 
        first_pass = true
        full_UI_table = {
            main = {},
            info = {},
            type = {},
            name = nil,
            badges = badges or {}
        }
    end
	
    local desc_nodes = (not full_UI_table.name and full_UI_table.main) or full_UI_table.info
    local name_override = nil
    local info_queue = {}
	
	logger:info(full_UI_table.info)

    if full_UI_table.name then
        full_UI_table.info[#full_UI_table.info+1] = {}
        desc_nodes = full_UI_table.info[#full_UI_table.info]
    end

    if not full_UI_table.name then
        if specific_vars and specific_vars.no_name then
            full_UI_table.name = true
        elseif card_type == 'Locked' then
            full_UI_table.name = localize{type = 'name', set = 'Other', key = 'locked', nodes = {}}
        elseif card_type == 'Undiscovered' then 
            full_UI_table.name = localize{type = 'name', set = 'Other', key = 'undiscovered_'..(string.lower(_c.set)), name_nodes = {}}
        elseif specific_vars and (card_type == 'Default' or card_type == 'Enhanced') then
            if (_c.name == 'Stone Card') then full_UI_table.name = true end
            if (specific_vars.playing_card and (_c.name ~= 'Stone Card')) then
                full_UI_table.name = {}
                localize{type = 'other', key = 'playing_card', set = 'Other', nodes = full_UI_table.name, vars = {localize(specific_vars.value, 'ranks'), localize(specific_vars.suit, 'suits_plural'), colours = {specific_vars.colour}}}
                full_UI_table.name = full_UI_table.name[1]
            end
        elseif card_type == 'Booster' then
            
        else
            full_UI_table.name = localize{type = 'name', set = _c.set, key = _c.key, nodes = full_UI_table.name}
        end
        full_UI_table.card_type = card_type or _c.set
    end 

    local loc_vars = {}
    if main_start then 
        desc_nodes[#desc_nodes+1] = main_start 
    end

    if _c.set == 'Other' then
        localize{type = 'other', key = _c.key, nodes = desc_nodes, vars = specific_vars or _c.vars}
    elseif card_type == 'Locked' then
        if _c.wip then localize{type = 'other', key = 'wip_locked', set = 'Other', nodes = desc_nodes, vars = loc_vars}
        elseif _c.demo and specific_vars then localize{type = 'other', key = 'demo_shop_locked', nodes = desc_nodes, vars = loc_vars}  
        elseif _c.demo then localize{type = 'other', key = 'demo_locked', nodes = desc_nodes, vars = loc_vars}
        else
            if _c.name == 'Golden Ticket' then
            elseif _c.name == 'Mr. Bones' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_losses}
            elseif _c.name == 'Acrobat' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_hands_played}
            elseif _c.name == 'Sock and Buskin' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_face_cards_played}
            elseif _c.name == 'Swashbuckler' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_jokers_sold}
            elseif _c.name == 'Troubadour' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Certificate' then
            elseif _c.name == 'Smeared Joker' then loc_vars = {_c.unlock_condition.extra.count,localize{type = 'name_text', key = _c.unlock_condition.extra.e_key, set = 'Enhanced'}}
            elseif _c.name == 'Throwback' then
            elseif _c.name == 'Hanging Chad' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'Rough Gem' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Bloodstone' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Arrowhead' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Onyx Agate' then loc_vars = {_c.unlock_condition.extra.count, localize(_c.unlock_condition.extra.suit, 'suits_singular')}
            elseif _c.name == 'Glass Joker' then loc_vars = {_c.unlock_condition.extra.count, localize{type = 'name_text', key = _c.unlock_condition.extra.e_key, set = 'Enhanced'}}
            elseif _c.name == 'Showman' then loc_vars = {_c.unlock_condition.ante}
            elseif _c.name == 'Flower Pot' then loc_vars = {_c.unlock_condition.ante}
            elseif _c.name == 'Blueprint' then
            elseif _c.name == 'Wee Joker' then loc_vars = {_c.unlock_condition.n_rounds}
            elseif _c.name == 'Merry Andy' then loc_vars = {_c.unlock_condition.n_rounds}
            elseif _c.name == 'Oops! All 6s' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'The Idol' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'Seeing Double' then loc_vars = {localize("ph_4_7_of_clubs")}
            elseif _c.name == 'Matador' then
            elseif _c.name == 'Hit the Road' then
            elseif _c.name == 'The Duo' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Trio' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Family' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Order' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'The Tribe' then loc_vars = {localize(_c.unlock_condition.extra, 'poker_hands')}
            elseif _c.name == 'Stuntman' then loc_vars = {number_format(_c.unlock_condition.chips)}
            elseif _c.name == 'Invisible Joker' then
            elseif _c.name == 'Brainstorm' then
            elseif _c.name == 'Satellite' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Shoot the Moon' then
            elseif _c.name == "Driver's License" then loc_vars = {_c.unlock_condition.extra.count}
            elseif _c.name == 'Cartomancer' then loc_vars = {_c.unlock_condition.tarot_count}
            elseif _c.name == 'Astronomer' then
            elseif _c.name == 'Burnt Joker' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_sold}
            elseif _c.name == 'Bootstraps' then loc_vars = {_c.unlock_condition.extra.count}
                --Vouchers
            elseif _c.name == 'Overstock Plus' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_shop_dollars_spent}
            elseif _c.name == 'Liquidation' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Tarot Tycoon' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_tarots_bought}
            elseif _c.name == 'Planet Tycoon' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_planets_bought}
            elseif _c.name == 'Glow Up' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Reroll Glut' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_shop_rerolls}
            elseif _c.name == 'Omen Globe' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_tarot_reading_used}
            elseif _c.name == 'Observatory' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_planetarium_used}
            elseif _c.name == 'Nacho Tong' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_played}
            elseif _c.name == 'Recyclomancy' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_cards_discarded}
            elseif _c.name == 'Money Tree' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak}
            elseif _c.name == 'Antimatter' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].voucher_usage.v_blank and G.PROFILES[G.SETTINGS.profile].voucher_usage.v_blank.count or 0}
            elseif _c.name == 'Illusion' then loc_vars = {_c.unlock_condition.extra, G.PROFILES[G.SETTINGS.profile].career_stats.c_playing_cards_bought}
            elseif _c.name == 'Petroglyph' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Retcon' then loc_vars = {_c.unlock_condition.extra}
            elseif _c.name == 'Palette' then loc_vars = {_c.unlock_condition.extra}
            end
            
            if _c.rarity and _c.rarity == 4 and specific_vars and not specific_vars.not_hidden then 
                localize{type = 'unlocks', key = 'joker_locked_legendary', set = 'Other', nodes = desc_nodes, vars = loc_vars}
            else

            localize{type = 'unlocks', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
            end
        end
    elseif hide_desc then
        localize{type = 'other', key = 'undiscovered_'..(string.lower(_c.set)), set = _c.set, nodes = desc_nodes}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_'..(specific_vars.playing_card and 'playing_card' or 'default'), nodes = desc_nodes}
    elseif _c.set == 'Joker' then
        if _c.name == 'Stone Joker' or _c.name == 'Marble Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_stone
        elseif _c.name == 'Steel Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_steel 
        elseif _c.name == 'Glass Joker' then info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
        elseif _c.name == 'Golden Ticket' then info_queue[#info_queue+1] = G.P_CENTERS.m_gold 
        elseif _c.name == 'Lucky Cat' then info_queue[#info_queue+1] = G.P_CENTERS.m_lucky 
        elseif _c.name == 'Midas Mask' then info_queue[#info_queue+1] = G.P_CENTERS.m_gold
        elseif _c.name == 'Invisible Joker' then 
            if G.jokers and G.jokers.cards then
                for k, v in ipairs(G.jokers.cards) do
                    if (v.edition and v.edition.negative) and (G.localization.descriptions.Other.remove_negative)then 
                        main_end = {}
                        localize{type = 'other', key = 'remove_negative', nodes = main_end, vars = {}}
                        main_end = main_end[1]
                        break
                    end
                end
            end 
        elseif _c.name == 'Diet Cola' then info_queue[#info_queue+1] = {key = 'tag_double', set = 'Tag'}
        elseif _c.name == 'Perkeo' then info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}}
        end
        if specific_vars and specific_vars.pinned then info_queue[#info_queue+1] = {key = 'pinned_left', set = 'Other'} end
        if specific_vars and specific_vars.sticker then info_queue[#info_queue+1] = {key = string.lower(specific_vars.sticker)..'_sticker', set = 'Other'} end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = specific_vars or {}}
    elseif _c.set == 'Tag' then
        if _c.name == 'Negative Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        elseif _c.name == 'Foil Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_foil 
        elseif _c.name == 'Holographic Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        elseif _c.name == 'Polychrome Tag' then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome 
        elseif _c.name == 'Charm Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_arcana_mega_1 
        elseif _c.name == 'Meteor Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_celestial_mega_1 
        elseif _c.name == 'Ethereal Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_spectral_normal_1 
        elseif _c.name == 'Standard Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_standard_mega_1 
        elseif _c.name == 'Buffoon Tag' then info_queue[#info_queue+1] = G.P_CENTERS.p_buffoon_mega_1 
        end
        localize{type = 'descriptions', key = _c.key, set = 'Tag', nodes = desc_nodes, vars = specific_vars or {}}
    elseif _c.set == 'Voucher' then
        if _c.name == "Overstock" or _c.name == 'Overstock Plus' then
        elseif _c.name == "Tarot Merchant" or _c.name == "Tarot Tycoon" then loc_vars = {_c.config.extra_disp}
        elseif _c.name == "Planet Merchant" or _c.name == "Planet Tycoon" then loc_vars = {_c.config.extra_disp}
        elseif _c.name == "Hone" or _c.name == "Glow Up" then loc_vars = {_c.config.extra}
        elseif _c.name == "Reroll Surplus" or _c.name == "Reroll Glut" then loc_vars = {_c.config.extra}
        elseif _c.name == "Grabber" or _c.name == "Nacho Tong" then loc_vars = {_c.config.extra}
        elseif _c.name == "Wasteful" or _c.name == "Recyclomancy" then loc_vars = {_c.config.extra}
        elseif _c.name == "Seed Money" or _c.name == "Money Tree" then loc_vars = {_c.config.extra/5}
        elseif _c.name == "Blank" or _c.name == "Antimatter" then
        elseif _c.name == "Hieroglyph" or _c.name == "Petroglyph" then loc_vars = {_c.config.extra}
        elseif _c.name == "Director's Cut" or _c.name == "Retcon" then loc_vars = {_c.config.extra}
        elseif _c.name == "Paint Brush" or _c.name == "Palette" then loc_vars = {_c.config.extra}
        elseif _c.name == "Telescope" or _c.name == "Observatory" then loc_vars = {_c.config.extra}
        elseif _c.name == "Clearance Sale" or _c.name == "Liquidation" then loc_vars = {_c.config.extra}
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Edition' then
        loc_vars = {_c.config.extra}
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Default' and specific_vars then 
        if specific_vars.nominal_chips then 
            localize{type = 'other', key = 'card_chips', nodes = desc_nodes, vars = {specific_vars.nominal_chips}}
        end
        if specific_vars.bonus_chips then
            localize{type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = {specific_vars.bonus_chips}}
        end
    elseif _c.set == 'Enhanced' then 
        if specific_vars and _c.name ~= 'Stone Card' and specific_vars.nominal_chips then
            localize{type = 'other', key = 'card_chips', nodes = desc_nodes, vars = {specific_vars.nominal_chips}}
        end
        if _c.effect == 'Mult Card' then loc_vars = {_c.config.mult}
        elseif _c.effect == 'Wild Card' then
        elseif _c.effect == 'Glass Card' then loc_vars = {_c.config.Xmult, G.GAME.probabilities.normal, _c.config.extra}
        elseif _c.effect == 'Steel Card' then loc_vars = {_c.config.h_x_mult}
        elseif _c.effect == 'Stone Card' then loc_vars = {((specific_vars and specific_vars.bonus_chips) or _c.config.bonus)}
        elseif _c.effect == 'Gold Card' then loc_vars = {_c.config.h_dollars}
        elseif _c.effect == 'Lucky Card' then loc_vars = {G.GAME.probabilities.normal, _c.config.mult, 5, _c.config.p_dollars, 15}
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
        if _c.name ~= 'Stone Card' and ((specific_vars and specific_vars.bonus_chips) or _c.config.bonus) then
            localize{type = 'other', key = 'card_extra_chips', nodes = desc_nodes, vars = {((specific_vars and specific_vars.bonus_chips) or _c.config.bonus)}}
        end
    elseif _c.set == 'Booster' then 
        local desc_override = 'p_arcana_normal'
        if _c.name == 'Arcana Pack' then desc_override = 'p_arcana_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Arcana Pack' then desc_override = 'p_arcana_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Arcana Pack' then desc_override = 'p_arcana_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Celestial Pack' then desc_override = 'p_celestial_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Celestial Pack' then desc_override = 'p_celestial_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Celestial Pack' then desc_override = 'p_celestial_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Spectral Pack' then desc_override = 'p_spectral_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Spectral Pack' then desc_override = 'p_spectral_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Spectral Pack' then desc_override = 'p_spectral_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Standard Pack' then desc_override = 'p_standard_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Standard Pack' then desc_override = 'p_standard_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Standard Pack' then desc_override = 'p_standard_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Buffoon Pack' then desc_override = 'p_buffoon_normal'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Jumbo Buffoon Pack' then desc_override = 'p_buffoon_jumbo'; loc_vars = {_c.config.choose, _c.config.extra}
        elseif _c.name == 'Mega Buffoon Pack' then desc_override = 'p_buffoon_mega'; loc_vars = {_c.config.choose, _c.config.extra}
        end
        name_override = desc_override
        if not full_UI_table.name then full_UI_table.name = localize{type = 'name', set = 'Other', key = name_override, nodes = full_UI_table.name} end
        localize{type = 'other', key = desc_override, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Spectral' then 
        if _c.name == 'Familiar' or _c.name == 'Grim' or _c.name == 'Incantation' then loc_vars = {_c.config.extra}
        elseif _c.name == 'Immolate' then loc_vars = {_c.config.extra.destroy, _c.config.extra.dollars}
        elseif _c.name == 'Hex' then info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        elseif _c.name == 'Talisman' then info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'}
        elseif _c.name == 'Deja Vu' then info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'}
        elseif _c.name == 'Trance' then info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'}
        elseif _c.name == 'Medium' then info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'}
        elseif _c.name == 'Ankh' then
            if G.jokers and G.jokers.cards then
                for k, v in ipairs(G.jokers.cards) do
                    if (v.edition and v.edition.negative) and (G.localization.descriptions.Other.remove_negative)then 
                        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
                        main_end = {}
                        localize{type = 'other', key = 'remove_negative', nodes = main_end, vars = {}}
                        main_end = main_end[1]
                        break
                    end
                end
            end
        elseif _c.name == 'Cryptid' then loc_vars = {_c.config.extra}
        end
        if _c.name == 'Ectoplasm' then info_queue[#info_queue+1] = G.P_CENTERS.e_negative; loc_vars = {G.GAME.ecto_minus or 1} end
        if _c.name == 'Aura' then
            info_queue[#info_queue+1] = G.P_CENTERS.e_foil
            info_queue[#info_queue+1] = G.P_CENTERS.e_holo
            info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        end
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Planet' then
        loc_vars = {
            G.GAME.hands[_c.config.hand_type].level,localize(_c.config.hand_type, 'poker_hands'), G.GAME.hands[_c.config.hand_type].l_mult, G.GAME.hands[_c.config.hand_type].l_chips,
            colours = {(G.GAME.hands[_c.config.hand_type].level==1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands[_c.config.hand_type].level)])}
        }
        localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
    elseif _c.set == 'Tarot' then
       if _c.name == "The Fool" then
            local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
            local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
            local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
            main_end = {
                {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                    {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                        {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                    }}
                }}
            }
           loc_vars = {last_tarot_planet}
           if not (not fool_c or fool_c.name == 'The Fool') then
                info_queue[#info_queue+1] = fool_c
           end
       elseif _c.name == "The Magician" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The High Priestess" then loc_vars = {_c.config.planets}
       elseif _c.name == "The Empress" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Emperor" then loc_vars = {_c.config.tarots}
       elseif _c.name == "The Hierophant" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Lovers" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Chariot" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "Justice" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Hermit" then loc_vars = {_c.config.extra}
       elseif _c.name == "The Wheel of Fortune" then loc_vars = {G.GAME.probabilities.normal, _c.config.extra};  info_queue[#info_queue+1] = G.P_CENTERS.e_foil; info_queue[#info_queue+1] = G.P_CENTERS.e_holo; info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome; 
       elseif _c.name == "Strength" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "The Hanged Man" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "Death" then loc_vars = {_c.config.max_highlighted}
       elseif _c.name == "Temperance" then
        local _money = 0
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    _money = _money + G.jokers.cards[i].sell_cost
                end
            end
        end
        loc_vars = {_c.config.extra, math.min(_c.config.extra, _money)}
       elseif _c.name == "The Devil" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Tower" then loc_vars = {_c.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = _c.config.mod_conv}}; info_queue[#info_queue+1] = G.P_CENTERS[_c.config.mod_conv]
       elseif _c.name == "The Star" then loc_vars = {_c.config.max_highlighted,  localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "The Moon" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "The Sun" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       elseif _c.name == "Judgement" then
       elseif _c.name == "The World" then loc_vars = {_c.config.max_highlighted, localize(_c.config.suit_conv, 'suits_plural'), colours = {G.C.SUITS[_c.config.suit_conv]}}
       end
       localize{type = 'descriptions', key = _c.key, set = _c.set, nodes = desc_nodes, vars = loc_vars}
   end

    if main_end then 
        desc_nodes[#desc_nodes+1] = main_end 
    end

   --Fill all remaining info if this is the main desc
    if not ((specific_vars and not specific_vars.sticker) and (card_type == 'Default' or card_type == 'Enhanced')) then
        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            localize{type = 'name', key = _c.key, set = _c.set, nodes = full_UI_table.name} 
            if not full_UI_table.name then full_UI_table.name = {} end
        elseif desc_nodes ~= full_UI_table.main then 
            desc_nodes.name = localize{type = 'name_text', key = name_override or _c.key, set = name_override and 'Other' or _c.set} 
        end
    end

    if first_pass and not (_c.set == 'Edition') and badges then
        for k, v in ipairs(badges) do
            if v == 'foil' then info_queue[#info_queue+1] = G.P_CENTERS['e_foil'] end
            if v == 'holographic' then info_queue[#info_queue+1] = G.P_CENTERS['e_holo'] end
            if v == 'polychrome' then info_queue[#info_queue+1] = G.P_CENTERS['e_polychrome'] end
            if v == 'negative' then info_queue[#info_queue+1] = G.P_CENTERS['e_negative'] end
            if v == 'negative_consumable' then info_queue[#info_queue+1] = {key = 'e_negative_consumable', set = 'Edition', config = {extra = 1}} end
            if v == 'gold_seal' then info_queue[#info_queue+1] = {key = 'gold_seal', set = 'Other'} end
            if v == 'blue_seal' then info_queue[#info_queue+1] = {key = 'blue_seal', set = 'Other'} end
            if v == 'red_seal' then info_queue[#info_queue+1] = {key = 'red_seal', set = 'Other'} end
            if v == 'purple_seal' then info_queue[#info_queue+1] = {key = 'purple_seal', set = 'Other'} end
            if v == 'eternal' then info_queue[#info_queue+1] = {key = 'eternal', set = 'Other'} end
            if v == 'perishable' then info_queue[#info_queue+1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds or 1, specific_vars.perish_tally or G.GAME.perishable_rounds}} end
            if v == 'rental' then info_queue[#info_queue+1] = {key = 'rental', set = 'Other', vars = {G.GAME.rental_rate or 1}} end
            if v == 'pinned_left' then info_queue[#info_queue+1] = {key = 'pinned_left', set = 'Other'} end
        end
    end

    for _, v in ipairs(info_queue) do
        generate_card_ui_custom(v, full_UI_table)
    end

    return full_UI_table
end

local function on_disable()
end

local function menu()
end

local function on_game_load(args)
end

local function on_game_quit()
end

local function on_key_pressed(key)
end

local function on_key_released(key)
end

local function on_mouse_pressed(button, x, y, touch)
end

local function on_mouse_released(button, x, y)
end

local function on_mousewheel(x, y)
end

local function on_pre_render()
end

local function on_post_render()
end

local function on_error(message)
end

local function on_pre_update(dt)
end

local function on_post_update(dt)
end

return {
    on_enable = on_enable,
    on_disable = on_disable,
    menu = menu,
    on_game_load = on_game_load,
    on_game_quit = on_game_quit,
    on_key_pressed = on_key_pressed,
    on_key_released = on_key_released,
    on_mouse_pressed = on_mouse_pressed,
    on_mouse_released = on_mouse_released,
    on_mousewheel = on_mousewheel,
    on_pre_render = on_pre_render,
    on_post_render = on_post_render,
    on_error = on_error,
    on_pre_update = on_pre_update,
    on_post_update = on_post_update,
}