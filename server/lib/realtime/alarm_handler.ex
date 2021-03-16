defmodule Realtime.AlarmHandler do
  require Logger

  def init({_args, {:alarm_handler, alarms}}) do
    Logger.info("Custom alarm handler init!")
    for {alarm_id, alarm_description} <- alarms, do: handle_alarm(alarm_id, alarm_description)
    {:ok, []}
  end

  def handle_event({:set_alarm, {alarm_id, alarm_description}}, state) do
    Logger.info(
      "Got an alarm " <> Atom.to_string(alarm_id) <> " " <> Kernel.inspect(alarm_description)
    )

    handle_alarm(alarm_id, alarm_description)
    {:ok, state}
  end

  def handle_event({:clear_alarm, alarm_id}, state) do
    Logger.info("Clearing the alarm  " <> Atom.to_string(alarm_id))
    {:ok, state}
  end

  def handle_alarm(:process_memory_high_watermark = alarm_id, high_mem_pid)
      when is_pid(high_mem_pid) do
    Logger.info("Handling alarm " <> Atom.to_string(alarm_id))

    Process.list() |> Enum.each(&:erlang.garbage_collect/1)

    Logger.info("End handling alarm " <> Atom.to_string(alarm_id))
  end

  def handle_alarm(_alarm_id, _alarm_description), do: :ok
end
