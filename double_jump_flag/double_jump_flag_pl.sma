#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <colorchat>

#define DOUBLE_JUMP_FLAG 262144 // ADMIN_LEVEL_G (s), https://amxx.pl/topic/6472-flagi-admina/?p=38100
#define DOUBLE_JUMP_PREFIX "DoubleJump"
#define DOUBLE_JUMP_TIME 10.0
#define DOUBLE_JUMP_MIN_VELOCITY 265.0
#define DOUBLE_JUMP_MAX_VELOCITY 285.0

forward amxbans_admin_connect(id);

new bool:g_Jumpers[MAX_PLAYERS + 1];
new g_Jumps[MAX_PLAYERS + 1];
new Float:g_LastUserJump[MAX_PLAYERS + 1];

public plugin_init() {
    register_plugin("Double Jump", "1.0.0", "benio101 & speedkill (edit: angelika_null)");
    
    register_forward(FM_CmdStart, "CmdStartPre");
    RegisterHam(Ham_Spawn, "player", "SpawnedEventPre", 1);
    
    set_task(0.5, "check_doublejump", .flags="b");
}

public check_doublejump() {
    for(new id = 1; id <= MAX_PLAYERS; id++) {
        if(is_user_connected(id) && g_Jumpers[id] && is_user_alive(id)) {
            if(g_Jumps[id] == 0 && (get_gametime() - g_LastUserJump[id]) > DOUBLE_JUMP_TIME) {
                g_Jumps[id] = 1;
                ColorChat(id, GREEN, "[%s] ^x01Możesz ponownie skoczyć podwójnie.", DOUBLE_JUMP_PREFIX);
            }
        }
    }
}

public client_authorized(id, const authid[]) {
    if((get_user_flags(id) & DOUBLE_JUMP_FLAG) == DOUBLE_JUMP_FLAG) {
        client_authorized_jumper(id);
    }
}

public client_authorized_jumper(id) {
    g_Jumpers[id] = true;
}

public client_disconnected(id) {
    if(g_Jumpers[id]) {
        client_disconnect_jumper(id);
    }
}

public client_disconnect_jumper(id) {
    g_Jumpers[id] = false;
    g_Jumps[id] = 0;
    g_LastUserJump[id] = 0.0;
}

public CmdStartPre(id, uc_handle) {
    if(g_Jumpers[id]) {
        if(is_user_alive(id)) {
            CmdStartPreJumper(id, uc_handle);
        }
    }
}

public CmdStartPreJumper(id, uc_handle) {
    new flags = pev(id, pev_flags);
    
    if((get_uc(uc_handle, UC_Buttons) & IN_JUMP) && !(flags & FL_ONGROUND) && !(pev(id, pev_oldbuttons) & IN_JUMP) && g_Jumps[id] > 0) {
        --g_Jumps[id];
        
        new Float:velocity[3];
        pev(id, pev_velocity, velocity);
        velocity[2] = random_float(DOUBLE_JUMP_MIN_VELOCITY, DOUBLE_JUMP_MAX_VELOCITY);
        set_pev(id, pev_velocity, velocity);
        
        g_LastUserJump[id] = get_gametime();
        
        ColorChat(id, GREEN, "[%s] ^x01Podwójny skok wykorzystany, odczekaj %.0f sekund.", DOUBLE_JUMP_PREFIX, DOUBLE_JUMP_TIME);
    }
}

public SpawnedEventPre(id) {
    if(g_Jumpers[id]) {
        if(is_user_alive(id)) {
            SpawnedEventPreJumper(id);
        }
    }
}

public SpawnedEventPreJumper(id) {
    g_Jumps[id] = 1;
    g_LastUserJump[id] = 0.0;
}

public amxbans_admin_connect(id) {
    client_authorized(id, "");
}