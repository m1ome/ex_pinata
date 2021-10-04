defmodule Pinata do
  alias Tesla.Multipart
  alias Pinata.{API, Helpers}
  alias Pinata.Models.{
    DataUsage,
    Pin,
    HashPin,
    Jobs,
    Key,
  }

  #
  # User
  #
  @spec generate_api_key(String.t(), map(), keyword()) :: {:ok, Key.t()} | {:error, any()}
  def generate_api_key(key_name, permissions, opts \\ []) do
    body =
      %{keyName: key_name, permissions: permissions}
      |> Helpers.maybe_add_field(:maxUses, Keyword.get(opts, :max_uses))

    case API.post("/users/generateApiKey", body) do
      {:ok, %{body: body, status: 200}} -> {:ok, Key.from_map(body)}
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec revoke_api_key(String.t()) :: :ok | {:error, any()}
  def revoke_api_key(api_key) do
    case API.put("/users/revokeApiKey", %{apiKey: api_key}) do
      {:ok, %{status: 200}} -> :ok
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end


  #
  # Pinning
  #

  @spec pin_file(binary(), String.t(), map(), map()) :: {:ok, Pin.t()} | {:error, any()}
  def pin_file(file, filename,  metadata \\ %{}, options \\ %{}) do
    body = Multipart.new()
    |> Multipart.add_file_content(file, filename)
    |> Helpers.maybe_add_field(:metadata, metadata)
    |> Helpers.maybe_add_field(:metadata, options)

    case API.post("/pinning/pinFileToIPFS", body) do
      {:ok, %{body: body, status: 200}} -> {:ok, Pin.from_map(body)}
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec pin_json(map() | list(), map(), map()) :: {:ok, Pin.t()} | {:error, any()}
  def pin_json(object, metadata \\ %{}, options \\ %{}) do
    body =
      object
      |> Helpers.maybe_add_field(:metadata, metadata)
      |> Helpers.maybe_add_field(:metadata, options)

    case API.post("/pinning/pinJSONToIPFS", body) do
      {:ok, %{body: body, status: 200}} -> {:ok, Pin.from_map(body)}
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec pin_by_hash(String.t(), map(), map()) :: {:ok, HashPin.t()} | {:error, any}
  def pin_by_hash(hash, metadata \\ %{}, options \\ %{}) do
    body =
      %{hashToPin: hash}
      |> Helpers.maybe_add_field(:metadata, metadata)
      |> Helpers.maybe_add_field(:options, options)

      case API.post("/pinning/pinByHash", body) do
        {:ok, %{body: body, status: 200}} -> {:ok, HashPin.from_map(body)}
        {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
        {:error, _} = error -> error
      end
  end

  @spec unpin(String.t()) :: :ok | {:error, any()}
  def unpin(hash) do
    url = "/pinning/unpin/#{hash}"
    case API.delete(url) do
      {:ok, %{status: 200}} -> :ok
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec hash_metadata(String.t(), keyword()) :: :ok | {:error, any()}
  def hash_metadata(hash, opts \\ []) do
    body =
      %{ipfsPinHash: hash}
      |> Helpers.maybe_add_field(:name, Keyword.get(opts, :name))
      |> Helpers.maybe_add_field(:keyvalues, Keyword.get(opts, :keyvalues))

    case API.put("/pinning/hashMetadata", body) do
      {:ok, %{status: 200}} -> :ok
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec hash_pin_policy(String.t(), map()) :: :ok | {:error, any()}
  def hash_pin_policy(hash, policy) do
    body = %{
      ipfsPinHash: hash,
      newPinPolicy: policy
    }

    case API.put("/pinning/hashPinPolicy", body) do
      {:ok, %{status: 200}} -> :ok
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  @spec global_pin_policy(map, keyword()) :: :ok | {:error, any()}
  def global_pin_policy(policy, opts \\ []) do
    body =
      %{newPinPolicy: policy}
      |> Helpers.maybe_add_field(:migratePreviousPins, Keyword.get(opts, :migrate))

      case API.put("/pinning/userPinPolicy", body) do
        {:ok, %{status: 200}} -> :ok
        {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
        {:error, _} = error -> error
      end
  end

  @spec pin_jobs(keyword()) :: {:ok, Jobs.t()} | {:error, any()}
  def pin_jobs(opts \\ []) do
    case API.request(url: "/pinning/pinJobs", method: :get, query: opts) do
      {:ok, %{body: body, status: 200}} -> {:ok, Jobs.from_map(body)}
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end

  #
  # Data
  #

  @spec data_usage() :: {:ok, DataUsage.t()} | {:error, any()}
  def data_usage() do
    case API.get("/data/userPinnedDataTotal") do
      {:ok, %{body: body, status: 200}} -> {:ok, DataUsage.from_map(body)}
      {:ok, %{body: body, status: status}} -> {:error, "pinata responded with #{status}: #{inspect body}"}
      {:error, _} = error -> error
    end
  end
end
