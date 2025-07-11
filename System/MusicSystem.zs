class HIH_MusicSetter: EventHandler
{
  override void worldLoaded(WorldEvent e)
  {
    super.worldLoaded(e);
	{
	S_ChangeMusic("HIH_MAPDRONE");
	S_StartSound("misc/startupdone", CHAN_VOICE, CHANF_UI|CHANF_NOPAUSE, 0.3);
	}
  }
}