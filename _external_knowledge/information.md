
check this for basics and to understand
https://www.cardmaker.net/forums/topic/331955-ygopro-basic-tutorial/

## ui assets

### card attribute icons
#### monster attributes
earth = ("assets/themes/default/attributes/earth.png")
water = ("assets/themes/default/attributes/water.png")
fire = ("assets/themes/default/attributes/fire.png")
wind = ("assets/themes/default/attributes/wind.png")
light = ("assets/themes/default/attributes/light.png")
dark = ("assets/themes/default/attributes/dark.png")
divine = ("assets/themes/default/attributes/divine.png")
#### spell & trap attributes
spell = ("assets/themes/default/attributes/spell.png")
trap = ("assets/themes/default/attributes/trap.png")

### monster race icons
warrior = ("assets/themes/default/races/warrior.png")
aqua = ("assets/themes/default/races/aqua.png")
beast_warrior = ("assets/themes/default/races/beast-warrior.png")
dinosaur = ("assets/themes/default/races/dinosaur.png")
beast = ("assets/themes/default/races/beast.png")
cyverse = ("assets/themes/default/races/cyberse.png")
divine_beast = ("assets/themes/default/races/divine-beast.png")
diviner_beast = ("assets/themes/default/races/diviner-beast.png")
dragon = ("assets/themes/default/races/dragon.png")
fairy = ("assets/themes/default/races/fairy.png")
fiend = ("assets/themes/default/races/fiend.png")
fish = ("assets/themes/default/races/fish.png")
insect = ("assets/themes/default/races/insect.png")
machine = ("assets/themes/default/races/machine.png")
plant = ("assets/themes/default/races/plant.png")
psychic = ("assets/themes/default/races/psychic.png")
pyro = ("assets/themes/default/races/pyro.png")
reptile = ("assets/themes/default/races/reptile.png")
rock = ("assets/themes/default/races/rock.png")
sea_serpent = ("assets/themes/default/races/sea-serpent.png")
spellcaster = ("assets/themes/default/races/spellcaster.png")
thunder = ("assets/themes/default/races/thunder.png")
winged_beast = ("assets/themes/default/races/winged-beast.png")
wyrm = ("assets/themes/default/races/wyrm.png")
zombie = ("assets/themes/default/races/zombie.png")
illusion = ("assets/themes/default/races/illusion.png")

### monster rating icons
level_star = ("assets/themes/default//ratings/level.png")
rank_star = ("assets/themes/default//ratings/rank.png")
pendulum_scale = ("assets/themes/default//ratings/pendulum_scale.png")
#### link arrow for link monster types
t_arrow = ("assets/themes/default//ratings/t_arrow.png")
tl_arrow = ("assets/themes/default//ratings/tl_arrow.png")
l_arrow = ("assets/themes/default//ratings/l_arrow.png")
bl_arrow = ("assets/themes/default//ratings/bl_arrow.png")
b_arrow = ("assets/themes/default//ratings/b_arrow.png")
br_arrow = ("assets/themes/default//ratings/br_arrow.png")
r_arrow = ("assets/themes/default//ratings/r_arrow.png")
tr_arrow = ("assets/themes/default//ratings/tr_arrow.png")

## hex lists
**monster_type_list** =
 1,2,4,8,16,32,33554432,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216

**monster_type_text_list** = 
"Warrior","Spellcaster","Fairy","Fiend","Zombie","Machine","Illusion", "Aqua","Pyro","Rock","Winged-Beast","Plant","Insect","Thunder","Dragon","Beast","Beast-Warrior","Dinosaur","Fish","Sea Serpent","Reptile","Psychic","Divine-Beast","Diviner-Beast","Wyrm","Cyverse"

**attribute_list** = 
1,2,4,8,16,32,64

**card_type_list** = 33554465,33,16777249,8225,97,8388641,16777313,16785441,25165857,67108897,17,16401,67108865,129,161,16777280,16777344,16777472,4193,12321,8193,65,4161,33558561,50331681,2097185,4129,5153,4113,1057,2081,8388609,18874401,4257,20497,16777233,545,673,16781345,16781329,37748769,4194337,16777377,2101281,33554977,16777761,1048580,524290,262146,131076,131074,65538,16384,130,4,2,    2097313

**card_type_text_list** = 
"Special-Summon/Effect","Effect","Pendulum/Effect","Synchro/Effect","Fusion/Effect","Xyz/Effect","Fusion/Pendulum/Effect","Synchro/Pendulum/Effect","Xyz/Pendulum/Effect","Link/Effect","Normal","Token","Link","Ritual","Ritual/Effect","","","","Fusion/Tuner/Effect","Synchro/Tuner/Effect","Synchro","Fusion","Fusion/Tuner","Special-Summon/Tuner/Effect","Special-Summon/Pendulum/Effect","Flip/Effect","Tuner/Effect","Union/Tuner/Effect","Normal/Tuner","Union/Effect","Gemini/Effect","Xyz","Pendulum/Flip/Effect","Ritual/Tuner/Effect","Token/Tuner","Pendulum/Normal","Spirit/Effect","Ritual/Spirit/Effect","Pendulum/Tuner/Effect","Pendulum/Tuner/Normal","Special-Summon/Toon/Effect","Toon/Effect","Pendulum/Ritual/Effect","Flip/Tuner/Effect","Special-Summon/Spirit/Effect","Pendulum/Spirit/Effect","Counter/Trap","Field/Spell","Equip/Spell","Continuous/Trap","Continuous/Spell","Quick-Play/Spell","","Ritual/Spell","Trap","Spell",      "Ritual/Flip/Effect"

