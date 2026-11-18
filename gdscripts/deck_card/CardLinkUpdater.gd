# CardLinkUpdater.gd

class_name CardLinkUpdater
extends RefCounted


static func update(card, data:Dictionary) -> void:

	if !CardTypeHelper.is_link(data.type):

		card.tl.visible = false
		card.t.visible = false
		card.tr.visible = false

		card.l.visible = false
		card.r.visible = false

		card.bl.visible = false
		card.b.visible = false
		card.br.visible = false

		card.link_count.text = ""

		return


	var markers:int = data.def


	card.link_count.text = str(data.level)


	card.t.visible = (markers & 128) != 0

	card.tl.visible = (markers & 64) != 0

	card.l.visible = (markers & 8) != 0

	card.bl.visible = (markers & 1) != 0

	card.b.visible = (markers & 2) != 0

	card.br.visible = (markers & 4) != 0

	card.r.visible = (markers & 32) != 0

	card.tr.visible = (markers & 256) != 0
