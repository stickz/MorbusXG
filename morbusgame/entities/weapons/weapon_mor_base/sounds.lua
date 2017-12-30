-- alien.Grunt1
-- alien.Grunt2
-- alien.Grunt3
-- alien.Impact1
-- alien.Impact2
-- alien.Impact3
-- alien.Impact4
-- alien.Hit1
-- alien.Hit2
-- alien.Spit1
-- alien.Gestate

-- npc\combine_gunship\attack_start2.wav -- heavy energy weapon sound
-- npc\combine_gunship\attack_stop2.wav -- heavy weapon sound
-- npc\combine_gunship\gunship_ping_search.wav -- sonar ping
-- npc\roller\mine\combine_mine_deactivate1.wav -- nade / gadget ping
-- npc\roller\mine\combine_mine_active_loop1.wav -- nade / gadget ping loop
-- ambient\levels\citadel\zapper_warmup1.wav -- gadget charge
-- ambient\levels\citadel\weapon_disintegrate2.wav -- small energy pop / gadget discharge
-- npc\scanner\cbot_energyexplosion1.wav -- electronic destroy


-- ambient\machines\gas_loop_1.wav -- gas loop

sound.Add({
    name =              "phaser.Single",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    sound =             "weapons/railgun/pulsar_shot1.wav"
})

sound.Add({
    name =              "phaser.Single.light",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             135,
    sound =             "weapons/railgun/pulsar_shot1.wav"
})

sound.Add({
    name =              "phaser.Single.heavy",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             85,
    sound =             "weapons/railgun/pulsar_shot1.wav"
})


sound.Add({
    name =              "rail.Single",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    sound =             "weapons/railgun/railgun_fire1.wav"
})

sound.Add({
    name =              "rail.Single.light",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             135,
    sound =             "weapons/railgun/railgun_fire1.wav"
})

sound.Add({
    name =              "rail.Single.heavy",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             85,
    sound =             "weapons/railgun/railgun_fire1.wav"
})

sound.Add({
    name =              "particle.Single",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    sound =             "npc/combine_gunship/attack_start2.wav"
})

sound.Add({
    name =              "particle.Single.light",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             135,
    sound =             "npc/combine_gunship/attack_start2.wav"
})

sound.Add({
    name =              "particle.Single.heavy",
    channel =           CHAN_USER_BASE+10,
    volume =            1.0,
    pitch =             85,
    sound =             "npc/combine_gunship/attack_start2.wav"
})

sound.Add({
    name    =           "gas.Loop",
    channel =           CHAN_USER_BASE+10,
    volume  =           1.0,
    sound   =           "ambient/machines/gas_loop_1.wav"
})

sound.Add({
    name =          "bulldog.shoot",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/demon/heavyrifle.wav"
})

sound.Add({
    name =          "bulldog.shoot.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         85,
    sound =             "weapons/demon/heavyrifle.wav"
})

sound.Add({
    name =          "bulldog.shoot.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         150,
    sound =             "weapons/demon/heavyrifle.wav"
})

sound.Add({
    name    =           "egon.BeamLoop",
    channel =           CHAN_USER_BASE+10,
    volume  =           1.0,
    sound   =           "ambient/levels/citadel/extract_loop1.wav"
})

sound.Add({
    name    =           "egon.BeamLoop.heavy",
    channel =           CHAN_USER_BASE+10,
    volume  =           1.0,
    pitch =             75,
    sound   =           "ambient/levels/citadel/extract_loop1.wav"
})

sound.Add({
    name    =           "egon.BeamLoop.light",
    channel =           CHAN_USER_BASE+10,
    volume  =           1.0,
    pitch =             150,
    sound   =           "ambient/levels/citadel/extract_loop1.wav"
})

sound.Add({
    name    =           "egon.BeamFinish",
    channel =           CHAN_USER_BASE+10,
    volume  =           1.0,
    sound   =           "npc/scanner/scanner_electric2.wav"
})

sound.Add({
    name =          "alien.Grunt1",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/asay61.wav"
})

sound.Add({
    name =          "alien.Impact1",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/bilebombfire.wav"
})

sound.Add({
    name =          "alien.Grunt2",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/bitekill.wav"
})

sound.Add({
    name =          "alien.Hit1",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/clawshit1.wav"
})

sound.Add({
    name =          "alien.Hit2",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/clawshit2.wav"
})

sound.Add({
    name =          "alien.Grunt3",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/devour.wav"
})

sound.Add({
    name =          "alien.Gestate",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/digesting.wav"
})

sound.Add({
    name =          "alien.Spit1",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/parasitefire.wav"
})

sound.Add({
    name =          "alien.Impact2",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/spithit1.wav"
})

sound.Add({
    name =          "alien.Impact3",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/spithit2.wav"
})

sound.Add({
    name =          "alien.Impact4",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "ns_sounds/sporefire.wav"
})



