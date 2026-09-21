extends Node

signal debug_skip()

#region Player Action/Reaction Signals
signal energy_updated(current_energy, added_energy, previous_energy)

signal max_energy_reached()
signal max_energy_lost()





signal no_hit(nohit_status)


#Firing Modes
signal shotgun_fired(projectile)

#endregion

#region Enemy Action/Reaction Signals

signal player_damaged(player, current_health, previous_health, amount)
signal player_healed(player, current_health, previous_health, amount)
signal player_missed(player, current_health, previous_health, amount)
signal player_death(player)
signal player_projectile_fired(projectile : Projectile)
signal player_railcannon_secondary_fired(current_rail_charge : float)

signal upgrade(uid : String)

signal breaker_activated(breaker : Breaker)
signal breaker_ended(breaker : Breaker)


signal entity_damaged(entity, current_health, previous_health, amount)
signal entity_healed(entity, current_health, previous_health, amount)
signal entity_missed(entity, current_health, previous_health, amount)
signal hitbox_interaction(hitbox : Hitbox)

signal boss_damaged(boss)

#endregion

#region Stage Action/Reaction Signals
signal stage_intro_finished
signal stage_started
signal stage_time(audio_time)
signal spawn_boss
signal boss_death
signal boss_spawning
signal GameOver(final_score)

# Tres-2B Special Events
signal enter_nullspace
signal tutorial_completed
signal skipped_tutorial
#endregion

#region Camera Signals
signal camera_shake(amount)
signal camera_zoom(zoom_amount, zoom_to_position, zoom_duration)
signal camera_freezeframe(amount, duration)
signal camera_flash()
#endregion
