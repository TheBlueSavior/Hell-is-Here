Class SectorSpawnInit : EventHandler 
{
    override void WorldLoaded(WorldEvent e)
    {
        if (deathmatch || e.IsReopen)
			return;
		else
			let spawnerz = Actor.Spawn("SectorSpawner",(0,0,0));
	}
}


Class SectorSpawner : Actor
{

    Array<Class<Actor> > ScoutActors;
    Array<int> SpawnWeights;


    int IntervalCounter;

    override void Tick()
    {
        super.Tick();

        IntervalCounter++;
        if (IntervalCounter >= spawn_interval)
        {
            IntervalCounter = 0; // reset do * 35 ^
            SpawnInSector();
        }
    }

    int GetRandomActor()
    {
        int TotalWeight = 0;

        // Sum all weights
        for (int i = 0; i < ScoutActors.Size(); i++)
            TotalWeight += SpawnWeights[i];

        if (TotalWeight <= 0) return 0;

        // Pick a random number in [0, totalWeight)
        int choice = Random(0, TotalWeight - 1);

        // Walk through list until we find the chosen one
        for (int i = 0; i < ScoutActors.Size(); i++)
        {
            choice -= SpawnWeights[i];
            if (choice < 0)
            {
                return i;
                break;  
            }
        }
        return 0;
    }

    void SpawnInSector()
    {
        int pt_in_arr = GetRandomActor();
        class<Actor> GivenScout = ScoutActors[pt_in_arr];
        

        for (int i = 0; i < level.sectors.Size(); i++)
        {
            Sector sec = level.sectors[i];

            Vector2 sec_center = sec.centerspot;

            Vector3 sec_point = (sec_center.x, sec_center.y, 0);

            if (level.IsPointInLevel(sec_point) == false)
            {
                continue; //in the void - go to next attempt
            }

            let scout = Spawn(GivenScout, sec_point);
            if (scout.TestMobjLocation() == true)
            {
                // success!
                Console.Printf("fits!!");
            }
            else
            {
                scout.Destroy(); // did not fit destroy scout
            }

        }
    }
    
    override void PostBeginPlay()
    {
        super.PostBeginPlay();

        // manual could be changed
        ScoutActors.Push("ChaingunGuy");
        ScoutActors.Push("ZombieMan");
        ScoutActors.Push("ShotgunGuy");

        SpawnWeights.Push(50);
        SpawnWeights.Push(30);
        SpawnWeights.Push(20);
    }

	Default
    {
		Health 999999;
		Radius 10;
		Height 44;
		Mass 1000;
		Speed 30;
		PainChance 0;
		Monster;
		+FLOORCLIP
		+THRUACTORS
		+DONTGIB
		+NOCLIP
		-COUNTKILL
		-SHOOTABLE
	}

    States
	{
	Spawn:
		TNT1 A 0;
		Loop;
	}
}