sound.Add({
    name =          "energy.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        0.5,
    pitch =         135,
    sound =             "weapons/demon/laser01.wav"
})

sound.Add({
    name =          "energy.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        0.5,
    pitch =         105,
    sound =             "weapons/demon/laser01.wav"
})

sound.Add({
    name =          "energy.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        0.5,
    pitch =         75,
    sound =             "weapons/demon/laser01.wav"
})

sound.Add({
    name =          "delta.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         125,
    sound =             "weapons/demon/delta01.wav"
})

sound.Add({
    name =          "delta.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         85,
    sound =             "weapons/demon/delta01.wav"
})

sound.Add({
    name =          "solsar.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =         "weapons/demon/fire3.wav"
})

sound.Add({
    name =          "solsar.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         75,
    sound =         "weapons/demon/fire3.wav"
})

sound.Add({
    name =          "solsar.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         135,
    sound =         "weapons/demon/fire3.wav"
})

sound.Add({
    name =          "pulsar.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         145,
    sound =             "weapons/demon/fire2.wav"
})

sound.Add({
    name =          "pulsar.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         110,
    sound =             "weapons/demon/fire2.wav"
})

sound.Add({
    name =          "pulsar.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         85,
    sound =             "weapons/demon/fire2.wav"
})

sound.Add({
    name =          "plasma.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/demon/energy_6.wav"
})

sound.Add({
    name =          "plasma.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         85,
    sound =             "weapons/demon/energy_6.wav"
})

sound.Add({
    name =          "plasma.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         145,
    sound =             "weapons/demon/energy_6.wav"
})

sound.Add({
    name =          "gamma.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/demon/energy_5.wav"
})

sound.Add({
    name =          "gamma.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         75,
    sound =             "weapons/demon/energy_5.wav"
})

sound.Add({
    name =          "gamma.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         145,
    sound =             "weapons/demon/energy_5.wav"
})

sound.Add({
    name =          "pounder.Single.light",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         145,
    sound =             "weapons/demon/energy_7.wav"
})

sound.Add({
    name =          "pounder.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/demon/energy_7.wav"
})

sound.Add({
    name =          "zx9.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/Bianachi/bian-2.wav"
})

sound.Add({
    name =          "zx9.Single.heavy",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    pitch =         75,
    sound =             "weapons/Bianachi/bian-2.wav"
})

sound.Add({
    name =          "m20.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/xamas/xamas-1.wav"
})

sound.Add({
    name =          "r22.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/zamas/zamas-1.wav"
})

//vektor
sound.Add({
    name =          "kriss_vector.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/Kriss/ump45-1.wav"
})

sound.Add({
    name =          "kriss_vector.Magrelease",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/magrel.wav"
})

sound.Add({
    name =          "kriss_vector.Clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/clipout.wav"
})

sound.Add({
    name =          "kriss_vector.Dropclip",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/dropclip.wav"
})

sound.Add({
    name =          "kriss_vector.Clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/clipin.wav"
})


sound.Add({
    name =          "kriss_vector.Boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/boltpull.wav"
})

sound.Add({
    name =          "kriss_vector.unfold",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/Kriss/unfold.wav"
})



//uzi

sound.Add({
    name =          "Weapon_uzi.single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/uzi/mac10-1.wav"
})

sound.Add({
    name =          "imi_uzi_09mm.boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/uzi/mac10_boltpull.wav"
})

sound.Add({
    name =          "imi_uzi_09mm.clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/uzi/mac10_clipin.wav"
})

sound.Add({
    name =          "imi_uzi_09mm.clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/uzi/mac10_clipout.wav"
})


//sc7
sound.Add({
    name =          "Wep_fnscarh.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             {"weapons/fnscarh/aug-1.wav",
                        "weapons/fnscarh/aug-2.wav",
                        "weapons/fnscarh/aug-3.wav"}
})

sound.Add({
    name =          "Wep_fnscar.Boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/fnscarh/aug_boltpull.wav"
})

sound.Add({
    name =          "Wep_fnscar.Boltslap",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/fnscarh/aug_boltslap.wav"
})

sound.Add({
    name =          "Wep_fnscar.Clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/fnscarh/aug_clipout.wav"
})

sound.Add({
    name =          "Wep_fnscar.Clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/fnscarh/aug_clipin.wav"
})

//scarm8
sound.Add({
    name =          "spas_12_shoty.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/spas_12/xm1014-1.wav"
})

sound.Add({
    name =          "spas_12_shoty.insert",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/spas_12/xm_insert.wav"
})

sound.Add({
    name =          "spas_12_shoty.cock",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/spas_12/xm_cock.wav"
})

//USAS
sound.Add({
    name =          "Weapon_usas.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/usas12/xm1014-1.wav"
})

sound.Add({
    name =          "Weapon_usas.clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/usas12/magin.wav"
})

