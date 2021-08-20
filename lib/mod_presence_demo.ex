defmodule ModPresenceDemo do
  use Ejabberd.Module

  def start(host, _opts) do
    info('Starting ejabberd module Presence Demo')
    # Ejabberd.Hooks.add(:set_presence_hook, host, __MODULE__, :on_presence, 50)
    result = :gen_iq_handler.add_iq_handler(:ejabberd_sm, host, "module:roster_extended:check_user", __MODULE__, :on_iq_received)
    info(host)
    info(__MODULE__)
    info(result)
    :ok
  end

  def stop(host) do
    info('Stopping ejabberd module Presence Demo')
    # Ejabberd.Hooks.delete(:set_presence_hook, host, __MODULE__, :on_presence, 50)
    result = :gen_iq_handler.remove_iq_handler(:ejabberd_sm, host, "module:roster_extended:check_user", __MODULE__, :on_iq_received)
    :ok
  end

  def on_presence(user, _server, _resource, _packet) do
    info('Receive presence for #{user}')
    :none
  end
  
  def decode_iq_subel(el) do
    el
  end

  def on_iq_received(iq) do
    info('Received data for IQ handler')
    info(inspect(iq))
    iq
  end

  def depends(_host, _opts) do
    []
  end

  def mod_options(_host) do
    []
  end

  def mod_doc() do
    %{:desc => 'This is just a demonstration.'}
  end

end
