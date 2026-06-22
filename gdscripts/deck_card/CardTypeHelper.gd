class_name CardTypeHelper
extends RefCounted


static func is_monster(card_type:int) -> bool:
	return card_type not in [
		2, 130, 65538, 262146, 524290,
		4, 131076, 1048580
	]


static func is_spell(card_type:int) -> bool:
	return card_type in [
		2,
		130,
		65538,
		262146,
		524290
	]


static func is_trap(card_type:int) -> bool:
	return card_type in [
		4,
		131076,
		1048580
	]


static func is_link(card_type:int) -> bool:
	return card_type in [
		67108865,
		67108897
	]


static func is_xyz(card_type:int) -> bool:
	return card_type in [
		8388609,
		8388641,
		25165857
	]


static func is_pendulum(card_type:int) -> bool:
	return card_type in [
		16777249,
		50331681,
		18874401,
		16781345,
		16777761,
		16785441,
		16777313,
		25165857,
		16777233,
		16781329,
		16777377
	]


static func uses_level_rank(card_type:int) -> bool:
	return is_monster(card_type) and not is_link(card_type)


static func uses_link_arrows(card_type:int) -> bool:
	return is_link(card_type)


static func uses_pendulum_scale(card_type:int) -> bool:
	return is_pendulum(card_type)


static func uses_attribute(card_type:int) -> bool:
	return true


static func uses_race(card_type:int) -> bool:
	return is_monster(card_type)


static func uses_atk(card_type:int) -> bool:
	return is_monster(card_type)


static func uses_def(card_type:int) -> bool:
	return (
		is_monster(card_type)
		and not is_link(card_type)
	)


static func uses_link_rating(card_type:int) -> bool:
	return is_link(card_type)


static func uses_level_icon(card_type:int) -> bool:
	return (
		is_monster(card_type)
		and not is_link(card_type)
		and not is_xyz(card_type)
	)


static func uses_rank_icon(card_type:int) -> bool:
	return is_xyz(card_type)
