class LitterTest : Litter
{
    Default
    {
        Mass 20;
        Radius 16;
        Height 2;
        Speed 10;
        Damage 10;
        //+FLATSPRITE;
    }

    States
    {
        Spawn:
            SMBT ABCD 4 Manipulate(60, 100, 100, 5);
            Loop;
    }

}