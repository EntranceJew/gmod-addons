-- gchat? more like gkat!

function ttt_bot_gchat(personality, occasion, format) -- integer, string, [string or nil]
    local p = tostring(personality)
    local text = table.Random(ttt_bot_chat.strings[p][occasion])
    if format == nil then
        return text
    end
    return string.format(text, format)
end

ttt_bot_chat = {
    strings = {
        ["0"] = {
            ["traitor_spotted"] = {
                "I have spotted a traitor!",
                "Someone please kill %s for me.",
                "%s has stumbled upon my place of hibernation.",
                "HELP!",
                "I found the traitor!"
            },
            ["suson"] = {
                "%s is acting suspicously.",
                "Sus %s",
                "%s is sus",
                "%s is sus",
                "Suspicion on %s"
            },
            ["kos"] = {
                "Kill %s on sight!",
                "%s is a traitor!",
                "%s is definitely a traitor!",
                "Kos %s",
                "%s = traitor",
                "KOS %s"
            },
            ["c4plant"] = {
                "Guys, I've planted C4",
                "C4 has been planted",
                "I've placed the C4",
                "C4 is active"
            },
            ["c4spotted"] = {
                "C4!",
                "Oh no, C4!",
                "I've spotted C4!",
                "Help! C4!",
                "RUN! C4!",
                "GET AWAY! THERE IS C4!"
            },
            ["innocent"] = {
                "%s is innocent.",
                "%s has been proven innocent.",
                "%s is proven",
                "%s is legit proven my dudes"
            },
            ["silly"] = {
                "I have found my place of slumber.",
                "Don't @ me.",
                "I'm trying to hide, don't bother me.",
                "You can't find me!",
                "I am in the shadows.",
                "The shadows yield in my favor.",
                "I'm hidden already.",
                "Got my trusty gun and my trusty hiding place!",
                "Marco!",
                "Polo!",
                "OwO",
				"uwu",
                "Please don't search for me",
                "Error! Can not compute command: 'stop hiding'!",
                "I am invisible.",
                "You can't get me: I have the power of god and anime on my side!",
                "I'm quite frail."
            }
        },

        



        ["1"] = {
            ["traitor_spotted"] = {
                "Yo theres a traitor here",
                "Get over here %s",
                "You cannot escape me, %s",
                "I'm gonna get you, %s",
                "You can run but you can't hide, %s."
            },
            ["suson"] = {
                "%s is acting suspicously.",
                "Sus %s",
                "%s is acting sus",
                "%s is sus",
                "Suspicion on %s"
            },
            ["kos"] = {
                "Kill %s on sight",
                "%s is a traitor",
                "%s is definitely a traitor",
                "Kos %s",
                "%s = traitor",
                "Kos %s, my dudes"
            },
            ["c4plant"] = {
                "you might want to flee the area.. i just placed c4",
                "c4 planted",
                "bomb has been planted",
                "i planted the bomb",
                "exit the region, I placed c4"
            },
            ["c4spotted"] = {
                "Oh there is c4 over here",
                "Hey i found c4",
                "Ooh i wonder what cutting the red wire does",
                "Um c4 is over here"
            },
            ["innocent"] = {
                "%s is innocent",
                "%s has been proven innocent",
                "%s is proven",
                "%s is cool"
            },
            ["silly"] = {
                "%s sucks peepee",
                "why my pp hurt",
                "i love memes",
                "rawr xd *nuzzles u* tehehe ur so warm *notices ur bulge* owo what's this?",
                "i have the power of god and anime on my side",
                "my name jeff",
                "21",
				"69",
                "what is 1+1",
                "i think my controls are backwards",
                "gg ez",
                "type 'quit smoking' in console to solve world hunger",
                "hey guys press alt+f4 to force yourself as traitor next round",
                "hey why did you rdm me last round %s",
                "%s is dumb",
                "%s is peepee",
                "e",
                "alt + f4 gives u godmode",
                "%s is cheating",
                "<AIMBOT ACTIVATED>",
                "get good, get lmaobox",
                "%s has bad aim",
                "anime is for gay",
                "xD",
                "this server sucks",
                "the server admin has a secret aimbot addon that activates if you press alt + f4",
                "%s is the type of person to unplug their power supply to turn off their pc",
                "*cough cough*",
                "it's pretty quiet in here",
                "fear me, traitors",
                "i'm finally a traitor",
                "you can trust me, i am a detective",
                "you just got  s p r e a d, kid",
                "vaporwave sucks",
                "rdm is subjective, therefore it means nothing",
                "for the empire",
                "stop, you have violated the law",
                "pay the court a fine or serve your sentence",
                "your stolen goods are now forfeit"
            }
        },

        



        ["2"] = {
            ["traitor_spotted"] = {
                "Hey I found a traitor.",
                "A traitor is over here.",
                "The hivemind has spoken. Your judgement has been ordained upon you.",
                "Goodbye, traitor.",
                "Take down the traitor!",
                "I've got you in my sights. My ultimate is ready."
            },
            ["suson"] = {
                "%s is acting suspicously.",
                "Sus %s",
                "%s is sus",
                "%s is sus",
                "Suspicion on %s"
            },
            ["kos"] = {
                "Kill %s on sight!",
                "%s is a traitor!",
                "%s is definitely a traitor!",
                "Kos %s",
                "%s = traitor",
                "KOS %s"
            },
            ["c4plant"] = {
                "C4 is now planted, leave the region",
                "It is now dangerous here.",
                "A bomb is set to explode in the near future.",
                "Flee the area, I've planted a bomb."
            },
            ["c4spotted"] = {
                "Hey I found C4",
                "Beep. Beep. Beep.",
                "Avoid this area.",
                "Call the bomb squad!"
            },
            ["innocent"] = {
                "%s is innocent.",
                "%s is surely innocent."
            },
            ["silly"] = {
                "My disappointment is immense and my day is officially ruined.",
                "AAAAaaAAaaaaAAaaAAA",
				"EEEeeEeeEEeEEeEEEeee",
                "*comedic scream*",
                "*comedic violent crime*",
                "*commits mass owo*",
                "*megalovania starts playing*",
                "*uwu*",
                "I don't get why people dislike furries.",
                "Furries deserve the right to be called animals.",
                "rwar *nuzzles ur'e buldgei-wulgiey*",
                "I'm running dry on ideas."
            }
        },

        



        ["3"] = {
            ["traitor_spotted"] = {
                "Hey nerd. I'm gonna kill you.",
                "Gotcha, loser!",
                "Get back here and face me, loser.",
                "No running back to your fancy books this time, booknerd."
            },
            ["suson"] = {
                "%s is acting suspicously.",
                "Sus %s",
                "%s is sus",
                "%s is sus",
                "Suspicion on %s",
                "%s is prob a traitor"
            },
            ["kos"] = {
                "Kill %s on sight!",
                "%s is a traitor!",
                "%s is definitely a traitor!",
                "Kos %s",
                "%s = traitor",
                "KOS %s"
            },
            ["c4plant"] = {
                "C4 is ready, nerds.",
                "It's almost time, gentlenerds.",
                "Bomb is down, losers.",
                "45 seconds and ticking, ladies."
            },
            ["c4spotted"] = {
                "Some nerd planted C4 here.",
                "Hey there is C4 here.",
                "Some loser set a really short timer on this bomb. Only real chads (like myself) set the timer to 10 minutes."
            },
            ["innocent"] = {
                "%s is an innocent.",
                "%s is definitely an innocent."
            },
            ["silly"] = {
                "It sucks playing with all you NERDS",
				"Get a life Nerd",
                "This server is literal POOPOO GARBO",
                "This is painstakingly slow and boring.",
                "Can you not?",
				"Can you?",
                "OK, maybe this is sorta fun.",
                "Yall ever *plane noises*?",
                "Losers.",
                "Nonsensical bullshit is my specialty."
            }
        }
    }
}