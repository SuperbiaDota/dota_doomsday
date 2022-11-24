var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
var center_block = parentHUDElements.FindChildTraverse("center_block")
var buffs =  parentHUDElements.FindChildTraverse("buffs")
var debuffs = parentHUDElements.FindChildTraverse("debuffs")

// TODO: move to a general remove stuff file, and add glyph/scan
var aghanim = center_block.FindChildTraverse("AghsStatusContainer")
aghanim.visible = false;
var extra_item_slots = center_block.FindChildTraverse("inventory_composition_layer_container")
extra_item_slots.visible = false;

let handle = GameEvents.Subscribe( "update_craft_ui", CreateCraftButtons )

/*
Panel id="AbilitiesAndStatBranch"
->Panel class="LeftRightFlow"
DOTAAghsStatusDisplay id="AghsStatusContainer"
DOTAHudTalentDisplay id="StatBranch"

Panel id="inventory_composition_layer_container"
*/

function CreateCraftButtons( data )
{
	for (let i = 0; i < center_block.GetChildCount(); i++)
	{
		if (center_block.GetChild(i).id == "CraftButtonContainer")
		{
			center_block.GetChild(i).DeleteAsync(0);
		}
	}

	let CraftButtonContainer = $.CreatePanel("Panel", center_block, "CraftButtonContainer");
	CraftButtonContainer.style.align = "right bottom";
	CraftButtonContainer.style.flowChildren = "left";
	CraftButtonContainer.style.marginBottom = "145px";
	CraftButtonContainer.style.marginRight = "93px";

	CraftButtonContainer.style.backgroundImage = "url('s2r://panorama/images/conduct/ovw-bar-bg_png.vtex')";

	// TODO(jason): format ordering
	let craft_count = Object.keys(data).length;
	let first_count = 0;
	if (craft_count <= 0)
	{ 
		return;
	} 
	else if (craft_count > 6)
	{
		first_count = craft_count - 6;
		craft_count = 6;
	}

	let first_button = CreateCraftButton(CraftButtonContainer, data[first_count].item, data[first_count].duration);
	first_button.style.marginRight = "5px";
	for (let item_iter = first_count+1;
		item_iter < craft_count-1;
		item_iter++)
	{
		CreateCraftButton(CraftButtonContainer, data[item_iter].item, data[item_iter].duration);
	}
	let last_button = null;
	if (craft_count > 1)
	{
		last_button = CreateCraftButton(CraftButtonContainer, data[craft_count-1].item, data[craft_count-1].duration);
	}
	else
	{
		last_button = first_button;
	}
	last_button.style.marginLeft = "5px";
}

function CreateCraftButton(container, item, duration)
{

	let CraftMain = $.CreatePanel("Panel", container, '');
	CraftMain.style.width = "47px"
	CraftMain.style.height = "35px"
	CraftMain.style.marginBottom = "5px"
	CraftMain.style.marginTop = "5px"
	CraftMain.style.marginLeft = "2px"

	let CraftIcon = $.CreatePanelWithProperties(
		"DOTAItemImage", 
		CraftMain, 
		"image_" + item, 
		{
			style: "width:100%;height:100%;", 
			itemname: item
		}
	);
	CraftIcon.SetPanelEvent(
		'onmouseactivate', 
		function()
		{
			CastAbilityCraft(item, duration)
		}
	);
	return CraftMain
}

function CastAbilityCraft(item, duration)
{
	GameEvents.SendCustomGameEventToServer( 
		"cast_ability_craft",
		{
			unit: Players.GetLocalPlayerPortraitUnit(),
			item: item,
			duration: duration
		}
	);
}