sound.Add({
    name =          "Weapon_usas.clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/usas12/magout.wav"
})

sound.Add({
    name =          "Weapon_usas.draw",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/usas12/draw.wav"
})





//m418
sound.Add({
    name =          "hk416weapon.SilencedSingle",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound = "weapons/twinkie_hk416/m4a1-1.wav"
})

sound.Add({
    name =          "hk416weapon.UnsilSingle",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound = "weapons/twinkie_hk416/m4a1_unsil-1.wav"
})

sound.Add({
    name =          "hk416weapon.Clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_clipout.wav"    
})

sound.Add({
    name =          "hk416weapon.Magtap",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_tap.wav"    
})

sound.Add({
    name =          "hk416weapon.Clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_clipin.wav" 
})

sound.Add({
    name =          "hk416weapon.Boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_boltpull.wav"   
})

sound.Add({
    name =          "hk416weapon.Boltrelease",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_boltrelease.wav"    
})

sound.Add({
    name =          "hk416weapon.Deploy",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_deploy.wav" 
})

sound.Add({
    name =          "hk416weapon.Silencer_On",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_silencer_on.wav"    
})

sound.Add({
    name =          "hk416weapon.Silencer_Off",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/twinkie_hk416/m4a1_silencer_off.wav"   
})



//lz400
sound.Add({
    name =          "KAC_PDW.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_unsil-1.wav"
})

sound.Add({
    name =          "KAC_PDW.SilentSingle",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1-1.wav"
})

sound.Add({
    name =          "kac_pdw_001.Clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_clipout.wav"
})

sound.Add({
    name =          "kac_pdw_001.Clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_clipin.wav"
})

sound.Add({
    name =          "kac_pdw_001.Boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_boltpull.wav"
})

sound.Add({
    name =          "kac_pdw_001.Deploy",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_deploy.wav"
})

sound.Add({
    name =          "kac_pdw_001.Silencer_On",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_silencer_on.wav"
})

sound.Add({
    name =          "kac_pdw_001.Silencer_Off",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/kac_pdw/m4a1_silencer_off.wav"
})


//gr4
sound.Add({
    name =          "hk_g3_weapon.Single",
    channel =       CHAN_USER_BASE+10,
    volume =        1.0,
    sound = "weapons/hk_g3/galil-1.wav"
})

sound.Add({
    name =          "hk_g3_weapon.Clipout",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/galil_clipout.wav"   
})

sound.Add({
    name =          "hk_g3_weapon.Clipin",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/galil_clipin.wav"    
})

sound.Add({
    name =          "hk_g3_weapon.Boltpull",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/boltpull.wav"    
})

sound.Add({
    name =          "hk_g3_weapon.Boltforward",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/boltforward.wav" 
})

sound.Add({
    name =          "hk_g3_weapon.cloth",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/Cloth.wav"   
})

sound.Add({
    name =          "hk_g3_weapon.draw",
    channel =       CHAN_ITEM,
    volume =        1.0,
    sound =             "weapons/hk_g3/draw.wav"    
})

//beretta
sound.Add(
{
    name = "92FS.single",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = SNDLVL_GUNFIRE,
    pitchstart = 90,
    pitchend = 110, 
    sound = "GDC/TRH_92FS/92FS-1.wav"
})
sound.Add(
{
    name = "92FS.Deploy",
    channel = CHAN_USER_BASE+1,
    volume = 1.0,
    soundlevel = SNDLVL_IDLE,
    sound = "GDC/TRH_92FS/deploy.wav"
})
sound.Add(
{
    name = "92FS.Foley",
    channel = CHAN_USER_BASE+1,
    volume = 1.0,
    soundlevel = SNDLVL_IDLE,
    sound = "GDC/TRH_92FS/foley.wav"
})
sound.Add(
{
    name = "92FS.ClipOut",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "GDC/TRH_92FS/clip_out.wav"
})
sound.Add(
{
    name = "Weapon.MagDropPistol",
    channel = CHAN_ITEM,
    volume = 0.1,
    soundlevel = SNDLVL_IDLE,
    sound = {"GDC/Universal/magdrop_pistol1.wav", "GDC/Universal/magdrop_pistol2.wav", "GDC/Universal/magdrop_pistol3.wav"}
})
sound.Add(
{
    name = "92FS.ClipIn",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "GDC/TRH_92FS/clip_in.wav"
})
sound.Add(
{
    name = "92FS.ClipLocked",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "GDC/TRH_92FS/clip_locked.wav"
})
sound.Add(
{
    name = "92FS.SlideBack",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "GDC/TRH_92FS/slide_back.wav"
})
sound.Add(
{
    name = "92FS.SlideForward",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = SNDLVL_NORM,
    sound = "GDC/TRH_92FS/slide_forward.wav"
})



