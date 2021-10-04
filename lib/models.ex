defmodule Pinata.Models.Pin do
  defstruct ~w(hash size timestamp is_duplicate)a

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: t()
  def from_map(
        %{
          "IpfsHash" => hash,
          "PinSize" => size,
          "Timestamp" => ts
        } = model
      ) do
    %__MODULE__{
      hash: hash,
      size: size,
      timestamp: Timex.parse!(ts, "{RFC3339z}"),
      is_duplicate: Map.get(model, "isDuplicate", false)
    }
  end
end

defmodule Pinata.Models.DataUsage do
  defstruct ~w(pin_count pin_size_total pin_size_with_replications_total)a

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: t()
  def from_map(%{
        "pin_count" => pin_count,
        "pin_size_total" => pin_size_total,
        "pin_size_with_replications_total" => pin_size_with_replications_total
      }) do
    %__MODULE__{
      pin_count: pin_count,
      pin_size_total: pin_size_total,
      pin_size_with_replications_total: pin_size_with_replications_total
    }
  end
end

defmodule Pinata.Models.HashPin do
  defstruct ~w(id hash name status)a

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: t()
  def from_map(%{
        "id" => id,
        "ipfsHash" => hash,
        "name" => name,
        "status" => status
      }) do
    %__MODULE__{
      id: id,
      name: name,
      hash: hash,
      status: status
    }
  end
end

defmodule Pinata.Models.Job do
  defstruct ~w(id hash date_queued status name keyvalues host_nodes pin_policy)a

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: %__MODULE__{}
  def from_map(%{
        "id" => id,
        "ipfs_pin_hash" => ipfs_pin_hash,
        "date_queued" => date_queued,
        "status" => status,
        "name" => name,
        "keyvalues" => keyvalues,
        "host_nodes" => host_nodes,
        "pin_policy" => pin_policy
      }) do
    %__MODULE__{
      id: id,
      hash: ipfs_pin_hash,
      date_queued: Timex.parse!(date_queued, "{RFC3339z}"),
      status: status,
      name: name,
      keyvalues: keyvalues,
      host_nodes: host_nodes,
      pin_policy: pin_policy
    }
  end
end

defmodule Pinata.Models.Jobs do
  defstruct ~w(count rows)a

  alias Pinata.Models.Job

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: t()
  def from_map(%{"count" => count, "rows" => rows}) do
    %__MODULE__{
      count: count,
      rows: Enum.map(rows, &Job.from_map/1)
    }
  end
end

defmodule Pinata.Models.Key do
  defstruct ~w(jwt api_key api_secret)a

  @type t() :: %__MODULE__{}

  @spec from_map(map()) :: t()
  def from_map(%{
        "JWT" => jwt,
        "pinata_api_key" => api_key,
        "pinata_api_secret" => api_secret
      }) do
    %__MODULE__{
      jwt: jwt,
      api_key: api_key,
      api_secret: api_secret
    }
  end
end
