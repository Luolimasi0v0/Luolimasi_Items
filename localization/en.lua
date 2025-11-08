return {
    joker = {
        BakaCirnojoker = {
            name = "Baka Cirno",
            text = {
                "{C:chips}+#1# chips{}",
                "At the end of each turn, there is a {C:green}#2#/#3#{} chance",
                "to subtract the highest digit of the chips",
                "{C:inactive}(e.g., 129 chips -> 29 chips){}"
            }
        },
        GeniusCirnojoker = {
            name = "Genius Cirno",
            text = {
                "Each {C:attention}3{} you play scores",
                "with {X:chips,C:white}X#2#{} Chips",
                "Each {C:attention}9{} you play scores",
                "with {X:chips,C:white}X#3#{} Chips",
                "{C:inactive}(Currently: {X:chips,C:white}X#1#{C:inactive} Chips)"
            }
        },
        Money_obsessedjoker = {
            name = "Money-obsessed Joker",
            text = {
                "Every card you play that scores",
                "and has a value greater than {C:attention}#2#{}",
                "will earn you {C:money}#1#${}",
                "{C:inactive}(The value switches each turn){}"
            }
        },
        Stargazing = {
            name = "Stargazing",
            text = {
                "At the end of your turn, if you have at least {C:money}#1#${},",
                "you have a {C:green}1/(N+2){} chance to upgrade the last {C:attention}poker hand{} you played and lose {C:money}#1#${}.",
                "This effect repeats until the card is no longer upgraded or you have less than {C:money}#1#${}.",
                "{C:inactive}(N is the number of upgrades this turn; upgraded #2# times last turn)"
            }
        },
        PlasmaJoker = {
            name = "Plasma Joker",
            text = {
            "Balancing {C:chips} chips {} and {C:mult} multiplier {}",
            "The transferred value can be up to {C:attention}1/3{} of the higher value"
            }
        },
        NegativeJoker = {
            name = "Negative Joker",
            text = {
                "At the end of each turn",
                "There is a {C:green}#1#/#2#{} chance to destroy yourself",
                "and turn a random {C:attention}Joker card{} into {C:dark_edition}Negative{}",
                "{C:inactive}(The probability increases each turn)"
            }
        },
        CasinoEntryCard = {
            name = "Casino Entry Card",
            text = {
                "Whenever you play cards, if the total value of all {C:attention}scoring cards{} exceeds {C:attention}#1#{}, generate a {C:mult}Rare Joker{}",
                "otherwise, if the total value exceeds {C:attention}#2#{}, generate a {C:green}Uncommon Joker{}",
                "{C:inactive}(J, Q, K, A are worth 11, 12, 13, 14)",
                "{C:inactive}(Requires an empty slot; values change each round)",
                "{C:inactive}(Generated #3# Rare and #4# Uncommon Jokers this round)"
            }
        },
        Mod3Limit = {
            name = "Can't Count to 3",
            text = {
                "Each card played and scored",
                "{C:attention}triggers again{} its value modulo 3 times",
                "{C:inactive}(e.g. 4 mod 3 = 1, so it triggers once more)",
                "{C:inactive}(J, Q, K, A are 11, 12, 13, 14)"
            }
        },
        ChipSquirrel = {
            name = "Chip Squirrel",
            text = {
                "At end of each round",
                "for each {C:attention}Upgrade Card{} in hand",
                "gain {X:chips,C:white}X#2#{} Chips",
                "{C:inactive}(Currently: {X:chips,C:white}X#1#{C:inactive} Chips)"
            }
        },
        TarotDealer = {
            name = "The Tarot Dealer",
            text = {
                "When opening a {C:attention}Arcana Booster Pack{}",
                "gain {X:chips,C:white}X#2#{} chips",
                "{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive} chips)"
            }
        },
        TheAstrologer = {
            name = "The Astrologer",
            text = {
                "When playing a {C:planet}Planet{} card, gain {X:chips,C:white}X#3#{} chips",
                "When playing a {C:purple}Tarot{} card, gain {X:mult,C:white}X#4#{} mult",
                "{C:inactive}(Currently {X:chips,C:white}X#1#{C:inactive} chips, {X:mult,C:white}X#2#{C:inactive} mult)"
            }
        },
        TheShowman = {
            name = "The Showman",
            text = {
                "At end of round, gain {X:mult,C:white}Xn{} multiplier",
                "where n is the ratio of (final score - 1.5×ante requirement) to ante requirement",
                "and n is at least #2#, at most #3#",
                "{C:inactive}(Currently: {X:mult,C:white}X#1#{C:inactive} multiplier)"
            }
        },
        JokerBank = {
            name = "Joker Bank",
            text = {
                "When selecting a blind, deposit half your current coins (rounded down)",
                "After defeating the Boss Blind, gain {C:chips}+#2#{} chips per {C:money}$1{} deposited",
                "and receive half of the deposit back (rounded up)",
                "{C:inactive}(Currently {C:chips}+#1#{} chips, {C:money}$#3#{} deposited)"
            }
        },
        TheQuasar = {
            name = "The Quasar",
            text = {
                "Gain {C:mult}+n{} Mult on your first two plays each round",
                "where n is the {C:attention}rank{} of this {C:attention}hand type's play count{} among all hand types, up to 5",
                "{C:inactive}(Higher play count = higher rank; most played is rank 1)",
                "{C:inactive}(Ties take the best possible rank)",
                "{C:inactive}(Currently gaining {C:mult}+#1#{C:inactive} Mult)"
            }
        },
        BlackMarketBroker = {
            name = "Black Market Broker",
            text = {
                "At the end of your turn, gain {C:money}“funds”{} equal to the value of the Joker on the right and {C:attention}destroy{} the Joker on the right",
                "When leaving the shop, if you have more than {C:attention}$#1#{} in “funds”, reduce {C:money}$#1#{} “funds” and create a {C:attention}Joker tag{}",
                "{C:inactive}(Currently have {C:money}$#2#{C:inactive} in “funds”)"
            }
        }
    },
    v_dictionary = {
        a_xchips = "X#1# chips",
        BakaCirnojoker_weaken = "weaken to +#1# chips",
        BakaCirnojoker_remove = "Cirno, you big baka!",
        balanced = "balanced",
        transfer = "transfer",
        transferFailed = "probability increase",
        XchipsAndXmult = "X#1# mult X#2# chips",
        a_deposit = "deposit $#1#",
        updated = "updated",
        create_tag = "create tag",
    },
    rank_to_value = {
        [2] = '2',
        [3] = '3',
        [4] = '4',
        [5] = '5',
        [6] = '6',
        [7] = '7',
        [8] = '8',
        [9] = '9',
        [10] = '10',
        [11] = 'Jack',
        [12] = 'Queen',
        [13] = 'King',
        [14] = 'Ace'
    }
}