return {
    joker = {
        BakaCirnojoker = {
            name = "笨蛋琪露诺",
            text = {
                "{C:chips}+#1#筹码{}",
                "每回合结束时，有{C:green}#2#/#3#{}的概率将筹码的最高位减去",
                "{C:inactive}(如129筹码->29筹码){}"
            }
        },
        GeniusCirnojoker = {
            name = "天才琪露诺",
            text = {
                "每张你打出的{C:attention}3{}计分时",
                "获得{X:chips,C:white}X#2#{}筹码",
                "每张你打出的{C:attention}9{}计分时",
                "获得{X:chips,C:white}X#3#{}筹码",
                "{C:inactive}(当前为{X:chips,C:white}X#1#{C:inactive}筹码)"
            }
        },
        Money_obsessedjoker = {
            name = "贪财小丑",
            text = {
                "你打出的每一张计分",
                "且点数大于{C:attention}#2#{}的牌",
                "会让你获得{C:money}#1#${}",
                "{C:inactive}(点数每回合切换){}"
            }
        },
        Stargazing = {
            name = "星空观测",
            text = {
                "回合结束时，如果你有至少{C:money}#1#${}",
                "你有{C:green}1/(N+2){}的概率升级你最后打出的{C:attention}牌型{}并失去{C:money}#1#${}",
                "且重复判定，直至没有升级或你只有少于{C:money}#1#${}",
                "{C:inactive}(N为本回合已升级的次数，上一个回合升级了#2#次)"
            }
        },
        PlasmaJoker = {
            name = "等离子小丑",
            text = {
                "平衡{C:chips}筹码{}和{C:mult}倍率{}",
                "转移的值最多为较高值的{C:attention}1/3{}"
            }
        },
        NegativeJoker = {
            name = "负片小丑",
            text = {
                "每回合结束时",
                "有{C:green}#1#/#2#{}的概率摧毁自己",
                "并将随机一张{C:attention}小丑牌{}变为{C:dark_edition}负片{}",
                "{C:inactive}(每回合概率提升)"
            }
        },
        CasinoEntryCard = {
            name = "赌场入卡",
            text = {
                "每次出牌时，若打出的所有{C:attention}计分牌{}点数之和超过{C:attention}#1#{},生成一张{C:mult}稀有小丑牌{}",
                "否则，若点数之和超过{C:attention}#2#{},生成一张{C:green}罕见小丑牌{}",
                "{C:inactive}(J、Q、K、A的点数分别为11、12、13、14)",
                "{C:inactive}(生成时必须有空位，点数每回合变化)",
                "{C:inactive}(本回合已生成#3#张稀有小丑牌，#4#张罕见小丑牌)"
            }
        },
        Mod3Limit = {
            name = "数不过3",
            text = {
                "每张打出并计分的牌",
                "{C:attention}重新触发{}自身点数{C:mult}模3{}次",
                "{C:inactive}(如4除以3的余数为1，则4模3为1,额外触发一次)",
                "{C:inactive}(J、Q、K、A的点数分别为11、12、13、14)"
            }
        },
        ChipSquirrel = {
            name = "筹码屯屯鼠",
            text = {
                "每回合结束时",
                "手牌中每有一张{C:attention}增强卡牌{}",
                "获得{X:chips,C:white}X#2#{}筹码",
                "{C:inactive}（当前为{X:chips,C:white}X#1#{C:inactive}筹码）"
            }
        },
        TarotDealer = {
            name = "塔罗商人",
            text = {
                "每打开一个{C:attention}秘术补充包{}",
                "获得{X:chips,C:white}X#2#{}筹码",
                "{C:inactive}（当前为{X:chips,C:white}X#1#{C:inactive}筹码）",
            }
        },
        TheAstrologer = {
            name = "占星师",
            text = {
                "每使用一张{C:planet}星球牌{}，获得{X:chips,C:white}X#3#{}筹码",
                "每使用一张{C:purple}塔罗牌{}，获得{X:mult,C:white}X#4#{}倍率",
                "{C:inactive}（当前为{X:chips,C:white}X#1#{C:inactive}筹码，{{X:mult,C:white}X#2#{C:inactive}倍率）",
            }
        },
        TheShowman = {
            name = "巨星小丑",
            text = {
                "回合结束时，获得{X:mult,C:white}Xn{}倍率",
                "其中n为(最终得分 - 1.5×盲注至少得分)与盲注至少得分的比值",
                "且n至少为#2#，最多为#3#",
                "{C:inactive}（当前为{X:mult,C:white}X#1#{C:inactive}倍率）"
            }
        },
        JokerBank = {
            name = "小丑银行",
            text = {
                "选择盲注时，将你当前存款的一半存入（向下取整）",
                "击败Boss盲注后，你每存入{C:money}$1{}，获得{C:chips}+#2#{}筹码，并返还一半存款（向上取整）",
                "{C:inactive}（当前为{C:chips}+#1#{}筹码，存款为{C:money}$#3#{}）"
            }
        },
        TheQuasar = {
            name = "类星体",
            text = {
                "每回合前两次出牌时,获得{C:mult}+n{}倍率",
                "其中n为{C:attention}牌型{}的{C:attention}打出次数{}在所有打出次数的{C:mult}排名{},且最多为5",
                "{C:inactive}（打出次数越多，排名越高，如打出最多次的排名为1）",
                "{C:inactive}（若有并列，则取并列中的最高数值排名）",
                "{C:inactive}（当前为{C:mult}+#1#{C:inactive}倍率）"
            }
        },
        BlackMarketBroker = {
            name = "黑市掮客",
            text = {
                "回合结束时，获得等同于右边小丑的{C:money}“资金”{}，并{C:attention}摧毁{}右边的小丑",
                "离开商店时，如果有多于{C:attention}$#1#{}的“资金”，减少{C:money}$#1#{}“资金”，并创建一个{C:attention}小丑标签{}",
                "{C:inactive}（当前为{C:money}$#2#{C:inactive}“资金”）"
            }
        }
    },
    v_dictionary = {
        a_xchips = "X#1#筹码",
        BakaCirnojoker_weaken = "削弱为+#1#筹码",
        balanced = "平衡",
        transfer = "传递",
        transferFailed = "概率提升",
        XchipsAndXmult = "X#1#倍率 X#2#筹码",
        a_deposit = "存入$#1#",
        updated = "更新",
        create_tag = "创建标签",
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
        [11] = 'J',
        [12] = 'Q',
        [13] = 'K',
        [14] = 'A'
    }
}