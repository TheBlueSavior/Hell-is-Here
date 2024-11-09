// this is just a proof of concept class, this will (ideally) be implemented with the actual demons in the future
class DoorKnocker : KAI_Creature replaces DoomImp
{
    FLineTraceData line_data;

    //bool found_door;
    Vector3 found_door_pos;


    bool analyzeLine()
    {
        int door_specials[]={
            10,11,12,13,14,
            105,106,194,195,198,
            202,
            249,252,262,263,265,266,268,274
        };

        
        Console.printf("testing hit line %i", line_data.HitLine.special);
        

        for (int i = 0; i < door_specials.size(); i++) {
            if  (line_data.HitLine.special == door_specials[i])
            {
                
                // for the middle of the door
                int dist = sqrt((line_data.HitLine.v2.p.x - line_data.HitLine.v1.p.x) * (line_data.HitLine.v2.p.x - line_data.HitLine.v1.p.x) + (line_data.HitLine.v2.p.y - line_data.HitLine.v1.p.y) * (line_data.HitLine.v2.p.x - line_data.HitLine.v1.p.x) + (line_data.HitLine.v2.p.y - line_data.HitLine.v1.p.y));
                
                // we get around the middle of the door and then move the goal position upwards a bit depending on the calling actors radius
                // (we could also randomize the position slightly in the future)
                found_door_pos.x = line_data.HitLine.v2.p.x + (dist / 2);
                found_door_pos.y = line_data.HitLine.v2.p.y + (self.radius * 1/3);

                Console.printf("line found");

                return true;
            }
        }

        return false;
    }

    default
    {
        Health 60;
		Radius 20;
		Height 56;
		Mass 100;
		Speed 8;
		PainChance 200;
		Monster;
		+FLOORCLIP
		SeeSound "imp/sight";
		PainSound "imp/pain";
		DeathSound "imp/death";
		ActiveSound "imp/active";
		HitObituary "$OB_IMPHIT";
		Obituary "$OB_IMP";
		Tag "$FN_IMP";
    }

    states 
    {
        Spawn:
		    TROO AB 10 A_Look;
		    Loop;
	    See:
            TNT1 A 0 
            {
                // spread out a cone of LineTraces
                for (int i = 0; i < 20; i ++) 
                {
                    float angle_offset = ((i - (20 - 1) / 2) * (90.0 / (20 - 1)));
                    float fire_angle = self.Angle + angle_offset;


                    Vector3 angleToVec;
                    angleToVec.xy = AngleToVector(fire_angle, 4096);
                    angleToVec.z = 0;
                    KAI_LOFRaycast.VisualizeTracePath(self.pos, angleToVec, 4096);
                    LineTrace(fire_angle, 4096, self.Pitch, TRF_THRUSPECIES | TRF_THRUACTORS | TRF_THRUHITSCAN | TRF_SOLIDACTORS, 0, 0, data : line_data);
                    A_JumpIf(analyzeLine(), "DoorFound");
                }
            }
            //TNT1 A 0 
            //{
            //    bool found_door = analyzeLine();
            //    A_JumpIf(found_door, "DoorFound");
            //}
		    TROO AA 3 A_Chase;
            //TROO BB 3 LineTrace(self.Angle, 20000, self.Pitch, TRF_THRUSPECIES | TRF_THRUACTORS | TRF_THRUHITSCAN | TRF_SOLIDACTORS, 0, 0, data : line_data);
            TROO CC 3 A_Chase;
            TROO DD 3 A_Chase;
		    Loop;
        DoorFound:
            TNT1 A 0
            {
                Console.printf("Door has been found at %i, %i", self.found_door_pos.x, self.found_door_pos.y);
            } 
            

            // pretty buggy fix l8er
            TROO AA 3 KAI_MoveTowards(found_door_pos, 0.8, 14, 0, 0);
            // check if actor has reached door, then go to KnockDoor

            TNT1 A 0
            {
                if (self.pos ~== found_door_pos)
                {
                    A_Jump(256, "KnockDoor");
                }
                //else {
                //    self.found_door = false;
                //    A_Jump(256, "KnockDoor");
                //}
            }
            Loop;
        KnockDoor:
            // play a knocking sound, maybe we could possibly make the knocking sound change depending on the type of door, but that might be overkill
            TNT1 A 0
            {
                Console.printf("Door has been reached!");
            }

            Goto See;
        Missile:
            TROO EF 8 A_FaceTarget;
            TROO G 6 A_BruisAttack;
            Goto See;
        Pain:
            TROO H 2;
            TROO H 2 A_Pain;
            Goto See;
        Death:
            TROO I 8;
            TROO J 8 A_Scream;
            TROO K 6;
            TROO L 6 A_NoBlocking;
            TROO M -1;
            Stop;
        XDeath:
            TROO N 5;
            TROO O 5 A_XScream;
            TROO P 5;
            TROO Q 5 A_NoBlocking;
            TROO RST 5;
            TROO U -1;
            Stop;
        Raise:
            TROO ML 8;
            TROO KJI 6;
            Goto See;
    }
}