**level_rank_icon_switch (by card_type, switch between non-link non-xyz monster or xyz monster)** = level_star,level_star,level_star,level_star,level_star,rank_star,level_star,level_star,rank_star,rank_star,level_star,level_star,rank_star,level_star,level_star,rank_star,rank_star,rank_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,rank_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,level_star,rank_star,rank_star,rank_star,rank_star,rank_star,rank_star,rank_star,rank_star,rank_star,rank_star,      level_star

**level_rank_visiblity (by card_type, non-link non-xyz monster and xyz monster or else)**= true,true,true,true,true,true,true,true,true,false,true,true,false,true,true,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,    true

**pendulume_scale_visiblity (by card_type, non-link monster or else)** = false,false,true,false,false,false,true,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,true,false,false,true,false,false,true,true,false,false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,    false

**link_arrows_visiblity (by card_type,link monster or else)**= false,false,false,false,false,false,false,false,false,true,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,   false

**monster_attribute_visiblity (by card_type, monster or spell and trap)**= true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,   true

**monster_type_visiblity (by card_type, monster or spell and trap)**= true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false,false,false,false,false,false,false,false,false,false,   true

**spell_trap_attribute_visiblity (by card_type, monster or spell and trap)** = false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,true,true,true,true,true,true,true,true,    false



**special_card_type_list** = 10000000,10000010,10000020.    (these are ids for oblisk, slifer and ra from cards.db / datas table / id column)




## card categories and filters (from cards.db / datas table / type column)
**type_effect** = 33554465,33,16777249,33558561,50331681,2097185,4129,5153,1057,2081,18874401,545,16781345,37748769,2101281,33554977,16777761
**type_synchro** = 8225,16785441,12321,8193
**type_fusion** = 97,16777313,4193,65,4161
**type_xyz** = 8388641,25165857,8388609
**type_link** = 67108897,67108865
**type_normal** = 17,4113,16777233,16781329
**type_token** = 16401,20497
**type_ritual** = 129,161,4257,673,16777377,     2097313
**type_spell** = 524290,262146,131074,65538,130,2
**type_trap** = 1048580,131076,4
**subtype_effect** = 33,2097185,4129,5153,2081,18874401,545,16781345,37748769,4194337,2101281,33554977,16777761,33554465,33558561,50331681,16777249,8225,12321,97,4193,8388641,67108897,161,4257,673,16777377,16785441,16777313,25165857
**subtype_special_summon** = 33554465,33558561,50331681,37748769,33554977
**subtype_pendulum** = 16777249,50331681,18874401,16781345,16777761,16785441,16777313,25165857,16777233,16781329,16777377
**subtype_tuner** = 33558561,4129,5153,16781345,2101281,12321,4193,4161,4113,16781329,20497,4257
**subtype_flip** = 2097185,18874401,2101281
**subtype_union** = 5153,1057
**subtype_gemini** = 2081
**subtype_spirit** = 545,33554977,16777761,673
**subtype_toon** = 37748769,4194337
**subtype_none_effect_nor_normal** = 8193,65,4161,8388609,67108865,129
	
following could be used for each link arrow visiblity too (from cards.db / datas table / def column   for card type in type column that is in **type_link** )
**t_arrow** =  128,130,131,132,133,134,135,136,138,139,160,161,162,163,166,168,170,173,175,196,387,388,390,422,448,490,384
**tl_arrow** =  64,66,68,69,77,196,325,448,490
**l_arrow** =  8,9,10,12,14,40,41,42,43,45,46,47,77,136,138,139,168,170,173,175,490
**bl_arrow** =  1,3,5,7,9,33,39,41,43,45,47,69,77,131,133,135,139,161,163,173,175,257,325,387,37
**b_arrow** =  2,3,6,7,10,14,34,38,39,42,43,46,47,66,130,131,134,135,138,139,162,163,166,170,175,387,390,422,490
**br_arrow** =  4,5,6,7,12,14,36,38,39,45,46,47,68,69,77,132,133,134,135,166,173,175,196,260,325,388,390,422,37
**r_arrow** =  32,33,34,36,38,39,40,41,42,43,45,46,47,160,161,162,163,166,168,170,173,175,422,490,37,288
**tr_arrow** = 256,257,260,325,387,388,390,422,448,490,288,384

**cg_list** = 'TCG','OCG','OCG/TCG','Anime/Manga' (ot column) , 'Rush' (means get it from cards-rush.db)

**ban_list** = banned, limited, semi-limited, unlimited


## visual shadings
**card header colors**
normal = weak golden
ritual = azure
effect = orange
fusion = magenta
synchro = white
xyz = dark blue-black gradient
link = light blue
normal pendulum = weak golden on top half, solid green in bottom half
effect pendulum = orange on top half, solid green in bottom half
ritual pendulum = azure on top half, solid green in bottom half
fusion pendulum = magenta on top half, solid green in bottom half
synchro pendulum = white on top half, solid green in bottom half
xyz pendulum = dark blue-black gradient on top half, solid green in bottom half
spell = green
trap = pink
ra (special) = Yellow
oblisk (special) = strong blue
slifer (special) = red