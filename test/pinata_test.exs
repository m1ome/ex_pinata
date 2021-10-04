defmodule PinataTest do
  use ExUnit.Case

  test "it should pin file" do
    Tesla.Mock.mock(fn %{method: :post, url: "https://api.pinata.cloud/pinning/pinFileToIPFS"} ->
      body =
        ~S({"IpfsHash":"QmfVgEy1kWaWKKAU8nRmA1eKUr1hMMqFYfApciWjF8SaNT","PinSize":65488,"Timestamp":"2021-10-04T12:17:49.657Z","isDuplicate":true})

      %Tesla.Env{status: 200, body: Jason.decode!(body)}
    end)

    assert {:ok, file} = Pinata.pin_file("file content", "filename.jpg")
    assert file.hash == "QmfVgEy1kWaWKKAU8nRmA1eKUr1hMMqFYfApciWjF8SaNT"
    assert file.size == 65488
    assert file.timestamp == ~U[2021-10-04 12:17:49.657Z]
    assert file.is_duplicate == true
  end
end
