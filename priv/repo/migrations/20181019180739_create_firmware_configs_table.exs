defmodule Elixir.FarmbotRes.Repo.Migrations.CreateFirmwareConfigsTable do
  use Ecto.Migration

  def change do
    create table("firmware_configs", primary_key: false) do
      add(:local_id, :binary_id, primary_key: true)
      add(:id, :id)
      add(:pin_guard_4_time_out, :float)
      add(:pin_guard_1_active_state, :float)
      add(:encoder_scaling_y, :float)
      add(:movement_invert_2_endpoints_x, :float)
      add(:movement_min_spd_y, :float)
      add(:pin_guard_2_time_out, :float)
      add(:movement_timeout_y, :float)
      add(:movement_home_at_boot_y, :float)
      add(:movement_home_spd_z, :float)
      add(:movement_invert_endpoints_z, :float)
      add(:pin_guard_1_pin_nr, :float)
      add(:movement_invert_endpoints_y, :float)
      add(:movement_max_spd_y, :float)
      add(:movement_home_up_y, :float)
      add(:encoder_missed_steps_decay_z, :float)
      add(:movement_home_spd_y, :float)
      add(:encoder_use_for_pos_x, :float)
      add(:movement_step_per_mm_x, :float)
      add(:movement_home_at_boot_z, :float)
      add(:movement_steps_acc_dec_z, :float)
      add(:pin_guard_5_pin_nr, :float)
      add(:movement_invert_motor_z, :float)
      add(:movement_max_spd_x, :float)
      add(:movement_enable_endpoints_y, :float)
      add(:movement_enable_endpoints_z, :float)
      add(:movement_stop_at_home_x, :float)
      add(:movement_axis_nr_steps_y, :float)
      add(:pin_guard_1_time_out, :float)
      add(:movement_home_at_boot_x, :float)
      add(:pin_guard_2_pin_nr, :float)
      add(:encoder_scaling_z, :float)
      add(:param_e_stop_on_mov_err, :float)
      add(:encoder_enabled_x, :float)
      add(:pin_guard_2_active_state, :float)
      add(:encoder_missed_steps_decay_y, :float)
      add(:movement_home_up_z, :float)
      add(:movement_enable_endpoints_x, :float)
      add(:movement_step_per_mm_y, :float)
      add(:pin_guard_3_pin_nr, :float)
      add(:param_mov_nr_retry, :float)
      add(:movement_stop_at_home_z, :float)
      add(:pin_guard_4_active_state, :float)
      add(:movement_steps_acc_dec_y, :float)
      add(:movement_home_spd_x, :float)
      add(:movement_keep_active_x, :float)
      add(:pin_guard_3_time_out, :float)
      add(:movement_keep_active_y, :float)
      add(:encoder_scaling_x, :float)
      add(:movement_invert_2_endpoints_z, :float)
      add(:encoder_missed_steps_decay_x, :float)
      add(:movement_timeout_z, :float)
      add(:encoder_missed_steps_max_z, :float)
      add(:movement_min_spd_z, :float)
      add(:encoder_enabled_y, :float)
      add(:encoder_type_y, :float)
      add(:movement_home_up_x, :float)
      add(:pin_guard_3_active_state, :float)
      add(:movement_invert_motor_x, :float)
      add(:movement_keep_active_z, :float)
      add(:movement_max_spd_z, :float)
      add(:movement_secondary_motor_invert_x, :float)
      add(:movement_stop_at_max_x, :float)
      add(:movement_steps_acc_dec_x, :float)
      add(:pin_guard_4_pin_nr, :float)
      add(:encoder_type_x, :float)
      add(:movement_invert_2_endpoints_y, :float)
      add(:encoder_invert_y, :float)
      add(:movement_axis_nr_steps_x, :float)
      add(:movement_stop_at_max_z, :float)
      add(:movement_invert_endpoints_x, :float)
      add(:encoder_invert_z, :float)
      add(:encoder_use_for_pos_z, :float)
      add(:pin_guard_5_active_state, :float)
      add(:movement_step_per_mm_z, :float)
      add(:encoder_enabled_z, :float)
      add(:movement_secondary_motor_x, :float)
      add(:pin_guard_5_time_out, :float)
      add(:movement_min_spd_x, :float)
      add(:encoder_type_z, :float)
      add(:movement_stop_at_max_y, :float)
      add(:encoder_use_for_pos_y, :float)
      add(:encoder_missed_steps_max_y, :float)
      add(:movement_timeout_x, :float)
      add(:movement_stop_at_home_y, :float)
      add(:movement_axis_nr_steps_z, :float)
      add(:encoder_invert_x, :float)
      add(:encoder_missed_steps_max_x, :float)
      add(:movement_invert_motor_y, :float)
      timestamps(inserted_at: :created_at, type: :utc_datetime)
    end
  end
end
