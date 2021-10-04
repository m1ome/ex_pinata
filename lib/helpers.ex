defmodule Pinata.Helpers do
  alias Tesla.Multipart

  @spec maybe_add_field(any(), atom(), any()) :: any()
  def maybe_add_field(%{} = object, key, value) when value != %{} and value != nil,
    do: Map.put(object, key, value)

  def maybe_add_field(%Multipart{} = object, key, value) when value != %{} and value != nil,
    do: Multipart.add_field(object, key, value)

  def maybe_add_field(object, _, _), do: object
end
