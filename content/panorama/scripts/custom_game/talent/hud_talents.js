//var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
//var center_block = parentHUDElements.FindChildTraverse("center_block")

//var old_talents = center_block.FindChildTraverse("AbilitiesAndStatBranch");
// old_talents.RemoveAndDeleteChildren()

/*
TODO: make sure you can't skill other people's talents

0-4:
top left
top right
left
right
bottom 

*/

const talents = [false, false, false, false, false];

let handle = GameEvents.Subscribe( "talent_learned", UpdateTalents );

if ($.GetContextPanel().GetParent().BHasClass("LeftRightFlow") == false) {
    Init();
}

function Init()
{
	let dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("AbilitiesAndStatBranch");
	$.GetContextPanel().SetParent(dotaHud.FindChildrenWithClassTraverse("LeftRightFlow")[0]);
	dotaHud.FindChildrenWithClassTraverse("LeftRightFlow")[0].MoveChildBefore($.GetContextPanel(),dotaHud.FindChildTraverse("StatBranch"))
	//talents = [false, false, false, false, false];
}

let stat_branch = $.GetContextPanel().GetParent().FindChildTraverse("StatBranch")
stat_branch.visible = false

CreateHUDTalents(talents)

function UpdateTalents( data ) // called on talent learned
{
	talents[data.talent_index] = true;
	CreateHUDTalents(talents);
}

function CreateHUDTalents() 
{
	let TalentsMain = $.GetContextPanel();

	// if not a hero return
	let parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("HUDElements");
	let check_local = parentHUDElements.FindChildTraverse("center_block");
	if (check_local.BHasClass("NonHero"))
	{
		TalentsMain.visible = false;
		return;
	}

	TalentsMain.visible = true;

	// delete burning effect
	// TODO: change this to make invisible later?
	for (let i = 0; i < TalentsMain.GetChildCount(); i++)
	{
		if (TalentsMain.GetChild(i).id == "PentagramPoint")
		{
			TalentsMain.GetChild(i).DeleteAsync(0);
		}
	}

	for (let point_index = 0;
		point_index < 5;
		point_index++)
	{
		if (talents[point_index])
		{
			let BurningEffect = $.CreatePanel("Image", TalentsMain, "PentagramPoint");
			let arc = point_index * (360 / 5);
			BurningEffect.SetImage("s2r://panorama/images/custom_game/talent/pentagram_point.png");
			BurningEffect.style.transform = "rotatez(" + arc + "deg);";
		}
	}
}

function CreateLevelTalentDisplay()
{
	// check to make sure the correct unit is selected

	
}

function LevelTalent()
{
	GameEvents.SendCustomGameEventToServer( 
		"level_talent",
		{
			
		}
	);
}