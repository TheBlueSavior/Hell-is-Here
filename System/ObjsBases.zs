class ObjectsBase : KAI_Actor
{
    double SpawnWeight;
    property SpawnWeight : SpawnWeight;


    Default 
    {
        ObjectsBase.SpawnWeight 1.0;
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
        if (other.bIsMonster == true) 
        {
            Thrust(other.speed / 4, AngleTo(other) + 180);
            //Console.Printf("Collided with a monster!");
        }
        else
        {
            Thrust(other.speed / 2, AngleTo(other) + 180);
            //Console.Printf("Collided with an entity!");
        }
        
        if(DealDamage)
        {
            other.DamageMobj(self, self, self.damage + (self.speed * 1/3), 'Normal', 0, 0);

            self.DealDamage = false;
        }

        Super.CollidedWith(other, passive);
    }


    Default
    {
        //+THRUSPECIES;
        ObjectsBase.SpawnWeight 1.0;
        Litter.SoundVolume 0.5;
    }
}

class Trap : ObjectsBase
{
    double SoundVolume;
    property SoundVolume : SoundVolume;


    virtual void trigger(){}

    Default
    {
        ObjectsBase.SpawnWeight 0.5;
        Trap.SoundVolume 0.85;
    }
}