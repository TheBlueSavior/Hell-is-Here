class LitterTest : Litter
{

    override void BeginPlay()
    {
        self.SkinSprites.Push('SMGT');
        self.SkinSprites.Push('SMBT');

        Super.BeginPlay();
    }

    Default
    {
        Mass 20;
        Radius 16;
        Height 2;
        Speed 10;
        Damage 10;
        ObjectsBase.CurrentSkinIndex 1;
        //+FLATSPRITE;
    }


    States
    {
        Spawn:
            #### ABCD 4;
            Loop;
    }

}