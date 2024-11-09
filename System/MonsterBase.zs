class HIH_MonsterBase : KAI_Creature abstract
{                      
	transient CVar StealthOption;
	
	int ForgetThreshold;
	property ForgetThreshold: ForgetThreshold; // [Ace] The higher this number, the slower it'll take for an enemy to give up on you, provided you've jammed yourself in a mousehole.

	double AlwaysSeeDistance;
	property AlwaysSeeDistance: AlwaysSeeDistance;

	double MaxSeeDistance;
	property MaxSeeDistance: MaxSeeDistance;

	double MaxHearDistance;
	property MaxHearDistance: MaxHearDistance;

	Default
	{
		HIH_MonsterBase.ForgetThreshold 200;
		HIH_MonsterBase.AlwaysSeeDistance 256;
		HIH_MonsterBase.MaxSeeDistance 6144;
		HIH_MonsterBase.MaxHearDistance 6144;
		Monster;
		+FLOORCLIP;
	}

	override void Tick()
	{
	    if (!StealthOption) { StealthOption = CVar.GetCVar('hih_forgetcheck'); }

		if (GetAge() % 35 == 0 && StealthOption.GetInt() > 1)
		{
			if (Target && Health > 0)
			{
				double dist, adjDist;
				[dist, adjDist] = GetAdjustedSeeDistance();
				//Console.Printf("\c[DarkGray]Distance:\c- %.2f, \c[DarkGray]Adj. See Distance:\c- %.2f", dist, adjDist);
				if (dist > AlwaysSeeDistance) // [Ace] I was considering adding a CheckSight to this, but it made me think that it'd be more immersive to have to hide in a dark corner than to just go AROUND a corner.
				{
					ForgetThreshold -= int(1000 / max(10, adjDist));
					if (ForgetThreshold <= 0)
					{
						A_ClearTarget();
						SetState(SpawnState);
					}
				}
			}
			else
			{
				ForgetThreshold = default.ForgetThreshold;
			}
		}

		// [Ace] If you load DS before PM, you can use the helper stuff from DS for debugging. Just don't forget to comment out the code later.
		//DSCore.DrawCollisionBox(self);
		Super.Tick();
	}

	double, double GetAdjustedSeeDistance()
	{
		if (!Target || !Target.CurSector)
		{
			return 0, MaxSeeDistance;
		}

		double dist = Distance3D(Target);
		double distRedFac = (Target.CurSector.lightlevel / 144.0) * (0.5 + Target.Vel.Length() / 8.0) * (Target.Player ? Target.Player.crouchfactor : 1.0) * (Target.bSHADOW ? 0.35 : 1.0);

		return dist, MaxSeeDistance * distRedFac;
	}
		
	void HIH_Look(double fov = 140, int flags = LOF_NOSEESOUND)
	{
		// [Ace] Simplify things for friendly monsters. Just attack.
		if (!StealthOption || StealthOption.GetInt() == 0 || bFRIENDLY || Target && (!Target.Player || !Target.CurSector))
		{
			A_LookEx(flags, label: "Look");
			return;
		}
        
		A_LookEx(flags | LOF_NOJUMP, maxseedist: MaxSeeDistance, MaxHearDistance, fov);
		if (Target && !LastHeard && Health >= 0)
		{
			double dist, adjDist;
			[dist, adjDist] = GetAdjustedSeeDistance();
			if (dist > AlwaysSeeDistance && (dist > adjDist || random(0, 10)))
			{
				A_ClearTarget();
			}
		}
		if (Target && (!bAMBUSH || CheckSight(Target)))
		{
			SetStateLabel('Look');
		}
	}
}