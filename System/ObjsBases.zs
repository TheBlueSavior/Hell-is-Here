class ObjectsBase : KAI_Actor
{
    double SpawnWeight;
    property SpawnWeight : SpawnWeight;

    // current skin index should be dependent on some kind of cvar in the future
    int CurrentSkinIndex;
    property CurrentSkinIndex : CurrentSkinIndex;


    Array<Name> SkinSprites;
    property SkinSprites : SkinSprites;


    override void PostBeginPlay()
    {
        self.sprite = GetSpriteIndex(SkinSprites[CurrentSkinIndex]);
        Super.PostBeginPlay();
    }

    void ChangeSprites(int index)
    {
        CurrentSkinIndex = index;

        self.sprite = GetSpriteIndex(SkinSprites[CurrentSkinIndex]);
    }

    Default 
    {
        ObjectsBase.SpawnWeight 1.0;
        ObjectsBase.CurrentSkinIndex 0;
        +NONSHOOTABLE;
        +NOBLOOD;
        +CASTSPRITESHADOW;
        +FLOORCLIP;
        +INVULNERABLE;
        +FIXMAPTHINGPOS;
    }
}

class Litter : ObjectsBase
{
    bool DealDamage;


    double SoundVolume;
    property SoundVolume : SoundVolume;


    void ToggleFloating()
    {
        self.bFloat = !self.bFloat;
        self.bNoGravity = !self.bNoGravity;
        self.bFloatBob = !self.bFloatBob;
    }

    void ToggleDamage()
    {
        self.DealDamage = !self.DealDamage;
    }

    void Manipulate(double angle, double length, double airheight, double airmod)
    {
        Vector3 VectPos = (AngleToVector(angle, length), airheight);

        //console.printf("hello?");
        KAI_MoveTowards(VectPos, 1.0, 0, 0, 0);
        VectPos.z += sin(GetAge() % airmod * (self.mass * 1/4));

    }

    void ChuckSelf(Actor targ, double givenPitch)
    {

        Vel3DFromAngle(self.speed, AngleTo(targ, false), givenPitch);
        //    targ.DamageMobj(self, self, self.damage, 'Normal', 0, 0);
    }

    override void CollidedWith(Actor other, bool passive)
    {
        // for some reason monsters seem to be able to push away litter at a higher velocity than the player can
        if (other.bIsMonster == true) 
        {
            Thrust(other.speed / 4, AngleTo(other) + 180);
            //Console.Printf("Collided with a monster!");
        }
        else
        {
            // in the future we should call whatever creates sound monsters can detect here
            Thrust(other.speed / 2, AngleTo(other) + 180);
            //Console.Printf("Collided with an entity!");
        }
        
        if(DealDamage)
        {
            other.DamageMobj(self, self, self.damage + (self.speed * 1/3), 'Normal', 0, 0);

            ToggleDamage();
        }

        Super.CollidedWith(other, passive);
    }


    Default
    {
        //+THRUSPECIES;
        ObjectsBase.SpawnWeight 1.0;
        ObjectsBase.CurrentSkinIndex 0;
        Litter.SoundVolume 0.5;
    }
}

class Decoration : ObjectsBase
{

    // effect when a demon is messing with it, overridable because each new class should have a different effect
    virtual void Modify(){}
}

class Trap : ObjectsBase
{
    double SoundVolume;
    property SoundVolume : SoundVolume;

    // im thinking we have a seperate actor that detects collisions from players and sends that back to the trap, triggering the trap
    // we can just use the originator ptr to call the owning traps trigger function
    Class<Actor> TriggerActor;
    property TriggerActor : TriggerActor;

    // spawn offset of the trigger actor
    Vector3 TriggerSpawnAway;
    property TriggerSpawnAway : TriggerSpawnAway;


    override void BeginPlay()
    {
        A_SpawnItemEx(TriggerActor, TriggerSpawnAway.x, TriggerSpawnAway.y, TriggerSpawnAway.z, 0, 0, 0, 0, 0, 0, 0);

        Super.BeginPlay();
    }
    
    // effect when trap is triggered
    virtual void trigger(){}

    Default
    {
        ObjectsBase.SpawnWeight 0.5;
        Trap.SoundVolume 0.85;
    }
}