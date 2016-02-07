json.array!(@party_affiliations) do |party_affiliation|
  json.extract! party_affiliation, :id, :partyAffiliation, :partyColour
  json.url party_affiliation_url(party_affiliation, format: :json)
end
