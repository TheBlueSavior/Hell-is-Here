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
    bool CollideDamage;

    double SoundVolume;
    property SoundVolume : SoundVolume;


    void Manipulate(double angle, double length, double airheight, double airmod)
    {
        Vector3 VectPos = (AngleToVector(angle, length), airheight);

        self.bFloat = true;
        self.bNoGravity = true;

        while (self.pos != VectPos)
        {
            KAI_MoveTowards(VectPos, 1.0, 0, 0, 0);
            VectPos.z += sin(GetAge() % airmod * (self.mass * 1/4));
        }

        self.bFloat = false;
        self.bNoGravity = false;
    }

    void ChuckSelf(Actor targ, double givenPitch)
    {
        self.bFloat = true;
        self.bNoGravity = true;
        self.bFloatBob = true;


        while (CheckSpaceSize(self.radius, self.height, 8, false) == -1)
        {
            Vel3DFromAngle(self.speed, AngleTo(targ, false), givenPitch);

            self.CollideDamage = true;
        }

        self.CollideDamage = false;
        //    targ.DamageMobj(self, self, self.damage, 'Normal', 0, 0);

        self.bFloat = false;
        self.bNoGravity = false;
        self.bFloatBob = false;
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
        
        if(CollideDamage)
        {
            other.DamageMobj(self, self, self.damage + (self.speed * 1/3), 'Normal', 0, 0);

            self.CollideDamage = false;
        }

        //other.DamageMobj(self, self, self.damage + (self.speed * 1/3), 'Normal', 0, 0);

        Super.CollidedWith(other, passive);
    }


    Default
    {
        +THRUSPECIES;
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