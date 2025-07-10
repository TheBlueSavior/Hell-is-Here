Class HIH_Possessed : HIH_MonsterBase
{ 
	Default
	{
    Health 30;
    Radius 8;
    Height 54;
    Mass 100;
    Speed 1;
    PainChance 200;
    Damage 1;
    MONSTER;
    MeleeRange 80;
    +FloorClip
	+SLIDESONWALLS
	-HARMFRIENDS
	+DOHARMSPECIES
	+DOHARMSPECIES
	Species "Possessed";
	Tag "Possessed";
    OBITUARY "%o was taken.";
    SEESOUND "";
    PainSound "";
    DeathSound "";
    ACTIVESOUND "";
	}
    states
    {
    Spawn:
    Idle:
        A00_ AAAAAAAAAA 10;
		A00_ A 0
		{
		if (!random(0, 60))
			{
				A_StartSound("Possessed/Idle",35,volume:frandom(0.0,0.2),pitch:frandom(0.5,1));
			}
		}
		A00_ A 0 A_Jump(45,"Explore");
		Loop;
	Explore:
		TNT1 A 0 A_SetSpeed(6);
		TNT1 A 0
		{
		if (!random(0, 50))
			{
				A_StartSound("Possessed/Idle",35,volume:frandom(0.0,0.2),pitch:frandom(0.5,1));
			}
		}
		A00_ BBBB 4
		{
		A_Recoil(frandom(0.1,0.3));
		KAI_Wander();
		}
		TNT1 A 0 A_StartSound("Possessed/Footstep",4,volume:0.03);
		A00_ CCCC random(2,12)
		{
		A_Recoil(frandom(-0.5,-0.1));
		}
		A00_ DDDD 4
		{
		A_Recoil(frandom(0.1,0.3));
		KAI_Wander();
		}
		TNT1 A 0 A_StartSound("Possessed/Footstep",4,volume:0.03);
		POS1 A 0 A_Jump(40,"Idle");
		A00_ EEEE random(2,12)
		{
		A_Recoil(frandom(-0.5,-0.1));
		}
		Loop;
    Death:
        POS1 H 5 A_NoBlocking;
        POS1 I 5;
        POS1 J 5;
        POS1 K 5;
		TNT1 A 0 A_StartSound("Corpse/Fall",CHAN_6);
        POS1 L 90;
        POS1 L -1;
        Stop;
    XDeath:
        TNT1 A 0 A_StopSound(35);
		POS1 M 5;
		POS1 N 5 A_XScream;
        POS1 O 5 A_NoBlocking;
        POS1 P 5;
        POS1 Q 5;
        POS1 RST 5;
        POS1 U -1;
        Stop;
    Raise:
        POS1 LKJIH 5;
        Goto Look;
    }
}

