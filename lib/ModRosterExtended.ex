defmodule ModRosterExtended do
  use Ejabberd.Module

  require Record
    Record.defrecord(:iq, Record.extract(:iq, from: "deps/xmpp/include/xmpp_codec.hrl"))
    Record.defrecord(:jid, Record.extract(:jid, from: "deps/xmpp/include/jid.hrl"))

  def start(host, _opts) do
    info('Ejabberd Module Roster Extended')
    Ejabberd.Hooks.add(:set_presence_hook, host, __MODULE__, :on_presence, 50)
    result = :gen_iq_handler.add_iq_handler(:ejabberd_local, host, "module:roster_extended:check_user", __MODULE__, :on_iq_received)
    info(host)
    info(__MODULE__)
    info(result)
    :ok
  end

  def stop(host) do
    # info('Stopping ejabberd module Presence Demo')
    Ejabberd.Hooks.delete(:set_presence_hook, host, __MODULE__, :on_presence, 50)
    _result = :gen_iq_handler.remove_iq_handler(:ejabberd_local, host, "module:roster_extended:check_user")
    :ok
  end

  def on_presence(user, _server, _resource, _packet) do
    info('Receive presence for #{user}')
    :none
  end
  
  def decode_iq_subel(el) do
    el
  end

  # def on_iq_received(iq_stanza) when iq(iq_stanza, :type) == :get do
  #   info("Received data for GET IQ handler")
  #   # info(inspect(iq(iq_stanza)))
  #   # info(inspect(jid(iq(iq_stanza, :from))))
  #   info(inspect(iq_stanza))
  #   iq(iq_stanza, type: :result, to: iq(iq_stanza, :from))
  # end

  def on_iq_received(iq_stanza) do
    info("Received data for Default IQ handler")
    info(inspect(iq(iq_stanza, :type)))
    # ToDo: Check if user exists in the DB using Ecto
    iq(iq_stanza, type: :result, to: iq(iq_stanza, :from))
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

# Sample XMPP request
# <iq xml:lang='en' id="test" from="mayank@localhost" to="server@localhost" type="get"><query xmlns="module:roster_extended:check_user" phone="+918451041645"/></iq>